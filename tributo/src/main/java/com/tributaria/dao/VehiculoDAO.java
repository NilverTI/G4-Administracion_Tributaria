package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.util.List;

public class VehiculoDAO {

    // LISTAR VEHÍCULOS
    public List<Object[]> listar() {
    EntityManager em = JPAUtil.getEntityManager();
    try {
        Query q = em.createNativeQuery("CALL sp_listar_vehiculos()");
        return q.getResultList();
    } finally {
        em.close();
    }
}

    // CREAR VEHÍCULO
    public void crear(
            int idContribuyente,
            String placa,
            String marca,
            String modelo,
            int anio,
            String fechaInscripcion,
            BigDecimal valor,
            BigDecimal porcentaje
    ) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp =
                em.createStoredProcedureQuery("sp_crear_vehiculo");

            sp.registerStoredProcedureParameter("p_id_contribuyente", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_placa", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_marca", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_modelo", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_fecha_inscripcion", String.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_valor", BigDecimal.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_porcentaje", BigDecimal.class, ParameterMode.IN);

            sp.setParameter("p_id_contribuyente", idContribuyente);
            sp.setParameter("p_placa", placa);
            sp.setParameter("p_marca", marca);
            sp.setParameter("p_modelo", modelo);
            sp.setParameter("p_anio", anio);
            sp.setParameter("p_fecha_inscripcion", fechaInscripcion);
            sp.setParameter("p_valor", valor);
            sp.setParameter("p_porcentaje", porcentaje);

            sp.execute();
            tx.commit();

        } catch (Exception e) {
            tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // CAMBIAR ESTADO
    public void cambiarEstado(int idVehiculo, String estado) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            StoredProcedureQuery sp =
                em.createStoredProcedureQuery("sp_cambiar_estado_vehiculo");

            sp.registerStoredProcedureParameter("p_id_vehiculo", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_estado", String.class, ParameterMode.IN);

            sp.setParameter("p_id_vehiculo", idVehiculo);
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

    public Object[] obtenerEditablePorId(int idVehiculo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT v.id_vehiculo, v.id_contribuyente, v.placa, v.marca, v.modelo, " +
                            "v.anio, v.fecha_inscripcion, v.valor, v.estado " +
                            "FROM vehiculo v WHERE v.id_vehiculo = ?1");
            q.setParameter(1, idVehiculo);

            List<?> result = q.getResultList();
            if (result.isEmpty()) {
                return null;
            }
            return (Object[]) result.get(0);
        } finally {
            em.close();
        }
    }

    public Object[] obtenerDetallePorId(int idVehiculo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT v.id_vehiculo, v.placa, v.marca, v.modelo, v.anio, v.fecha_inscripcion, " +
                            "v.valor, v.porcentaje, v.estado, v.fecha_registro, " +
                            "CONCAT(p.nombres, ' ', p.apellidos) AS contribuyente " +
                            "FROM vehiculo v " +
                            "INNER JOIN contribuyentes c ON c.id_contribuyente = v.id_contribuyente " +
                            "INNER JOIN personas p ON p.id_persona = c.id_persona " +
                            "WHERE v.id_vehiculo = ?1");
            q.setParameter(1, idVehiculo);

            List<?> result = q.getResultList();
            if (result.isEmpty()) {
                return null;
            }
            return (Object[]) result.get(0);
        } finally {
            em.close();
        }
    }

    public void actualizarDatosBasicos(
            int idVehiculo,
            String placa,
            String marca,
            String modelo,
            int anio,
            String fechaInscripcion,
            BigDecimal valor
    ) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "UPDATE vehiculo SET placa = ?1, marca = ?2, modelo = ?3, anio = ?4, " +
                            "fecha_inscripcion = ?5, valor = ?6 WHERE id_vehiculo = ?7");
            q.setParameter(1, placa);
            q.setParameter(2, marca);
            q.setParameter(3, modelo);
            q.setParameter(4, anio);
            q.setParameter(5, fechaInscripcion);
            q.setParameter(6, valor);
            q.setParameter(7, idVehiculo);
            q.executeUpdate();

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

    public void actualizarDatosCompletos(
            int idVehiculo,
            int idContribuyente,
            String placa,
            String marca,
            String modelo,
            int anio,
            String fechaInscripcion,
            BigDecimal valor
    ) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "UPDATE vehiculo SET id_contribuyente = ?1, placa = ?2, marca = ?3, modelo = ?4, anio = ?5, " +
                            "fecha_inscripcion = ?6, valor = ?7 WHERE id_vehiculo = ?8");
            q.setParameter(1, idContribuyente);
            q.setParameter(2, placa);
            q.setParameter(3, marca);
            q.setParameter(4, modelo);
            q.setParameter(5, anio);
            q.setParameter(6, fechaInscripcion);
            q.setParameter(7, valor);
            q.setParameter(8, idVehiculo);
            q.executeUpdate();

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

    // MÉTODO PARA OBTENER % VEHICULAR ACTIVO
public BigDecimal obtenerPorcentajeVigente() {
    EntityManager em = JPAUtil.getEntityManager();

    try {
        StoredProcedureQuery sp =
            em.createStoredProcedureQuery("sp_porcentaje_vehicular_vigente");

        Object result = sp.getSingleResult();
        return new BigDecimal(result.toString());

    } finally {
        em.close();
    }
}
}
