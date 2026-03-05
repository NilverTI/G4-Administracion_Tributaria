package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;

import java.util.List;

public class ContribuyenteImpuestoDAO {

    public List<Object[]> listarPredialesPorPersona(int idPersona) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT p.id_predial, " +
                            "YEAR(COALESCE(p.fecha_inicio, p.fecha_registro)) AS anio, " +
                            "p.monto_anual, p.estado, p.fecha_inicio " +
                            "FROM impuesto_predial p " +
                            "INNER JOIN inmueble i ON i.id_inmueble = p.id_inmueble " +
                            "INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente " +
                            "WHERE c.id_persona = ?1 " +
                            "ORDER BY p.id_predial DESC"
            );
            q.setParameter(1, idPersona);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Object[] obtenerPredialPorPersona(int idPersona, int idPredial) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT p.id_predial, " +
                            "YEAR(COALESCE(p.fecha_inicio, p.fecha_registro)) AS anio, " +
                            "p.monto_anual, p.estado, p.fecha_inicio " +
                            "FROM impuesto_predial p " +
                            "INNER JOIN inmueble i ON i.id_inmueble = p.id_inmueble " +
                            "INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente " +
                            "WHERE c.id_persona = ?1 AND p.id_predial = ?2 " +
                            "LIMIT 1"
            );
            q.setParameter(1, idPersona);
            q.setParameter(2, idPredial);

            List<?> rows = q.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (Object[]) rows.get(0);
        } finally {
            em.close();
        }
    }

    public List<String> listarPlacasPorPersona(int idPersona) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT UPPER(TRIM(v.placa)) AS placa " +
                            "FROM vehiculo v " +
                            "INNER JOIN contribuyentes c ON c.id_contribuyente = v.id_contribuyente " +
                            "WHERE c.id_persona = ?1"
            );
            q.setParameter(1, idPersona);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarCuotasPendientesPorPersona(int idPersona) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "fi.tipo_impuesto, " +
                            "fc.numero_cuota, " +
                            "fi.total_cuotas, " +
                            "fc.fecha_vencimiento, " +
                            "fc.monto_programado " +
                            "FROM fraccionamiento_cuota fc " +
                            "INNER JOIN fraccionamiento_impuesto fi ON fi.id_fraccionamiento = fc.id_fraccionamiento " +
                            "LEFT JOIN impuesto_predial p ON fi.tipo_impuesto = 'PREDIAL' AND fi.id_referencia = p.id_predial " +
                            "LEFT JOIN inmueble ip ON p.id_inmueble = ip.id_inmueble " +
                            "LEFT JOIN contribuyentes c_pred ON ip.id_contribuyente = c_pred.id_contribuyente " +
                            "LEFT JOIN impuesto iv ON fi.tipo_impuesto = 'VEHICULAR' AND fi.id_referencia = iv.id_impuesto " +
                            "LEFT JOIN contribuyentes c_veh ON iv.id_contribuyente = c_veh.id_contribuyente " +
                            "LEFT JOIN alcabala a ON fi.tipo_impuesto = 'ALCABALA' AND fi.id_referencia = a.id_alcabala " +
                            "LEFT JOIN contribuyentes c_alc ON a.id_contribuyente_comprador = c_alc.id_contribuyente " +
                            "WHERE fc.estado = 'PENDIENTE' " +
                            "AND ( " +
                            "   (fi.tipo_impuesto = 'PREDIAL' AND c_pred.id_persona = ?1) " +
                            "   OR (fi.tipo_impuesto = 'VEHICULAR' AND c_veh.id_persona = ?1) " +
                            "   OR (fi.tipo_impuesto = 'ALCABALA' AND c_alc.id_persona = ?1) " +
                            ") " +
                            "ORDER BY fc.fecha_vencimiento ASC, fc.numero_cuota ASC"
            );
            q.setParameter(1, idPersona);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarCuotasPorPersona(int idPersona) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "fc.id_cuota, " +
                            "fi.tipo_impuesto, " +
                            "fi.codigo_impuesto, " +
                            "fc.numero_cuota, " +
                            "fi.total_cuotas, " +
                            "fc.periodo_label, " +
                            "fc.fecha_vencimiento, " +
                            "fc.monto_programado, " +
                            "fc.estado, " +
                            "fc.fecha_pago, " +
                            "COALESCE(fc.monto_pagado, 0), " +
                            "fi.id_fraccionamiento " +
                            "FROM fraccionamiento_cuota fc " +
                            "INNER JOIN fraccionamiento_impuesto fi ON fi.id_fraccionamiento = fc.id_fraccionamiento " +
                            "LEFT JOIN impuesto_predial p ON fi.tipo_impuesto = 'PREDIAL' AND fi.id_referencia = p.id_predial " +
                            "LEFT JOIN inmueble ip ON p.id_inmueble = ip.id_inmueble " +
                            "LEFT JOIN contribuyentes c_pred ON ip.id_contribuyente = c_pred.id_contribuyente " +
                            "LEFT JOIN impuesto iv ON fi.tipo_impuesto = 'VEHICULAR' AND fi.id_referencia = iv.id_impuesto " +
                            "LEFT JOIN contribuyentes c_veh ON iv.id_contribuyente = c_veh.id_contribuyente " +
                            "LEFT JOIN alcabala a ON fi.tipo_impuesto = 'ALCABALA' AND fi.id_referencia = a.id_alcabala " +
                            "LEFT JOIN contribuyentes c_alc ON a.id_contribuyente_comprador = c_alc.id_contribuyente " +
                            "WHERE ( " +
                            "   (fi.tipo_impuesto = 'PREDIAL' AND c_pred.id_persona = ?1) " +
                            "   OR (fi.tipo_impuesto = 'VEHICULAR' AND c_veh.id_persona = ?1) " +
                            "   OR (fi.tipo_impuesto = 'ALCABALA' AND c_alc.id_persona = ?1) " +
                            ") " +
                            "ORDER BY CASE WHEN fc.estado = 'PENDIENTE' THEN 0 ELSE 1 END ASC, " +
                            "fc.fecha_vencimiento ASC, fc.id_cuota DESC"
            );
            q.setParameter(1, idPersona);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Object[] obtenerFraccionamientoPorPersona(int idPersona, int idFraccionamiento) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "fi.id_fraccionamiento, " +
                            "fi.tipo_impuesto, " +
                            "fi.id_referencia, " +
                            "fi.codigo_impuesto, " +
                            "fi.contribuyente, " +
                            "fi.descripcion, " +
                            "fi.monto_anual, " +
                            "fi.periodicidad, " +
                            "fi.meses_por_cuota, " +
                            "fi.total_cuotas, " +
                            "SUM(CASE WHEN fc.estado = 'PAGADO' THEN 1 ELSE 0 END) AS cuotas_pagadas, " +
                            "SUM(CASE WHEN fc.estado = 'PENDIENTE' THEN 1 ELSE 0 END) AS cuotas_pendientes, " +
                            "fi.estado, " +
                            "fi.fecha_registro, " +
                            "fi.fecha_cierre " +
                            "FROM fraccionamiento_impuesto fi " +
                            "LEFT JOIN fraccionamiento_cuota fc ON fc.id_fraccionamiento = fi.id_fraccionamiento " +
                            "LEFT JOIN impuesto_predial p ON fi.tipo_impuesto = 'PREDIAL' AND fi.id_referencia = p.id_predial " +
                            "LEFT JOIN inmueble ip ON p.id_inmueble = ip.id_inmueble " +
                            "LEFT JOIN contribuyentes c_pred ON ip.id_contribuyente = c_pred.id_contribuyente " +
                            "LEFT JOIN impuesto iv ON fi.tipo_impuesto = 'VEHICULAR' AND fi.id_referencia = iv.id_impuesto " +
                            "LEFT JOIN contribuyentes c_veh ON iv.id_contribuyente = c_veh.id_contribuyente " +
                            "LEFT JOIN alcabala a ON fi.tipo_impuesto = 'ALCABALA' AND fi.id_referencia = a.id_alcabala " +
                            "LEFT JOIN contribuyentes c_alc ON a.id_contribuyente_comprador = c_alc.id_contribuyente " +
                            "WHERE fi.id_fraccionamiento = ?1 " +
                            "AND ( " +
                            "   (fi.tipo_impuesto = 'PREDIAL' AND c_pred.id_persona = ?2) " +
                            "   OR (fi.tipo_impuesto = 'VEHICULAR' AND c_veh.id_persona = ?2) " +
                            "   OR (fi.tipo_impuesto = 'ALCABALA' AND c_alc.id_persona = ?2) " +
                            ") " +
                            "GROUP BY fi.id_fraccionamiento, fi.tipo_impuesto, fi.id_referencia, fi.codigo_impuesto, " +
                            "fi.contribuyente, fi.descripcion, fi.monto_anual, fi.periodicidad, fi.meses_por_cuota, " +
                            "fi.total_cuotas, fi.estado, fi.fecha_registro, fi.fecha_cierre " +
                            "LIMIT 1"
            );
            q.setParameter(1, idFraccionamiento);
            q.setParameter(2, idPersona);

            List<?> rows = q.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (Object[]) rows.get(0);
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarDetalleFraccionamientoPorPersona(int idPersona, int idFraccionamiento) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "fc.id_cuota, " +
                            "fc.numero_cuota, " +
                            "fc.periodo_label, " +
                            "fc.fecha_vencimiento, " +
                            "fc.monto_programado, " +
                            "fc.estado, " +
                            "fc.fecha_pago, " +
                            "fc.monto_pagado, " +
                            "fc.observacion_pago " +
                            "FROM fraccionamiento_cuota fc " +
                            "INNER JOIN fraccionamiento_impuesto fi ON fi.id_fraccionamiento = fc.id_fraccionamiento " +
                            "LEFT JOIN impuesto_predial p ON fi.tipo_impuesto = 'PREDIAL' AND fi.id_referencia = p.id_predial " +
                            "LEFT JOIN inmueble ip ON p.id_inmueble = ip.id_inmueble " +
                            "LEFT JOIN contribuyentes c_pred ON ip.id_contribuyente = c_pred.id_contribuyente " +
                            "LEFT JOIN impuesto iv ON fi.tipo_impuesto = 'VEHICULAR' AND fi.id_referencia = iv.id_impuesto " +
                            "LEFT JOIN contribuyentes c_veh ON iv.id_contribuyente = c_veh.id_contribuyente " +
                            "LEFT JOIN alcabala a ON fi.tipo_impuesto = 'ALCABALA' AND fi.id_referencia = a.id_alcabala " +
                            "LEFT JOIN contribuyentes c_alc ON a.id_contribuyente_comprador = c_alc.id_contribuyente " +
                            "WHERE fi.id_fraccionamiento = ?1 " +
                            "AND ( " +
                            "   (fi.tipo_impuesto = 'PREDIAL' AND c_pred.id_persona = ?2) " +
                            "   OR (fi.tipo_impuesto = 'VEHICULAR' AND c_veh.id_persona = ?2) " +
                            "   OR (fi.tipo_impuesto = 'ALCABALA' AND c_alc.id_persona = ?2) " +
                            ") " +
                            "ORDER BY fc.numero_cuota ASC"
            );
            q.setParameter(1, idFraccionamiento);
            q.setParameter(2, idPersona);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarPagosPorPersona(int idPersona) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "fc.id_cuota, " +
                            "fi.tipo_impuesto, " +
                            "fi.codigo_impuesto, " +
                            "fc.numero_cuota, " +
                            "fi.total_cuotas, " +
                            "fc.periodo_label, " +
                            "fc.fecha_vencimiento, " +
                            "fc.fecha_pago, " +
                            "COALESCE(fc.monto_pagado, fc.monto_programado, 0), " +
                            "fc.observacion_pago " +
                            "FROM fraccionamiento_cuota fc " +
                            "INNER JOIN fraccionamiento_impuesto fi ON fi.id_fraccionamiento = fc.id_fraccionamiento " +
                            "LEFT JOIN impuesto_predial p ON fi.tipo_impuesto = 'PREDIAL' AND fi.id_referencia = p.id_predial " +
                            "LEFT JOIN inmueble ip ON p.id_inmueble = ip.id_inmueble " +
                            "LEFT JOIN contribuyentes c_pred ON ip.id_contribuyente = c_pred.id_contribuyente " +
                            "LEFT JOIN impuesto iv ON fi.tipo_impuesto = 'VEHICULAR' AND fi.id_referencia = iv.id_impuesto " +
                            "LEFT JOIN contribuyentes c_veh ON iv.id_contribuyente = c_veh.id_contribuyente " +
                            "LEFT JOIN alcabala a ON fi.tipo_impuesto = 'ALCABALA' AND fi.id_referencia = a.id_alcabala " +
                            "LEFT JOIN contribuyentes c_alc ON a.id_contribuyente_comprador = c_alc.id_contribuyente " +
                            "WHERE fc.estado = 'PAGADO' " +
                            "AND ( " +
                            "   (fi.tipo_impuesto = 'PREDIAL' AND c_pred.id_persona = ?1) " +
                            "   OR (fi.tipo_impuesto = 'VEHICULAR' AND c_veh.id_persona = ?1) " +
                            "   OR (fi.tipo_impuesto = 'ALCABALA' AND c_alc.id_persona = ?1) " +
                            ") " +
                            "ORDER BY COALESCE(fc.fecha_pago, fc.fecha_vencimiento) DESC, fc.id_cuota DESC"
            );
            q.setParameter(1, idPersona);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarInmueblesPorPersona(int idPersona) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "i.id_inmueble, " +
                            "i.direccion, " +
                            "z.nombre, " +
                            "i.tipo_uso, " +
                            "i.valor_catastral, " +
                            "i.estado, " +
                            "i.fecha_registro " +
                            "FROM inmueble i " +
                            "INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente " +
                            "INNER JOIN zona z ON z.id_zona = i.id_zona " +
                            "WHERE c.id_persona = ?1 " +
                            "ORDER BY i.id_inmueble DESC"
            );
            q.setParameter(1, idPersona);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarVehiculosPorPersona(int idPersona) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "v.id_vehiculo, " +
                            "v.placa, " +
                            "v.marca, " +
                            "v.modelo, " +
                            "v.anio, " +
                            "v.valor, " +
                            "v.estado, " +
                            "v.fecha_registro " +
                            "FROM vehiculo v " +
                            "INNER JOIN contribuyentes c ON c.id_contribuyente = v.id_contribuyente " +
                            "WHERE c.id_persona = ?1 " +
                            "ORDER BY v.id_vehiculo DESC"
            );
            q.setParameter(1, idPersona);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Object[] obtenerCuotaPendientePorPersona(int idPersona, int idCuota) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "fc.id_cuota, " +
                            "fi.id_fraccionamiento, " +
                            "fi.tipo_impuesto, " +
                            "fi.id_referencia, " +
                            "fi.codigo_impuesto, " +
                            "fc.numero_cuota, " +
                            "fi.total_cuotas, " +
                            "fc.monto_programado, " +
                            "fc.estado " +
                            "FROM fraccionamiento_cuota fc " +
                            "INNER JOIN fraccionamiento_impuesto fi ON fi.id_fraccionamiento = fc.id_fraccionamiento " +
                            "LEFT JOIN impuesto_predial p ON fi.tipo_impuesto = 'PREDIAL' AND fi.id_referencia = p.id_predial " +
                            "LEFT JOIN inmueble ip ON p.id_inmueble = ip.id_inmueble " +
                            "LEFT JOIN contribuyentes c_pred ON ip.id_contribuyente = c_pred.id_contribuyente " +
                            "LEFT JOIN impuesto iv ON fi.tipo_impuesto = 'VEHICULAR' AND fi.id_referencia = iv.id_impuesto " +
                            "LEFT JOIN contribuyentes c_veh ON iv.id_contribuyente = c_veh.id_contribuyente " +
                            "LEFT JOIN alcabala a ON fi.tipo_impuesto = 'ALCABALA' AND fi.id_referencia = a.id_alcabala " +
                            "LEFT JOIN contribuyentes c_alc ON a.id_contribuyente_comprador = c_alc.id_contribuyente " +
                            "WHERE fc.id_cuota = ?1 " +
                            "AND fc.estado = 'PENDIENTE' " +
                            "AND ( " +
                            "   (fi.tipo_impuesto = 'PREDIAL' AND c_pred.id_persona = ?2) " +
                            "   OR (fi.tipo_impuesto = 'VEHICULAR' AND c_veh.id_persona = ?2) " +
                            "   OR (fi.tipo_impuesto = 'ALCABALA' AND c_alc.id_persona = ?2) " +
                            ") " +
                            "LIMIT 1"
            );
            q.setParameter(1, idCuota);
            q.setParameter(2, idPersona);

            List<?> rows = q.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (Object[]) rows.get(0);
        } finally {
            em.close();
        }
    }

    public void actualizarDatosContactoPersona(int idPersona, String telefono, String direccion) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.createNativeQuery(
                            "UPDATE personas " +
                                    "SET telefono = ?1, direccion = ?2 " +
                                    "WHERE id_persona = ?3")
                    .setParameter(1, telefono)
                    .setParameter(2, direccion)
                    .setParameter(3, idPersona)
                    .executeUpdate();
            tx.commit();
        } catch (RuntimeException ex) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw ex;
        } finally {
            em.close();
        }
    }

    public void actualizarPasswordUsuario(int idUsuario, String passwordHash) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.createNativeQuery(
                            "UPDATE usuarios " +
                                    "SET password_hash = ?1 " +
                                    "WHERE id_usuario = ?2")
                    .setParameter(1, passwordHash)
                    .setParameter(2, idUsuario)
                    .executeUpdate();
            tx.commit();
        } catch (RuntimeException ex) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw ex;
        } finally {
            em.close();
        }
    }
}
