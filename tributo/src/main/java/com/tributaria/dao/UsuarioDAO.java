package com.tributaria.dao;

import com.tributaria.entity.Usuario;
import com.tributaria.util.JPAUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.StoredProcedureQuery;

import java.util.List;

public class UsuarioDAO {

    public Usuario login(String username) {

        EntityManager em = JPAUtil.getEntityManager();
        Usuario usuario = null;

        try {

            StoredProcedureQuery spq = em
                    .createStoredProcedureQuery("sp_login", Usuario.class);

            spq.registerStoredProcedureParameter("p_username",
                    String.class, ParameterMode.IN);

            spq.setParameter("p_username", username);

            spq.execute();

            List<?> resultado = spq.getResultList();

            if (!resultado.isEmpty()) {
                usuario = (Usuario) resultado.get(0);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }

        return usuario;
    }
}
