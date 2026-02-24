package com.tributaria.dao;

import com.tributaria.entity.Pago;
import com.tributaria.util.JPAUtil;

import jakarta.persistence.EntityManager;
import java.util.List;

public class PagoDAO {

    public void guardar(Pago pago) {
        EntityManager em = JPAUtil.getEntityManager();
        em.getTransaction().begin();
        em.persist(pago);
        em.getTransaction().commit();
        em.close();
    }

    public List<Pago> listar() {
        EntityManager em = JPAUtil.getEntityManager();

        List<Pago> lista = em.createQuery("""
            SELECT p FROM Pago p
            JOIN FETCH p.cuota c
            JOIN FETCH c.impuesto i
            JOIN FETCH i.contribuyente co
            JOIN FETCH co.persona
            ORDER BY p.id DESC
        """, Pago.class).getResultList();

        em.close();
        return lista;
    }
}