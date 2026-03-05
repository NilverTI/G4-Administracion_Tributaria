-- ============================================================
-- Migracion: Predial + Alcabala + fecha_nacimiento contribuyente
-- Fecha: 2026-03-02
-- Motor: MySQL 8+
-- ============================================================

USE tributaria;

-- -----------------------------
-- 1) Ajustes de esquema
-- -----------------------------
SET @schema_name := DATABASE();

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = @schema_name
              AND table_name = 'personas'
              AND column_name = 'fecha_nacimiento'
        ),
        'SELECT ''personas.fecha_nacimiento ya existe''',
        'ALTER TABLE personas ADD COLUMN fecha_nacimiento DATE NULL'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS impuesto_predial (
    id_predial INT AUTO_INCREMENT PRIMARY KEY,
    id_inmueble INT NOT NULL,
    monto_anual DECIMAL(14,2) NOT NULL,
    tasa_aplicada DECIMAL(8,4) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    motivo_estado VARCHAR(30) NULL,
    detalle_motivo VARCHAR(255) NULL,
    fecha_inicio DATE NOT NULL,
    fecha_cierre DATE NULL,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_impuesto_predial_inmueble FOREIGN KEY (id_inmueble)
        REFERENCES inmueble(id_inmueble)
);

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.statistics
            WHERE table_schema = @schema_name
              AND table_name = 'impuesto_predial'
              AND index_name = 'idx_predial_inmueble_estado'
        ),
        'SELECT ''idx_predial_inmueble_estado ya existe''',
        'CREATE INDEX idx_predial_inmueble_estado ON impuesto_predial(id_inmueble, estado)'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS impuesto_predial_historial (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_predial INT NOT NULL,
    estado_anterior VARCHAR(20) NULL,
    estado_nuevo VARCHAR(20) NOT NULL,
    motivo VARCHAR(30) NULL,
    detalle_motivo VARCHAR(255) NULL,
    origen VARCHAR(20) NOT NULL,
    fecha_cambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historial_predial FOREIGN KEY (id_predial)
        REFERENCES impuesto_predial(id_predial)
);

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = @schema_name
              AND table_name = 'alcabala'
              AND column_name = 'valor_catastral_ref'
        ),
        'SELECT ''alcabala.valor_catastral_ref ya existe''',
        'ALTER TABLE alcabala ADD COLUMN valor_catastral_ref DECIMAL(14,2) NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'base_calculo'
        ),
        'SELECT ''alcabala.base_calculo ya existe''',
        'ALTER TABLE alcabala ADD COLUMN base_calculo DECIMAL(14,2) NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'monto_inafecto'
        ),
        'SELECT ''alcabala.monto_inafecto ya existe''',
        'ALTER TABLE alcabala ADD COLUMN monto_inafecto DECIMAL(14,2) NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'base_imponible'
        ),
        'SELECT ''alcabala.base_imponible ya existe''',
        'ALTER TABLE alcabala ADD COLUMN base_imponible DECIMAL(14,2) NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'tasa_aplicada'
        ),
        'SELECT ''alcabala.tasa_aplicada ya existe''',
        'ALTER TABLE alcabala ADD COLUMN tasa_aplicada DECIMAL(8,4) NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'monto_alcabala'
        ),
        'SELECT ''alcabala.monto_alcabala ya existe''',
        'ALTER TABLE alcabala ADD COLUMN monto_alcabala DECIMAL(14,2) NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'anio_uit'
        ),
        'SELECT ''alcabala.anio_uit ya existe''',
        'ALTER TABLE alcabala ADD COLUMN anio_uit INT NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'valor_uit'
        ),
        'SELECT ''alcabala.valor_uit ya existe''',
        'ALTER TABLE alcabala ADD COLUMN valor_uit DECIMAL(14,2) NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'fecha_registro'
        ),
        'SELECT ''alcabala.fecha_registro ya existe''',
        'ALTER TABLE alcabala ADD COLUMN fecha_registro DATETIME NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'id_contribuyente_comprador'
        ),
        'SELECT ''alcabala.id_contribuyente_comprador ya existe''',
        'ALTER TABLE alcabala ADD COLUMN id_contribuyente_comprador INT NULL'
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
              AND table_name = 'alcabala'
              AND column_name = 'id_contribuyente_vendedor'
        ),
        'SELECT ''alcabala.id_contribuyente_vendedor ya existe''',
        'ALTER TABLE alcabala ADD COLUMN id_contribuyente_vendedor INT NULL'
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
              AND table_name = 'alcabala'
              AND index_name = 'idx_alcabala_comprador'
        ),
        'SELECT ''idx_alcabala_comprador ya existe''',
        'CREATE INDEX idx_alcabala_comprador ON alcabala(id_contribuyente_comprador)'
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
              AND table_name = 'alcabala'
              AND index_name = 'idx_alcabala_vendedor'
        ),
        'SELECT ''idx_alcabala_vendedor ya existe''',
        'CREATE INDEX idx_alcabala_vendedor ON alcabala(id_contribuyente_vendedor)'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.table_constraints
            WHERE table_schema = @schema_name
              AND table_name = 'alcabala'
              AND constraint_name = 'fk_alcabala_contribuyente_comprador'
              AND constraint_type = 'FOREIGN KEY'
        ),
        'SELECT ''fk_alcabala_contribuyente_comprador ya existe''',
        'ALTER TABLE alcabala ADD CONSTRAINT fk_alcabala_contribuyente_comprador FOREIGN KEY (id_contribuyente_comprador) REFERENCES contribuyentes(id_contribuyente)'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.table_constraints
            WHERE table_schema = @schema_name
              AND table_name = 'alcabala'
              AND constraint_name = 'fk_alcabala_contribuyente_vendedor'
              AND constraint_type = 'FOREIGN KEY'
        ),
        'SELECT ''fk_alcabala_contribuyente_vendedor ya existe''',
        'ALTER TABLE alcabala ADD CONSTRAINT fk_alcabala_contribuyente_vendedor FOREIGN KEY (id_contribuyente_vendedor) REFERENCES contribuyentes(id_contribuyente)'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- -----------------------------
