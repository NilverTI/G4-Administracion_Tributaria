package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

public class FuncionarioCuotaDAO {

    public boolean existeFraccionamiento(String tipoImpuesto, int idReferencia) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT COUNT(*) " +
                            "FROM fraccionamiento_impuesto " +
                            "WHERE tipo_impuesto = ?1 " +
                            "  AND id_referencia = ?2"
            );
            q.setParameter(1, tipoImpuesto);
            q.setParameter(2, idReferencia);

            Number total = (Number) q.getSingleResult();
            return total != null && total.longValue() > 0;
        } finally {
            em.close();
        }
    }

    public boolean existeFraccionamientoVigente(String tipoImpuesto, int idReferencia) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT COUNT(*) " +
                            "FROM fraccionamiento_impuesto " +
                            "WHERE tipo_impuesto = ?1 " +
                            "  AND id_referencia = ?2 " +
                            "  AND estado = 'ACTIVO'"
            );
            q.setParameter(1, tipoImpuesto);
            q.setParameter(2, idReferencia);

            Number total = (Number) q.getSingleResult();
            return total != null && total.longValue() > 0;
        } finally {
            em.close();
        }
    }

    public String obtenerEstadoUltimoFraccionamiento(String tipoImpuesto, int idReferencia) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT estado " +
                            "FROM fraccionamiento_impuesto " +
                            "WHERE tipo_impuesto = ?1 " +
                            "  AND id_referencia = ?2 " +
                            "ORDER BY id_fraccionamiento DESC " +
                            "LIMIT 1"
            );
            q.setParameter(1, tipoImpuesto);
            q.setParameter(2, idReferencia);

            List<?> rows = q.getResultList();
            if (rows.isEmpty() || rows.get(0) == null) {
                return null;
            }
            return rows.get(0).toString().trim().toUpperCase();
        } finally {
            em.close();
        }
    }

    public int contarFraccionamientosCerrados(String tipoImpuesto, int idReferencia) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT COUNT(*) " +
                            "FROM fraccionamiento_impuesto " +
                            "WHERE tipo_impuesto = ?1 " +
                            "  AND id_referencia = ?2 " +
                            "  AND estado = 'CERRADO'"
            );
            q.setParameter(1, tipoImpuesto);
            q.setParameter(2, idReferencia);

            Number total = (Number) q.getSingleResult();
            return total == null ? 0 : total.intValue();
        } finally {
            em.close();
        }
    }

    public int crearFraccionamiento(
            String tipoImpuesto,
            int idReferencia,
            String codigoImpuesto,
            String contribuyente,
            String descripcion,
            BigDecimal montoAnual,
            String periodicidad,
            int mesesPorCuota,
            int totalCuotas
    ) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "INSERT INTO fraccionamiento_impuesto (" +
                            "tipo_impuesto, id_referencia, codigo_impuesto, contribuyente, descripcion, " +
                            "monto_anual, periodicidad, meses_por_cuota, total_cuotas, estado, fecha_registro" +
                            ") VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, 'ACTIVO', NOW())"
            );
            q.setParameter(1, tipoImpuesto);
            q.setParameter(2, idReferencia);
            q.setParameter(3, codigoImpuesto);
            q.setParameter(4, contribuyente);
            q.setParameter(5, descripcion);
            q.setParameter(6, montoAnual);
            q.setParameter(7, periodicidad);
            q.setParameter(8, mesesPorCuota);
            q.setParameter(9, totalCuotas);
            q.executeUpdate();

            Number id = (Number) em.createNativeQuery("SELECT LAST_INSERT_ID()").getSingleResult();
            tx.commit();
            return id == null ? 0 : id.intValue();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void crearCuota(
            int idFraccionamiento,
            int numeroCuota,
            String periodoLabel,
            LocalDate fechaVencimiento,
            BigDecimal montoProgramado
    ) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "INSERT INTO fraccionamiento_cuota (" +
                            "id_fraccionamiento, numero_cuota, periodo_label, fecha_vencimiento, monto_programado, estado, fecha_registro" +
                            ") VALUES (?1, ?2, ?3, ?4, ?5, 'PENDIENTE', NOW())"
            );
            q.setParameter(1, idFraccionamiento);
            q.setParameter(2, numeroCuota);
            q.setParameter(3, periodoLabel);
            q.setParameter(4, Date.valueOf(fechaVencimiento));
            q.setParameter(5, montoProgramado);
            q.executeUpdate();

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public int contarDetallesVehicularesPagados(int idImpuesto) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT COUNT(*) " +
                            "FROM impuesto_detalle " +
                            "WHERE id_impuesto = ?1 " +
                            "  AND estado = 'PAGADO'"
            );
            q.setParameter(1, idImpuesto);

            Number total = (Number) q.getSingleResult();
            return total == null ? 0 : total.intValue();
        } finally {
            em.close();
        }
    }

    public boolean marcarSiguienteDetalleVehicularPagado(int idImpuesto) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query qSelect = em.createNativeQuery(
                    "SELECT id_detalle, monto " +
                            "FROM impuesto_detalle " +
                            "WHERE id_impuesto = ?1 " +
                            "  AND estado = 'PENDIENTE' " +
                            "ORDER BY anio ASC, id_detalle ASC " +
                            "LIMIT 1"
            );
            qSelect.setParameter(1, idImpuesto);

            List<?> rows = qSelect.getResultList();
            if (rows.isEmpty()) {
                tx.commit();
                return false;
            }

            Object[] row = (Object[]) rows.get(0);
            int idDetalle = ((Number) row[0]).intValue();
            BigDecimal monto = row[1] == null ? BigDecimal.ZERO : new BigDecimal(row[1].toString());

            Query qUpdate = em.createNativeQuery(
                    "UPDATE impuesto_detalle " +
                            "SET pagado = ?1, estado = 'PAGADO' " +
                            "WHERE id_detalle = ?2 AND estado = 'PENDIENTE'"
            );
            qUpdate.setParameter(1, monto);
            qUpdate.setParameter(2, idDetalle);
            qUpdate.executeUpdate();

            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public Integer obtenerPredialActivoPorInmueble(int idInmueble) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT id_predial " +
                            "FROM impuesto_predial " +
                            "WHERE id_inmueble = ?1 " +
                            "  AND estado = 'ACTIVO' " +
                            "ORDER BY id_predial DESC " +
                            "LIMIT 1"
            );
            q.setParameter(1, idInmueble);

            List<?> rows = q.getResultList();
            if (rows.isEmpty() || rows.get(0) == null) {
                return null;
            }
            Object value = rows.get(0);
            if (value instanceof Number) {
                return ((Number) value).intValue();
            }
            return Integer.parseInt(value.toString().trim());
        } finally {
            em.close();
        }
    }

    public void actualizarEstadoAlcabala(int idAlcabala, String estado) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "UPDATE alcabala SET estado = ?1 WHERE id_alcabala = ?2"
            );
            q.setParameter(1, estado);
            q.setParameter(2, idAlcabala);
            q.executeUpdate();

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void eliminarFraccionamiento(int idFraccionamiento) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "DELETE FROM fraccionamiento_impuesto WHERE id_fraccionamiento = ?1"
            );
            q.setParameter(1, idFraccionamiento);
            q.executeUpdate();

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarFraccionamientos() {
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
                            "fi.total_cuotas, " +
                            "SUM(CASE WHEN fc.estado = 'PAGADO' THEN 1 ELSE 0 END) AS cuotas_pagadas, " +
                            "SUM(CASE WHEN fc.estado = 'PENDIENTE' THEN 1 ELSE 0 END) AS cuotas_pendientes, " +
                            "fi.estado, " +
                            "fi.fecha_registro " +
                            "FROM fraccionamiento_impuesto fi " +
                            "INNER JOIN (" +
                            "   SELECT tipo_impuesto, id_referencia, MAX(id_fraccionamiento) AS id_fraccionamiento " +
                            "   FROM fraccionamiento_impuesto " +
                            "   GROUP BY tipo_impuesto, id_referencia" +
                            ") ult ON ult.id_fraccionamiento = fi.id_fraccionamiento " +
                            "LEFT JOIN fraccionamiento_cuota fc ON fc.id_fraccionamiento = fi.id_fraccionamiento " +
                            "GROUP BY fi.id_fraccionamiento, fi.tipo_impuesto, fi.id_referencia, fi.codigo_impuesto, fi.contribuyente, " +
                            "fi.descripcion, fi.monto_anual, fi.periodicidad, fi.total_cuotas, fi.estado, fi.fecha_registro " +
                            "ORDER BY fi.id_fraccionamiento DESC"
            );
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Object[] obtenerFraccionamiento(int idFraccionamiento) {
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
                            "WHERE fi.id_fraccionamiento = ?1 " +
                            "GROUP BY fi.id_fraccionamiento, fi.tipo_impuesto, fi.id_referencia, fi.codigo_impuesto, " +
                            "fi.contribuyente, fi.descripcion, fi.monto_anual, fi.periodicidad, fi.meses_por_cuota, " +
                            "fi.total_cuotas, fi.estado, fi.fecha_registro, fi.fecha_cierre"
            );
            q.setParameter(1, idFraccionamiento);

            List<?> rows = q.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (Object[]) rows.get(0);
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarCuotasPorFraccionamiento(int idFraccionamiento) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "id_cuota, " +
                            "numero_cuota, " +
                            "periodo_label, " +
                            "fecha_vencimiento, " +
                            "monto_programado, " +
                            "estado, " +
                            "fecha_pago, " +
                            "monto_pagado, " +
                            "observacion_pago " +
                            "FROM fraccionamiento_cuota " +
                            "WHERE id_fraccionamiento = ?1 " +
                            "ORDER BY numero_cuota ASC"
            );
            q.setParameter(1, idFraccionamiento);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarCuotasPendientes() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "fi.id_fraccionamiento, " +
                            "fi.tipo_impuesto, " +
                            "fi.id_referencia, " +
                            "fi.codigo_impuesto, " +
                            "fi.contribuyente, " +
                            "fi.monto_anual, " +
                            "fi.periodicidad, " +
                            "fi.total_cuotas, " +
                            "SUM(CASE WHEN fc.estado = 'PAGADO' THEN 1 ELSE 0 END) AS cuotas_pagadas, " +
                            "SUM(CASE WHEN fc.estado = 'PENDIENTE' THEN 1 ELSE 0 END) AS cuotas_pendientes, " +
                            "MIN(CASE WHEN fc.estado = 'PENDIENTE' THEN fc.fecha_vencimiento END) AS proximo_vencimiento, " +
                            "SUM(CASE WHEN fc.estado = 'PENDIENTE' THEN fc.monto_programado ELSE 0 END) AS saldo_pendiente, " +
                            "fi.estado " +
                            "FROM fraccionamiento_cuota fc " +
                            "INNER JOIN fraccionamiento_impuesto fi ON fi.id_fraccionamiento = fc.id_fraccionamiento " +
                            "INNER JOIN (" +
                            "   SELECT tipo_impuesto, id_referencia, MAX(id_fraccionamiento) AS id_fraccionamiento " +
                            "   FROM fraccionamiento_impuesto " +
                            "   GROUP BY tipo_impuesto, id_referencia" +
                            ") ult ON ult.id_fraccionamiento = fi.id_fraccionamiento " +
                            "GROUP BY fi.id_fraccionamiento, fi.tipo_impuesto, fi.id_referencia, fi.codigo_impuesto, " +
                            "fi.contribuyente, fi.monto_anual, fi.periodicidad, fi.total_cuotas, fi.estado " +
                            "HAVING SUM(CASE WHEN fc.estado = 'PENDIENTE' THEN 1 ELSE 0 END) > 0 " +
                            "ORDER BY proximo_vencimiento ASC, fi.id_fraccionamiento DESC"
            );
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Object[] obtenerCuotaPorId(int idCuota) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT " +
                            "id_cuota, " +
                            "id_fraccionamiento, " +
                            "numero_cuota, " +
                            "periodo_label, " +
                            "fecha_vencimiento, " +
                            "monto_programado, " +
                            "estado " +
                            "FROM fraccionamiento_cuota " +
                            "WHERE id_cuota = ?1 " +
                            "LIMIT 1"
            );
            q.setParameter(1, idCuota);

            List<?> rows = q.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (Object[]) rows.get(0);
        } finally {
            em.close();
        }
    }

    public void registrarPagoCuota(
            int idCuota,
            LocalDate fechaPago,
            BigDecimal montoPagado,
            String observacion
    ) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "UPDATE fraccionamiento_cuota " +
                            "SET estado = 'PAGADO', fecha_pago = ?1, monto_pagado = ?2, observacion_pago = ?3 " +
                            "WHERE id_cuota = ?4 AND estado = 'PENDIENTE'"
            );
            q.setParameter(1, Date.valueOf(fechaPago));
            q.setParameter(2, montoPagado);
            q.setParameter(3, observacion);
            q.setParameter(4, idCuota);
            q.executeUpdate();

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void actualizarEstadoFraccionamiento(int idFraccionamiento) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query qPendientes = em.createNativeQuery(
                    "SELECT COUNT(*) " +
                            "FROM fraccionamiento_cuota " +
                            "WHERE id_fraccionamiento = ?1 " +
                            "  AND estado <> 'PAGADO'"
            );
            qPendientes.setParameter(1, idFraccionamiento);

            Number pendientes = (Number) qPendientes.getSingleResult();
            boolean tienePendientes = pendientes != null && pendientes.longValue() > 0;

            if (tienePendientes) {
                Query q = em.createNativeQuery(
                        "UPDATE fraccionamiento_impuesto " +
                                "SET estado = 'ACTIVO', fecha_cierre = NULL " +
                                "WHERE id_fraccionamiento = ?1"
                );
                q.setParameter(1, idFraccionamiento);
                q.executeUpdate();
            } else {
                Query q = em.createNativeQuery(
                        "UPDATE fraccionamiento_impuesto " +
                                "SET estado = 'CERRADO', fecha_cierre = CURDATE() " +
                                "WHERE id_fraccionamiento = ?1"
                );
                q.setParameter(1, idFraccionamiento);
                q.executeUpdate();
            }

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
}
