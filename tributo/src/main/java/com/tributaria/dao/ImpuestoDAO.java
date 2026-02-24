package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.EntityManager;

import java.util.List;

public class ImpuestoDAO {

    @SuppressWarnings("unchecked")
    public List<Object[]> listarImpuestos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createNativeQuery("CALL sp_listar_impuestos()")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> listarContribuyentesCombo() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createNativeQuery("CALL sp_listar_contribuyentes_combo()")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> listarCuotasPorImpuesto(int idImpuesto) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createNativeQuery("CALL sp_listar_cuotas_por_impuesto(?)")
                    .setParameter(1, idImpuesto)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void generarImpuesto(int idContribuyente, String tipo, int anio) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            em.createNativeQuery("CALL sp_generar_impuesto(?, ?, ?)")
                    .setParameter(1, idContribuyente)
                    .setParameter(2, tipo)
                    .setParameter(3, anio)
                    .executeUpdate();

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}