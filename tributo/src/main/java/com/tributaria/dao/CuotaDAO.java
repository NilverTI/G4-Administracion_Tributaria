package com.tributaria.dao;

import com.tributaria.entity.Cuota;
import com.tributaria.util.JPAUtil;

import jakarta.persistence.EntityManager;
import java.time.LocalDate;
import java.util.List;

public class CuotaDAO {

    public List<Cuota> listar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT c FROM Cuota c ORDER BY c.id DESC",
                    Cuota.class).getResultList();
        } finally {
            em.close();
        }
    }

    // ✅ Para la vista plana de CUOTAS (SP)
    @SuppressWarnings("unchecked")
    public List<Object[]> listarVista() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createNativeQuery("CALL sp_listar_cuotas()")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // ✅ MODAL: listar cuotas de un impuesto (SP ya existe en tu BD)
    // Esperado (ideal): id_cuota, numero, total_cuotas, monto, vencimiento, estado
    @SuppressWarnings("unchecked")
    public List<Object[]> listarCuotasPorImpuesto(int idImpuesto) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createNativeQuery("CALL sp_listar_cuotas_por_impuesto(?)")
                    .setParameter(1, idImpuesto)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // ✅ COMBO: Impuestos disponibles para fraccionar (SP ya existe en tu BD)
    // i[0]=id_impuesto, i[1]=IMP0001, i[2]=Nombre Apellido, i[3]=tipo, i[4]=anio, i[5]=monto_total
    @SuppressWarnings("unchecked")
    public List<Object[]> listarImpuestosParaFraccionar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createNativeQuery("CALL sp_listar_impuestos_para_fraccionar()")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // ✅ FRACCIONAR IMPUESTO (SP ya existe en tu BD)
    public void fraccionarImpuesto(int idImpuesto, int numeroCuotas, LocalDate fechaPrimeraCuota) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            em.createNativeQuery("CALL sp_fraccionar_impuesto(?, ?, ?)")
                    .setParameter(1, idImpuesto)
                    .setParameter(2, numeroCuotas)
                    .setParameter(3, java.sql.Date.valueOf(fechaPrimeraCuota))
                    .executeUpdate();

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // ✅ PARA PAGOS: trae cuotas pendientes
    public List<Cuota> listarPendientes() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT c FROM Cuota c " +
                            "JOIN FETCH c.impuesto i " +
                            "WHERE UPPER(c.estado) IN ('PENDIENTE','VENCIDO','VENCIDA') " +
                            "ORDER BY c.vencimiento ASC",
                    Cuota.class).getResultList();
        } finally {
            em.close();
        }
    }

    public Cuota buscarPorId(int idCuota) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Cuota.class, idCuota);
        } finally {
            em.close();
        }
    }

    public void marcarComoPagada(Integer idCuota) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            Cuota cuota = em.find(Cuota.class, idCuota);
            if (cuota != null) {
                cuota.setEstado("PAGADA");
                cuota.setFechaPago(LocalDate.now());
                em.merge(cuota);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void guardar(Cuota cuota) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(cuota);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void actualizar(Cuota cuota) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(cuota);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}