-- 2) SPs Predial
-- -----------------------------
DROP PROCEDURE IF EXISTS sp_listar_impuestos_prediales;
DROP PROCEDURE IF EXISTS sp_listar_inmuebles_disponibles_predial;
DROP PROCEDURE IF EXISTS sp_crear_impuesto_predial;
DROP PROCEDURE IF EXISTS sp_obtener_impuesto_predial;
DROP PROCEDURE IF EXISTS sp_cambiar_estado_impuesto_predial;
DROP PROCEDURE IF EXISTS sp_listar_historial_predial;
DROP PROCEDURE IF EXISTS sp_aplicar_reglas_automaticas_predial;

DELIMITER $$

CREATE PROCEDURE sp_listar_impuestos_prediales()
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
END $$

CREATE PROCEDURE sp_listar_inmuebles_disponibles_predial()
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
END $$

CREATE PROCEDURE sp_crear_impuesto_predial(
    IN p_id_inmueble INT
)
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
END $$

CREATE PROCEDURE sp_obtener_impuesto_predial(
    IN p_id_predial INT
)
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
END $$

CREATE PROCEDURE sp_cambiar_estado_impuesto_predial(
    IN p_id_predial INT,
    IN p_estado VARCHAR(20),
    IN p_motivo VARCHAR(30),
    IN p_detalle_motivo VARCHAR(255)
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
END $$

CREATE PROCEDURE sp_listar_historial_predial(
    IN p_id_predial INT
)
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
END $$

CREATE PROCEDURE sp_aplicar_reglas_automaticas_predial(
    IN p_edad_limite INT
)
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
END $$


-- -----------------------------
-- 3) SPs Alcabala
-- -----------------------------
DROP PROCEDURE IF EXISTS sp_listar_impuestos_alcabala;
DROP PROCEDURE IF EXISTS sp_listar_inmuebles_para_alcabala;
DROP PROCEDURE IF EXISTS sp_crear_impuesto_alcabala;
DROP PROCEDURE IF EXISTS sp_obtener_impuesto_alcabala;

CREATE PROCEDURE sp_listar_impuestos_alcabala()
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
END $$

CREATE PROCEDURE sp_listar_inmuebles_para_alcabala()
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
END $$

CREATE PROCEDURE sp_crear_impuesto_alcabala(
    IN p_id_inmueble INT,
    IN p_id_contribuyente_comprador INT,
    IN p_valor_venta DECIMAL(14,2),
    IN p_fecha_venta DATE
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

    -- Transferencia del inmueble al comprador
    UPDATE inmueble
       SET id_contribuyente = p_id_contribuyente_comprador
     WHERE id_inmueble = p_id_inmueble;
END $$

CREATE PROCEDURE sp_obtener_impuesto_alcabala(
    IN p_id_alcabala INT
)
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
END $$


-- -----------------------------
-- 4) Ajuste SP contribuyente
-- -----------------------------
DROP PROCEDURE IF EXISTS sp_crear_contribuyente;

CREATE PROCEDURE sp_crear_contribuyente(
    IN p_tipo_documento VARCHAR(20),
    IN p_numero_documento VARCHAR(20),
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(150),
    IN p_direccion VARCHAR(255),
    IN p_fecha_nacimiento DATE
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
END $$

DELIMITER ;
