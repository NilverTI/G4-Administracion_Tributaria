package com.tributaria.Negocio;

import com.tributaria.dao.UsuarioDAO;
import com.tributaria.model.Usuario;

public class LoginService {

    private UsuarioDAO dao = new UsuarioDAO();

    public Usuario login(String user, String pass) throws Exception {
        return dao.login(user, pass);
    }
}
