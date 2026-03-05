package com.tributaria.service;

import com.tributaria.dao.ZonaDAO;
import java.util.List;

public class ZonaService {

    private ZonaDAO dao = new ZonaDAO();

    public List<Object[]> listar() {
        return dao.listar();
    }

    public void crear(String codigo, String nombre, double tasa) {
        dao.crear(codigo, nombre, tasa);
    }

    public void cambiarEstado(int id, String estado) {
        dao.cambiarEstado(id, estado);
    }
}