package com.tributaria.dao;

import com.tributaria.util.JPAUtil;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.util.List;

public class VehiculoDAO {

    // LISTAR VEHÍCULOS
    @SuppressWarnings("unchecked")
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

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_crear_vehiculo");

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
            if (tx.isActive()) tx.rollback();
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

            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_cambiar_estado_vehiculo");

            sp.registerStoredProcedureParameter("p_id_vehiculo", Integer.class, ParameterMode.IN);
            sp.registerStoredProcedureParameter("p_estado", String.class, ParameterMode.IN);

            sp.setParameter("p_id_vehiculo", idVehiculo);
            sp.setParameter("p_estado", estado);

            sp.execute();
            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // CONTAR VEHÍCULOS
    public int contar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Number total = (Number) em.createNativeQuery("SELECT COUNT(*) FROM vehiculo")
                    .getSingleResult();
            return total.intValue();
        } finally {
            em.close();
        }
    }

    // CONTAR VEHÍCULOS ACTIVOS
    public int contarActivos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Number total = (Number) em.createNativeQuery("SELECT COUNT(*) FROM vehiculo WHERE estado='ACTIVO'")
                    .getSingleResult();
            return total.intValue();
        } finally {
            em.close();
        }
    }

    // ✅ OBTENER % VEHICULAR VIGENTE (SP)
    public BigDecimal obtenerPorcentajeVigente() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery sp = em.createStoredProcedureQuery("sp_porcentaje_vehicular_vigente");

            Object result = sp.getSingleResult();
            if (result == null) return BigDecimal.ZERO;

            return new BigDecimal(result.toString());

        } finally {
            em.close();
        }
    }
    
    public boolean existePlaca(String placa) {
    EntityManager em = JPAUtil.getEntityManager();
    try {
        Number n = (Number) em.createNativeQuery(
                "SELECT COUNT(*) FROM vehiculo WHERE placa = ?"
        ).setParameter(1, placa).getSingleResult();
        return n.intValue() > 0;
    } finally {
        em.close();
    }
}
}