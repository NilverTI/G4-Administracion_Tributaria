package com.tributaria.service;

import com.tributaria.dao.UITDAO;

import java.util.List;

public class UITService {

    private UITDAO dao = new UITDAO();

    public List<Object[]> listar() {
        return dao.listar();
    }

    public void crear(int anio, double valor) {
        dao.crear(anio, valor);
    }

    public void actualizar(int anio, double valor) {
        dao.actualizar(anio, valor);
    }
}