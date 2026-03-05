package com.tributaria.service;

import com.tributaria.dao.ContribuyenteDAO;

import java.time.LocalDate;
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
            String direccion,
            LocalDate fechaNacimiento) {

        dao.crear(tipoDoc, numeroDoc, nombres, apellidos,
                  telefono, email, direccion, fechaNacimiento);
    }

    public Object[] obtenerPorId(int idContribuyente) {
        return dao.obtenerPorId(idContribuyente);
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
        dao.actualizar(
                idContribuyente,
                numeroDoc,
                nombres,
                apellidos,
                telefono,
                email,
                direccion,
                fechaNacimiento
        );
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
