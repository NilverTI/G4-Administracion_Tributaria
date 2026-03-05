-- Tributaria - Script corregido y funcional + DATOS DE PRUEBA (MySQL/MariaDB)
-- Generado: 2026-03-03
-- Incluye: CREATE DATABASE/USE para evitar Error 1046 (No database selected)
-- Incluye: DROPs para re-ejecutar sin conflictos
-- Incluye: Datos de prueba (seed) para todas las tablas principales

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
START TRANSACTION;

-- =========================================================
-- 1) BASE DE DATOS
-- =========================================================
CREATE DATABASE IF NOT EXISTS `tributaria`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE `tributaria`;

-- =========================================================
-- 2) LIMPIEZA (re-ejecutable)
-- =========================================================
SET FOREIGN_KEY_CHECKS = 0;

DROP PROCEDURE IF EXISTS `sp_actualizar_uit`;
DROP PROCEDURE IF EXISTS `sp_actualizar_vehicular_config`;
DROP PROCEDURE IF EXISTS `sp_aplicar_reglas_automaticas_predial`;
DROP PROCEDURE IF EXISTS `sp_calcular_alcabala`;
DROP PROCEDURE IF EXISTS `sp_cambiar_estado_contribuyente`;
DROP PROCEDURE IF EXISTS `sp_cambiar_estado_impuesto_predial`;
DROP PROCEDURE IF EXISTS `sp_cambiar_estado_inmueble`;
DROP PROCEDURE IF EXISTS `sp_cambiar_estado_vehicular_config`;
DROP PROCEDURE IF EXISTS `sp_cambiar_estado_vehiculo`;
DROP PROCEDURE IF EXISTS `sp_cambiar_estado_zona`;
DROP PROCEDURE IF EXISTS `sp_crear_alcabala`;
DROP PROCEDURE IF EXISTS `sp_crear_contribuyente`;
DROP PROCEDURE IF EXISTS `sp_crear_impuesto_alcabala`;
DROP PROCEDURE IF EXISTS `sp_crear_impuesto_predial`;
DROP PROCEDURE IF EXISTS `sp_crear_impuesto_vehicular`;
DROP PROCEDURE IF EXISTS `sp_crear_inmueble`;
DROP PROCEDURE IF EXISTS `sp_crear_uit`;
DROP PROCEDURE IF EXISTS `sp_crear_vehicular_config`;
DROP PROCEDURE IF EXISTS `sp_crear_vehiculo`;
DROP PROCEDURE IF EXISTS `sp_crear_zona`;
DROP PROCEDURE IF EXISTS `sp_listar_contribuyentes`;
DROP PROCEDURE IF EXISTS `sp_listar_contribuyentes_combo`;
DROP PROCEDURE IF EXISTS `sp_listar_detalle_impuesto`;
DROP PROCEDURE IF EXISTS `sp_listar_historial_predial`;
DROP PROCEDURE IF EXISTS `sp_listar_impuestos_alcabala`;
DROP PROCEDURE IF EXISTS `sp_listar_impuestos_prediales`;
DROP PROCEDURE IF EXISTS `sp_listar_impuestos_vehiculares`;
DROP PROCEDURE IF EXISTS `sp_listar_inmuebles`;
DROP PROCEDURE IF EXISTS `sp_listar_inmuebles_disponibles_predial`;
DROP PROCEDURE IF EXISTS `sp_listar_inmuebles_para_alcabala`;
DROP PROCEDURE IF EXISTS `sp_listar_uit`;
DROP PROCEDURE IF EXISTS `sp_listar_vehicular_config`;
DROP PROCEDURE IF EXISTS `sp_listar_vehiculos`;
DROP PROCEDURE IF EXISTS `sp_listar_zonas`;
DROP PROCEDURE IF EXISTS `sp_listar_zonas_combo`;
DROP PROCEDURE IF EXISTS `sp_login`;
DROP PROCEDURE IF EXISTS `sp_obtener_impuesto_alcabala`;
DROP PROCEDURE IF EXISTS `sp_obtener_impuesto_predial`;
DROP PROCEDURE IF EXISTS `sp_obtener_impuesto_vehicular`;
DROP PROCEDURE IF EXISTS `sp_obtener_porcentaje_vehicular`;
DROP PROCEDURE IF EXISTS `sp_porcentaje_vehicular_vigente`;

DROP TABLE IF EXISTS `impuesto_vehicular`;
DROP TABLE IF EXISTS `impuesto_predial_historial`;
DROP TABLE IF EXISTS `impuesto_predial`;
DROP TABLE IF EXISTS `alcabala`;
DROP TABLE IF EXISTS `impuesto_detalle`;
DROP TABLE IF EXISTS `impuesto`;
DROP TABLE IF EXISTS `vehiculo`;
DROP TABLE IF EXISTS `vehicular_config`;
DROP TABLE IF EXISTS `inmueble`;
DROP TABLE IF EXISTS `zona`;
DROP TABLE IF EXISTS `fraccionamiento_cuota`;
DROP TABLE IF EXISTS `fraccionamiento_impuesto`;
DROP TABLE IF EXISTS `usuarios`;
DROP TABLE IF EXISTS `funcionarios`;
DROP TABLE IF EXISTS `contribuyentes`;
DROP TABLE IF EXISTS `roles`;
DROP TABLE IF EXISTS `uit`;
DROP TABLE IF EXISTS `personas`;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- 3) TABLAS
-- =========================================================

