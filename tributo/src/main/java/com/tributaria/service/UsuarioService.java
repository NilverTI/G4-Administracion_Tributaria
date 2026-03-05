package com.tributaria.service;

import com.tributaria.dao.UsuarioDAO;
import com.tributaria.entity.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;

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

    public void registrarCuentaContribuyente(String correo,
                                             String password,
                                             String confirmarPassword) {

        String correoLimpio = correo == null ? "" : correo.trim().toLowerCase();

        if (correoLimpio.isEmpty()) {
            throw new IllegalArgumentException("Debe ingresar un correo.");
        }

        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException("Debe ingresar una contraseña.");
        }

        if (password.length() < 8) {
            throw new IllegalArgumentException("La contraseña debe tener al menos 8 caracteres.");
        }

        if (!password.equals(confirmarPassword)) {
            throw new IllegalArgumentException("Las contraseñas no coinciden.");
        }

        String hash = BCrypt.hashpw(password, BCrypt.gensalt());
        usuarioDAO.crearCuentaContribuyentePorCorreo(correoLimpio, hash);
    }

    public void registrarCuentaFuncionario(String correo,
                                           String password,
                                           String confirmarPassword) {

        String correoLimpio = correo == null ? "" : correo.trim().toLowerCase();

        if (correoLimpio.isEmpty()) {
            throw new IllegalArgumentException("Debe ingresar un correo.");
        }

        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException("Debe ingresar una contraseña.");
        }

        if (password.length() < 8) {
            throw new IllegalArgumentException("La contraseña debe tener al menos 8 caracteres.");
        }

        if (!password.equals(confirmarPassword)) {
            throw new IllegalArgumentException("Las contraseñas no coinciden.");
        }

        String hash = BCrypt.hashpw(password, BCrypt.gensalt());
        usuarioDAO.crearOActualizarCuentaFuncionarioPorCorreo(correoLimpio, hash);
    }

    public List<Object[]> listarPersonasDisponiblesParaFuncionario() {
        return usuarioDAO.listarPersonasDisponiblesParaFuncionario();
    }
}
