package com.tributaria.service;

import com.tributaria.dao.FuncionarioCuotaDAO;
import com.tributaria.dto.ImpuestoFraccionableDTO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FuncionarioCuotaService {

    private static final int MES_INICIO_FISCAL = 3; // Marzo

    private final FuncionarioCuotaDAO cuotaDAO = new FuncionarioCuotaDAO();
    private final ImpuestoService impuestoService = new ImpuestoService();
    private final VehiculoService vehiculoService = new VehiculoService();

    public List<ImpuestoFraccionableDTO> listarImpuestosActivosFraccionables() {
        List<ImpuestoFraccionableDTO> items = new ArrayList<>();

        cargarPredialesActivos(items);
        cargarVehicularesActivos(items);
        cargarAlcabalasActivas(items);

        items.sort(Comparator
                .comparing(ImpuestoFraccionableDTO::getTipoImpuesto)
                .thenComparing(ImpuestoFraccionableDTO::getIdReferencia, Comparator.reverseOrder()));

        return items;
    }

    public void crearFraccionamiento(String tipoImpuesto, int idReferencia, int mesesPorCuota) {
        String tipo = normalizarTipoImpuesto(tipoImpuesto);
        if ("ALCABALA".equals(tipo)) {
            mesesPorCuota = 12; // Alcabala es pago unico.
        }
        validarMesesPorCuota(mesesPorCuota);

        if (idReferencia <= 0) {
            throw new IllegalArgumentException("Impuesto invalido para fraccionar.");
        }

        if (cuotaDAO.existeFraccionamientoVigente(tipo, idReferencia)) {
            throw new IllegalArgumentException("El impuesto seleccionado ya tiene un fraccionamiento activo.");
        }

        ImpuestoFraccionableDTO impuesto = buscarImpuestoFraccionable(tipo, idReferencia);
        if (impuesto == null) {
            throw new IllegalArgumentException("El impuesto no esta activo o no puede fraccionarse.");
        }

        BigDecimal montoAnual = safeScale(impuesto.getMontoAnual());
        if (montoAnual.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("El impuesto no tiene monto valido para fraccionar.");
        }

        int totalCuotas = "ALCABALA".equals(tipo) ? 1 : (12 / mesesPorCuota);
        String periodicidad = periodicidadTexto(mesesPorCuota);
        LocalDate inicioPeriodo = resolverInicioPeriodo(tipo, idReferencia);

        int idFraccionamiento = cuotaDAO.crearFraccionamiento(
                impuesto.getTipoImpuesto(),
                impuesto.getIdReferencia(),
                impuesto.getCodigoImpuesto(),
                impuesto.getContribuyente(),
                impuesto.getDescripcion(),
                montoAnual,
                periodicidad,
                mesesPorCuota,
                totalCuotas
        );

        if (idFraccionamiento <= 0) {
            throw new IllegalStateException("No se pudo crear el fraccionamiento.");
        }

        try {
            if ("ALCABALA".equals(tipo)) {
                cuotaDAO.crearCuota(
                        idFraccionamiento,
                        1,
                        "UNICA",
                        inicioPeriodo.plusDays(30),
                        montoAnual
                );
                return;
            }

            BigDecimal montoBase = montoAnual.divide(BigDecimal.valueOf(totalCuotas), 2, RoundingMode.HALF_UP);
            BigDecimal acumulado = BigDecimal.ZERO;

            for (int i = 1; i <= totalCuotas; i++) {
                LocalDate inicioTramo = inicioPeriodo.plusMonths((long) (i - 1) * mesesPorCuota);
                LocalDate finTramo = inicioTramo.plusMonths(mesesPorCuota).minusDays(1);
                LocalDate fechaVencimiento = finTramo;

                BigDecimal montoCuota;
                if (i == totalCuotas) {
                    montoCuota = montoAnual.subtract(acumulado).setScale(2, RoundingMode.HALF_UP);
                } else {
                    montoCuota = montoBase;
                }
                acumulado = acumulado.add(montoCuota);

                cuotaDAO.crearCuota(
                        idFraccionamiento,
                        i,
                        periodoLabel(inicioTramo, finTramo),
                        fechaVencimiento,
                        montoCuota
                );
            }
        } catch (Exception e) {
            cuotaDAO.eliminarFraccionamiento(idFraccionamiento);
            throw e;
        }
    }

    public List<Object[]> listarFraccionamientos() {
        return listarFraccionamientos(false);
    }

    public List<Object[]> listarFraccionamientos(boolean incluirHistoricos) {
        List<Object[]> rows = cuotaDAO.listarFraccionamientos();
        List<Object[]> resultado = new ArrayList<>();

        for (Object[] row : rows) {
            String tipo = texto(valorEn(row, 1));
            int idReferencia = toInt(valorEn(row, 2), 0);
            boolean habilitadoPago = estaHabilitadoParaPago(tipo, idReferencia);

            if (!incluirHistoricos && !habilitadoPago) {
                continue;
            }

            Object[] rowConFlag = new Object[row.length + 1];
            System.arraycopy(row, 0, rowConFlag, 0, row.length);
            rowConFlag[row.length] = habilitadoPago;
            resultado.add(rowConFlag);
        }
        return resultado;
    }

    public Object[] obtenerFraccionamiento(int idFraccionamiento) {
        return cuotaDAO.obtenerFraccionamiento(idFraccionamiento);
    }

    public List<Object[]> listarCuotasPorFraccionamiento(int idFraccionamiento) {
        return cuotaDAO.listarCuotasPorFraccionamiento(idFraccionamiento);
    }

    public List<Object[]> listarCuotasPendientes() {
        return listarCuotasPendientes(false);
    }

    public List<Object[]> listarCuotasPendientes(boolean incluirHistoricos) {
        List<Object[]> rows = cuotaDAO.listarCuotasPendientes();
        List<Object[]> resultado = new ArrayList<>();

        for (Object[] row : rows) {
            String tipo = texto(valorEn(row, 1));
            int idReferencia = toInt(valorEn(row, 2), 0);
            boolean habilitadoPago = estaHabilitadoParaPago(tipo, idReferencia);

            if (!incluirHistoricos && !habilitadoPago) {
                continue;
            }

            Object[] rowConFlag = new Object[row.length + 1];
            System.arraycopy(row, 0, rowConFlag, 0, row.length);
            rowConFlag[row.length] = habilitadoPago;
            resultado.add(rowConFlag);
        }
        return resultado;
    }

    public int registrarPagoCuota(
            int idCuota,
            BigDecimal montoPagado,
            LocalDate fechaPago,
            String observacion
    ) {
        if (idCuota <= 0) {
            throw new IllegalArgumentException("Cuota invalida.");
        }

        Object[] cuota = cuotaDAO.obtenerCuotaPorId(idCuota);
        if (cuota == null) {
            throw new IllegalArgumentException("No existe la cuota solicitada.");
        }

        int idFraccionamiento = toInt(valorEn(cuota, 1), 0);
        BigDecimal montoProgramado = safeScale(toBigDecimal(valorEn(cuota, 5)));
        String estado = texto(valorEn(cuota, 6));

        Object[] fraccionamiento = cuotaDAO.obtenerFraccionamiento(idFraccionamiento);
        if (fraccionamiento == null) {
            throw new IllegalArgumentException("No se encontro el fraccionamiento de la cuota.");
        }

        String tipoImpuesto = texto(valorEn(fraccionamiento, 1));
        int idReferencia = toInt(valorEn(fraccionamiento, 2), 0);

        if (!estaHabilitadoParaPago(tipoImpuesto, idReferencia)) {
            throw new IllegalArgumentException("El impuesto ya no esta habilitado para recibir pagos.");
        }

        if (!"PENDIENTE".equalsIgnoreCase(estado)) {
            throw new IllegalArgumentException("La cuota ya fue pagada.");
        }

        BigDecimal monto = safeScale(montoPagado);
        if (monto.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("El monto pagado debe ser mayor a cero.");
        }

        if (monto.compareTo(montoProgramado) != 0) {
            throw new IllegalArgumentException("El monto pagado debe coincidir con el monto programado.");
        }

        LocalDate fecha = fechaPago == null ? LocalDate.now() : fechaPago;
        String detalle = observacion == null ? null : observacion.trim();
        if (detalle != null && detalle.length() > 255) {
            detalle = detalle.substring(0, 255);
        }

        cuotaDAO.registrarPagoCuota(idCuota, fecha, monto, detalle);
        cuotaDAO.actualizarEstadoFraccionamiento(idFraccionamiento);

        Object[] fraccionamientoActualizado = cuotaDAO.obtenerFraccionamiento(idFraccionamiento);
        String estadoFracc = texto(valorEn(fraccionamientoActualizado, 12));
        if ("CERRADO".equalsIgnoreCase(estadoFracc)) {
            if ("VEHICULAR".equalsIgnoreCase(tipoImpuesto)) {
                cuotaDAO.marcarSiguienteDetalleVehicularPagado(idReferencia);
            } else if ("ALCABALA".equalsIgnoreCase(tipoImpuesto)) {
                cuotaDAO.actualizarEstadoAlcabala(idReferencia, "PAGADO");
            }
        }

        return idFraccionamiento;
    }

    public String estadoPagoVehicularFuncionario(int idImpuestoVehicular, List<Object[]> detalleVehicular) {
        sincronizarPagosVehicularesDesdeFraccionamientos(idImpuestoVehicular);
        return calcularEstadoDetalleVehicular(detalleVehicular);
    }

    public boolean puedeCrearFraccionamientoVehicular(int idImpuestoVehicular) {
        if (idImpuestoVehicular <= 0) {
            return false;
        }
        sincronizarPagosVehicularesDesdeFraccionamientos(idImpuestoVehicular);
        if (cuotaDAO.existeFraccionamientoVigente("VEHICULAR", idImpuestoVehicular)) {
            return false;
        }
        return tieneCuotasPendientesVehicular(idImpuestoVehicular);
    }

    public boolean estaHabilitadoPagoFraccionamiento(int idFraccionamiento) {
        if (idFraccionamiento <= 0) {
            return false;
        }
        Object[] fraccionamiento = cuotaDAO.obtenerFraccionamiento(idFraccionamiento);
        if (fraccionamiento == null) {
            return false;
        }

        String tipo = texto(valorEn(fraccionamiento, 1));
        int idReferencia = toInt(valorEn(fraccionamiento, 2), 0);
        return estaHabilitadoParaPago(tipo, idReferencia);
    }

    public void validarPredialAlDiaParaVenta(int idInmueble) {
        Integer idPredial = cuotaDAO.obtenerPredialActivoPorInmueble(idInmueble);
        if (idPredial == null) {
            throw new IllegalArgumentException("No existe impuesto predial activo para el inmueble.");
        }

        if (cuotaDAO.existeFraccionamientoVigente("PREDIAL", idPredial)) {
            throw new IllegalArgumentException("El predial del inmueble tiene cuotas pendientes por pagar.");
        }

        int anioPendiente = obtenerAnioPendientePredial(idPredial);
        int anioActual = LocalDate.now().getYear();
        if (anioPendiente <= anioActual) {
            throw new IllegalArgumentException("Debe pagar el impuesto predial del anio actual antes de vender el inmueble.");
        }
    }

    private ImpuestoFraccionableDTO buscarImpuestoFraccionable(String tipo, int idReferencia) {
        for (ImpuestoFraccionableDTO item : listarImpuestosActivosFraccionables()) {
            if (tipo.equalsIgnoreCase(item.getTipoImpuesto()) && item.getIdReferencia() == idReferencia) {
                return item;
            }
        }
        return null;
    }

    private void cargarPredialesActivos(List<ImpuestoFraccionableDTO> destino) {
        List<Object[]> rows = impuestoService.listarPrediales();
        for (Object[] row : rows) {
            int idPredial = toInt(valorEn(row, 0), 0);
            String estado = texto(valorEn(row, 7));

            if (idPredial <= 0 || !"ACTIVO".equalsIgnoreCase(estado)) {
                continue;
            }

            if (cuotaDAO.existeFraccionamientoVigente("PREDIAL", idPredial)) {
                continue;
            }

            int anioPendiente = obtenerAnioPendientePredial(idPredial);

            ImpuestoFraccionableDTO item = new ImpuestoFraccionableDTO();
            item.setTipoImpuesto("PREDIAL");
            item.setIdReferencia(idPredial);
            item.setCodigoImpuesto("IMP-" + idPredial);
            item.setContribuyente(defaultText(texto(valorEn(row, 1)), "-"));
            item.setDescripcion(defaultText(texto(valorEn(row, 2)), "Sin direccion") + " | Anio " + anioPendiente);
            item.setMontoAnual(safeScale(toBigDecimal(valorEn(row, 6))));
            item.setEstado("ACTIVO");
            destino.add(item);
        }
    }

    private void cargarVehicularesActivos(List<ImpuestoFraccionableDTO> destino) {
        Map<String, String> estadoVehiculoPorPlaca = new HashMap<>();
        for (Object[] vehiculo : vehiculoService.listar()) {
            String placa = texto(valorEn(vehiculo, 1));
            if (placa == null) {
                continue;
            }
            String estado = texto(valorEn(vehiculo, 9));
            estadoVehiculoPorPlaca.put(placa.toUpperCase(), estado == null ? "ACTIVO" : estado.toUpperCase());
        }

        List<Object[]> vehiculares = impuestoService.listarVehiculares();
        Map<String, Object[]> ultimoImpuestoPorPlaca = new HashMap<>();
        for (Object[] row : vehiculares) {
            int idImpuesto = toInt(valorEn(row, 0), 0);
            String placa = texto(valorEn(row, 2));
            if (idImpuesto <= 0 || placa == null) {
                continue;
            }

            String key = placa.toUpperCase();
            Object[] actual = ultimoImpuestoPorPlaca.get(key);
            int idActual = toInt(valorEn(actual, 0), 0);
            if (actual == null || idImpuesto > idActual) {
                ultimoImpuestoPorPlaca.put(key, row);
            }
        }

        List<Object[]> rowsFiltradas = new ArrayList<>(ultimoImpuestoPorPlaca.values());
        rowsFiltradas.sort((a, b) -> Integer.compare(toInt(valorEn(b, 0), 0), toInt(valorEn(a, 0), 0)));

        for (Object[] row : rowsFiltradas) {
            int idImpuesto = toInt(valorEn(row, 0), 0);
            String placa = texto(valorEn(row, 2));
            if (placa == null || placa.isBlank()) {
                continue;
            }

            sincronizarPagosVehicularesDesdeFraccionamientos(idImpuesto);

            if (!"ACTIVO".equalsIgnoreCase(estadoVehiculoPorPlaca.getOrDefault(placa.toUpperCase(), "ACTIVO"))) {
                continue;
            }

            if (cuotaDAO.existeFraccionamientoVigente("VEHICULAR", idImpuesto)) {
                continue;
            }

            Object[] siguientePendiente = obtenerSiguienteDetalleVehicularPendiente(idImpuesto);
            if (siguientePendiente == null) {
                continue;
            }

            BigDecimal montoAnualPendiente = toBigDecimalOrZero(valorEn(siguientePendiente, 2));
            if (montoAnualPendiente.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }
            int anioPendiente = toInt(valorEn(siguientePendiente, 1), toInt(valorEn(row, 3), LocalDate.now().getYear()));

            ImpuestoFraccionableDTO item = new ImpuestoFraccionableDTO();
            item.setTipoImpuesto("VEHICULAR");
            item.setIdReferencia(idImpuesto);
            item.setCodigoImpuesto("IMP-" + idImpuesto);
            item.setContribuyente(defaultText(texto(valorEn(row, 1)), "-"));
            item.setDescripcion("Placa " + placa + " | Anio " + anioPendiente);
            item.setMontoAnual(safeScale(montoAnualPendiente));
            item.setEstado("ACTIVO");
            destino.add(item);
        }
    }

    private void cargarAlcabalasActivas(List<ImpuestoFraccionableDTO> destino) {
        List<Object[]> rows = impuestoService.listarAlcabalas();
        for (Object[] row : rows) {
            int idAlcabala = toInt(valorEn(row, 0), 0);
            if (idAlcabala <= 0) {
                continue;
            }

            String estado = texto(valorEn(row, 8));
            if (!"REGISTRADO".equalsIgnoreCase(estado) && !"ACTIVO".equalsIgnoreCase(estado)) {
                continue;
            }

            // Alcabala es pago unico: si ya tuvo fraccionamiento, no vuelve a mostrarse.
            if (cuotaDAO.existeFraccionamiento("ALCABALA", idAlcabala)) {
                continue;
            }

            BigDecimal monto = toBigDecimalOrZero(valorEn(row, 7));
            if (monto.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }

            Object fechaVentaObj = valorEn(row, 9);
            String fechaVentaTxt = fechaVentaObj == null ? "-" : fechaVentaObj.toString();

            ImpuestoFraccionableDTO item = new ImpuestoFraccionableDTO();
            item.setTipoImpuesto("ALCABALA");
            item.setIdReferencia(idAlcabala);
            item.setCodigoImpuesto("IMP-" + idAlcabala);
            item.setContribuyente(defaultText(texto(valorEn(row, 1)), "-"));
            item.setDescripcion(defaultText(texto(valorEn(row, 3)), "Sin direccion") + " | Venta " + fechaVentaTxt);
            item.setMontoAnual(safeScale(monto));
            item.setEstado("ACTIVO");
            destino.add(item);
        }
    }

    private Object[] obtenerSiguienteDetalleVehicularPendiente(int idImpuesto) {
        List<Object[]> detalle = impuestoService.listarDetalle(idImpuesto);
        if (detalle == null || detalle.isEmpty()) {
            return null;
        }

        Object[] candidato = null;
        int anioMin = Integer.MAX_VALUE;
        int idDetalleMin = Integer.MAX_VALUE;

        for (Object[] row : detalle) {
            String estado = texto(valorEn(row, 3));
            if ("PAGADO".equalsIgnoreCase(estado)) {
                continue;
            }

            int idDetalle = toInt(valorEn(row, 0), Integer.MAX_VALUE);
            int anio = toInt(valorEn(row, 1), Integer.MAX_VALUE);
            if (anio < anioMin || (anio == anioMin && idDetalle < idDetalleMin)) {
                anioMin = anio;
                idDetalleMin = idDetalle;
                candidato = row;
            }
        }

        return candidato;
    }

    private int obtenerAnioPendientePredial(int idPredial) {
        Object[] predial = impuestoService.obtenerPredialPorId(idPredial);
        int anioBase = extraerAnioFecha(valorEn(predial, 10)); // fecha_inicio
        if (anioBase <= 0) {
            anioBase = extraerAnioFecha(valorEn(predial, 12)); // fecha_registro
        }
        if (anioBase <= 0) {
            anioBase = LocalDate.now().getYear();
        }

        int fraccionamientosCerrados = cuotaDAO.contarFraccionamientosCerrados("PREDIAL", idPredial);
        return anioBase + fraccionamientosCerrados;
    }

    private LocalDate resolverInicioPeriodo(String tipoImpuesto, int idReferencia) {
        if ("VEHICULAR".equalsIgnoreCase(tipoImpuesto)) {
            Object[] pendiente = obtenerSiguienteDetalleVehicularPendiente(idReferencia);
            int anio = toInt(valorEn(pendiente, 1), LocalDate.now().getYear());
            return LocalDate.of(anio, MES_INICIO_FISCAL, 1);
        }

        if ("PREDIAL".equalsIgnoreCase(tipoImpuesto)) {
            int anio = obtenerAnioPendientePredial(idReferencia);
            return LocalDate.of(anio, MES_INICIO_FISCAL, 1);
        }

        if ("ALCABALA".equalsIgnoreCase(tipoImpuesto)) {
            Object[] alcabala = impuestoService.obtenerAlcabalaPorId(idReferencia);
            LocalDate fechaVenta = toLocalDate(valorEn(alcabala, 14));
            return fechaVenta == null ? LocalDate.now() : fechaVenta;
        }

        return LocalDate.now();
    }

    private boolean tieneCuotasPendientesVehicular(int idImpuesto) {
        List<Object[]> detalle = impuestoService.listarDetalle(idImpuesto);
        if (detalle == null || detalle.isEmpty()) {
            return false;
        }

        for (Object[] item : detalle) {
            String estado = texto(valorEn(item, 3));
            if (!"PAGADO".equalsIgnoreCase(estado)) {
                return true;
            }
        }
        return false;
    }

    private boolean estaHabilitadoParaPago(String tipoImpuesto, int idReferencia) {
        String tipo = tipoImpuesto == null ? "" : tipoImpuesto.trim().toUpperCase();
        if ("PREDIAL".equals(tipo)) {
            Object[] predial = impuestoService.obtenerPredialPorId(idReferencia);
            String estado = texto(valorEn(predial, 7));
            return "ACTIVO".equalsIgnoreCase(estado);
        }
        if ("VEHICULAR".equals(tipo)) {
            sincronizarPagosVehicularesDesdeFraccionamientos(idReferencia);
            return tieneCuotasPendientesVehicular(idReferencia);
        }
        if ("ALCABALA".equals(tipo)) {
            Object[] alcabala = impuestoService.obtenerAlcabalaPorId(idReferencia);
            String estado = texto(valorEn(alcabala, 13));
            return "REGISTRADO".equalsIgnoreCase(estado) || "ACTIVO".equalsIgnoreCase(estado);
        }
        return false;
    }

    private String calcularEstadoDetalleVehicular(List<Object[]> detalle) {
        if (detalle == null || detalle.isEmpty()) {
            return "PENDIENTE";
        }
        for (Object[] fila : detalle) {
            String estado = texto(valorEn(fila, 3));
            if (!"PAGADO".equalsIgnoreCase(estado)) {
                return "PENDIENTE";
            }
        }
        return "PAGADO";
    }

    private void sincronizarPagosVehicularesDesdeFraccionamientos(int idImpuesto) {
        if (idImpuesto <= 0) {
            return;
        }

        int fraccCerrados = cuotaDAO.contarFraccionamientosCerrados("VEHICULAR", idImpuesto);
        int detallesPagados = cuotaDAO.contarDetallesVehicularesPagados(idImpuesto);
        int faltantes = fraccCerrados - detallesPagados;
        if (faltantes <= 0) {
            return;
        }

        for (int i = 0; i < faltantes; i++) {
            boolean ok = cuotaDAO.marcarSiguienteDetalleVehicularPagado(idImpuesto);
            if (!ok) {
                break;
            }
        }
    }

    private String normalizarTipoImpuesto(String tipoImpuesto) {
        String tipo = tipoImpuesto == null ? "" : tipoImpuesto.trim().toUpperCase();
        if ("PREDIAL".equals(tipo) || "VEHICULAR".equals(tipo) || "ALCABALA".equals(tipo)) {
            return tipo;
        }
        throw new IllegalArgumentException("Tipo de impuesto invalido para fraccionamiento.");
    }

    private void validarMesesPorCuota(int mesesPorCuota) {
        if (mesesPorCuota == 1 || mesesPorCuota == 2 || mesesPorCuota == 3
                || mesesPorCuota == 4 || mesesPorCuota == 6 || mesesPorCuota == 12) {
            return;
        }
        throw new IllegalArgumentException("Periodicidad invalida para fraccionamiento.");
    }

    private String periodicidadTexto(int mesesPorCuota) {
        if (mesesPorCuota == 1) {
            return "MENSUAL";
        }
        if (mesesPorCuota == 2) {
            return "BIMESTRAL";
        }
        if (mesesPorCuota == 3) {
            return "TRIMESTRAL";
        }
        if (mesesPorCuota == 4) {
            return "CUATRIMESTRAL";
        }
        if (mesesPorCuota == 6) {
            return "SEMESTRAL";
        }
        return "ANUAL";
    }

    private String periodoLabel(LocalDate inicio, LocalDate fin) {
        return inicio.getMonthValue() + "/" + inicio.getYear() + " - " + fin.getMonthValue() + "/" + fin.getYear();
    }

    private int extraerAnioFecha(Object value) {
        LocalDate date = toLocalDate(value);
        return date == null ? -1 : date.getYear();
    }

    private LocalDate toLocalDate(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof LocalDate) {
            return (LocalDate) value;
        }
        if (value instanceof LocalDateTime) {
            return ((LocalDateTime) value).toLocalDate();
        }
        if (value instanceof Date) {
            return ((Date) value).toLocalDate();
        }
        if (value instanceof java.util.Date) {
            return new java.sql.Date(((java.util.Date) value).getTime()).toLocalDate();
        }
        try {
            return LocalDate.parse(value.toString().substring(0, 10));
        } catch (Exception ignored) {
            return null;
        }
    }

    private String defaultText(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }

    private BigDecimal safeScale(BigDecimal value) {
        if (value == null) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        return value.setScale(2, RoundingMode.HALF_UP);
    }

    private Object valorEn(Object[] row, int index) {
        if (row == null || index < 0 || index >= row.length) {
            return null;
        }
        return row[index];
    }

    private String texto(Object value) {
        if (value == null) {
            return null;
        }
        String text = value.toString().trim();
        return text.isBlank() ? null : text;
    }

    private int toInt(Object value, int fallback) {
        if (value == null) {
            return fallback;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        try {
            return Integer.parseInt(value.toString().trim());
        } catch (Exception ex) {
            return fallback;
        }
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }
        if (value instanceof Number) {
            return new BigDecimal(value.toString());
        }
        return new BigDecimal(value.toString().trim());
    }

    private BigDecimal toBigDecimalOrZero(Object value) {
        try {
            return toBigDecimal(value);
        } catch (Exception ignored) {
            return BigDecimal.ZERO;
        }
    }
}
