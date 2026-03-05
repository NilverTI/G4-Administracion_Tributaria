package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.*;

import java.sql.Date;
import java.time.LocalDate;
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

    public Object[] obtenerPorId(int idContribuyente) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query query = em.createNativeQuery(
                    "SELECT " +
                            "c.id_contribuyente, " +
                            "c.fecha_registro_tributario, " +
                            "c.estado, " +
                            "p.tipo_documento, " +
                            "p.numero_documento, " +
                            "p.nombres, " +
                            "p.apellidos, " +
                            "p.telefono, " +
                            "p.email, " +
                            "p.direccion, " +
                            "p.fecha_nacimiento, " +
                            "p.estado " +
                            "FROM contribuyentes c " +
                            "INNER JOIN personas p ON p.id_persona = c.id_persona " +
                            "WHERE c.id_contribuyente = ?1 " +
                            "LIMIT 1"
            );
            query.setParameter(1, idContribuyente);
            List<?> rows = query.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (Object[]) rows.get(0);
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
            String direccion,
            LocalDate fechaNacimiento) {

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
            query.registerStoredProcedureParameter("p_fecha_nacimiento", Date.class, ParameterMode.IN);

            query.setParameter("p_tipo_documento", tipoDoc);
            query.setParameter("p_numero_documento", numeroDoc);
            query.setParameter("p_nombres", nombres);
            query.setParameter("p_apellidos", apellidos);
            query.setParameter("p_telefono", telefono);
            query.setParameter("p_email", email);
            query.setParameter("p_direccion", direccion);
            query.setParameter("p_fecha_nacimiento", fechaNacimiento == null ? null : Date.valueOf(fechaNacimiento));

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

    public void actualizar(
            int idContribuyente,
            String numeroDoc,
            String nombres,
            String apellidos,
            String telefono,
            String email,
            String direccion,
            LocalDate fechaNacimiento
    ) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            List<?> personas = em.createNativeQuery(
                            "SELECT c.id_persona " +
                                    "FROM contribuyentes c " +
                                    "WHERE c.id_contribuyente = ?1 " +
                                    "LIMIT 1")
                    .setParameter(1, idContribuyente)
                    .getResultList();

            if (personas.isEmpty()) {
                throw new IllegalArgumentException("No se encontro el contribuyente.");
            }

            int idPersona = ((Number) personas.get(0)).intValue();

            Number totalUsuarios = (Number) em.createNativeQuery(
                            "SELECT COUNT(*) FROM usuarios WHERE id_persona = ?1")
                    .setParameter(1, idPersona)
                    .getSingleResult();

            String correoNormalizado = email == null ? null : email.trim();
            if (correoNormalizado != null && correoNormalizado.isEmpty()) {
                correoNormalizado = null;
            }

            if (totalUsuarios.intValue() > 0 && correoNormalizado == null) {
                throw new IllegalArgumentException("No puede dejar vacio el correo porque el contribuyente tiene cuenta de acceso.");
            }

            em.createNativeQuery(
                            "UPDATE personas " +
                                    "SET numero_documento = ?1, " +
                                    "nombres = ?2, " +
                                    "apellidos = ?3, " +
                                    "telefono = ?4, " +
                                    "email = ?5, " +
                                    "direccion = ?6, " +
                                    "fecha_nacimiento = ?7 " +
                                    "WHERE id_persona = ?8")
                    .setParameter(1, numeroDoc)
                    .setParameter(2, nombres)
                    .setParameter(3, apellidos)
                    .setParameter(4, telefono)
                    .setParameter(5, correoNormalizado)
                    .setParameter(6, direccion)
                    .setParameter(7, fechaNacimiento == null ? null : Date.valueOf(fechaNacimiento))
                    .setParameter(8, idPersona)
                    .executeUpdate();

            if (totalUsuarios.intValue() > 0 && correoNormalizado != null) {
                em.createNativeQuery(
                                "UPDATE usuarios " +
                                        "SET username = ?1 " +
                                        "WHERE id_persona = ?2")
                        .setParameter(1, correoNormalizado.toLowerCase())
                        .setParameter(2, idPersona)
                        .executeUpdate();
            }

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
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
        Query q = em.createNativeQuery(
                "SELECT c.id_contribuyente, " +
                        "CONCAT(p.nombres, ' ', p.apellidos) AS contribuyente, " +
                        "p.numero_documento " +
                        "FROM contribuyentes c " +
                        "INNER JOIN personas p ON p.id_persona = c.id_persona " +
                        "WHERE c.estado = 'ACTIVO' " +
                        "AND p.estado = 'ACTIVO' " +
                        "ORDER BY p.nombres, p.apellidos"
        );
        return q.getResultList();
    } finally {
        em.close();
    }
    }

}
