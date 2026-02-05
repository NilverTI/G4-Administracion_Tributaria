package com.tributaria.dao;

import java.sql.*;
import com.tributaria.config.Conexion;

public class ContribuyenteDAO {

    public void insertar(long idPersona, String codigo) throws Exception {

        String sql = "INSERT INTO contribuyente (id_persona, codigo_contribuyente) VALUES (?, ?)";

        PreparedStatement ps = Conexion.getConexion().prepareStatement(sql);

        ps.setLong(1, idPersona);
        ps.setString(2, codigo);

        ps.executeUpdate();
    }

    public boolean existeCodigo(String codigo) throws Exception {
    String sql = "SELECT COUNT(*) FROM contribuyente WHERE codigo_contribuyente = ?";
    PreparedStatement ps = Conexion.getConexion().prepareStatement(sql);
    ps.setString(1, codigo);

    ResultSet rs = ps.executeQuery();
    rs.next();
    return rs.getInt(1) > 0;
}
}
