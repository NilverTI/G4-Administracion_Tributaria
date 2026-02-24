package com.tributaria.service;

import com.tributaria.dao.ImpuestoDAO;

import java.util.List;

public class ImpuestoService {

    private final ImpuestoDAO dao = new ImpuestoDAO();

    public List<Object[]> listar() {
        return dao.listarImpuestos();
    }

    public List<Object[]> listarContribuyentesActivos() {
        return dao.listarContribuyentesCombo();
    }

    public List<Object[]> listarCuotas(int idImpuesto) {
        return dao.listarCuotasPorImpuesto(idImpuesto);
    }

    public void generarImpuesto(int idContribuyente, String tipo, int anio) {
        dao.generarImpuesto(idContribuyente, tipo, anio);
    }
}