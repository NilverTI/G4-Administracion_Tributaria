package com.tributaria.model;


public class Persona {

    private Long idPersona;
    private String nombres;
    private String apellidos;
    private String razonSocial;
    private int tipoPersonaId;

    public Long getIdPersona() {
        return idPersona;
    }

    public void setIdPersona(Long idPersona) {
        this.idPersona = idPersona;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getRazonSocial() {
        return razonSocial;
    }

    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }

    public int getTipoPersonaId() {
        return tipoPersonaId;
    }

    public void setTipoPersonaId(int tipoPersonaId) {
        this.tipoPersonaId = tipoPersonaId;
    }
}
