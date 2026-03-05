package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.*;

import java.util.List;

public class ZonaDAO {

    public List<Object[]> listar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp =
                    em.createStoredProcedureQuery("sp_listar_zonas");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void crear(String codigo, String nombre, double tasa) {

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp =
                    em.createStoredProcedureQuery("sp_crear_zona");

            sp.registerStoredProcedureParameter("p_codigo", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_tasa", Double.class, ParameterMode.IN);

            sp.setParameter("p_codigo", codigo);
            sp.setParameter("p_nombre", nombre);
            sp.setParameter("p_tasa", tasa);

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
                    em.createStoredProcedureQuery("sp_cambiar_estado_zona");

            sp.registerStoredProcedureParameter("p_id_zona", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_estado", String.class, ParameterMode.IN);

            sp.setParameter("p_id_zona", id);
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
}