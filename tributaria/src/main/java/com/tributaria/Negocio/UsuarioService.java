package com.tributaria.Negocio;

import com.tributaria.dao.UsuarioDAO;

public class UsuarioService {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    /**
     * Crear usuario desde contribuyente usando PA
     */
    public void crearUsuarioContribuyente(String codigo, String username, String password) throws Exception {

        // Validaciones antes de ir al DAO
        if (codigo == null || codigo.isBlank()) {
            throw new Exception("Debe ingresar un código de contribuyente.");
        }

        if (username == null || username.isBlank()) {
            throw new Exception("Debe ingresar un nombre de usuario.");
        }

        if (password == null || password.isBlank()) {
            throw new Exception("Debe ingresar una contraseña.");
        }

        if (username.length() < 3) {
            throw new Exception("El usuario debe tener al menos 3 caracteres.");
        }

        if (password.length() < 4) {
            throw new Exception("La contraseña debe tener al menos 4 caracteres.");
        }

        // Llamar al DAO que ejecuta el PA
        usuarioDAO.crearUsuarioContribuyente(codigo, username, password);
    }
}