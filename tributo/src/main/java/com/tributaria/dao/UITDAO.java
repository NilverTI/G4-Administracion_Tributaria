package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.*;
import java.util.List;

public class UITDAO {

    public List<Object[]> listar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp =
                    em.createStoredProcedureQuery("sp_listar_uit");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public void crear(int anio, double valor) {

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            StoredProcedureQuery sp =
                    em.createStoredProcedureQuery("sp_crear_uit");

            sp.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_valor", Double.class, ParameterMode.IN);

            sp.setParameter("p_anio", anio);
            sp.setParameter("p_valor", valor);

            sp.execute();
            tx.commit();

        } catch (Exception e) {
            tx.rollback();
            throw e;

        } finally {
            em.close();
        }
    }

    public void actualizar(int anio, double valor) {

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            StoredProcedureQuery sp =
                    em.createStoredProcedureQuery("sp_actualizar_uit");

            sp.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_valor", Double.class, ParameterMode.IN);

            sp.setParameter("p_anio", anio);
            sp.setParameter("p_valor", valor);

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