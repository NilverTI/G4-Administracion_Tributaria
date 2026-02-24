CREATE DATABASE tributaria;
USE tributaria;

CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150),
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO'
);

INSERT INTO roles (nombre, descripcion) VALUES
('ADMIN', 'Administrador del sistema'),
('FUNCIONARIO', 'Personal administrativo'),
('CONTRIBUYENTE', 'Usuario tributario');

CREATE TABLE personas (
    id_persona INT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento VARCHAR(20) NOT NULL,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(150),
    direccion VARCHAR(255),
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL UNIQUE,
    id_rol INT NOT NULL,
    username VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
    primer_ingreso BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_persona) REFERENCES personas(id_persona),
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

CREATE TABLE funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL UNIQUE,
    cargo VARCHAR(100) NOT NULL,
    area VARCHAR(100),
    fecha_ingreso DATE NOT NULL,
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',

    FOREIGN KEY (id_persona) REFERENCES personas(id_persona)
);

CREATE TABLE contribuyentes (
    id_contribuyente INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL UNIQUE,
    fecha_registro_tributario DATE NOT NULL,
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',

    FOREIGN KEY (id_persona) REFERENCES personas(id_persona)
);

CREATE TABLE zona (
    id_zona INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    tasa_predial DECIMAL(6,4) NOT NULL, -- 0.012 = 1.2%
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO zona (codigo, nombre, tasa_predial)
VALUES
('Z001', 'Zona A', 0.012),
('Z002', 'Zona B', 0.008),
('Z003', 'Zona C', 0.005),
('Z004', 'Zona D', 0.003);


CREATE TABLE uit (
    id_uit INT AUTO_INCREMENT PRIMARY KEY,
    anio INT NOT NULL UNIQUE,
    valor DECIMAL(10,2) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO uit (anio, valor)
VALUES
(2023, 4950.00),
(2024, 5150.00),
(2025, 5350.00);

DROP TABLE IF EXISTS inmueble;

CREATE TABLE inmueble (
    id_inmueble INT AUTO_INCREMENT PRIMARY KEY,
    id_contribuyente INT NOT NULL,
    id_zona INT NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    valor_catastral DECIMAL(12,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_inmueble_contribuyente
        FOREIGN KEY (id_contribuyente)
        REFERENCES contribuyentes(id_contribuyente)
        ON DELETE CASCADE,

    CONSTRAINT fk_inmueble_zona
        FOREIGN KEY (id_zona)
        REFERENCES zona(id_zona)
);


CREATE TABLE vehiculo (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_contribuyente INT NOT NULL,
    placa VARCHAR(20) NOT NULL UNIQUE,
    marca VARCHAR(100) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    anio INT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    valor DECIMAL(12,2) NOT NULL,
    porcentaje DECIMAL(5,2) NOT NULL, -- Ej: 1.5
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_vehiculo_contribuyente
        FOREIGN KEY (id_contribuyente)
        REFERENCES contribuyentes(id_contribuyente)
        ON DELETE CASCADE
);

CREATE TABLE alcabala (
    id_alcabala INT AUTO_INCREMENT PRIMARY KEY,
    id_inmueble INT NOT NULL,
    valor_venta DECIMAL(12,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    estado VARCHAR(20) DEFAULT 'PENDIENTE',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_alcabala_inmueble
        FOREIGN KEY (id_inmueble)
        REFERENCES inmueble(id_inmueble)
        ON DELETE CASCADE
);

CREATE INDEX idx_inmueble_contribuyente 
ON inmueble(id_contribuyente);

CREATE INDEX idx_vehiculo_contribuyente 
ON vehiculo(id_contribuyente);

CREATE INDEX idx_alcabala_inmueble 
ON alcabala(id_inmueble);

ALTER TABLE zona ADD COLUMN alicuota DECIMAL(10,2) NOT NULL DEFAULT 0;

CREATE TABLE impuesto (
  id_impuesto INT AUTO_INCREMENT PRIMARY KEY,
  id_contribuyente INT NOT NULL,
  codigo VARCHAR(20),
  tipo VARCHAR(20) NOT NULL,
  anio INT NOT NULL,
  monto_total DECIMAL(12,2) NOT NULL,
  estado VARCHAR(20) DEFAULT 'PENDIENTE',
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_vencimiento DATE,

  CONSTRAINT fk_impuesto_contribuyente
    FOREIGN KEY (id_contribuyente)
    REFERENCES contribuyentes(id_contribuyente)
    ON DELETE CASCADE
);

CREATE INDEX idx_impuesto_contribuyente ON impuesto(id_contribuyente);

CREATE TABLE cuota (
  id_cuota INT AUTO_INCREMENT PRIMARY KEY,
  id_impuesto INT NOT NULL,
  numero INT NOT NULL,
  total_cuotas INT NOT NULL,
  monto DECIMAL(12,2) NOT NULL,
  vencimiento DATE NOT NULL,
  estado VARCHAR(20) DEFAULT 'PENDIENTE',
  fecha_pago DATE NULL,
  codigo VARCHAR(10) NOT NULL,

  CONSTRAINT fk_cuota_impuesto
    FOREIGN KEY (id_impuesto)
    REFERENCES impuesto(id_impuesto)
    ON DELETE CASCADE
);

CREATE INDEX idx_cuota_impuesto ON cuota(id_impuesto);

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(30) UNIQUE NOT NULL,
    id_cuota INT NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    medio_pago VARCHAR(30) NOT NULL,
    fecha_pago DATE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_pago_cuota
        FOREIGN KEY (id_cuota)
        REFERENCES cuota(id_cuota)
        ON DELETE CASCADE
);


