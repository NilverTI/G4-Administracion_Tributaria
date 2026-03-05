package com.tributaria.service;

import com.tributaria.dao.InmuebleDAO;
import com.tributaria.entity.Contribuyente;
import com.tributaria.entity.Zona;

import java.math.BigDecimal;
import java.util.List;

public class InmuebleService {

    private final InmuebleDAO dao = new InmuebleDAO();

    public List<Object[]> listar() {
        return dao.listar();
    }

    public List<Contribuyente> listarContribuyentes() {
        return dao.listarContribuyentes();
    }

    public List<Zona> listarZonas() {
        return dao.listarZonas();
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
        dao.crear(idContribuyente, idZona, direccion, valor, tipoUso, areaTerrenoM2, areaConstruidaM2, tipoMaterial);
    }

    public Object[] obtenerPorId(int idInmueble) {
        return dao.obtenerPorId(idInmueble);
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
        dao.actualizar(idInmueble, idContribuyente, idZona, direccion, valor, tipoUso, areaTerrenoM2, areaConstruidaM2, tipoMaterial);
    }

    public void cambiarEstado(int id, String estado) {
        dao.cambiarEstado(id, estado);
    }
}
