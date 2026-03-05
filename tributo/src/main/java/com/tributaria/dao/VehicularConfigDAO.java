package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.util.List;

public class VehicularConfigDAO {

    public List<Object[]> listar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp =
                em.createStoredProcedureQuery("sp_listar_vehicular_config");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void crear(int anio, double porcentaje) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp =
                em.createStoredProcedureQuery("sp_crear_vehicular_config");

            sp.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_porcentaje", Double.class, ParameterMode.IN);

            sp.setParameter("p_anio", anio);
            sp.setParameter("p_porcentaje", porcentaje);

            sp.execute();
            tx.commit();
        } catch (Exception e) {
            tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void cambiarEstado(int id, String estado) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp =
                em.createStoredProcedureQuery("sp_cambiar_estado_vehicular_config");

            sp.registerStoredProcedureParameter("p_id", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_estado", String.class, ParameterMode.IN);

            sp.setParameter("p_id", id);
            sp.setParameter("p_estado", estado);

            sp.execute();
            tx.commit();
        } catch (Exception e) {
            tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // 🔥 NUEVO → obtener porcentaje según año
    public BigDecimal obtenerPorcentajeVigente(int anio) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            StoredProcedureQuery sp =
                em.createStoredProcedureQuery("sp_obtener_porcentaje_vehicular");

            sp.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.IN);
            sp.setParameter("p_anio", anio);

            List<Object> result = sp.getResultList();

            if (!result.isEmpty() && result.get(0) != null) {
                return new BigDecimal(result.get(0).toString());
            }

            return BigDecimal.ZERO; // Si no hay porcentaje para ese año

        } finally {
            em.close();
        }
    }
}