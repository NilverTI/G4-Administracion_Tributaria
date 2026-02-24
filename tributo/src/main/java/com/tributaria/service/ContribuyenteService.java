package com.tributaria.service;

import com.tributaria.dao.ContribuyenteDAO;

import java.util.List;

public class ContribuyenteService {

    private ContribuyenteDAO dao = new ContribuyenteDAO();

    public List<Object[]> listar() {
        return dao.listar();
    }

    public void crear(
            String tipoDoc,
            String numeroDoc,
            String nombres,
            String apellidos,
            String telefono,
            String email,
            String direccion) {

        dao.crear(tipoDoc, numeroDoc, nombres, apellidos,
                  telefono, email, direccion);
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

    public List<Object[]> listarActivosCombo() {
        return dao.listarActivosCombo();
    }

}