CREATE TABLE `personas` (
  `id_persona` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_documento` varchar(20) NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_nacimiento` date DEFAULT NULL,
  PRIMARY KEY (`id_persona`),
  UNIQUE KEY `numero_documento` (`numero_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `id_persona` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `username` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `primer_ingreso` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `id_persona` (`id_persona`),
  UNIQUE KEY `username` (`username`),
  KEY `id_rol` (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `contribuyentes` (
  `id_contribuyente` int(11) NOT NULL AUTO_INCREMENT,
  `id_persona` int(11) NOT NULL,
  `fecha_registro_tributario` date NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_contribuyente`),
  UNIQUE KEY `id_persona` (`id_persona`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `funcionarios` (
  `id_funcionario` int(11) NOT NULL AUTO_INCREMENT,
  `id_persona` int(11) NOT NULL,
  `cargo` varchar(100) NOT NULL,
  `area` varchar(100) DEFAULT NULL,
  `fecha_ingreso` date NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_funcionario`),
  UNIQUE KEY `id_persona` (`id_persona`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `uit` (
  `id_uit` int(11) NOT NULL AUTO_INCREMENT,
  `anio` int(11) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_uit`),
  UNIQUE KEY `anio` (`anio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `vehicular_config` (
  `anio` int(11) NOT NULL,
  `porcentaje` decimal(5,2) NOT NULL,
  `estado` varchar(10) DEFAULT 'ACTIVO',
  PRIMARY KEY (`anio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `zona` (
  `id_zona` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `tasa_predial` decimal(6,4) NOT NULL,
  `estado` varchar(20) DEFAULT 'ACTIVO',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `alicuota` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id_zona`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `inmueble` (
  `id_inmueble` int(11) NOT NULL AUTO_INCREMENT,
  `id_contribuyente` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `direccion` varchar(200) NOT NULL,
  `valor_catastral` decimal(12,2) NOT NULL,
  `estado` varchar(20) DEFAULT 'ACTIVO',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `tipo_uso` varchar(20) NOT NULL DEFAULT 'TERRENO',
  `area_terreno_m2` decimal(12,2) DEFAULT NULL,
  `area_construida_m2` decimal(12,2) DEFAULT NULL,
  `tipo_material` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_inmueble`),
  KEY `fk_inmueble_zona` (`id_zona`),
  KEY `idx_inmueble_contribuyente` (`id_contribuyente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `vehiculo` (
  `id_vehiculo` int(11) NOT NULL AUTO_INCREMENT,
  `id_contribuyente` int(11) NOT NULL,
  `placa` varchar(20) NOT NULL,
  `marca` varchar(100) NOT NULL,
  `modelo` varchar(100) NOT NULL,
  `anio` int(11) NOT NULL,
  `fecha_inscripcion` date NOT NULL,
  `valor` decimal(12,2) NOT NULL,
  `porcentaje` decimal(5,2) NOT NULL,
  `estado` varchar(20) DEFAULT 'ACTIVO',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_vehiculo`),
  UNIQUE KEY `placa` (`placa`),
  KEY `idx_vehiculo_contribuyente` (`id_contribuyente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `impuesto` (
  `id_impuesto` int(11) NOT NULL AUTO_INCREMENT,
  `id_contribuyente` int(11) NOT NULL,
  `tipo` enum('VEHICULAR','PREDIAL','ALCABALA') NOT NULL,
  `anio_inicio` int(11) NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `pagado` decimal(12,2) NOT NULL DEFAULT 0.00,
  `estado` enum('PENDIENTE','PAGADO') DEFAULT 'PENDIENTE',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_impuesto`),
  KEY `id_contribuyente` (`id_contribuyente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `impuesto_detalle` (
  `id_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `id_impuesto` int(11) NOT NULL,
  `anio` int(11) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `pagado` decimal(12,2) DEFAULT 0.00,
  `estado` enum('PENDIENTE','PAGADO') DEFAULT 'PENDIENTE',
  PRIMARY KEY (`id_detalle`),
  KEY `id_impuesto` (`id_impuesto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `impuesto_vehicular` (
  `id_impuesto` int(11) NOT NULL,
  `id_vehiculo` int(11) NOT NULL,
  `valor_vehiculo` decimal(12,2) NOT NULL,
  `porcentaje` decimal(5,2) NOT NULL,
  `anio_inscripcion` int(11) NOT NULL,
  PRIMARY KEY (`id_impuesto`),
  KEY `id_vehiculo` (`id_vehiculo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `impuesto_predial` (
  `id_predial` int(11) NOT NULL AUTO_INCREMENT,
  `id_inmueble` int(11) NOT NULL,
  `monto_anual` decimal(14,2) NOT NULL,
  `tasa_aplicada` decimal(8,4) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'ACTIVO',
  `motivo_estado` varchar(30) DEFAULT NULL,
  `detalle_motivo` varchar(255) DEFAULT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_cierre` date DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_predial`),
  KEY `idx_predial_inmueble_estado` (`id_inmueble`,`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `impuesto_predial_historial` (
  `id_historial` int(11) NOT NULL AUTO_INCREMENT,
  `id_predial` int(11) NOT NULL,
  `estado_anterior` varchar(20) DEFAULT NULL,
  `estado_nuevo` varchar(20) NOT NULL,
  `motivo` varchar(30) DEFAULT NULL,
  `detalle_motivo` varchar(255) DEFAULT NULL,
  `origen` varchar(20) NOT NULL,
  `fecha_cambio` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_historial`),
  KEY `fk_historial_predial` (`id_predial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `alcabala` (
  `id_alcabala` int(11) NOT NULL AUTO_INCREMENT,
  `id_inmueble` int(11) NOT NULL,
  `valor_venta` decimal(12,2) NOT NULL,
  `fecha_venta` date NOT NULL,
  `estado` varchar(20) DEFAULT 'PENDIENTE',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `valor_catastral_ref` decimal(14,2) DEFAULT NULL,
  `base_calculo` decimal(14,2) DEFAULT NULL,
  `monto_inafecto` decimal(14,2) DEFAULT NULL,
  `base_imponible` decimal(14,2) DEFAULT NULL,
  `tasa_aplicada` decimal(8,4) DEFAULT NULL,
  `monto_alcabala` decimal(14,2) DEFAULT NULL,
  `anio_uit` int(11) DEFAULT NULL,
  `valor_uit` decimal(14,2) DEFAULT NULL,
  `id_contribuyente_comprador` int(11) DEFAULT NULL,
  `id_contribuyente_vendedor` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_alcabala`),
  KEY `idx_alcabala_inmueble` (`id_inmueble`),
  KEY `idx_alcabala_comprador` (`id_contribuyente_comprador`),
  KEY `idx_alcabala_vendedor` (`id_contribuyente_vendedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `fraccionamiento_impuesto` (
  `id_fraccionamiento` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_impuesto` varchar(20) NOT NULL,
  `id_referencia` int(11) NOT NULL,
  `codigo_impuesto` varchar(30) NOT NULL,
  `contribuyente` varchar(180) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `monto_anual` decimal(14,2) NOT NULL,
  `periodicidad` varchar(20) NOT NULL,
  `meses_por_cuota` int(11) NOT NULL,
  `total_cuotas` int(11) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'ACTIVO',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_cierre` date DEFAULT NULL,
  PRIMARY KEY (`id_fraccionamiento`),
  KEY `idx_fracc_tipo_ref_estado` (`tipo_impuesto`,`id_referencia`,`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `fraccionamiento_cuota` (
  `id_cuota` int(11) NOT NULL AUTO_INCREMENT,
  `id_fraccionamiento` int(11) NOT NULL,
  `numero_cuota` int(11) NOT NULL,
  `periodo_label` varchar(40) NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `monto_programado` decimal(14,2) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'PENDIENTE',
  `fecha_pago` date DEFAULT NULL,
  `monto_pagado` decimal(14,2) DEFAULT NULL,
  `observacion_pago` varchar(255) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_cuota`),
  UNIQUE KEY `uq_fracc_cuota_numero` (`id_fraccionamiento`,`numero_cuota`),
  KEY `idx_fracc_cuota_estado_fecha` (`estado`,`fecha_vencimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =========================================================
-- 4) RELACIONES (FOREIGN KEYS)
-- =========================================================
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `personas` (`id_persona`),
  ADD CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);

ALTER TABLE `contribuyentes`
  ADD CONSTRAINT `contribuyentes_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `personas` (`id_persona`);

ALTER TABLE `funcionarios`
  ADD CONSTRAINT `funcionarios_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `personas` (`id_persona`);

ALTER TABLE `inmueble`
  ADD CONSTRAINT `fk_inmueble_contribuyente` FOREIGN KEY (`id_contribuyente`) REFERENCES `contribuyentes` (`id_contribuyente`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_inmueble_zona` FOREIGN KEY (`id_zona`) REFERENCES `zona` (`id_zona`);

ALTER TABLE `vehiculo`
  ADD CONSTRAINT `fk_vehiculo_contribuyente` FOREIGN KEY (`id_contribuyente`) REFERENCES `contribuyentes` (`id_contribuyente`) ON DELETE CASCADE;

ALTER TABLE `impuesto`
  ADD CONSTRAINT `impuesto_ibfk_1` FOREIGN KEY (`id_contribuyente`) REFERENCES `contribuyentes` (`id_contribuyente`);

ALTER TABLE `impuesto_detalle`
  ADD CONSTRAINT `impuesto_detalle_ibfk_1` FOREIGN KEY (`id_impuesto`) REFERENCES `impuesto` (`id_impuesto`);

ALTER TABLE `impuesto_vehicular`
  ADD CONSTRAINT `impuesto_vehicular_ibfk_1` FOREIGN KEY (`id_impuesto`) REFERENCES `impuesto` (`id_impuesto`),
  ADD CONSTRAINT `impuesto_vehicular_ibfk_2` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculo` (`id_vehiculo`);

ALTER TABLE `impuesto_predial`
  ADD CONSTRAINT `fk_impuesto_predial_inmueble` FOREIGN KEY (`id_inmueble`) REFERENCES `inmueble` (`id_inmueble`);

ALTER TABLE `impuesto_predial_historial`
  ADD CONSTRAINT `fk_historial_predial` FOREIGN KEY (`id_predial`) REFERENCES `impuesto_predial` (`id_predial`);

ALTER TABLE `alcabala`
  ADD CONSTRAINT `fk_alcabala_inmueble` FOREIGN KEY (`id_inmueble`) REFERENCES `inmueble` (`id_inmueble`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_alcabala_contribuyente_comprador` FOREIGN KEY (`id_contribuyente_comprador`) REFERENCES `contribuyentes` (`id_contribuyente`),
  ADD CONSTRAINT `fk_alcabala_contribuyente_vendedor` FOREIGN KEY (`id_contribuyente_vendedor`) REFERENCES `contribuyentes` (`id_contribuyente`);

ALTER TABLE `fraccionamiento_cuota`
  ADD CONSTRAINT `fk_fraccionamiento_cuota` FOREIGN KEY (`id_fraccionamiento`) REFERENCES `fraccionamiento_impuesto` (`id_fraccionamiento`) ON DELETE CASCADE;

-- =========================================================
-- 5) DATOS DE PRUEBA (SEED)
-- =========================================================

-- Roles
INSERT INTO `roles` (`id_rol`, `nombre`, `descripcion`, `estado`) VALUES
(1, 'ADMIN', 'Administrador del sistema', 'ACTIVO'),
(2, 'FUNCIONARIO', 'Personal administrativo', 'ACTIVO'),
(3, 'CONTRIBUYENTE', 'Usuario tributario', 'ACTIVO');

-- Personas (1 admin + 3 contribuyentes + 1 funcionario)
INSERT INTO `personas` (`id_persona`,`tipo_documento`,`numero_documento`,`nombres`,`apellidos`,`telefono`,`email`,`direccion`,`estado`,`fecha_nacimiento`) VALUES
(1,'DNI','00000001','Admin','Sistema','999999999','admin@tributaria.com','Oficina Central','ACTIVO',NULL),
(2,'DNI','71122526','Euler','Flores','915903587','euler@mail.com','Av. Principal 100','ACTIVO','2004-08-20'),
(3,'DNI','33333333','Nilver','Tantalean','912345678','nilver@mail.com','Los Sauces 12','ACTIVO','2005-05-10'),
(4,'DNI','88888888','Tefa','Cruz','911100000','tefa@mail.com','Calle 15','ACTIVO','2005-03-03'),
(5,'DNI','22222222','Mariana','Lopez','900111222','mlopez@muni.gob','Municipalidad','ACTIVO','1998-11-01');

-- Usuarios (admin + un contribuyente)
INSERT INTO `usuarios` (`id_usuario`,`id_persona`,`id_rol`,`username`,`password_hash`,`estado`,`primer_ingreso`) VALUES
(1,1,1,'admin','$2a$10$NxwV3yfFF8Cc3e3jbbD5tOs8HPcz8aC4zX8Eyk98KqCosqKVdoIJ.','ACTIVO',0),
(2,3,3,'nilver@mail.com','$2a$10$2UnBMYnYCx6b.XETV37GNewnCoXbymv8OVci53Y7KvIwkwiiwK51m','ACTIVO',0);

-- Contribuyentes (Euler, Nilver, Tefa)
INSERT INTO `contribuyentes` (`id_contribuyente`,`id_persona`,`fecha_registro_tributario`,`estado`) VALUES
(1,2,'2026-03-01','ACTIVO'),
(2,3,'2026-03-02','ACTIVO'),
(3,4,'2026-03-03','ACTIVO');

-- Funcionarios
INSERT INTO `funcionarios` (`id_funcionario`,`id_persona`,`cargo`,`area`,`fecha_ingreso`,`estado`) VALUES
(1,5,'Analista Tributario','Rentas','2024-01-15','ACTIVO');

-- UIT
INSERT INTO `uit` (`id_uit`,`anio`,`valor`) VALUES
(1,2023,4950.00),
(2,2024,5150.00),
(3,2025,5350.00),
(4,2026,6000.00);

-- Config Vehicular
INSERT INTO `vehicular_config` (`anio`,`porcentaje`,`estado`) VALUES
(2025,1.00,'ACTIVO'),
(2026,1.20,'ACTIVO');

-- Zonas
INSERT INTO `zona` (`id_zona`,`codigo`,`nombre`,`tasa_predial`,`estado`,`alicuota`) VALUES
(1,'Z001','Zona A',0.0120,'ACTIVO',0.00),
(2,'Z002','Zona B',0.0080,'ACTIVO',0.00),
(3,'Z003','Zona C',0.0050,'ACTIVO',0.00),
(4,'Z004','Zona D',0.0030,'ACTIVO',0.00),
(5,'Z005','Chiclayo',1.5000,'ACTIVO',0.00);

-- Inmuebles
INSERT INTO `inmueble` (`id_inmueble`,`id_contribuyente`,`id_zona`,`direccion`,`valor_catastral`,`estado`,`tipo_uso`,`area_terreno_m2`,`area_construida_m2`,`tipo_material`) VALUES
(1,1,5,'Calle 13',150000.00,'ACTIVO','TERRENO',90.00,NULL,NULL),
(2,1,5,'Av. Lima 123',200000.00,'ACTIVO','TERRENO',120.00,NULL,NULL),
(3,2,5,'Av. Grau 500',100000.00,'ACTIVO','TERRENO',80.00,NULL,NULL),
(4,2,4,'Calle 12',100000.00,'ACTIVO','TERRENO',75.00,NULL,NULL),
(5,1,5,'Calle 20',120000.00,'ACTIVO','TERRENO',90.00,NULL,NULL),
(6,3,1,'Calle 30',50000.00,'ACTIVO','TERRENO',60.00,NULL,NULL);

-- Vehículos (valores realistas)
INSERT INTO `vehiculo` (`id_vehiculo`,`id_contribuyente`,`placa`,`marca`,`modelo`,`anio`,`fecha_inscripcion`,`valor`,`porcentaje`,`estado`) VALUES
(1,1,'BB-10','Toyota','Hilux',2026,'2026-03-01',200000.00,1.20,'ACTIVO'),
(2,1,'JJ-01','Toyota','Hilux',2025,'2026-03-01',200000.00,1.20,'ACTIVO'),
(3,1,'KKKK','Toyota','Hilux',2024,'2026-03-01',100000.00,1.20,'ACTIVO'),
(4,1,'AASASA','Toyota','Hilux',2025,'2025-02-01',150000.00,1.00,'ACTIVO'),
(5,3,'PPPP','Toyota','Hilux',2025,'2026-03-03',50000.00,1.20,'ACTIVO');

-- Impuesto vehicular (2 ejemplos)
INSERT INTO `impuesto` (`id_impuesto`,`id_contribuyente`,`tipo`,`anio_inicio`,`total`,`pagado`,`estado`) VALUES
(1,1,'VEHICULAR',2026,7200.00,0.00,'PENDIENTE'), -- 200,000 * 1.2% = 2,400 anual -> 3 años = 7,200
(2,3,'VEHICULAR',2026,1800.00,600.00,'PENDIENTE'); -- 50,000 * 1.2% = 600 anual -> 3 años = 1,800 (1 año pagado)

INSERT INTO `impuesto_vehicular` (`id_impuesto`,`id_vehiculo`,`valor_vehiculo`,`porcentaje`,`anio_inscripcion`) VALUES
(1,1,200000.00,1.20,2026),
(2,5,50000.00,1.20,2026);

INSERT INTO `impuesto_detalle` (`id_detalle`,`id_impuesto`,`anio`,`monto`,`pagado`,`estado`) VALUES
(1,1,2026,2400.00,0.00,'PENDIENTE'),
(2,1,2027,2400.00,0.00,'PENDIENTE'),
(3,1,2028,2400.00,0.00,'PENDIENTE'),
(4,2,2026,600.00,600.00,'PAGADO'),
(5,2,2027,600.00,0.00,'PENDIENTE'),
(6,2,2028,600.00,0.00,'PENDIENTE');

-- Impuesto predial (2 activos + 1 cerrado por "VENTA")
INSERT INTO `impuesto_predial` (`id_predial`,`id_inmueble`,`monto_anual`,`tasa_aplicada`,`estado`,`motivo_estado`,`detalle_motivo`,`fecha_inicio`,`fecha_cierre`) VALUES
(1,5,1800.00,1.5000,'ACTIVO',NULL,NULL,'2026-03-03',NULL),
(2,6,6.00,0.0120,'ACTIVO',NULL,NULL,'2026-03-03',NULL),
(3,2,3000.00,1.5000,'CERRADO','VENTA','Cierre automatico por registro de alcabala','2026-03-02','2026-03-02');

INSERT INTO `impuesto_predial_historial` (`id_historial`,`id_predial`,`estado_anterior`,`estado_nuevo`,`motivo`,`detalle_motivo`,`origen`) VALUES
(1,1,NULL,'ACTIVO','CREACION','Generacion inicial del impuesto predial','SISTEMA'),
(2,2,NULL,'ACTIVO','CREACION','Generacion inicial del impuesto predial','SISTEMA'),
(3,3,NULL,'ACTIVO','CREACION','Generacion inicial del impuesto predial','SISTEMA'),
(4,3,'ACTIVO','CERRADO','VENTA','Cierre automatico por registro de alcabala','AUTOMATICO');

-- Alcabala (venta de inmueble 2 de Euler a Nilver)
INSERT INTO `alcabala` (
  `id_alcabala`,`id_inmueble`,`valor_venta`,`fecha_venta`,`estado`,
  `valor_catastral_ref`,`base_calculo`,`monto_inafecto`,`base_imponible`,
  `tasa_aplicada`,`monto_alcabala`,`anio_uit`,`valor_uit`,
  `id_contribuyente_comprador`,`id_contribuyente_vendedor`
) VALUES
(1,2,220000.00,'2026-03-02','REGISTRADO',
 200000.00,220000.00,60000.00,160000.00,
 3.0000,4800.00,2026,6000.00,
 2,1);

-- Fraccionamiento: 1 predial anual + 1 vehicular trimestral
INSERT INTO `fraccionamiento_impuesto` (
  `id_fraccionamiento`,`tipo_impuesto`,`id_referencia`,`codigo_impuesto`,`contribuyente`,`descripcion`,
  `monto_anual`,`periodicidad`,`meses_por_cuota`,`total_cuotas`,`estado`,`fecha_registro`,`fecha_cierre`
) VALUES
(1,'PREDIAL',1,'PRED-1','Euler Flores','Predial 2026 - Calle 20',1800.00,'MENSUAL',1,12,'ACTIVO','2026-03-03 02:25:27',NULL),
(2,'VEHICULAR',1,'VEH-1','Euler Flores','Vehicular 2026 - BB-10',2400.00,'TRIMESTRAL',3,4,'ACTIVO','2026-03-03 01:36:28',NULL);

INSERT INTO `fraccionamiento_cuota` (
  `id_cuota`,`id_fraccionamiento`,`numero_cuota`,`periodo_label`,`fecha_vencimiento`,
  `monto_programado`,`estado`,`fecha_pago`,`monto_pagado`,`observacion_pago`
) VALUES
-- Predial mensual (12 cuotas de 150)
(1,1,1,'3/2026','2026-03-31',150.00,'PAGADO','2026-03-03',150.00,''),
(2,1,2,'4/2026','2026-04-30',150.00,'PAGADO','2026-03-03',150.00,''),
(3,1,3,'5/2026','2026-05-31',150.00,'PENDIENTE',NULL,NULL,NULL),
(4,1,4,'6/2026','2026-06-30',150.00,'PENDIENTE',NULL,NULL,NULL),
(5,1,5,'7/2026','2026-07-31',150.00,'PENDIENTE',NULL,NULL,NULL),
(6,1,6,'8/2026','2026-08-31',150.00,'PENDIENTE',NULL,NULL,NULL),
(7,1,7,'9/2026','2026-09-30',150.00,'PENDIENTE',NULL,NULL,NULL),
(8,1,8,'10/2026','2026-10-31',150.00,'PENDIENTE',NULL,NULL,NULL),
(9,1,9,'11/2026','2026-11-30',150.00,'PENDIENTE',NULL,NULL,NULL),
(10,1,10,'12/2026','2026-12-31',150.00,'PENDIENTE',NULL,NULL,NULL),
(11,1,11,'1/2027','2027-01-31',150.00,'PENDIENTE',NULL,NULL,NULL),
(12,1,12,'2/2027','2027-02-28',150.00,'PENDIENTE',NULL,NULL,NULL),

-- Vehicular trimestral (4 cuotas de 600)
(13,2,1,'3/2026 - 5/2026','2026-05-31',600.00,'PAGADO','2026-03-03',600.00,''),
(14,2,2,'6/2026 - 8/2026','2026-08-31',600.00,'PENDIENTE',NULL,NULL,NULL),
(15,2,3,'9/2026 - 11/2026','2026-11-30',600.00,'PENDIENTE',NULL,NULL,NULL),
(16,2,4,'12/2026 - 2/2027','2027-02-28',600.00,'PENDIENTE',NULL,NULL,NULL);

-- =========================================================
-- 6) PROCEDIMIENTOS (igual que tu dump)
-- =========================================================
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_uit` (IN `p_anio` INT, IN `p_valor` DECIMAL(10,2))
BEGIN
    UPDATE uit
    SET valor = p_valor
    WHERE anio = p_anio;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_vehicular_config` (IN `p_anio` INT, IN `p_porcentaje` DECIMAL(5,2))
BEGIN
    UPDATE vehicular_config
    SET porcentaje = p_porcentaje
    WHERE anio = p_anio;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_aplicar_reglas_automaticas_predial` (IN `p_edad_limite` INT)
BEGIN
    -- Regla 1: Inmueble inactivo -> suspender predial activo
    BEGIN
        DECLARE done_inmueble BOOLEAN DEFAULT FALSE;
        DECLARE v_id_predial_inmueble INT;

        DECLARE cur_inmueble CURSOR FOR
            SELECT p.id_predial
            FROM impuesto_predial p
            INNER JOIN inmueble i ON i.id_inmueble = p.id_inmueble
            WHERE p.estado = 'ACTIVO'
              AND i.estado = 'INACTIVO';

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_inmueble = TRUE;

        OPEN cur_inmueble;

        read_inmueble: LOOP
            FETCH cur_inmueble INTO v_id_predial_inmueble;
            IF done_inmueble THEN
                LEAVE read_inmueble;
            END IF;

            UPDATE impuesto_predial
               SET estado = 'SUSPENDIDO',
                   motivo_estado = 'INMUEBLE_INACTIVO',
                   detalle_motivo = 'Cambio automatico por inmueble en estado INACTIVO',
                   fecha_cierre = NULL
             WHERE id_predial = v_id_predial_inmueble
               AND estado = 'ACTIVO';

            IF ROW_COUNT() > 0 THEN
                INSERT INTO impuesto_predial_historial (
                    id_predial,
                    estado_anterior,
                    estado_nuevo,
                    motivo,
                    detalle_motivo,
                    origen,
                    fecha_cambio
                ) VALUES (
                    v_id_predial_inmueble,
                    'ACTIVO',
                    'SUSPENDIDO',
                    'INMUEBLE_INACTIVO',
                    'Cambio automatico por inmueble en estado INACTIVO',
                    'AUTOMATICO',
                    NOW()
                );
            END IF;
        END LOOP;

        CLOSE cur_inmueble;
    END;

    -- Regla 2: Edad limite >= p_edad_limite -> suspender predial activo
    BEGIN
        DECLARE done_edad BOOLEAN DEFAULT FALSE;
        DECLARE v_id_predial_edad INT;

        DECLARE cur_edad CURSOR FOR
            SELECT p.id_predial
            FROM impuesto_predial p
            INNER JOIN inmueble i ON i.id_inmueble = p.id_inmueble
            INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente
            INNER JOIN personas pe ON pe.id_persona = c.id_persona
            WHERE p.estado = 'ACTIVO'
              AND pe.fecha_nacimiento IS NOT NULL
              AND TIMESTAMPDIFF(YEAR, pe.fecha_nacimiento, CURDATE()) >= p_edad_limite;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_edad = TRUE;

        OPEN cur_edad;

        read_edad: LOOP
            FETCH cur_edad INTO v_id_predial_edad;
            IF done_edad THEN
                LEAVE read_edad;
            END IF;

            UPDATE impuesto_predial
               SET estado = 'SUSPENDIDO',
                   motivo_estado = 'EDAD_LIMITE',
                   detalle_motivo = CONCAT('Cambio automatico por edad >= ', p_edad_limite),
                   fecha_cierre = NULL
             WHERE id_predial = v_id_predial_edad
               AND estado = 'ACTIVO';

            IF ROW_COUNT() > 0 THEN
                INSERT INTO impuesto_predial_historial (
                    id_predial,
                    estado_anterior,
                    estado_nuevo,
                    motivo,
                    detalle_motivo,
                    origen,
                    fecha_cambio
                ) VALUES (
                    v_id_predial_edad,
                    'ACTIVO',
                    'SUSPENDIDO',
                    'EDAD_LIMITE',
                    CONCAT('Cambio automatico por edad >= ', p_edad_limite),
                    'AUTOMATICO',
                    NOW()
                );
            END IF;
        END LOOP;

        CLOSE cur_edad;
    END;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_calcular_alcabala` (IN `p_valor_venta` DECIMAL(12,2), IN `p_fecha_venta` DATE)
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cambiar_estado_contribuyente` (IN `p_id_contribuyente` INT, IN `p_estado` VARCHAR(10))
BEGIN
    UPDATE contribuyentes
    SET estado = p_estado
    WHERE id_contribuyente = p_id_contribuyente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cambiar_estado_impuesto_predial` (
    IN `p_id_predial` INT,
    IN `p_estado` VARCHAR(20),
    IN `p_motivo` VARCHAR(30),
    IN `p_detalle_motivo` VARCHAR(255)
)
BEGIN
    DECLARE v_estado_actual VARCHAR(20);

    SELECT estado INTO v_estado_actual
    FROM impuesto_predial
    WHERE id_predial = p_id_predial
    LIMIT 1;

    IF v_estado_actual IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No existe el impuesto predial solicitado.';
    END IF;

    IF (p_estado = 'SUSPENDIDO' OR p_estado = 'CERRADO')
       AND (p_motivo IS NULL OR TRIM(p_motivo) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Debe indicar motivo para SUSPENDIDO o CERRADO.';
    END IF;

    IF p_motivo = 'OTRO' AND (p_detalle_motivo IS NULL OR TRIM(p_detalle_motivo) = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Debe detallar el motivo cuando selecciona OTRO.';
    END IF;

    UPDATE impuesto_predial
       SET estado = p_estado,
           motivo_estado = p_motivo,
           detalle_motivo = p_detalle_motivo,
           fecha_cierre = CASE WHEN p_estado = 'CERRADO' THEN CURDATE() ELSE NULL END
     WHERE id_predial = p_id_predial;

    INSERT INTO impuesto_predial_historial (
        id_predial,
        estado_anterior,
        estado_nuevo,
        motivo,
        detalle_motivo,
        origen,
        fecha_cambio
    ) VALUES (
        p_id_predial,
        v_estado_actual,
        p_estado,
        p_motivo,
        p_detalle_motivo,
        'MANUAL',
        NOW()
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cambiar_estado_inmueble` (IN `p_id_inmueble` INT, IN `p_estado` VARCHAR(20))
BEGIN
    UPDATE inmueble
    SET estado = p_estado
    WHERE id_inmueble = p_id_inmueble;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cambiar_estado_vehicular_config` (IN `p_anio` INT, IN `p_estado` VARCHAR(10))
BEGIN
    UPDATE vehicular_config
    SET estado = p_estado
    WHERE anio = p_anio;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cambiar_estado_vehiculo` (IN `p_id_vehiculo` INT, IN `p_estado` VARCHAR(20))
BEGIN
    UPDATE vehiculo
    SET estado = p_estado
    WHERE id_vehiculo = p_id_vehiculo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cambiar_estado_zona` (IN `p_id_zona` INT, IN `p_estado` VARCHAR(20))
BEGIN
    UPDATE zona
    SET estado = p_estado
    WHERE id_zona = p_id_zona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_alcabala` (IN `p_id_inmueble` INT, IN `p_valor_venta` DECIMAL(12,2), IN `p_fecha_venta` DATE)
BEGIN
    INSERT INTO alcabala(
        id_inmueble,
        valor_venta,
        fecha_venta,
        estado
    )
    VALUES(
        p_id_inmueble,
        p_valor_venta,
        p_fecha_venta,
        'PENDIENTE'
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_contribuyente` (
    IN `p_tipo_documento` VARCHAR(20),
    IN `p_numero_documento` VARCHAR(20),
    IN `p_nombres` VARCHAR(100),
    IN `p_apellidos` VARCHAR(100),
    IN `p_telefono` VARCHAR(20),
    IN `p_email` VARCHAR(150),
    IN `p_direccion` VARCHAR(255),
    IN `p_fecha_nacimiento` DATE
)
BEGIN
    DECLARE v_id_persona INT;

    INSERT INTO personas (
        tipo_documento,
        numero_documento,
        nombres,
        apellidos,
        telefono,
        email,
        direccion,
        fecha_nacimiento,
        estado,
        fecha_registro
    ) VALUES (
        p_tipo_documento,
        p_numero_documento,
        p_nombres,
        p_apellidos,
        p_telefono,
        p_email,
        p_direccion,
        p_fecha_nacimiento,
        'ACTIVO',
        NOW()
    );

    SET v_id_persona = LAST_INSERT_ID();

    INSERT INTO contribuyentes (
        id_persona,
        fecha_registro_tributario,
        estado
    ) VALUES (
        v_id_persona,
        CURDATE(),
        'ACTIVO'
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_impuesto_alcabala` (
    IN `p_id_inmueble` INT,
    IN `p_id_contribuyente_comprador` INT,
    IN `p_valor_venta` DECIMAL(14,2),
    IN `p_fecha_venta` DATE
)
BEGIN
    DECLARE v_valor_catastral DECIMAL(14,2);
    DECLARE v_id_contribuyente_vendedor INT;
    DECLARE v_base_calculo DECIMAL(14,2);
    DECLARE v_valor_uit DECIMAL(14,2);
    DECLARE v_anio_uit INT;
    DECLARE v_monto_inafecto DECIMAL(14,2);
    DECLARE v_base_imponible DECIMAL(14,2);
    DECLARE v_monto_alcabala DECIMAL(14,2);
    DECLARE v_id_predial_activo INT;
    DECLARE v_comprador_count INT DEFAULT 0;

    SELECT i.valor_catastral, i.id_contribuyente
      INTO v_valor_catastral, v_id_contribuyente_vendedor
    FROM inmueble i
    WHERE i.id_inmueble = p_id_inmueble
    LIMIT 1;

    IF v_valor_catastral IS NULL OR v_id_contribuyente_vendedor IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No existe inmueble para calcular alcabala.';
    END IF;

    SELECT COUNT(*) INTO v_comprador_count
    FROM contribuyentes c
    WHERE c.id_contribuyente = p_id_contribuyente_comprador
      AND c.estado = 'ACTIVO';

    IF v_comprador_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El contribuyente comprador no existe o no esta activo.';
    END IF;

    IF v_id_contribuyente_vendedor = p_id_contribuyente_comprador THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El comprador no puede ser el mismo propietario actual.';
    END IF;

    SET v_base_calculo = GREATEST(p_valor_venta, v_valor_catastral);
    SET v_anio_uit = YEAR(p_fecha_venta);

    SELECT u.valor
      INTO v_valor_uit
    FROM uit u
    WHERE u.anio = v_anio_uit
    LIMIT 1;

    IF v_valor_uit IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No existe UIT para el anio de venta.';
    END IF;

    SET v_monto_inafecto = v_valor_uit * 10;
    SET v_base_imponible = GREATEST(v_base_calculo - v_monto_inafecto, 0);
    SET v_monto_alcabala = v_base_imponible * 0.03;

    INSERT INTO alcabala (
        id_inmueble,
        id_contribuyente_comprador,
        id_contribuyente_vendedor,
        valor_venta,
        fecha_venta,
        estado,
        valor_catastral_ref,
        base_calculo,
        monto_inafecto,
        base_imponible,
        tasa_aplicada,
        monto_alcabala,
        anio_uit,
        valor_uit,
        fecha_registro
    ) VALUES (
        p_id_inmueble,
        p_id_contribuyente_comprador,
        v_id_contribuyente_vendedor,
        p_valor_venta,
        p_fecha_venta,
        'REGISTRADO',
        v_valor_catastral,
        v_base_calculo,
        v_monto_inafecto,
        v_base_imponible,
        3.00,
        v_monto_alcabala,
        v_anio_uit,
        v_valor_uit,
        NOW()
    );

    SELECT id_predial INTO v_id_predial_activo
    FROM impuesto_predial
    WHERE id_inmueble = p_id_inmueble
      AND estado = 'ACTIVO'
    ORDER BY id_predial DESC
    LIMIT 1;

    IF v_id_predial_activo IS NOT NULL THEN
        UPDATE impuesto_predial
           SET estado = 'CERRADO',
               motivo_estado = 'VENTA',
               detalle_motivo = 'Cierre automatico por registro de alcabala',
               fecha_cierre = CURDATE()
         WHERE id_predial = v_id_predial_activo;

        INSERT INTO impuesto_predial_historial (
            id_predial,
            estado_anterior,
            estado_nuevo,
            motivo,
            detalle_motivo,
            origen,
            fecha_cambio
        ) VALUES (
            v_id_predial_activo,
            'ACTIVO',
            'CERRADO',
            'VENTA',
            'Cierre automatico por registro de alcabala',
            'AUTOMATICO',
            NOW()
        );
    END IF;

    UPDATE inmueble
       SET id_contribuyente = p_id_contribuyente_comprador
     WHERE id_inmueble = p_id_inmueble;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_impuesto_predial` (IN `p_id_inmueble` INT)
BEGIN
    DECLARE v_valor_catastral DECIMAL(14,2);
    DECLARE v_tasa_predial DECIMAL(8,4);
    DECLARE v_monto_anual DECIMAL(14,2);
    DECLARE v_count_activo INT DEFAULT 0;

    SELECT COUNT(*) INTO v_count_activo
    FROM impuesto_predial
    WHERE id_inmueble = p_id_inmueble
      AND estado = 'ACTIVO';

    IF v_count_activo > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El inmueble ya tiene un impuesto predial ACTIVO.';
    END IF;

    SELECT i.valor_catastral, z.tasa_predial
      INTO v_valor_catastral, v_tasa_predial
    FROM inmueble i
    INNER JOIN zona z ON z.id_zona = i.id_zona
    WHERE i.id_inmueble = p_id_inmueble
      AND i.estado = 'ACTIVO'
    LIMIT 1;

    IF v_valor_catastral IS NULL OR v_tasa_predial IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se encontro inmueble activo o zona con tasa predial.';
    END IF;

    SET v_monto_anual = v_valor_catastral * (v_tasa_predial / 100);

    INSERT INTO impuesto_predial (
        id_inmueble,
        monto_anual,
        tasa_aplicada,
        estado,
        motivo_estado,
        detalle_motivo,
        fecha_inicio,
        fecha_cierre,
        fecha_registro
    ) VALUES (
        p_id_inmueble,
        v_monto_anual,
        v_tasa_predial,
        'ACTIVO',
        NULL,
        NULL,
        CURDATE(),
        NULL,
        NOW()
    );

    INSERT INTO impuesto_predial_historial (
        id_predial,
        estado_anterior,
        estado_nuevo,
        motivo,
        detalle_motivo,
        origen,
        fecha_cambio
    ) VALUES (
        LAST_INSERT_ID(),
        NULL,
        'ACTIVO',
        'CREACION',
        'Generacion inicial del impuesto predial',
        'SISTEMA',
        NOW()
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_impuesto_vehicular` (IN `p_id_vehiculo` INT)
BEGIN
    DECLARE v_id_contribuyente INT;
    DECLARE v_valor DECIMAL(12,2);
    DECLARE v_porcentaje DECIMAL(5,2);
    DECLARE v_anio_ins INT;

    DECLARE v_impuesto_anual DECIMAL(12,2);
    DECLARE v_total DECIMAL(12,2);
    DECLARE v_id_impuesto INT;

    SELECT v.id_contribuyente, v.valor, vc.porcentaje, YEAR(v.fecha_inscripcion)
    INTO v_id_contribuyente, v_valor, v_porcentaje, v_anio_ins
    FROM vehiculo v
    INNER JOIN vehicular_config vc
       ON YEAR(v.fecha_inscripcion) = vc.anio
    WHERE v.id_vehiculo = p_id_vehiculo;

    SET v_impuesto_anual = v_valor * (v_porcentaje / 100);
    SET v_total = v_impuesto_anual * 3;

    INSERT INTO impuesto(id_contribuyente, tipo, anio_inicio, total)
    VALUES (v_id_contribuyente, 'VEHICULAR', v_anio_ins, v_total);

    SET v_id_impuesto = LAST_INSERT_ID();

    INSERT INTO impuesto_vehicular
        (id_impuesto, id_vehiculo, valor_vehiculo, porcentaje, anio_inscripcion)
    VALUES
        (v_id_impuesto, p_id_vehiculo, v_valor, v_porcentaje, v_anio_ins);

    INSERT INTO impuesto_detalle (id_impuesto, anio, monto)
    VALUES
        (v_id_impuesto, v_anio_ins, v_impuesto_anual),
        (v_id_impuesto, v_anio_ins + 1, v_impuesto_anual),
        (v_id_impuesto, v_anio_ins + 2, v_impuesto_anual);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_inmueble` (
    IN `p_id_contribuyente` INT,
    IN `p_id_zona` INT,
    IN `p_direccion` VARCHAR(200),
    IN `p_valor_catastral` DECIMAL(12,2)
)
BEGIN
    INSERT INTO inmueble(
        id_contribuyente,
        id_zona,
        direccion,
        valor_catastral,
        estado,
        fecha_registro
    )
    VALUES(
        p_id_contribuyente,
        p_id_zona,
        p_direccion,
        p_valor_catastral,
        'ACTIVO',
        CURRENT_TIMESTAMP
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_uit` (IN `p_anio` INT, IN `p_valor` DECIMAL(10,2))
BEGIN
    INSERT INTO uit(anio, valor)
    VALUES(p_anio, p_valor);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_vehicular_config` (IN `p_anio` INT, IN `p_porcentaje` DECIMAL(5,2))
BEGIN
    INSERT INTO vehicular_config(anio, porcentaje, estado)
    VALUES(p_anio, p_porcentaje, 'ACTIVO');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_vehiculo` (
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
        id_contribuyente,
        placa,
        marca,
        modelo,
        anio,
        fecha_inscripcion,
        valor,
        porcentaje,
        estado,
        fecha_registro
    )
    VALUES(
        p_id_contribuyente,
        p_placa,
        p_marca,
        p_modelo,
        p_anio,
        p_fecha_inscripcion,
        p_valor,
        p_porcentaje,
        'ACTIVO',
        CURRENT_TIMESTAMP
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_zona` (IN `p_codigo` VARCHAR(20), IN `p_nombre` VARCHAR(200), IN `p_tasa` DECIMAL(10,4))
BEGIN
    INSERT INTO zona(
        codigo,
        nombre,
        tasa_predial,
        estado,
        fecha_creacion
    )
    VALUES(
        p_codigo,
        p_nombre,
        p_tasa,
        'ACTIVO',
        NOW()
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_contribuyentes` ()
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
    INNER JOIN personas p
        ON c.id_persona = p.id_persona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_contribuyentes_combo` ()
BEGIN
    SELECT 
        c.id_contribuyente,
        CONCAT(p.nombres, ' ', p.apellidos) AS nombre
    FROM contribuyentes c
    INNER JOIN personas p 
        ON c.id_persona = p.id_persona
    WHERE c.estado = 'ACTIVO'
    ORDER BY nombre;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_detalle_impuesto` (IN `p_id_impuesto` INT)
BEGIN
    SELECT 
        id_detalle,
        anio,
        monto,
        estado
    FROM impuesto_detalle
    WHERE id_impuesto = p_id_impuesto
    ORDER BY anio ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_historial_predial` (IN `p_id_predial` INT)
BEGIN
    SELECT
        id_historial,
        estado_anterior,
        estado_nuevo,
        motivo,
        detalle_motivo,
        origen,
        fecha_cambio
    FROM impuesto_predial_historial
    WHERE id_predial = p_id_predial
    ORDER BY fecha_cambio DESC, id_historial DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_impuestos_alcabala` ()
BEGIN
    SELECT
        a.id_alcabala,
        CONCAT(pe_comp.nombres, ' ', pe_comp.apellidos) AS comprador,
        CONCAT(pe_vend.nombres, ' ', pe_vend.apellidos) AS propietario,
        i.direccion,
        a.valor_venta,
        a.base_calculo,
        a.base_imponible,
        a.monto_alcabala,
        a.estado,
        a.fecha_venta,
        a.fecha_registro
    FROM alcabala a
    INNER JOIN inmueble i ON i.id_inmueble = a.id_inmueble
    LEFT JOIN contribuyentes c_vend ON c_vend.id_contribuyente = a.id_contribuyente_vendedor
    LEFT JOIN personas pe_vend ON pe_vend.id_persona = c_vend.id_persona
    LEFT JOIN contribuyentes c_comp ON c_comp.id_contribuyente = a.id_contribuyente_comprador
    LEFT JOIN personas pe_comp ON pe_comp.id_persona = c_comp.id_persona
    ORDER BY a.id_alcabala DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_impuestos_prediales` ()
BEGIN
    SELECT
        p.id_predial,
        CONCAT(pe.nombres, ' ', pe.apellidos) AS contribuyente,
        i.direccion,
        z.nombre AS zona,
        i.valor_catastral,
        p.tasa_aplicada,
        p.monto_anual,
        p.estado,
        p.motivo_estado,
        p.fecha_registro
    FROM impuesto_predial p
    INNER JOIN inmueble i ON i.id_inmueble = p.id_inmueble
    INNER JOIN zona z ON z.id_zona = i.id_zona
    INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente
    INNER JOIN personas pe ON pe.id_persona = c.id_persona
    ORDER BY p.id_predial DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_impuestos_vehiculares` ()
BEGIN
    SELECT 
        i.id_impuesto,
        CONCAT(p.nombres, ' ', p.apellidos) AS contribuyente,
        v.placa,
        iv.anio_inscripcion,
        i.total,
        i.pagado,
        i.estado,
        i.fecha_registro
    FROM impuesto i
    INNER JOIN impuesto_vehicular iv ON i.id_impuesto = iv.id_impuesto
    INNER JOIN vehiculo v ON iv.id_vehiculo = v.id_vehiculo
    INNER JOIN contribuyentes c ON i.id_contribuyente = c.id_contribuyente
    INNER JOIN personas p ON c.id_persona = p.id_persona
    ORDER BY i.id_impuesto DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_inmuebles` ()
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
    INNER JOIN contribuyentes c 
        ON i.id_contribuyente = c.id_contribuyente
    INNER JOIN personas p 
        ON c.id_persona = p.id_persona
    INNER JOIN zona z
        ON i.id_zona = z.id_zona
    ORDER BY i.id_inmueble DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_inmuebles_disponibles_predial` ()
BEGIN
    SELECT
        i.id_inmueble,
        CONCAT(pe.nombres, ' ', pe.apellidos) AS contribuyente,
        i.direccion,
        z.nombre AS zona,
        i.valor_catastral,
        z.tasa_predial
    FROM inmueble i
    INNER JOIN zona z ON z.id_zona = i.id_zona
    INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente
    INNER JOIN personas pe ON pe.id_persona = c.id_persona
    WHERE i.estado = 'ACTIVO'
      AND NOT EXISTS (
        SELECT 1
        FROM impuesto_predial p
        WHERE p.id_inmueble = i.id_inmueble
          AND p.estado = 'ACTIVO'
      )
    ORDER BY i.id_inmueble DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_inmuebles_para_alcabala` ()
BEGIN
    SELECT
        i.id_inmueble,
        CONCAT(pe.nombres, ' ', pe.apellidos) AS contribuyente,
        i.direccion,
        i.valor_catastral,
        z.nombre AS zona,
        p.id_predial
    FROM inmueble i
    INNER JOIN zona z ON z.id_zona = i.id_zona
    INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente
    INNER JOIN personas pe ON pe.id_persona = c.id_persona
    INNER JOIN impuesto_predial p ON p.id_inmueble = i.id_inmueble
    WHERE i.estado = 'ACTIVO'
      AND p.estado = 'ACTIVO'
    ORDER BY i.id_inmueble DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_uit` ()
BEGIN
    SELECT 
        anio,
        valor
    FROM uit
    ORDER BY anio DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_vehicular_config` ()
BEGIN
    SELECT anio, porcentaje, estado
    FROM vehicular_config
    ORDER BY anio DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_vehiculos` ()
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
    INNER JOIN contribuyentes c 
        ON v.id_contribuyente = c.id_contribuyente
    INNER JOIN personas p 
        ON c.id_persona = p.id_persona
    ORDER BY v.id_vehiculo DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_zonas` ()
BEGIN
    SELECT 
        id_zona,
        codigo,
        nombre,
        tasa_predial,
        estado,
        fecha_creacion
    FROM zona
    ORDER BY id_zona DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_zonas_combo` ()
BEGIN
    SELECT id_zona, nombre, tasa_predial
    FROM zona
    WHERE estado = 'ACTIVO'
    ORDER BY nombre;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login` (IN `p_username` VARCHAR(150))
BEGIN
    SELECT *
    FROM usuarios
    WHERE username = p_username
      AND estado = 'ACTIVO';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_impuesto_alcabala` (IN `p_id_alcabala` INT)
BEGIN
    SELECT
        a.id_alcabala,
        CONCAT(pe_comp.nombres, ' ', pe_comp.apellidos) AS comprador,
        CONCAT(pe_vend.nombres, ' ', pe_vend.apellidos) AS propietario,
        i.direccion,
        a.valor_catastral_ref,
        a.valor_venta,
        a.base_calculo,
        a.monto_inafecto,
        a.base_imponible,
        a.tasa_aplicada,
        a.monto_alcabala,
        a.anio_uit,
        a.valor_uit,
        a.estado,
        a.fecha_venta,
        a.fecha_registro
    FROM alcabala a
    INNER JOIN inmueble i ON i.id_inmueble = a.id_inmueble
    LEFT JOIN contribuyentes c_vend ON c_vend.id_contribuyente = a.id_contribuyente_vendedor
    LEFT JOIN personas pe_vend ON pe_vend.id_persona = c_vend.id_persona
    LEFT JOIN contribuyentes c_comp ON c_comp.id_contribuyente = a.id_contribuyente_comprador
    LEFT JOIN personas pe_comp ON pe_comp.id_persona = c_comp.id_persona
    WHERE a.id_alcabala = p_id_alcabala;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_impuesto_predial` (IN `p_id_predial` INT)
BEGIN
    SELECT
        p.id_predial,
        CONCAT(pe.nombres, ' ', pe.apellidos) AS contribuyente,
        i.direccion,
        z.nombre AS zona,
        i.valor_catastral,
        p.tasa_aplicada,
        p.monto_anual,
        p.estado,
        p.motivo_estado,
        p.detalle_motivo,
        p.fecha_inicio,
        p.fecha_cierre,
        p.fecha_registro
    FROM impuesto_predial p
    INNER JOIN inmueble i ON i.id_inmueble = p.id_inmueble
    INNER JOIN zona z ON z.id_zona = i.id_zona
    INNER JOIN contribuyentes c ON c.id_contribuyente = i.id_contribuyente
    INNER JOIN personas pe ON pe.id_persona = c.id_persona
    WHERE p.id_predial = p_id_predial;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_impuesto_vehicular` (IN `p_id_impuesto` INT)
BEGIN
    SELECT 
        i.id_impuesto,
        CONCAT(p.nombres, ' ', p.apellidos) AS contribuyente,
        CONCAT(v.marca, ' ', v.modelo, ' (', v.placa, ')') AS vehiculo,
        iv.anio_inscripcion,
        iv.valor_vehiculo,
        iv.porcentaje,
        (iv.valor_vehiculo * (iv.porcentaje/100)) AS impuesto_anual,
        i.total,
        i.estado,
        i.fecha_registro
    FROM impuesto i
    INNER JOIN impuesto_vehicular iv ON i.id_impuesto = iv.id_impuesto
    INNER JOIN vehiculo v ON iv.id_vehiculo = v.id_vehiculo
    INNER JOIN contribuyentes c ON i.id_contribuyente = c.id_contribuyente
    INNER JOIN personas p ON c.id_persona = p.id_persona
    WHERE i.id_impuesto = p_id_impuesto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_porcentaje_vehicular` (IN `p_anio` INT)
BEGIN
    SELECT porcentaje
    FROM vehicular_config
    WHERE anio = p_anio
      AND estado = 'ACTIVO'
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_porcentaje_vehicular_vigente` ()
BEGIN
    SELECT porcentaje
    FROM vehicular_config
    WHERE estado = 'ACTIVO'
    ORDER BY anio DESC
    LIMIT 1;
END$$

DELIMITER ;

COMMIT;
