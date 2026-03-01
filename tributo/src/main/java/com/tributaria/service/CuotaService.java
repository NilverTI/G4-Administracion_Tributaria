package com.tributaria.service;

import com.tributaria.dao.CuotaDAO;
import com.tributaria.entity.Cuota;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

public class CuotaService {

    private final CuotaDAO cuotaDAO = new CuotaDAO();

    public List<Cuota> listarPendientes() {
        return cuotaDAO.listarPendientes();
    }

    public Cuota buscarPorId(int idCuota) {
        return cuotaDAO.buscarPorId(idCuota);
    }

    public void marcarComoPagada(Integer idCuota) {
        cuotaDAO.marcarComoPagada(idCuota);
    }

    public List<Cuota> listar() {
        return cuotaDAO.listar();
    }

    public void guardar(Cuota cuota) {
        cuotaDAO.guardar(cuota);
    }

    public void actualizar(Cuota cuota) {
        cuotaDAO.actualizar(cuota);
    }

    public List<Object[]> listarVista() {
        return cuotaDAO.listarVista();
    }

    public List<Object[]> listarImpuestosParaFraccionar() {
        return cuotaDAO.listarImpuestosParaFraccionar();
    }

    public void crearFraccionamiento(int idImpuesto, int numeroCuotas, LocalDate fechaPrimeraCuota) {
        cuotaDAO.fraccionarImpuesto(idImpuesto, numeroCuotas, fechaPrimeraCuota);
    }

    public List<Object[]> listarCuotasPorImpuesto(int idImpuesto) {
        return cuotaDAO.listarCuotasPorImpuesto(idImpuesto);
    }

    public List<Map<String, Object>> listarFraccionamientosAgrupados() {
        List<Object[]> rows = cuotaDAO.listarVista(); // CALL sp_listar_cuotas()
        final int IDX_ID_IMP = 0;
        final int IDX_COD_IMP = 1;
        final int IDX_CONTRI = 2;

        final int IDX_TIPO = 3;
        final int IDX_ANIO = 4;

        final int IDX_TOTAL_CUOTAS = 6;
        final int IDX_MONTO_CUOTA = 7;
        final int IDX_VENC = 8;
        final int IDX_ESTADO = 9;

        Map<Integer, Map<String, Object>> grouped = new LinkedHashMap<>();

        for (Object[] r : rows) {
            if (r == null || r.length == 0)
                continue;

            Integer idImp = toInt(r[IDX_ID_IMP]);

            Map<String, Object> g = grouped.get(idImp);
            if (g == null) {
                g = new HashMap<>();
                g.put("idImpuesto", idImp);
                g.put("codigoImpuesto", str(r[IDX_COD_IMP]));
                g.put("contribuyente", str(r[IDX_CONTRI]));
                g.put("tipo", idxSafe(r, IDX_TIPO) ? str(r[IDX_TIPO]) : "");
                g.put("anio", idxSafe(r, IDX_ANIO) ? str(r[IDX_ANIO]) : "");

                g.put("totalCuotas", idxSafe(r, IDX_TOTAL_CUOTAS) ? toInt(r[IDX_TOTAL_CUOTAS]) : 0);
                g.put("totalMonto", BigDecimal.ZERO);

                g.put("proximoVenc", null);
                g.put("pagadas", 0);
                g.put("todas", 0);

                grouped.put(idImp, g);
            }

            // sumar monto cuota
            if (idxSafe(r, IDX_MONTO_CUOTA)) {
                BigDecimal monto = toBig(r[IDX_MONTO_CUOTA]);
                g.put("totalMonto", ((BigDecimal) g.get("totalMonto")).add(monto));
            }

            // estado
            String est = idxSafe(r, IDX_ESTADO) ? str(r[IDX_ESTADO]).toUpperCase(Locale.ROOT) : "";
            g.put("todas", (int) g.get("todas") + 1);
            if (est.equals("PAGADA"))
                g.put("pagadas", (int) g.get("pagadas") + 1);

            // próximo vencimiento de cuotas NO pagadas
            if (!est.equals("PAGADA") && idxSafe(r, IDX_VENC)) {
                LocalDate venc = toDate(r[IDX_VENC]);
                LocalDate actual = (LocalDate) g.get("proximoVenc");
                if (venc != null && (actual == null || venc.isBefore(actual))) {
                    g.put("proximoVenc", venc);
                }
            }
        }

        for (Map<String, Object> g : grouped.values()) {
            int pagadas = (int) g.get("pagadas");
            int total = (int) g.get("todas");
            String estadoGeneral = (total > 0 && pagadas == total) ? "PAGADO" : (pagadas > 0) ? "PARCIAL" : "PENDIENTE";
            g.put("estadoGeneral", estadoGeneral);
        }

        return new ArrayList<>(grouped.values());
    }

    private static boolean idxSafe(Object[] r, int idx) {
        return idx >= 0 && idx < r.length;
    }

    private static String str(Object o) {
        return o == null ? "" : String.valueOf(o);
    }

    private static Integer toInt(Object o) {
        if (o == null)
            return 0;
        if (o instanceof Number n)
            return n.intValue();
        try {
            return Integer.parseInt(String.valueOf(o));
        } catch (Exception e) {
            return 0;
        }
    }

    private static BigDecimal toBig(Object o) {
        if (o == null)
            return BigDecimal.ZERO;
        if (o instanceof BigDecimal b)
            return b;
        try {
            return new BigDecimal(String.valueOf(o));
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private static LocalDate toDate(Object o) {
        if (o == null)
            return null;
        try {
            return LocalDate.parse(String.valueOf(o));
        } catch (Exception e) {
            return null;
        }
    }
}