-- ============================================================
-- Migracion: cuotas y pagos para funcionario
-- Fecha: 2026-03-03
-- Motor: MySQL 8+
-- ============================================================

USE tributaria;

SET @schema_name := DATABASE();

CREATE TABLE IF NOT EXISTS fraccionamiento_impuesto (
    id_fraccionamiento INT AUTO_INCREMENT PRIMARY KEY,
    tipo_impuesto VARCHAR(20) NOT NULL,
    id_referencia INT NOT NULL,
    codigo_impuesto VARCHAR(30) NOT NULL,
    contribuyente VARCHAR(180) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    monto_anual DECIMAL(14,2) NOT NULL,
    periodicidad VARCHAR(20) NOT NULL,
    meses_por_cuota INT NOT NULL,
    total_cuotas INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre DATE NULL
);

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.statistics
            WHERE table_schema = @schema_name
              AND table_name = 'fraccionamiento_impuesto'
              AND index_name = 'idx_fracc_tipo_ref_estado'
        ),
        'SELECT ''idx_fracc_tipo_ref_estado ya existe''',
        'CREATE INDEX idx_fracc_tipo_ref_estado ON fraccionamiento_impuesto(tipo_impuesto, id_referencia, estado)'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS fraccionamiento_cuota (
    id_cuota INT AUTO_INCREMENT PRIMARY KEY,
    id_fraccionamiento INT NOT NULL,
    numero_cuota INT NOT NULL,
    periodo_label VARCHAR(40) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    monto_programado DECIMAL(14,2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    fecha_pago DATE NULL,
    monto_pagado DECIMAL(14,2) NULL,
    observacion_pago VARCHAR(255) NULL,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fraccionamiento_cuota
        FOREIGN KEY (id_fraccionamiento)
        REFERENCES fraccionamiento_impuesto(id_fraccionamiento)
        ON DELETE CASCADE
);

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.statistics
            WHERE table_schema = @schema_name
              AND table_name = 'fraccionamiento_cuota'
              AND index_name = 'uq_fracc_cuota_numero'
        ),
        'SELECT ''uq_fracc_cuota_numero ya existe''',
        'CREATE UNIQUE INDEX uq_fracc_cuota_numero ON fraccionamiento_cuota(id_fraccionamiento, numero_cuota)'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.statistics
            WHERE table_schema = @schema_name
              AND table_name = 'fraccionamiento_cuota'
              AND index_name = 'idx_fracc_cuota_estado_fecha'
        ),
        'SELECT ''idx_fracc_cuota_estado_fecha ya existe''',
        'CREATE INDEX idx_fracc_cuota_estado_fecha ON fraccionamiento_cuota(estado, fecha_vencimiento)'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
