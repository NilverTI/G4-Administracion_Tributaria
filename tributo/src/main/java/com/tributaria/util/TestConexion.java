package com.tributaria.util;

import jakarta.persistence.EntityManager;

public class TestConexion {

    public static void main(String[] args) {

        EntityManager em = JPAUtil.getEntityManager();

        if (em != null) {
            System.out.println("Conexión JPA exitosa");
            em.close();
        }
    }
}
