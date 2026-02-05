CREATE DATABASE Tributo;
USE Tributo;

/* ============================================================
   MÓDULO 1: PERSONAS Y CONTRIBUYENTES
   ============================================================ */

-- TIPO PERSONA
CREATE TABLE tipo_persona (
    id_tipo_persona BIGINT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);

-- PERSONA
CREATE TABLE persona (
    id_persona BIGINT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100),
    razon_social VARCHAR(150),
    tipo_persona_id BIGINT NOT NULL
);

ALTER TABLE persona
ADD CONSTRAINT fk_persona_tipo
FOREIGN KEY (tipo_persona_id)
REFERENCES tipo_persona(id_tipo_persona);

-- CONTRIBUYENTE
CREATE TABLE contribuyente (
    id_contribuyente BIGINT PRIMARY KEY,
    id_persona BIGINT NOT NULL,
    codigo_contribuyente VARCHAR(30) NOT NULL
);

ALTER TABLE contribuyente
ADD CONSTRAINT fk_contribuyente_persona
FOREIGN KEY (id_persona)
REFERENCES persona(id_persona);

ALTER TABLE contribuyente
ADD CONSTRAINT unq_contribuyente_codigo UNIQUE (codigo_contribuyente);

/* ============================================================
   MÓDULO 2: BIENES
   ============================================================ */

-- TIPO DE BIEN
CREATE TABLE tipo_bien (
    id_tipo_bien BIGINT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);

ALTER TABLE tipo_bien
ADD CONSTRAINT unq_tipo_bien UNIQUE (descripcion);

-- BIEN
CREATE TABLE bien (
    id_bien BIGINT PRIMARY KEY,
    id_contribuyente BIGINT NOT NULL,
    id_tipo_bien BIGINT NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    direccion VARCHAR(200),
    placa VARCHAR(20)
);

ALTER TABLE bien
ADD CONSTRAINT fk_bien_contribuyente
FOREIGN KEY (id_contribuyente)
REFERENCES contribuyente(id_contribuyente);

ALTER TABLE bien
ADD CONSTRAINT fk_bien_tipo
FOREIGN KEY (id_tipo_bien)
REFERENCES tipo_bien(id_tipo_bien);

ALTER TABLE bien
ADD CONSTRAINT chk_bien_desc CHECK (LENGTH(descripcion) >= 3);

/* ============================================================
   MÓDULO 3: FUNCIONARIOS
   ============================================================ */

