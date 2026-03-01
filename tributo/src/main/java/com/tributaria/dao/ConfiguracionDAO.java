package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.util.List;

public class ConfiguracionDAO {

    // =========================================================
    // ===============          UIT           ===================
    // =========================================================

    @SuppressWarnings("unchecked")
    public List<Object[]> listarUIT() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_uit");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void crearUIT(int anio, double valor) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_crear_uit");
            sp.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_valor", Double.class, ParameterMode.IN);

            sp.setParameter("p_anio", anio);
            sp.setParameter("p_valor", valor);

            sp.execute();
            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void actualizarUIT(int anio, double valor) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_actualizar_uit");
            sp.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_valor", Double.class, ParameterMode.IN);

            sp.setParameter("p_anio", anio);
            sp.setParameter("p_valor", valor);

            sp.execute();
            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // =========================================================
    // ==========   CONFIGURACIÓN VEHICULAR (PORCENTAJE)  =======
    // =========================================================

    @SuppressWarnings("unchecked")
    public List<Object[]> listarVehicularConfig() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_vehicular_config");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void crearVehicularConfig(int anio, double porcentaje) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_crear_vehicular_config");
            sp.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_porcentaje", Double.class, ParameterMode.IN);

            sp.setParameter("p_anio", anio);
            sp.setParameter("p_porcentaje", porcentaje);

            sp.execute();
            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void cambiarEstadoVehicularConfig(int id, String estado) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_cambiar_estado_vehicular_config");
            sp.registerStoredProcedureParameter("p_id", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_estado", String.class, ParameterMode.IN);

            sp.setParameter("p_id", id);
            sp.setParameter("p_estado", estado);

            sp.execute();
            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // 🔥 obtener porcentaje según año (SP)
    @SuppressWarnings("unchecked")
    public BigDecimal obtenerPorcentajeVehicularPorAnio(int anio) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_obtener_porcentaje_vehicular");
            sp.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.IN);
            sp.setParameter("p_anio", anio);

            List<Object> result = sp.getResultList();
            if (!result.isEmpty() && result.get(0) != null) {
                return new BigDecimal(result.get(0).toString());
            }
            return BigDecimal.ZERO;

        } finally {
            em.close();
        }
    }

    // =========================================================
    // ===============          ZONAS          ==================
    // =========================================================

    @SuppressWarnings("unchecked")
    public List<Object[]> listarZonas() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_zonas");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void crearZona(String codigo, String nombre, double tasa) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_crear_zona");
            sp.registerStoredProcedureParameter("p_codigo", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_tasa", Double.class, ParameterMode.IN);

            sp.setParameter("p_codigo", codigo);
            sp.setParameter("p_nombre", nombre);
            sp.setParameter("p_tasa", tasa);

            sp.execute();
            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void cambiarEstadoZona(int idZona, String estado) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_cambiar_estado_zona");
            sp.registerStoredProcedureParameter("p_id_zona", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_estado", String.class, ParameterMode.IN);

            sp.setParameter("p_id_zona", idZona);
            sp.setParameter("p_estado", estado);

            sp.execute();
            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}