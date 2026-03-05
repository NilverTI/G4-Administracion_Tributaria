package com.tributaria.dao;

import com.tributaria.entity.Usuario;
import com.tributaria.util.JPAUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
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

    public void crearCuentaContribuyentePorCorreo(String correo, String passwordHash) {

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            List<?> registros = em.createNativeQuery(
                            "SELECT c.id_contribuyente, p.id_persona " +
                                    "FROM contribuyentes c " +
                                    "INNER JOIN personas p ON p.id_persona = c.id_persona " +
                                    "WHERE LOWER(TRIM(p.email)) = LOWER(TRIM(?1)) " +
                                    "AND c.estado = 'ACTIVO' " +
                                    "AND p.estado = 'ACTIVO'")
                    .setParameter(1, correo)
                    .getResultList();

            if (registros.isEmpty()) {
                throw new IllegalArgumentException("El correo no existe como contribuyente activo.");
            }

            if (registros.size() > 1) {
                throw new IllegalStateException("El correo tiene multiples registros. Contacte al funcionario.");
            }

            Object[] fila = (Object[]) registros.get(0);
            int idPersona = ((Number) fila[1]).intValue();

            Number totalUsuarios = (Number) em.createNativeQuery(
                            "SELECT COUNT(*) FROM usuarios WHERE id_persona = ?1")
                    .setParameter(1, idPersona)
                    .getSingleResult();

            if (totalUsuarios.intValue() > 0) {
                throw new IllegalStateException("Este correo ya tiene una cuenta creada.");
            }

            List<?> roles = em.createNativeQuery(
                            "SELECT id_rol FROM roles WHERE UPPER(nombre) = 'CONTRIBUYENTE' LIMIT 1")
                    .getResultList();

            if (roles.isEmpty()) {
                throw new IllegalStateException("No existe el rol CONTRIBUYENTE en el sistema.");
            }

            int idRolContribuyente = ((Number) roles.get(0)).intValue();
            String username = correo.trim().toLowerCase();

            em.createNativeQuery(
                            "INSERT INTO usuarios (" +
                                    "id_persona, id_rol, username, password_hash, estado, primer_ingreso, fecha_creacion" +
                                    ") VALUES (?1, ?2, ?3, ?4, 'ACTIVO', 0, NOW())")
                    .setParameter(1, idPersona)
                    .setParameter(2, idRolContribuyente)
                    .setParameter(3, username)
                    .setParameter(4, passwordHash)
                    .executeUpdate();

            tx.commit();

        } catch (RuntimeException e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            String msg = e.getMessage() == null ? "" : e.getMessage().toLowerCase();
            if (msg.contains("duplicate") || msg.contains("duplicada")) {
                throw new IllegalStateException("Ya existe una cuenta con este correo.");
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void crearOActualizarCuentaFuncionarioPorCorreo(String correo, String passwordHash) {

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            List<?> registros = em.createNativeQuery(
                            "SELECT p.id_persona " +
                                    "FROM personas p " +
                                    "WHERE LOWER(TRIM(p.email)) = LOWER(TRIM(?1)) " +
                                    "AND p.estado = 'ACTIVO'")
                    .setParameter(1, correo)
                    .getResultList();

            if (registros.isEmpty()) {
                throw new IllegalArgumentException("El correo no existe como persona activa.");
            }

            if (registros.size() > 1) {
                throw new IllegalStateException("El correo tiene multiples personas registradas. Corrija el dato antes de crear el funcionario.");
            }

            int idPersona = ((Number) registros.get(0)).intValue();

            List<?> roles = em.createNativeQuery(
                            "SELECT id_rol FROM roles " +
                                    "WHERE UPPER(nombre) = 'FUNCIONARIO' " +
                                    "AND estado = 'ACTIVO' " +
                                    "LIMIT 1")
                    .getResultList();

            if (roles.isEmpty()) {
                throw new IllegalStateException("No existe el rol FUNCIONARIO en el sistema.");
            }

            int idRolFuncionario = ((Number) roles.get(0)).intValue();
            String username = correo.trim().toLowerCase();

            Number totalFuncionario = (Number) em.createNativeQuery(
                            "SELECT COUNT(*) FROM funcionarios WHERE id_persona = ?1")
                    .setParameter(1, idPersona)
                    .getSingleResult();

            if (totalFuncionario.intValue() == 0) {
                em.createNativeQuery(
                                "INSERT INTO funcionarios (" +
                                        "id_persona, cargo, area, fecha_ingreso, estado" +
                                        ") VALUES (?1, 'Funcionario', 'General', CURDATE(), 'ACTIVO')")
                        .setParameter(1, idPersona)
                        .executeUpdate();
            } else {
                em.createNativeQuery(
                                "UPDATE funcionarios " +
                                        "SET estado = 'ACTIVO' " +
                                        "WHERE id_persona = ?1")
                        .setParameter(1, idPersona)
                        .executeUpdate();
            }

            Number totalUsuarios = (Number) em.createNativeQuery(
                            "SELECT COUNT(*) FROM usuarios WHERE id_persona = ?1")
                    .setParameter(1, idPersona)
                    .getSingleResult();

            if (totalUsuarios.intValue() == 0) {
                em.createNativeQuery(
                                "INSERT INTO usuarios (" +
                                        "id_persona, id_rol, username, password_hash, estado, primer_ingreso, fecha_creacion" +
                                        ") VALUES (?1, ?2, ?3, ?4, 'ACTIVO', 0, NOW())")
                        .setParameter(1, idPersona)
                        .setParameter(2, idRolFuncionario)
                        .setParameter(3, username)
                        .setParameter(4, passwordHash)
                        .executeUpdate();
            } else {
                em.createNativeQuery(
                                "UPDATE usuarios " +
                                        "SET id_rol = ?1, " +
                                        "username = ?2, " +
                                        "password_hash = ?3, " +
                                        "estado = 'ACTIVO', " +
                                        "primer_ingreso = 0 " +
                                        "WHERE id_persona = ?4")
                        .setParameter(1, idRolFuncionario)
                        .setParameter(2, username)
                        .setParameter(3, passwordHash)
                        .setParameter(4, idPersona)
                        .executeUpdate();
            }

            tx.commit();

        } catch (RuntimeException e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            String msg = e.getMessage() == null ? "" : e.getMessage().toLowerCase();
            if (msg.contains("duplicate") || msg.contains("duplicada")) {
                throw new IllegalStateException("Ya existe una cuenta con ese correo.");
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public List<Object[]> listarPersonasDisponiblesParaFuncionario() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createNativeQuery(
                            "SELECT " +
                                    "p.id_persona, " +
                                    "CONCAT(p.nombres, ' ', p.apellidos) AS persona, " +
                                    "p.email, " +
                                    "COALESCE(r.nombre, 'SIN CUENTA') AS rol_actual " +
                                    "FROM personas p " +
                                    "LEFT JOIN usuarios u ON u.id_persona = p.id_persona " +
                                    "LEFT JOIN roles r ON r.id_rol = u.id_rol " +
                                    "WHERE p.estado = 'ACTIVO' " +
                                    "AND p.email IS NOT NULL " +
                                    "AND TRIM(p.email) <> '' " +
                                    "AND (r.nombre IS NULL OR UPPER(r.nombre) <> 'ADMIN') " +
                                    "ORDER BY p.nombres, p.apellidos")
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
