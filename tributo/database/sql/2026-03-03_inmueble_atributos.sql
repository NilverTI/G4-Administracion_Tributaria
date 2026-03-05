-- ============================================================
-- Migracion: atributos de inmueble (terreno vs construido)
-- Fecha: 2026-03-03
-- Motor: MySQL 8+
-- ============================================================

USE tributaria;

SET @schema_name := DATABASE();

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = @schema_name
              AND table_name = 'inmueble'
              AND column_name = 'tipo_uso'
        ),
        'SELECT ''inmueble.tipo_uso ya existe''',
        'ALTER TABLE inmueble ADD COLUMN tipo_uso VARCHAR(20) NOT NULL DEFAULT ''TERRENO'''
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = @schema_name
              AND table_name = 'inmueble'
              AND column_name = 'area_terreno_m2'
        ),
        'SELECT ''inmueble.area_terreno_m2 ya existe''',
        'ALTER TABLE inmueble ADD COLUMN area_terreno_m2 DECIMAL(12,2) NULL'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = @schema_name
              AND table_name = 'inmueble'
              AND column_name = 'area_construida_m2'
        ),
        'SELECT ''inmueble.area_construida_m2 ya existe''',
        'ALTER TABLE inmueble ADD COLUMN area_construida_m2 DECIMAL(12,2) NULL'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = @schema_name
              AND table_name = 'inmueble'
              AND column_name = 'tipo_material'
        ),
        'SELECT ''inmueble.tipo_material ya existe''',
        'ALTER TABLE inmueble ADD COLUMN tipo_material VARCHAR(20) NULL'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @old_sql_safe_updates := @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;

UPDATE inmueble
SET tipo_uso = 'TERRENO'
WHERE tipo_uso IS NULL OR TRIM(tipo_uso) = '';

SET SQL_SAFE_UPDATES = @old_sql_safe_updates;
