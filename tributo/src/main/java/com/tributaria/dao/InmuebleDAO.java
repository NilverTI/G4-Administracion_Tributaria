package com.tributaria.dao;

import com.tributaria.entity.Zona;
import com.tributaria.entity.Contribuyente;
import com.tributaria.util.JPAUtil;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.util.List;

public class InmuebleDAO {

    public List<Object[]> listar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_listar_inmuebles");
            return sp.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Zona> listarZonas() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT z FROM Zona z", Zona.class)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Contribuyente> listarContribuyentes() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Contribuyente c WHERE c.estado='ACTIVO'", Contribuyente.class)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public void crear(int idContribuyente, int idZona, String direccion, BigDecimal valor) {

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_crear_inmueble");

            sp.registerStoredProcedureParameter("p_id_contribuyente", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_id_zona", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_direccion", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_valor_catastral", BigDecimal.class, ParameterMode.IN);

            sp.setParameter("p_id_contribuyente", idContribuyente);
            sp.setParameter("p_id_zona", idZona);
            sp.setParameter("p_direccion", direccion);
            sp.setParameter("p_valor_catastral", valor);

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
                em.createStoredProcedureQuery("sp_cambiar_estado_inmueble");

            sp.registerStoredProcedureParameter("p_id_inmueble", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_estado", String.class, ParameterMode.IN);

            sp.setParameter("p_id_inmueble", id);
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
        // ✅ CONTAR INMUEBLES
    public int contar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long total = (Long) em
                    .createQuery("SELECT COUNT(i) FROM Inmueble i")
                    .getSingleResult();
            return total.intValue();
        } finally {
            em.close();
        }
    }

    // ✅ CONTAR INMUEBLES ACTIVOS
    public int contarActivos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long total = (Long) em
                    .createQuery("SELECT COUNT(i) FROM Inmueble i WHERE i.estado = 'ACTIVO'")
                    .getSingleResult();
            return total.intValue();
        } finally {
            em.close();
        }
    }
}
