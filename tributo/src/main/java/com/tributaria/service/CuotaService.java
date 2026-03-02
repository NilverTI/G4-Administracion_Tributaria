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
        return cuotaDAO.listarVista(); // CALL sp_listar_cuotas()
    }

    public List<Object[]> listarImpuestosParaFraccionar() {
        return cuotaDAO.listarImpuestosParaFraccionar();
    }

    public void crearFraccionamiento(int idImpuesto, int numeroCuotas, LocalDate fechaPrimeraCuota) {
        cuotaDAO.fraccionarImpuesto(idImpuesto, numeroCuotas, fechaPrimeraCuota);
    }

    public List<Object[]> listarCuotasPorImpuesto(int idImpuesto) {
        return cuotaDAO.listarCuotasPorImpuesto(idImpuesto); // numero, venc, monto, estado
    }

    /**
     * Agrupa cuotas por impuesto (1 fila por IMPxxxx).
     * Se basa en tu SP sp_listar_cuotas() real.
     */
    public List<Map<String, Object>> listarFraccionamientosAgrupados() {

        List<Object[]> rows = cuotaDAO.listarVista();
        Map<Integer, Map<String, Object>> grouped = new LinkedHashMap<>();

        for (Object[] r : rows) {
            if (r == null || r.length < 11)
                continue;

            // SP real:
            // 0=id_impuesto, 1=codigo_impuesto, 2=contribuyente, 3=tipo, 4=anio,
            // 5=id_cuota, 6=numero, 7=total_cuotas, 8=monto, 9=vencimiento, 10=estado

            Integer idImp = toInt(r[0]);
            String codImp = str(r[1]);
            String contribuyente = str(r[2]);
            String tipo = str(r[3]);
            String anio = str(r[4]);

            if (idImp == null || idImp <= 0)
                continue;

            Map<String, Object> g = grouped.get(idImp);
            if (g == null) {
                g = new HashMap<>();
                g.put("idImpuesto", idImp);
                g.put("codigoImpuesto", codImp);
                g.put("contribuyente", contribuyente);

                // ✅ YA VIENEN DEL SP
                g.put("tipo", tipo);
                g.put("anio", anio);

                g.put("totalCuotas", toInt(r[7])); // total_cuotas
                g.put("totalMonto", java.math.BigDecimal.ZERO);

                g.put("proximoVenc", null);
                g.put("pagadas", 0);
                g.put("todas", 0);

                grouped.put(idImp, g);
            }

            // ✅ monto (col 8)
            java.math.BigDecimal monto = toBig(r[8]);
            g.put("totalMonto", ((java.math.BigDecimal) g.get("totalMonto")).add(monto));

            // ✅ estado cuota (col 10)
            String est = str(r[10]).trim().toUpperCase(java.util.Locale.ROOT);
            g.put("todas", (int) g.get("todas") + 1);
            if ("PAGADA".equals(est))
                g.put("pagadas", (int) g.get("pagadas") + 1);

            // ✅ próximo vencimiento de NO pagadas (col 9)
            if (!"PAGADA".equals(est)) {
                java.time.LocalDate venc = toDate(r[9]);
                java.time.LocalDate actual = (java.time.LocalDate) g.get("proximoVenc");
                if (venc != null && (actual == null || venc.isBefore(actual))) {
                    g.put("proximoVenc", venc);
                }
            }
        }

        // ✅ estado general
        for (Map<String, Object> g : grouped.values()) {
            int pagadas = (int) g.get("pagadas");
            int total = (int) g.get("todas");

            String estadoGeneral = (total > 0 && pagadas == total) ? "PAGADO"
                    : (pagadas > 0) ? "PARCIAL"
                            : "PENDIENTE";

            g.put("estadoGeneral", estadoGeneral);
        }

        return new ArrayList<>(grouped.values());
    }

    private Integer parseIdImpuesto(String codImp) {
        // "IMP0014" -> 14
        if (codImp == null)
            return null;
        String s = codImp.trim().toUpperCase(Locale.ROOT);
        if (!s.startsWith("IMP"))
            return null;
        s = s.replace("IMP", "");
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return null;
        }
    }

    private static String str(Object o) {
        return o == null ? "" : String.valueOf(o);
    }

    private static int toInt(Object o) {
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