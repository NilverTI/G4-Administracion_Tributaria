package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.*;

import java.util.List;

public class ContribuyenteDAO {

    public List<Object[]> listar() {

        EntityManager em = JPAUtil.getEntityManager();

        try {
            StoredProcedureQuery query =
                    em.createStoredProcedureQuery("sp_listar_contribuyentes");

            return (List<Object[]>) query.getResultList();


        } finally {
            em.close();
        }
    }

    public void crear(
            String tipoDoc,
            String numeroDoc,
            String nombres,
            String apellidos,
            String telefono,
            String email,
            String direccion) {

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery query =
                    em.createStoredProcedureQuery("sp_crear_contribuyente");

            query.registerStoredProcedureParameter("p_tipo_documento", String.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("p_numero_documento", String.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("p_nombres", String.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("p_apellidos", String.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("p_telefono", String.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("p_email", String.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("p_direccion", String.class, ParameterMode.IN);

            query.setParameter("p_tipo_documento", tipoDoc);
            query.setParameter("p_numero_documento", numeroDoc);
            query.setParameter("p_nombres", nombres);
            query.setParameter("p_apellidos", apellidos);
            query.setParameter("p_telefono", telefono);
            query.setParameter("p_email", email);
            query.setParameter("p_direccion", direccion);

            query.execute();

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

            StoredProcedureQuery query =
                    em.createStoredProcedureQuery("sp_cambiar_estado_contribuyente");

            query.registerStoredProcedureParameter("p_id_contribuyente", Integer.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("p_estado", String.class, ParameterMode.IN);

            query.setParameter("p_id_contribuyente", id);
            query.setParameter("p_estado", estado);

            query.execute();

            tx.commit();

        } catch (Exception e) {
            tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public int contar() {

    EntityManager em = JPAUtil.getEntityManager();

    try {
        Long total = (Long) em
                .createQuery("SELECT COUNT(c) FROM Contribuyente c")
                .getSingleResult();

        return total.intValue();

    } finally {
        em.close();
    }
    }



    public int contarActivos() {

    EntityManager em = JPAUtil.getEntityManager();

    try {
        Long total = (Long) em
                .createQuery("SELECT COUNT(c) FROM Contribuyente c WHERE c.estado = 'ACTIVO'")
                .getSingleResult();

        return total.intValue();

    } finally {
        em.close();
    }
    }

    public List<Object[]> listarActivosCombo() {
    EntityManager em = JPAUtil.getEntityManager();
    try {
        Query q = em.createNativeQuery("CALL sp_listar_contribuyentes_combo()");
        return q.getResultList();
    } finally {
        em.close();
    }
    }

}
