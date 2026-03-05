package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.Query;
import jakarta.persistence.StoredProcedureQuery;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

public class ImpuestoDAO {

    // =========================
    // Vehicular
    // =========================
    public List<Object[]> listarVehiculares() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_impuestos_vehiculares");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void crearImpuestoVehicular(int idVehiculo) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_crear_impuesto_vehicular");
            sp.registerStoredProcedureParameter("p_id_vehiculo", Integer.class, ParameterMode.IN);
            sp.setParameter("p_id_vehiculo", idVehiculo);

            sp.execute();
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

    public Object[] obtenerPorId(int idImpuesto) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_obtener_impuesto_vehicular");

            sp.registerStoredProcedureParameter("p_id_impuesto", Integer.class, ParameterMode.IN);
            sp.setParameter("p_id_impuesto", idImpuesto);

            return (Object[]) sp.getSingleResult();

        } finally {
            em.close();
        }
    }

    public List<Object[]> listarDetalle(int idImpuesto) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_detalle_impuesto");

            sp.registerStoredProcedureParameter("p_id_impuesto", Integer.class, ParameterMode.IN);
            sp.setParameter("p_id_impuesto", idImpuesto);

            return sp.getResultList();

        } finally {
            em.close();
        }
    }

    // =========================
    // Predial
    // =========================
    public List<Object[]> listarPrediales() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_impuestos_prediales");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarInmueblesPredialDisponibles() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_inmuebles_disponibles_predial");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void crearImpuestoPredial(int idInmueble) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_crear_impuesto_predial");
            sp.registerStoredProcedureParameter("p_id_inmueble", Integer.class, ParameterMode.IN);
            sp.setParameter("p_id_inmueble", idInmueble);

            sp.execute();
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

    public Object[] obtenerPredialPorId(int idPredial) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_obtener_impuesto_predial");
            sp.registerStoredProcedureParameter("p_id_predial", Integer.class, ParameterMode.IN);
            sp.setParameter("p_id_predial", idPredial);
            return (Object[]) sp.getSingleResult();
        } finally {
            em.close();
        }
    }

    public void cambiarEstadoPredial(int idPredial, String estado, String motivo, String detalleMotivo) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_cambiar_estado_impuesto_predial");
            sp.registerStoredProcedureParameter("p_id_predial", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_estado", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_motivo", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_detalle_motivo", String.class, ParameterMode.IN);

            sp.setParameter("p_id_predial", idPredial);
            sp.setParameter("p_estado", estado);
            sp.setParameter("p_motivo", motivo);
            sp.setParameter("p_detalle_motivo", detalleMotivo);

            sp.execute();
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

    public List<Object[]> listarHistorialPredial(int idPredial) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_historial_predial");
            sp.registerStoredProcedureParameter("p_id_predial", Integer.class, ParameterMode.IN);
            sp.setParameter("p_id_predial", idPredial);
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void aplicarReglasAutomaticasPredial(int edadLimite) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_aplicar_reglas_automaticas_predial");
            sp.registerStoredProcedureParameter("p_edad_limite", Integer.class, ParameterMode.IN);
            sp.setParameter("p_edad_limite", edadLimite);

            sp.execute();
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

    public void actualizarPredialBasico(int idPredial, BigDecimal tasaAplicada, BigDecimal montoAnual) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "UPDATE impuesto_predial SET tasa_aplicada = ?1, monto_anual = ?2 WHERE id_predial = ?3");
            q.setParameter(1, tasaAplicada);
            q.setParameter(2, montoAnual);
            q.setParameter(3, idPredial);
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

    // =========================
    // Alcabala
    // =========================
    public List<Object[]> listarAlcabalas() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_impuestos_alcabala");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarInmueblesParaAlcabala() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_inmuebles_para_alcabala");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void crearImpuestoAlcabala(int idInmueble, int idComprador, BigDecimal valorVenta, LocalDate fechaVenta) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_crear_impuesto_alcabala");
            sp.registerStoredProcedureParameter("p_id_inmueble", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_id_contribuyente_comprador", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_valor_venta", BigDecimal.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_fecha_venta", Date.class, ParameterMode.IN);

            sp.setParameter("p_id_inmueble", idInmueble);
            sp.setParameter("p_id_contribuyente_comprador", idComprador);
            sp.setParameter("p_valor_venta", valorVenta);
            sp.setParameter("p_fecha_venta", Date.valueOf(fechaVenta));

            sp.execute();
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

    public Object[] obtenerAlcabalaPorId(int idAlcabala) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_obtener_impuesto_alcabala");
            sp.registerStoredProcedureParameter("p_id_alcabala", Integer.class, ParameterMode.IN);
            sp.setParameter("p_id_alcabala", idAlcabala);
            return (Object[]) sp.getSingleResult();
        } finally {
            em.close();
        }
    }

    public Object[] obtenerAlcabalaEditablePorId(int idAlcabala) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT id_alcabala, valor_venta, fecha_venta, estado, valor_catastral_ref " +
                            "FROM alcabala WHERE id_alcabala = ?1");
            q.setParameter(1, idAlcabala);
            List<?> rows = q.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (Object[]) rows.get(0);
        } finally {
            em.close();
        }
    }

    public void cambiarEstadoAlcabala(int idAlcabala, String estado) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Query q = em.createNativeQuery("UPDATE alcabala SET estado = ?1 WHERE id_alcabala = ?2");
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

    public void actualizarAlcabalaBasico(int idAlcabala, BigDecimal valorVenta, LocalDate fechaVenta) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query qAlc = em.createNativeQuery(
                    "SELECT valor_catastral_ref FROM alcabala WHERE id_alcabala = ?1");
            qAlc.setParameter(1, idAlcabala);
            List<?> alcRows = qAlc.getResultList();
            if (alcRows.isEmpty()) {
                throw new IllegalArgumentException("No existe el registro de alcabala.");
            }

            BigDecimal valorCatastral = toBigDecimal(alcRows.get(0));
            if (valorCatastral == null) {
                throw new IllegalArgumentException("No hay valor catastral de referencia para recalcular alcabala.");
            }

            int anioUit = fechaVenta.getYear();
            Query qUit = em.createNativeQuery("SELECT valor FROM uit WHERE anio = ?1 LIMIT 1");
            qUit.setParameter(1, anioUit);
            List<?> uitRows = qUit.getResultList();
            if (uitRows.isEmpty()) {
                throw new IllegalArgumentException("No existe UIT para el anio " + anioUit + ".");
            }

            BigDecimal valorUit = toBigDecimal(uitRows.get(0));
            BigDecimal baseCalculo = valorVenta.max(valorCatastral);
            BigDecimal montoInafecto = valorUit.multiply(new BigDecimal("10"));
            BigDecimal baseImponible = baseCalculo.subtract(montoInafecto);
            if (baseImponible.compareTo(BigDecimal.ZERO) < 0) {
                baseImponible = BigDecimal.ZERO;
            }
            BigDecimal montoAlcabala = baseImponible.multiply(new BigDecimal("0.03")).setScale(2, RoundingMode.HALF_UP);

            Query qUpd = em.createNativeQuery(
                    "UPDATE alcabala SET valor_venta = ?1, fecha_venta = ?2, base_calculo = ?3, " +
                            "monto_inafecto = ?4, base_imponible = ?5, tasa_aplicada = ?6, " +
                            "monto_alcabala = ?7, anio_uit = ?8, valor_uit = ?9 WHERE id_alcabala = ?10");
            qUpd.setParameter(1, valorVenta);
            qUpd.setParameter(2, Date.valueOf(fechaVenta));
            qUpd.setParameter(3, baseCalculo);
            qUpd.setParameter(4, montoInafecto);
            qUpd.setParameter(5, baseImponible);
            qUpd.setParameter(6, new BigDecimal("3.00"));
            qUpd.setParameter(7, montoAlcabala);
            qUpd.setParameter(8, anioUit);
            qUpd.setParameter(9, valorUit);
            qUpd.setParameter(10, idAlcabala);
            qUpd.executeUpdate();

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

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }
        if (value instanceof Number) {
            return new BigDecimal(value.toString());
        }
        return new BigDecimal(value.toString());
    }
}
