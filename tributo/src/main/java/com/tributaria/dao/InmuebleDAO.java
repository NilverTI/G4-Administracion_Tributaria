package com.tributaria.dao;

import com.tributaria.entity.Contribuyente;
import com.tributaria.entity.Zona;
import com.tributaria.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;

import java.math.BigDecimal;
import java.util.List;

public class InmuebleDAO {

    public List<Object[]> listar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT i.id_inmueble, " +
                            "CONCAT(pe.nombres, ' ', pe.apellidos) AS contribuyente, " +
                            "i.direccion, z.nombre AS zona, i.valor_catastral, i.tipo_uso, " +
                            "i.area_terreno_m2, i.area_construida_m2, i.tipo_material, " +
                            "i.estado, i.fecha_registro " +
                            "FROM inmueble i " +
                            "INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente " +
                            "INNER JOIN personas pe ON pe.id_persona = c.id_persona " +
                            "INNER JOIN zona z ON z.id_zona = i.id_zona " +
                            "ORDER BY i.id_inmueble DESC");
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Zona> listarZonas() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT z FROM Zona z", Zona.class).getResultList();
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

    public void crear(
            int idContribuyente,
            int idZona,
            String direccion,
            BigDecimal valor,
            String tipoUso,
            BigDecimal areaTerrenoM2,
            BigDecimal areaConstruidaM2,
            String tipoMaterial
    ) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "INSERT INTO inmueble (" +
                            "id_contribuyente, id_zona, direccion, valor_catastral, " +
                            "tipo_uso, area_terreno_m2, area_construida_m2, tipo_material, estado, fecha_registro" +
                            ") VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, 'ACTIVO', NOW())");
            q.setParameter(1, idContribuyente);
            q.setParameter(2, idZona);
            q.setParameter(3, direccion);
            q.setParameter(4, valor);
            q.setParameter(5, tipoUso);
            q.setParameter(6, areaTerrenoM2);
            q.setParameter(7, areaConstruidaM2);
            q.setParameter(8, tipoMaterial);
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

    public Object[] obtenerPorId(int idInmueble) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Query q = em.createNativeQuery(
                    "SELECT i.id_inmueble, i.id_contribuyente, i.id_zona, i.direccion, i.valor_catastral, " +
                            "i.tipo_uso, i.area_terreno_m2, i.area_construida_m2, i.tipo_material, i.estado, i.fecha_registro, " +
                            "CONCAT(pe.nombres, ' ', pe.apellidos) AS contribuyente, z.nombre AS zona " +
                            "FROM inmueble i " +
                            "INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente " +
                            "INNER JOIN personas pe ON pe.id_persona = c.id_persona " +
                            "INNER JOIN zona z ON z.id_zona = i.id_zona " +
                            "WHERE i.id_inmueble = ?1");
            q.setParameter(1, idInmueble);
            List<?> rows = q.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (Object[]) rows.get(0);
        } finally {
            em.close();
        }
    }

    public void actualizar(
            int idInmueble,
            int idContribuyente,
            int idZona,
            String direccion,
            BigDecimal valor,
            String tipoUso,
            BigDecimal areaTerrenoM2,
            BigDecimal areaConstruidaM2,
            String tipoMaterial
    ) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "UPDATE inmueble " +
                            "SET id_contribuyente = ?1, id_zona = ?2, direccion = ?3, valor_catastral = ?4, " +
                            "tipo_uso = ?5, area_terreno_m2 = ?6, area_construida_m2 = ?7, tipo_material = ?8 " +
                            "WHERE id_inmueble = ?9");
            q.setParameter(1, idContribuyente);
            q.setParameter(2, idZona);
            q.setParameter(3, direccion);
            q.setParameter(4, valor);
            q.setParameter(5, tipoUso);
            q.setParameter(6, areaTerrenoM2);
            q.setParameter(7, areaConstruidaM2);
            q.setParameter(8, tipoMaterial);
            q.setParameter(9, idInmueble);
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

    public void cambiarEstado(int id, String estado) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Query q = em.createNativeQuery(
                    "UPDATE inmueble SET estado = ?1 WHERE id_inmueble = ?2");
            q.setParameter(1, estado);
            q.setParameter(2, id);
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
}