-- CARGO DEL FUNCIONARIO
CREATE TABLE cargo_funcionario (
    id_cargo BIGINT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

ALTER TABLE cargo_funcionario
ADD CONSTRAINT unq_cargo UNIQUE (descripcion);

-- FUNCIONARIO
CREATE TABLE funcionario (
    id_funcionario BIGINT PRIMARY KEY,
    id_persona BIGINT NOT NULL,
    id_cargo BIGINT NOT NULL
);

ALTER TABLE funcionario
ADD CONSTRAINT fk_funcionario_persona
FOREIGN KEY (id_persona)
REFERENCES persona(id_persona);

ALTER TABLE funcionario
ADD CONSTRAINT fk_funcionario_cargo
FOREIGN KEY (id_cargo)
REFERENCES cargo_funcionario(id_cargo);

/* ============================================================
   MÓDULO 4: TRIBUTOS Y ASIGNACIÓN A BIENES
   ============================================================ */

-- PERIODICIDAD (mensual, trimestral, anual, única)
CREATE TABLE periodicidad_tributo (
    id_periodicidad BIGINT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    meses INT NOT NULL
);

ALTER TABLE periodicidad_tributo
ADD CONSTRAINT unq_periodicidad UNIQUE (descripcion);

-- TRIBUTO
CREATE TABLE tributo (
    id_tributo BIGINT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL,
    id_periodicidad BIGINT NOT NULL
);

ALTER TABLE tributo
ADD CONSTRAINT unq_tributo UNIQUE (descripcion);

ALTER TABLE tributo
ADD CONSTRAINT fk_tributo_periodicidad
FOREIGN KEY (id_periodicidad)
REFERENCES periodicidad_tributo(id_periodicidad);

-- TRIBUTO ASIGNADO A UN BIEN
CREATE TABLE tributo_bien (
    id_tributo_bien BIGINT PRIMARY KEY,
    id_bien BIGINT NOT NULL,
    id_tributo BIGINT NOT NULL,
    id_funcionario_asigna BIGINT NOT NULL,
    anio INT NOT NULL,
    monto DECIMAL(12,2) NOT NULL DEFAULT 0,
    estado VARCHAR(20) DEFAULT 'PENDIENTE'
);

ALTER TABLE tributo_bien
ADD CONSTRAINT fk_tb_bien
FOREIGN KEY (id_bien)
REFERENCES bien(id_bien);

ALTER TABLE tributo_bien
ADD CONSTRAINT fk_tb_tributo
FOREIGN KEY (id_tributo)
REFERENCES tributo(id_tributo);

ALTER TABLE tributo_bien
ADD CONSTRAINT fk_tb_funcionario
FOREIGN KEY (id_funcionario_asigna)
REFERENCES funcionario(id_funcionario);

ALTER TABLE tributo_bien
ADD CONSTRAINT chk_tb_monto CHECK (monto >= 0);

ALTER TABLE tributo_bien
ADD CONSTRAINT chk_tb_estado CHECK (estado IN ('PENDIENTE','PAGADO'));

ALTER TABLE tributo_bien
ADD CONSTRAINT chk_tb_anio CHECK (anio BETWEEN 1990 AND 2100);

/* ============================================================
   MÓDULO 5: CRONOGRAMA Y CUOTAS DE PAGO
   ============================================================ */

-- CRONOGRAMA POR AÑO
CREATE TABLE cronograma_pago (
    id_cronograma BIGINT PRIMARY KEY,
    id_tributo_bien BIGINT NOT NULL,
    anio INT NOT NULL
);

ALTER TABLE cronograma_pago
ADD CONSTRAINT fk_crono_tb
FOREIGN KEY (id_tributo_bien)
REFERENCES tributo_bien(id_tributo_bien);

-- CUOTAS
CREATE TABLE cuota_pago (
    id_cuota BIGINT PRIMARY KEY,
    id_cronograma BIGINT NOT NULL,
    numero_cuota INT NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'PENDIENTE'
);

ALTER TABLE cuota_pago
ADD CONSTRAINT fk_cuota_crono
FOREIGN KEY (id_cronograma)
REFERENCES cronograma_pago(id_cronograma);

ALTER TABLE cuota_pago
ADD CONSTRAINT chk_cuota_monto CHECK (monto >= 0);

ALTER TABLE cuota_pago
ADD CONSTRAINT chk_cuota_estado CHECK (estado IN ('PENDIENTE','PAGADO'));

ALTER TABLE cuota_pago
ADD CONSTRAINT chk_cuota_fech CHECK (fecha_vencimiento >= '1990-01-01');

/* ============================================================
   MÓDULO 6: PAGOS
   ============================================================ */

-- MEDIO DE PAGO
CREATE TABLE medio_pago (
    id_medio_pago BIGINT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);

ALTER TABLE medio_pago
ADD CONSTRAINT unq_mediop UNIQUE (descripcion);

-- ESTADO DE PAGO
CREATE TABLE estado_pago (
    id_estado_pago BIGINT PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL
);

ALTER TABLE estado_pago
ADD CONSTRAINT unq_estadop UNIQUE (descripcion);

-- PAGO (CONECTADO A CUOTA)
CREATE TABLE pago (
    id_pago BIGINT PRIMARY KEY,
    id_cuota BIGINT NOT NULL,
    fecha_pago DATE,
    monto_pagado DECIMAL(12,2) NOT NULL DEFAULT 0,
    id_medio_pago BIGINT,
    id_estado_pago BIGINT NOT NULL,
    id_funcionario_registra BIGINT
);

ALTER TABLE pago
ADD CONSTRAINT fk_pago_cuota
FOREIGN KEY (id_cuota)
REFERENCES cuota_pago(id_cuota);

ALTER TABLE pago
ADD CONSTRAINT fk_pago_medio
FOREIGN KEY (id_medio_pago)
REFERENCES medio_pago(id_medio_pago);

ALTER TABLE pago
ADD CONSTRAINT fk_pago_estado
FOREIGN KEY (id_estado_pago)
REFERENCES estado_pago(id_estado_pago);

ALTER TABLE pago
ADD CONSTRAINT fk_pago_funcionario
FOREIGN KEY (id_funcionario_registra)
REFERENCES funcionario(id_funcionario);

ALTER TABLE pago
ADD CONSTRAINT chk_pago_monto CHECK (monto_pagado >= 0);

ALTER TABLE pago
ADD CONSTRAINT chk_pago_fecha CHECK (fecha_pago >= '1990-01-01');

/* ============================================================
   MÓDULO 7: USUARIOS Y ROLES
   ============================================================ */

-- ROL
CREATE TABLE rol (
    id_rol BIGINT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);

ALTER TABLE rol
ADD CONSTRAINT unq_rol UNIQUE (descripcion);

-- PERMISO
CREATE TABLE permiso (
    id_permiso BIGINT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

ALTER TABLE permiso
ADD CONSTRAINT unq_perm UNIQUE (descripcion);

-- RELACIÓN ROL - PERMISO
CREATE TABLE rol_permiso (
    id_rol BIGINT NOT NULL,
    id_permiso BIGINT NOT NULL
);

ALTER TABLE rol_permiso
ADD CONSTRAINT pk_rp PRIMARY KEY (id_rol, id_permiso);

ALTER TABLE rol_permiso
ADD CONSTRAINT fk_rp_rol
FOREIGN KEY (id_rol)
REFERENCES rol(id_rol);

ALTER TABLE rol_permiso
ADD CONSTRAINT fk_rp_perm
FOREIGN KEY (id_permiso)
REFERENCES permiso(id_permiso);

-- USUARIO
CREATE TABLE usuario (
    id_usuario BIGINT PRIMARY KEY,
    id_persona BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

ALTER TABLE usuario
ADD CONSTRAINT fk_usuario_persona
FOREIGN KEY (id_persona)
REFERENCES persona(id_persona);

ALTER TABLE usuario
ADD CONSTRAINT fk_usuario_rol
FOREIGN KEY (id_rol)
REFERENCES rol(id_rol);

ALTER TABLE usuario
ADD CONSTRAINT unq_user UNIQUE (username);

ALTER TABLE contribuyente
MODIFY id_contribuyente BIGINT AUTO_INCREMENT;

ALTER TABLE persona 
MODIFY id_persona BIGINT NOT NULL AUTO_INCREMENT;