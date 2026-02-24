package com.tributaria.service;

import com.tributaria.dao.UsuarioDAO;
import com.tributaria.entity.Usuario;
import org.mindrot.jbcrypt.BCrypt;

public class UsuarioService {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    public Usuario autenticar(String username, String passwordIngresado) {

        Usuario usuario = usuarioDAO.login(username);

        if (usuario == null) {
            return null;
        }

        // Validar contraseña con BCrypt
        if (BCrypt.checkpw(passwordIngresado, usuario.getPasswordHash())) {
            return usuario;
        }

        return null;
    }
}
