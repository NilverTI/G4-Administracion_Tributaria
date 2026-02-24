-- =========================================================
-- Base de datos: tributaria (MySQL/MariaDB)
-- Script limpio y listo para ejecutar (tablas + datos + SP)
-- Generado: 2026-02-24
-- =========================================================

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- 1) Crear BD y usarla
CREATE DATABASE IF NOT EXISTS `tributaria`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE `tributaria`;

-- 2) Limpieza (drop) segura
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `pago`;
DROP TABLE IF EXISTS `cuota`;
DROP TABLE IF EXISTS `alcabala`;
DROP TABLE IF EXISTS `inmueble`;
DROP TABLE IF EXISTS `vehiculo`;
DROP TABLE IF EXISTS `impuesto`;
DROP TABLE IF EXISTS `usuarios`;
DROP TABLE IF EXISTS `funcionarios`;
DROP TABLE IF EXISTS `contribuyentes`;
DROP TABLE IF EXISTS `personas`;
DROP TABLE IF EXISTS `roles`;
DROP TABLE IF EXISTS `uit`;
DROP TABLE IF EXISTS `zona`;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- 3) TABLAS
-- =========================================================

CREATE TABLE `zona` (
  `id_zona` INT(11) NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(10) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `tasa_predial` DECIMAL(6,4) NOT NULL,
  `estado` VARCHAR(20) DEFAULT 'ACTIVO',
  `fecha_creacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `alicuota` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id_zona`),
  UNIQUE KEY `uk_zona_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `uit` (
  `id_uit` INT(11) NOT NULL AUTO_INCREMENT,
  `anio` INT(11) NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `fecha_creacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_uit`),
  UNIQUE KEY `uk_uit_anio` (`anio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `roles` (
  `id_rol` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(150) DEFAULT NULL,
  `estado` ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `uk_roles_nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `personas` (
  `id_persona` INT(11) NOT NULL AUTO_INCREMENT,
  `tipo_documento` VARCHAR(20) NOT NULL,
  `numero_documento` VARCHAR(20) NOT NULL,
  `nombres` VARCHAR(100) NOT NULL,
  `apellidos` VARCHAR(100) NOT NULL,
  `telefono` VARCHAR(20) DEFAULT NULL,
  `email` VARCHAR(150) DEFAULT NULL,
  `direccion` VARCHAR(255) DEFAULT NULL,
  `estado` ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_registro` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_persona`),
  UNIQUE KEY `uk_personas_numero_documento` (`numero_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `contribuyentes` (
  `id_contribuyente` INT(11) NOT NULL AUTO_INCREMENT,
  `id_persona` INT(11) NOT NULL,
  `fecha_registro_tributario` DATE NOT NULL,
  `estado` ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_contribuyente`),
  UNIQUE KEY `uk_contribuyentes_id_persona` (`id_persona`),
  CONSTRAINT `fk_contribuyentes_personas`
    FOREIGN KEY (`id_persona`) REFERENCES `personas` (`id_persona`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `funcionarios` (
  `id_funcionario` INT(11) NOT NULL AUTO_INCREMENT,
  `id_persona` INT(11) NOT NULL,
  `cargo` VARCHAR(100) NOT NULL,
  `area` VARCHAR(100) DEFAULT NULL,
  `fecha_ingreso` DATE NOT NULL,
  `estado` ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_funcionario`),
  UNIQUE KEY `uk_funcionarios_id_persona` (`id_persona`),
  CONSTRAINT `fk_funcionarios_personas`
    FOREIGN KEY (`id_persona`) REFERENCES `personas` (`id_persona`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `usuarios` (
  `id_usuario` INT(11) NOT NULL AUTO_INCREMENT,
  `id_persona` INT(11) NOT NULL,
  `id_rol` INT(11) NOT NULL,
  `username` VARCHAR(150) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `estado` ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `primer_ingreso` TINYINT(1) DEFAULT 1,
  `fecha_creacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_usuarios_id_persona` (`id_persona`),
  UNIQUE KEY `uk_usuarios_username` (`username`),
  KEY `idx_usuarios_rol` (`id_rol`),
  CONSTRAINT `fk_usuarios_personas`
    FOREIGN KEY (`id_persona`) REFERENCES `personas` (`id_persona`),
  CONSTRAINT `fk_usuarios_roles`
    FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `inmueble` (
  `id_inmueble` INT(11) NOT NULL AUTO_INCREMENT,
  `id_contribuyente` INT(11) NOT NULL,
  `id_zona` INT(11) NOT NULL,
  `direccion` VARCHAR(200) NOT NULL,
  `valor_catastral` DECIMAL(12,2) NOT NULL,
  `estado` VARCHAR(20) DEFAULT 'ACTIVO',
  `fecha_registro` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_inmueble`),
  KEY `idx_inmueble_contribuyente` (`id_contribuyente`),
  KEY `idx_inmueble_zona` (`id_zona`),
  CONSTRAINT `fk_inmueble_contribuyente`
    FOREIGN KEY (`id_contribuyente`) REFERENCES `contribuyentes` (`id_contribuyente`) ON DELETE CASCADE,
  CONSTRAINT `fk_inmueble_zona`
    FOREIGN KEY (`id_zona`) REFERENCES `zona` (`id_zona`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `vehiculo` (
  `id_vehiculo` INT(11) NOT NULL AUTO_INCREMENT,
  `id_contribuyente` INT(11) NOT NULL,
  `placa` VARCHAR(20) NOT NULL,
  `marca` VARCHAR(100) NOT NULL,
  `modelo` VARCHAR(100) NOT NULL,
  `anio` INT(11) NOT NULL,
  `fecha_inscripcion` DATE NOT NULL,
  `valor` DECIMAL(12,2) NOT NULL,
  `porcentaje` DECIMAL(5,2) NOT NULL,
  `estado` VARCHAR(20) DEFAULT 'ACTIVO',
  `fecha_registro` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_vehiculo`),
  UNIQUE KEY `uk_vehiculo_placa` (`placa`),
  KEY `idx_vehiculo_contribuyente` (`id_contribuyente`),
  CONSTRAINT `fk_vehiculo_contribuyente`
    FOREIGN KEY (`id_contribuyente`) REFERENCES `contribuyentes` (`id_contribuyente`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `impuesto` (
  `id_impuesto` INT(11) NOT NULL AUTO_INCREMENT,
  `id_contribuyente` INT(11) NOT NULL,
  `codigo` VARCHAR(20) DEFAULT NULL,
  `tipo` VARCHAR(20) NOT NULL,
  `anio` INT(11) NOT NULL,
  `monto_total` DECIMAL(12,2) NOT NULL,
  `estado` VARCHAR(20) DEFAULT 'PENDIENTE',
  `fecha_creacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `fecha_vencimiento` DATE DEFAULT NULL,
  `monto_pagado` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id_impuesto`),
  KEY `idx_impuesto_contribuyente` (`id_contribuyente`),
  CONSTRAINT `fk_impuesto_contribuyente`
    FOREIGN KEY (`id_contribuyente`) REFERENCES `contribuyentes` (`id_contribuyente`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `cuota` (
  `id_cuota` INT(11) NOT NULL AUTO_INCREMENT,
  `id_impuesto` INT(11) NOT NULL,
  `numero` INT(11) NOT NULL,
  `total_cuotas` INT(11) NOT NULL,
  `monto` DECIMAL(12,2) NOT NULL,
  `vencimiento` DATE NOT NULL,
  `estado` VARCHAR(20) DEFAULT 'PENDIENTE',
  `fecha_pago` DATE DEFAULT NULL,
  `codigo` VARCHAR(10) DEFAULT NULL,
  PRIMARY KEY (`id_cuota`),
  UNIQUE KEY `uk_cuota_codigo` (`codigo`),
  KEY `idx_cuota_impuesto` (`id_impuesto`),
  CONSTRAINT `fk_cuota_impuesto`
    FOREIGN KEY (`id_impuesto`) REFERENCES `impuesto` (`id_impuesto`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pago` (
  `id_pago` INT(11) NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(30) NOT NULL,
  `id_cuota` INT(11) NOT NULL,
  `monto` DECIMAL(12,2) NOT NULL,
  `medio_pago` VARCHAR(30) NOT NULL,
  `fecha_pago` DATE NOT NULL,
  `fecha_registro` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_pago`),
  UNIQUE KEY `uk_pago_codigo` (`codigo`),
  KEY `idx_pago_cuota` (`id_cuota`),
  CONSTRAINT `fk_pago_cuota`
    FOREIGN KEY (`id_cuota`) REFERENCES `cuota` (`id_cuota`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `alcabala` (
  `id_alcabala` INT(11) NOT NULL AUTO_INCREMENT,
  `id_inmueble` INT(11) NOT NULL,
  `valor_venta` DECIMAL(12,2) NOT NULL,
  `fecha_venta` DATE NOT NULL,
  `estado` VARCHAR(20) DEFAULT 'PENDIENTE',
  `fecha_registro` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id_alcabala`),
  KEY `idx_alcabala_inmueble` (`id_inmueble`),
  CONSTRAINT `fk_alcabala_inmueble`
    FOREIGN KEY (`id_inmueble`) REFERENCES `inmueble` (`id_inmueble`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =========================================================
-- 4) DATOS SEMILLA (según tu dump)
-- =========================================================

INSERT INTO `zona` (`id_zona`, `codigo`, `nombre`, `tasa_predial`, `estado`, `fecha_creacion`, `alicuota`) VALUES
(1, 'Z001', 'Zona A', 0.0120, 'ACTIVO', '2026-02-23 00:23:02', 0.00),
(2, 'Z002', 'Zona B', 0.0080, 'ACTIVO', '2026-02-23 00:23:02', 0.00),
(3, 'Z003', 'Zona C', 0.0050, 'ACTIVO', '2026-02-23 00:23:02', 0.00),
(4, 'Z004', 'Zona D', 0.0030, 'ACTIVO', '2026-02-23 00:23:02', 0.00);

INSERT INTO `uit` (`id_uit`, `anio`, `valor`, `fecha_creacion`) VALUES
(1, 2023, 4950.00, '2026-02-23 00:23:02'),
(2, 2024, 5150.00, '2026-02-23 00:23:02'),
(3, 2025, 5350.00, '2026-02-23 00:23:02');

INSERT INTO `roles` (`id_rol`, `nombre`, `descripcion`, `estado`) VALUES
(1, 'ADMIN', 'Administrador del sistema', 'ACTIVO'),
(2, 'FUNCIONARIO', 'Personal administrativo', 'ACTIVO'),
(3, 'CONTRIBUYENTE', 'Usuario tributario', 'ACTIVO');

INSERT INTO `personas` (`id_persona`, `tipo_documento`, `numero_documento`, `nombres`, `apellidos`, `telefono`, `email`, `direccion`, `estado`, `fecha_registro`) VALUES
(1, 'DNI', '00000001', 'Admin', 'Sistema', '999999999', 'admin@tributaria.com', 'Oficina Central', 'ACTIVO', '2026-02-23 00:23:21'),
(2, 'DNI', '74149543', 'Nilver', 'T.I', '933915043', 'nilvert.i13@gmail.com', NULL, 'ACTIVO', '2026-02-23 00:25:43'),
(3, 'DNI', '14563298', 'Juan', 'Llatas', '963258741', 'juanllatas@prueba.com', NULL, 'ACTIVO', '2026-02-24 13:15:19'),
(4, 'DNI', '72927772', 'Arnold', 'Mejia Quiroz', '915142871', 'arbraixitan24@gmail.com', NULL, 'ACTIVO', '2026-02-24 14:25:38');

INSERT INTO `contribuyentes` (`id_contribuyente`, `id_persona`, `fecha_registro_tributario`, `estado`) VALUES
(1, 2, '2026-02-22', 'ACTIVO'),
(2, 3, '2026-02-24', 'ACTIVO'),
(3, 4, '2026-02-24', 'ACTIVO');

INSERT INTO `usuarios` (`id_usuario`, `id_persona`, `id_rol`, `username`, `password_hash`, `estado`, `primer_ingreso`, `fecha_creacion`) VALUES
(1, 1, 1, 'admin', '$2a$10$NxwV3yfFF8Cc3e3jbbD5tOs8HPcz8aC4zX8Eyk98KqCosqKVdoIJ.', 'ACTIVO', 0, '2026-02-23 00:23:21');

INSERT INTO `inmueble` (`id_inmueble`, `id_contribuyente`, `id_zona`, `direccion`, `valor_catastral`, `estado`, `fecha_registro`) VALUES
(1, 1, 1, 'Los sauces V etapa LT 09 MZ O5', 12332.00, 'ACTIVO', '2026-02-23 00:25:56'),
(2, 2, 2, 'Los algarrobos 350', 2325.00, 'ACTIVO', '2026-02-24 13:19:45');

INSERT INTO `vehiculo` (`id_vehiculo`, `id_contribuyente`, `placa`, `marca`, `modelo`, `anio`, `fecha_inscripcion`, `valor`, `porcentaje`, `estado`, `fecha_registro`) VALUES
(1, 1, 'NTI-131', 'TOYOTA', 'HILUX', 2025, '2026-02-22', 55000.00, 3.00, 'ACTIVO', '2026-02-23 00:26:23'),
(2, 2, 'ABC-123', 'TOYOTA', 'HILUX', 2024, '2026-02-24', 40000.00, 6.00, 'ACTIVO', '2026-02-24 13:20:22');

INSERT INTO `impuesto` (`id_impuesto`, `id_contribuyente`, `codigo`, `tipo`, `anio`, `monto_total`, `estado`, `fecha_creacion`, `fecha_vencimiento`, `monto_pagado`) VALUES
(1, 1, 'IMP0001', 'PREDIAL', 2026, 2500.00, 'FRACCIONADO', '2026-02-24 04:17:13', '2026-06-30', 0.00),
(4, 1, 'IMP0004', 'PREDIAL', 2026, 2500.00, 'FRACCIONADO', '2026-02-24 13:35:25', NULL, 0.00),
(5, 1, 'IMP0005', 'PREDIAL', 2026, 2500.00, 'FRACCIONADO', '2026-02-24 13:35:30', NULL, 0.00),
(9, 2, 'IMP0009', 'PREDIAL', 2025, 2500.00, 'PENDIENTE', '2026-02-24 13:39:27', NULL, 0.00),
(10, 2, 'IMP0010', 'PREDIAL', 2025, 2500.00, 'PENDIENTE', '2026-02-24 13:44:32', NULL, 0.00),
(11, 2, 'IMP0011', 'PREDIAL', 2025, 2500.00, 'PENDIENTE', '2026-02-24 13:47:05', NULL, 0.00),
(12, 2, 'IMP0012', 'PREDIAL', 2025, 2500.00, 'PENDIENTE', '2026-02-24 13:51:03', NULL, 0.00),
(13, 1, 'IMP0013', 'PREDIAL', 2025, 2500.00, 'PENDIENTE', '2026-02-24 14:16:04', NULL, 0.00),
(14, 1, 'IMP0014', 'VEHICULAR', 2025, 2500.00, 'PENDIENTE', '2026-02-24 14:16:15', NULL, 0.00),
(15, 1, 'IMP0015', 'PREDIAL', 2025, 2500.00, 'FRACCIONADO', '2026-02-24 14:51:38', NULL, 0.00);

INSERT INTO `cuota` (`id_cuota`, `id_impuesto`, `numero`, `total_cuotas`, `monto`, `vencimiento`, `estado`, `fecha_pago`, `codigo`) VALUES
(1, 1, 1, 4, 625.00, '2026-02-28', 'PAGADA', '2026-02-24', 'CU0001'),
(2, 1, 2, 4, 625.00, '2026-03-31', 'PAGADA', '2026-02-24', 'CU0002'),
(3, 1, 3, 4, 625.00, '2026-04-30', 'PAGADA', '2026-02-24', 'CU0003'),
(4, 1, 4, 4, 625.00, '2026-05-31', 'PAGADA', '2026-02-24', 'CU0004'),
(5, 9, 1, 1, 2500.00, '2026-02-28', 'PAGADA', '2026-02-24', 'CU0009'),
(10, 15, 1, 2, 1250.00, '2026-01-31', 'PENDIENTE', NULL, 'CU0010'),
(11, 15, 2, 2, 1250.00, '2026-02-28', 'PAGADA', '2026-02-24', 'CU0011'),
(12, 4, 1, 3, 833.33, '2026-02-28', 'PENDIENTE', NULL, 'CU0012'),
(13, 4, 2, 3, 833.33, '2026-03-31', 'PENDIENTE', NULL, 'CU0013'),
(14, 4, 3, 3, 833.34, '2026-04-30', 'PENDIENTE', NULL, 'CU0014'),
(15, 5, 1, 2, 1250.00, '2026-02-28', 'PENDIENTE', NULL, 'CU0015'),
(16, 5, 2, 2, 1250.00, '2026-03-31', 'PENDIENTE', NULL, 'CU0016');

INSERT INTO `pago` (`id_pago`, `codigo`, `id_cuota`, `monto`, `medio_pago`, `fecha_pago`, `fecha_registro`) VALUES
(1, 'REC-2026-4438', 1, 625.00, 'EFECTIVO', '2026-02-24', '2026-02-24 10:58:38'),
(2, 'REC-2026-5C68', 3, 625.00, 'TRANSFERENCIA', '2026-02-24', '2026-02-24 18:00:36'),
(3, 'REC-2026-DCCF', 5, 2500.00, 'ONLINE', '2026-02-24', '2026-02-24 19:41:25'),
(4, 'REC-2026-C3B8', 2, 625.00, 'TARJETA', '2026-02-24', '2026-02-24 19:51:01'),
(5, 'REC-2026-9825', 4, 625.00, 'TARJETA', '2026-02-24', '2026-02-24 19:51:05'),
(6, 'REC-2026-8304', 11, 1250.00, 'ONLINE', '2026-02-24', '2026-02-24 19:53:37');

-- =========================================================
-- 5) PROCEDIMIENTOS ALMACENADOS (sin DEFINER)
--    Nota: se corrigió la columna cuota.codigo (ahora permite NULL)
-- =========================================================

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_calcular_alcabala`$$
CREATE PROCEDURE `sp_calcular_alcabala`(
  IN `p_valor_venta` DECIMAL(12,2),
  IN `p_fecha_venta` DATE
)
BEGIN
  DECLARE v_anio INT;
  DECLARE v_uit DECIMAL(10,2);
  DECLARE v_base DECIMAL(12,2);
  DECLARE v_impuesto DECIMAL(12,2);

  SET v_anio = YEAR(p_fecha_venta);

  SELECT valor INTO v_uit
  FROM uit
  WHERE anio = v_anio;

  SET v_base = p_valor_venta - (v_uit * 10);

  IF v_base > 0 THEN
    SET v_impuesto = v_base * 0.03;
  ELSE
    SET v_impuesto = 0;
  END IF;

  SELECT
    p_valor_venta AS valor_venta,
    v_uit AS uit,
    (v_uit * 10) AS deduccion,
    v_base AS base_imponible,
    v_impuesto AS impuesto_alcabala;
END$$

DROP PROCEDURE IF EXISTS `sp_cambiar_estado_contribuyente`$$
CREATE PROCEDURE `sp_cambiar_estado_contribuyente`(
  IN `p_id_contribuyente` INT,
  IN `p_estado` VARCHAR(10)
)
BEGIN
  UPDATE contribuyentes
  SET estado = p_estado
  WHERE id_contribuyente = p_id_contribuyente;
END$$

DROP PROCEDURE IF EXISTS `sp_cambiar_estado_inmueble`$$
CREATE PROCEDURE `sp_cambiar_estado_inmueble`(
  IN `p_id_inmueble` INT,
  IN `p_estado` VARCHAR(20)
)
BEGIN
  UPDATE inmueble
  SET estado = p_estado
  WHERE id_inmueble = p_id_inmueble;
END$$

DROP PROCEDURE IF EXISTS `sp_cambiar_estado_vehiculo`$$
CREATE PROCEDURE `sp_cambiar_estado_vehiculo`(
  IN `p_id_vehiculo` INT,
  IN `p_estado` VARCHAR(20)
)
BEGIN
  UPDATE vehiculo
  SET estado = p_estado
  WHERE id_vehiculo = p_id_vehiculo;
END$$

DROP PROCEDURE IF EXISTS `sp_crear_alcabala`$$
CREATE PROCEDURE `sp_crear_alcabala`(
  IN `p_id_inmueble` INT,
  IN `p_valor_venta` DECIMAL(12,2),
  IN `p_fecha_venta` DATE
)
BEGIN
  INSERT INTO alcabala(id_inmueble, valor_venta, fecha_venta, estado)
  VALUES(p_id_inmueble, p_valor_venta, p_fecha_venta, 'PENDIENTE');
END$$

DROP PROCEDURE IF EXISTS `sp_crear_contribuyente`$$
CREATE PROCEDURE `sp_crear_contribuyente`(
  IN `p_tipo_documento` VARCHAR(20),
  IN `p_numero_documento` VARCHAR(20),
  IN `p_nombres` VARCHAR(100),
  IN `p_apellidos` VARCHAR(100),
  IN `p_telefono` VARCHAR(20),
  IN `p_email` VARCHAR(150),
  IN `p_direccion` VARCHAR(255)
)
BEGIN
  DECLARE v_id_persona INT;

  INSERT INTO personas(
    tipo_documento, numero_documento, nombres, apellidos,
    telefono, email, direccion, estado
  )
  VALUES(
    p_tipo_documento, p_numero_documento, p_nombres, p_apellidos,
    p_telefono, p_email, p_direccion, 'ACTIVO'
  );

  SET v_id_persona = LAST_INSERT_ID();

  INSERT INTO contribuyentes(id_persona, fecha_registro_tributario, estado)
  VALUES(v_id_persona, CURDATE(), 'ACTIVO');
END$$

DROP PROCEDURE IF EXISTS `sp_crear_fraccionamiento`$$
CREATE PROCEDURE `sp_crear_fraccionamiento`(
  IN `p_id_contribuyente` INT,
  IN `p_tipo` VARCHAR(20),
  IN `p_anio` INT,
  IN `p_monto_total` DECIMAL(12,2),
  IN `p_numero_cuotas` INT
)
BEGIN
  DECLARE v_id_impuesto INT;
  DECLARE v_i INT DEFAULT 1;
  DECLARE v_monto_cuota DECIMAL(12,2);
  DECLARE v_venc DATE;
  DECLARE v_id_cuota INT;

  INSERT INTO impuesto(id_contribuyente, tipo, anio, monto_total, estado)
  VALUES(p_id_contribuyente, UPPER(TRIM(p_tipo)), p_anio, p_monto_total, 'FRACCIONADO');

  SET v_id_impuesto = LAST_INSERT_ID();

  UPDATE impuesto
  SET codigo = CONCAT('IMP', LPAD(v_id_impuesto, 4, '0'))
  WHERE id_impuesto = v_id_impuesto;

  SET v_monto_cuota = ROUND(p_monto_total / p_numero_cuotas, 2);
  SET v_venc = LAST_DAY(CURDATE());

  WHILE v_i <= p_numero_cuotas DO
    INSERT INTO cuota(id_impuesto, numero, total_cuotas, monto, vencimiento, estado, codigo)
    VALUES(v_id_impuesto, v_i, p_numero_cuotas, v_monto_cuota, v_venc, 'PENDIENTE', NULL);

    SET v_id_cuota = LAST_INSERT_ID();

    UPDATE cuota
    SET codigo = CONCAT('CU', LPAD(v_id_cuota, 4, '0'))
    WHERE id_cuota = v_id_cuota;

    SET v_i = v_i + 1;
    SET v_venc = LAST_DAY(DATE_ADD(v_venc, INTERVAL 1 MONTH));
  END WHILE;

  UPDATE impuesto
  SET fecha_vencimiento = v_venc
  WHERE id_impuesto = v_id_impuesto;
END$$

DROP PROCEDURE IF EXISTS `sp_crear_inmueble`$$
CREATE PROCEDURE `sp_crear_inmueble`(
  IN `p_id_contribuyente` INT,
  IN `p_id_zona` INT,
  IN `p_direccion` VARCHAR(200),
  IN `p_valor_catastral` DECIMAL(12,2)
)
BEGIN
  INSERT INTO inmueble(
    id_contribuyente, id_zona, direccion, valor_catastral,
    estado, fecha_registro
  )
  VALUES(
    p_id_contribuyente, p_id_zona, p_direccion, p_valor_catastral,
    'ACTIVO', CURRENT_TIMESTAMP
  );
END$$

DROP PROCEDURE IF EXISTS `sp_crear_vehiculo`$$
CREATE PROCEDURE `sp_crear_vehiculo`(
  IN `p_id_contribuyente` INT,
  IN `p_placa` VARCHAR(20),
  IN `p_marca` VARCHAR(100),
  IN `p_modelo` VARCHAR(100),
  IN `p_anio` INT,
  IN `p_fecha_inscripcion` DATE,
  IN `p_valor` DECIMAL(12,2),
  IN `p_porcentaje` DECIMAL(5,2)
)
BEGIN
  INSERT INTO vehiculo(
    id_contribuyente, placa, marca, modelo, anio,
    fecha_inscripcion, valor, porcentaje, estado, fecha_registro
  )
  VALUES(
    p_id_contribuyente, p_placa, p_marca, p_modelo, p_anio,
    p_fecha_inscripcion, p_valor, p_porcentaje, 'ACTIVO', CURRENT_TIMESTAMP
  );
END$$

DROP PROCEDURE IF EXISTS `sp_fraccionar_impuesto`$$
CREATE PROCEDURE `sp_fraccionar_impuesto`(
  IN `p_id_impuesto` INT,
  IN `p_numero_cuotas` INT,
  IN `p_fecha_primera` DATE
)
BEGIN
  DECLARE v_total DECIMAL(12,2);
  DECLARE v_base DECIMAL(12,2);
  DECLARE v_suma DECIMAL(12,2) DEFAULT 0.00;
  DECLARE v_i INT DEFAULT 1;
  DECLARE v_venc DATE;
  DECLARE v_id_cuota INT;

  IF p_id_impuesto IS NULL OR p_numero_cuotas IS NULL OR p_fecha_primera IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Datos incompletos para fraccionar';
  END IF;

  IF p_numero_cuotas < 1 OR p_numero_cuotas > 48 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Número de cuotas inválido (1 a 48)';
  END IF;

  SELECT IFNULL(monto_total, 0)
    INTO v_total
  FROM impuesto
  WHERE id_impuesto = p_id_impuesto;

  IF v_total <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El impuesto no tiene monto_total válido';
  END IF;

  IF EXISTS(
    SELECT 1 FROM impuesto
    WHERE id_impuesto = p_id_impuesto
      AND UPPER(IFNULL(estado,'')) = 'PAGADO'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede fraccionar un impuesto PAGADO';
  END IF;

  DELETE FROM cuota WHERE id_impuesto = p_id_impuesto;

  SET v_base = ROUND(v_total / p_numero_cuotas, 2);
  SET v_venc = LAST_DAY(p_fecha_primera);

  WHILE v_i <= p_numero_cuotas DO
    IF v_i < p_numero_cuotas THEN
      INSERT INTO cuota(id_impuesto, numero, total_cuotas, monto, vencimiento, estado, codigo)
      VALUES(p_id_impuesto, v_i, p_numero_cuotas, v_base, v_venc, 'PENDIENTE', NULL);

      SET v_id_cuota = LAST_INSERT_ID();

      UPDATE cuota
      SET codigo = CONCAT('CU', LPAD(v_id_cuota, 4, '0'))
      WHERE id_cuota = v_id_cuota;

      SET v_suma = v_suma + v_base;
    ELSE
      INSERT INTO cuota(id_impuesto, numero, total_cuotas, monto, vencimiento, estado, codigo)
      VALUES(p_id_impuesto, v_i, p_numero_cuotas, ROUND(v_total - v_suma, 2), v_venc, 'PENDIENTE', NULL);

      SET v_id_cuota = LAST_INSERT_ID();

      UPDATE cuota
      SET codigo = CONCAT('CU', LPAD(v_id_cuota, 4, '0'))
      WHERE id_cuota = v_id_cuota;
    END IF;

    SET v_i = v_i + 1;
    SET v_venc = LAST_DAY(DATE_ADD(v_venc, INTERVAL 1 MONTH));
  END WHILE;

  UPDATE impuesto
  SET estado = 'FRACCIONADO'
  WHERE id_impuesto = p_id_impuesto;
END$$

DROP PROCEDURE IF EXISTS `sp_generar_impuesto`$$
CREATE PROCEDURE `sp_generar_impuesto`(
  IN `p_id_contribuyente` INT,
  IN `p_tipo` VARCHAR(20),
  IN `p_anio` INT
)
BEGIN
  DECLARE v_id_impuesto INT;
  DECLARE v_codigo VARCHAR(20);

  INSERT INTO impuesto (codigo, id_contribuyente, tipo, anio, monto_total, estado)
  VALUES ('TMP', p_id_contribuyente, UPPER(p_tipo), p_anio, 2500.00, 'PENDIENTE');

  SET v_id_impuesto = LAST_INSERT_ID();
  SET v_codigo = CONCAT('IMP', LPAD(v_id_impuesto, 4, '0'));

  UPDATE impuesto
  SET codigo = v_codigo
  WHERE id_impuesto = v_id_impuesto;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_contribuyentes`$$
CREATE PROCEDURE `sp_listar_contribuyentes`()
BEGIN
  SELECT
    c.id_contribuyente,
    p.numero_documento,
    p.nombres,
    p.apellidos,
    p.telefono,
    p.email,
    p.direccion,
    c.estado
  FROM contribuyentes c
  INNER JOIN personas p ON c.id_persona = p.id_persona;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_contribuyentes_combo`$$
CREATE PROCEDURE `sp_listar_contribuyentes_combo`()
BEGIN
  SELECT
    c.id_contribuyente,
    CONCAT(p.nombres, ' ', p.apellidos) AS nombre
  FROM contribuyentes c
  INNER JOIN personas p ON c.id_persona = p.id_persona
  WHERE c.estado = 'ACTIVO'
  ORDER BY nombre;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_cuotas`$$
CREATE PROCEDURE `sp_listar_cuotas`()
BEGIN
  SELECT
    CONCAT('CU', LPAD(c.id_cuota, 4, '0')) AS codigo_cuota,
    CONCAT('IMP', LPAD(i.id_impuesto, 4, '0')) AS codigo_impuesto,
    CONCAT(p.nombres, ' ', p.apellidos) AS contribuyente,
    c.numero,
    c.total_cuotas,
    c.monto,
    c.vencimiento,
    c.estado
  FROM cuota c
  INNER JOIN impuesto i ON i.id_impuesto = c.id_impuesto
  INNER JOIN contribuyentes ct ON ct.id_contribuyente = i.id_contribuyente
  INNER JOIN personas p ON p.id_persona = ct.id_persona
  ORDER BY c.id_cuota DESC;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_cuotas_por_impuesto`$$
CREATE PROCEDURE `sp_listar_cuotas_por_impuesto`(IN `p_id_impuesto` INT)
BEGIN
  SELECT numero, vencimiento, monto, estado
  FROM cuota
  WHERE id_impuesto = p_id_impuesto
  ORDER BY numero ASC;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_impuestos`$$
CREATE PROCEDURE `sp_listar_impuestos`()
BEGIN
  SELECT
    i.id_impuesto AS id,
    CONCAT(p.nombres,' ',p.apellidos) AS contribuyente,
    i.tipo AS tipo,
    i.anio AS anio,
    IFNULL(i.monto_total,0) AS total,

    IFNULL((
      SELECT SUM(IFNULL(c2.monto,0))
      FROM cuota c2
      WHERE c2.id_impuesto = i.id_impuesto
        AND UPPER(c2.estado) = 'PAGADA'
    ),0) AS pagado,

    CASE
      WHEN IFNULL((
        SELECT SUM(IFNULL(c3.monto,0))
        FROM cuota c3
        WHERE c3.id_impuesto = i.id_impuesto
          AND UPPER(c3.estado) = 'PAGADA'
      ),0) >= IFNULL(i.monto_total,0)
      THEN 'PAGADO'

      WHEN EXISTS (SELECT 1 FROM cuota cx WHERE cx.id_impuesto = i.id_impuesto)
           AND IFNULL((
             SELECT SUM(CASE WHEN UPPER(c4.estado)='PAGADA' THEN 1 ELSE 0 END)
             FROM cuota c4
             WHERE c4.id_impuesto = i.id_impuesto
           ),0) > 0
      THEN 'FRACCIONADO'

      ELSE IFNULL(i.estado,'PENDIENTE')
    END AS estado
  FROM impuesto i
  JOIN contribuyentes co ON co.id_contribuyente = i.id_contribuyente
  JOIN personas p ON p.id_persona = co.id_persona
  ORDER BY i.id_impuesto DESC;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_impuestos_para_fraccionar`$$
CREATE PROCEDURE `sp_listar_impuestos_para_fraccionar`()
BEGIN
  SELECT
    i.id_impuesto                                  AS id_impuesto,
    CONCAT('IMP', LPAD(i.id_impuesto, 4, '0'))      AS codigo,
    CONCAT(p.nombres,' ',p.apellidos)              AS contribuyente,
    i.tipo                                         AS tipo,
    i.anio                                         AS anio,
    IFNULL(i.monto_total,0)                        AS monto_total
  FROM impuesto i
  JOIN contribuyentes co ON co.id_contribuyente = i.id_contribuyente
  JOIN personas p ON p.id_persona = co.id_persona
  LEFT JOIN cuota c ON c.id_impuesto = i.id_impuesto
  GROUP BY i.id_impuesto, p.nombres, p.apellidos, i.tipo, i.anio, i.monto_total
  HAVING COUNT(c.id_cuota) <= 1
  ORDER BY i.id_impuesto DESC;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_inmuebles`$$
CREATE PROCEDURE `sp_listar_inmuebles`()
BEGIN
  SELECT
    i.id_inmueble,
    CONCAT(p.nombres, ' ', p.apellidos) AS contribuyente,
    i.direccion,
    z.nombre AS zona,
    z.tasa_predial,
    i.valor_catastral,
    (i.valor_catastral * z.tasa_predial) AS impuesto_predial,
    i.estado,
    i.fecha_registro
  FROM inmueble i
  INNER JOIN contribuyentes c ON i.id_contribuyente = c.id_contribuyente
  INNER JOIN personas p ON c.id_persona = p.id_persona
  INNER JOIN zona z ON i.id_zona = z.id_zona
  ORDER BY i.id_inmueble DESC;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_uit`$$
CREATE PROCEDURE `sp_listar_uit`()
BEGIN
  SELECT anio, valor
  FROM uit
  ORDER BY anio DESC;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_vehiculos`$$
CREATE PROCEDURE `sp_listar_vehiculos`()
BEGIN
  SELECT
    v.id_vehiculo,
    v.placa,
    CONCAT(p.nombres, ' ', p.apellidos) AS contribuyente,
    CONCAT(v.marca, ' ', v.modelo) AS vehiculo,
    v.anio,
    v.valor,
    v.porcentaje,
    CASE
      WHEN TIMESTAMPDIFF(YEAR, v.fecha_inscripcion, CURDATE()) <= 3
      THEN (v.valor * (v.porcentaje / 100))
      ELSE 0
    END AS impuesto_vehicular,
    CASE
      WHEN TIMESTAMPDIFF(YEAR, v.fecha_inscripcion, CURDATE()) <= 3
      THEN 'PAGA'
      ELSE 'NO PAGA'
    END AS situacion,
    v.estado,
    v.fecha_registro
  FROM vehiculo v
  INNER JOIN contribuyentes c ON v.id_contribuyente = c.id_contribuyente
  INNER JOIN personas p ON c.id_persona = p.id_persona
  ORDER BY v.id_vehiculo DESC;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_zonas`$$
CREATE PROCEDURE `sp_listar_zonas`()
BEGIN
  SELECT id_zona, codigo, nombre, tasa_predial, estado
  FROM zona
  ORDER BY id_zona DESC;
END$$

DROP PROCEDURE IF EXISTS `sp_listar_zonas_combo`$$
CREATE PROCEDURE `sp_listar_zonas_combo`()
BEGIN
  SELECT id_zona, nombre, tasa_predial
  FROM zona
  WHERE estado = 'ACTIVO'
  ORDER BY nombre;
END$$

DROP PROCEDURE IF EXISTS `sp_login`$$
CREATE PROCEDURE `sp_login`(IN `p_username` VARCHAR(150))
BEGIN
  SELECT *
  FROM usuarios
  WHERE username = p_username
    AND estado = 'ACTIVO';
END$$

DELIMITER ;

-- Ajustar AUTO_INCREMENT al final (opcional, para conservar ids de tu dump)
ALTER TABLE `zona` AUTO_INCREMENT = 5;
ALTER TABLE `uit` AUTO_INCREMENT = 4;
ALTER TABLE `roles` AUTO_INCREMENT = 4;
ALTER TABLE `personas` AUTO_INCREMENT = 5;
ALTER TABLE `contribuyentes` AUTO_INCREMENT = 4;
ALTER TABLE `usuarios` AUTO_INCREMENT = 2;
ALTER TABLE `inmueble` AUTO_INCREMENT = 3;
ALTER TABLE `vehiculo` AUTO_INCREMENT = 3;
ALTER TABLE `impuesto` AUTO_INCREMENT = 16;
ALTER TABLE `cuota` AUTO_INCREMENT = 17;
ALTER TABLE `pago` AUTO_INCREMENT = 7;
ALTER TABLE `alcabala` AUTO_INCREMENT = 1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
