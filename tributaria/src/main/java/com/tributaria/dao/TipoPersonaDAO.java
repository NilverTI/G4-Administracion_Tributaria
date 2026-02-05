package com.tributaria.dao;

import java.sql.*;
import java.util.ArrayList;
import com.tributaria.config.Conexion;

public class TipoPersonaDAO {

    public ArrayList<String[]> listarTipos() throws Exception {

        ArrayList<String[]> lista = new ArrayList<>();

        String sql = "SELECT id_tipo_persona, descripcion FROM tipo_persona";

        PreparedStatement ps = Conexion.getConexion().prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            lista.add(new String[]{
                rs.getString("id_tipo_persona"),
                rs.getString("descripcion")
            });
        }

        return lista;
    }
}