package com.tributaria.service;

import com.tributaria.dao.InmuebleDAO;
import com.tributaria.entity.Contribuyente;
import com.tributaria.entity.Zona;

import java.math.BigDecimal;
import java.util.List;

public class InmuebleService {

    private InmuebleDAO dao = new InmuebleDAO();

    public List<Object[]> listar() {
        return dao.listar();
    }

    public List<Contribuyente> listarContribuyentes() {
        return dao.listarContribuyentes();
    }

    public List<Zona> listarZonas() {
        return dao.listarZonas();
    }

    public void crear(int idContribuyente, int idZona, String direccion, BigDecimal valor) {
        dao.crear(idContribuyente, idZona, direccion, valor);
    }

    public void cambiarEstado(int id, String estado) {
        dao.cambiarEstado(id, estado);
    }

    public int contar() {
        return dao.contar();
    }

    public int contarActivos() {
        return dao.contarActivos();
    }
}
