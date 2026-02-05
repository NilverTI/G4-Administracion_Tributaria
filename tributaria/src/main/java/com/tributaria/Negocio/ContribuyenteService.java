package com.tributaria.Negocio;


import com.tributaria.dao.PersonaDAO;
import com.tributaria.dao.ContribuyenteDAO;
import com.tributaria.model.Persona;


public class ContribuyenteService {

    public void registrarContribuyente(String nom, String ape, int tipoPersona) throws Exception {

        Persona p = new Persona();
        p.setNombres(nom);
        p.setApellidos(ape);
        p.setTipoPersonaId(tipoPersona);

        PersonaDAO pdao = new PersonaDAO();
        long idPersona = pdao.insertar(p);

        if (idPersona <= 0) {
            throw new Exception("No se pudo registrar la persona.");
        }

        String codigo = generarCodigoContribuyente(idPersona);

        ContribuyenteDAO cdao = new ContribuyenteDAO();
        cdao.insertar(idPersona, codigo);
    }

    private String generarCodigoContribuyente(long id) {
        return "C-" + String.format("%06d", id);
    }
}
