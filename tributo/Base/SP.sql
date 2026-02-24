USE Tributaria;

DELIMITER $$

CREATE PROCEDURE sp_login(IN p_username VARCHAR(150))
BEGIN
    SELECT *
    FROM usuarios
    WHERE username = p_username
      AND estado = 'ACTIVO';
END $$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_crear_contribuyente(
    IN p_tipo_documento VARCHAR(20),
    IN p_numero_documento VARCHAR(20),
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(150),
    IN p_direccion VARCHAR(255)
)
BEGIN

    DECLARE v_id_persona INT;

    INSERT INTO personas(
        tipo_documento,
        numero_documento,
        nombres,
        apellidos,
        telefono,
        email,
        direccion,
        estado
    )
    VALUES (
        p_tipo_documento,
        p_numero_documento,
        p_nombres,
        p_apellidos,
        p_telefono,
        p_email,
        p_direccion,
        'ACTIVO'
    );

    SET v_id_persona = LAST_INSERT_ID();

    INSERT INTO contribuyentes(
        id_persona,
        fecha_registro_tributario,
        estado
    )
    VALUES (
        v_id_persona,
        CURDATE(),
        'ACTIVO'
    );

END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE sp_listar_contribuyentes()
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

END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_cambiar_estado_contribuyente(
    IN p_id_contribuyente INT,
    IN p_estado VARCHAR(10)
)
BEGIN

    UPDATE contribuyentes
    SET estado = p_estado
    WHERE id_contribuyente = p_id_contribuyente;

END //

DELIMITER ;




DELIMITER $$

CREATE PROCEDURE sp_listar_zonas()
BEGIN
    SELECT id_zona, codigo, nombre, tasa_predial, estado
    FROM zona
    ORDER BY id_zona DESC;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_listar_zonas_combo()
BEGIN
    SELECT id_zona, nombre, tasa_predial
    FROM zona
    WHERE estado = 'ACTIVO'
    ORDER BY nombre;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_listar_uit()
BEGIN
    SELECT anio, valor
    FROM uit
    ORDER BY anio DESC;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_listar_inmuebles()
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
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_crear_inmueble(
    IN p_id_contribuyente INT,
    IN p_id_zona INT,
    IN p_direccion VARCHAR(200),
    IN p_valor_catastral DECIMAL(12,2)
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
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_inmueble(
    IN p_id_inmueble INT,
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE inmueble
    SET estado = p_estado
    WHERE id_inmueble = p_id_inmueble;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_listar_vehiculos()
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
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_crear_vehiculo(
    IN p_id_contribuyente INT,
    IN p_placa VARCHAR(20),
    IN p_marca VARCHAR(100),
    IN p_modelo VARCHAR(100),
    IN p_anio INT,
    IN p_fecha_inscripcion DATE,
    IN p_valor DECIMAL(12,2),
    IN p_porcentaje DECIMAL(5,2)
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
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_vehiculo(
    IN p_id_vehiculo INT,
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE vehiculo
    SET estado = p_estado
    WHERE id_vehiculo = p_id_vehiculo;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_calcular_alcabala(
    IN p_valor_venta DECIMAL(12,2),
    IN p_fecha_venta DATE
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
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_crear_alcabala(
    IN p_id_inmueble INT,
    IN p_valor_venta DECIMAL(12,2),
    IN p_fecha_venta DATE
)
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
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_listar_contribuyentes_combo()
BEGIN
    SELECT 
        c.id_contribuyente,
        CONCAT(p.nombres, ' ', p.apellidos) AS nombre
    FROM contribuyentes c
    INNER JOIN personas p 
        ON c.id_persona = p.id_persona
    WHERE c.estado = 'ACTIVO'
    ORDER BY nombre;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_crear_fraccionamiento(
  IN p_id_contribuyente INT,
  IN p_tipo VARCHAR(20),
  IN p_anio INT,
  IN p_monto_total DECIMAL(12,2),
  IN p_numero_cuotas INT
)
BEGIN
  DECLARE v_id_impuesto INT;
  DECLARE v_i INT DEFAULT 1;
  DECLARE v_monto_cuota DECIMAL(12,2);
  DECLARE v_venc DATE;

  INSERT INTO impuesto(id_contribuyente, tipo, anio, monto_total, estado)
  VALUES(p_id_contribuyente, UPPER(TRIM(p_tipo)), p_anio, p_monto_total, 'FRACCIONADO');

  SET v_id_impuesto = LAST_INSERT_ID();

  UPDATE impuesto
  SET codigo = CONCAT('IMP', LPAD(v_id_impuesto, 4, '0'))
  WHERE id_impuesto = v_id_impuesto;

  SET v_monto_cuota = ROUND(p_monto_total / p_numero_cuotas, 2);
  SET v_venc = LAST_DAY(CURDATE());

  WHILE v_i <= p_numero_cuotas DO
    INSERT INTO cuota(id_impuesto, numero, total_cuotas, monto, vencimiento, estado)
    VALUES(v_id_impuesto, v_i, p_numero_cuotas, v_monto_cuota, v_venc, 'PENDIENTE');

    SET v_i = v_i + 1;
    SET v_venc = LAST_DAY(DATE_ADD(v_venc, INTERVAL 1 MONTH));
  END WHILE;

  UPDATE impuesto
  SET fecha_vencimiento = v_venc
  WHERE id_impuesto = v_id_impuesto;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_listar_cuotas()
BEGIN
  SELECT
    CONCAT('CU', LPAD(c.id_cuota, 4, '0')),
    CONCAT('IMP', LPAD(i.id_impuesto, 4, '0')),
    CONCAT(p.nombres, ' ', p.apellidos),
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
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_generar_impuesto(
  IN p_id_contribuyente INT,
  IN p_tipo VARCHAR(20),
  IN p_anio INT
)
BEGIN
  DECLARE v_total DECIMAL(10,2);
  DECLARE v_id INT;
  DECLARE v_codigo VARCHAR(20);

  -- 🔹 define monto (ajusta si tienes cálculo real)
  IF UPPER(p_tipo) = 'PREDIAL' THEN
    SET v_total = 2500.00;
  ELSEIF UPPER(p_tipo) = 'VEHICULAR' THEN
    SET v_total = 1800.00;
  ELSE
    SET v_total = 1200.00;
  END IF;

  -- 1️⃣ Insertar sin código (pero no puede ser NULL)
  INSERT INTO impuesto(
      codigo,
      id_contribuyente,
      tipo,
      anio,
      monto_total,
      monto_pagado,
      estado
  )
  VALUES(
      '',   -- valor temporal (evita NULL)
      p_id_contribuyente,
      UPPER(p_tipo),
      p_anio,
      v_total,
      0.00,
      'PENDIENTE'
  );

  SET v_id = LAST_INSERT_ID();

  -- 2️⃣ Generar código real
  SET v_codigo = CONCAT('IMP', LPAD(v_id,4,'0'));

  UPDATE impuesto
  SET codigo = v_codigo
  WHERE id_impuesto = v_id;

  -- 3️⃣ Crear una sola cuota
  INSERT INTO cuota(
      id_impuesto,
      numero,
      total_cuotas,
      monto,
      vencimiento,
      estado,
      fecha_pago,
      codigo
  )
  VALUES(
      v_id,
      1,
      1,
      v_total,
      LAST_DAY(CURDATE()),
      'PENDIENTE',
      NULL,
      CONCAT('CU', LPAD(v_id,4,'0'))
  );

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_listar_impuestos;
DELIMITER $$

CREATE PROCEDURE sp_listar_impuestos()
BEGIN
  SELECT
    i.id_impuesto AS id,
    CONCAT(p.nombres,' ',p.apellidos) AS contribuyente,
    i.tipo AS tipo,
    i.anio AS anio,
    IFNULL(i.monto_total,0) AS total,

    -- pagado: suma de cuotas PAGADA
    IFNULL((
      SELECT SUM(IFNULL(c2.monto,0))
      FROM cuota c2
      WHERE c2.id_impuesto = i.id_impuesto
        AND UPPER(c2.estado) = 'PAGADA'
    ),0) AS pagado,

    -- estado calculado
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

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_generar_impuesto;
DELIMITER $$

CREATE PROCEDURE sp_generar_impuesto(
  IN p_id_contribuyente INT,
  IN p_tipo VARCHAR(20),
  IN p_anio INT
)
BEGIN
  DECLARE v_id_impuesto INT;
  DECLARE v_codigo VARCHAR(20);

  -- (1) Inserta impuesto (codigo temporal para no romper NOT NULL)
  INSERT INTO impuesto (codigo, id_contribuyente, tipo, anio, monto_total, estado)
  VALUES ('TMP', p_id_contribuyente, UPPER(p_tipo), p_anio, 2500.00, 'PENDIENTE');

  SET v_id_impuesto = LAST_INSERT_ID();

  -- (2) Genera codigo real IMP0001...
  SET v_codigo = CONCAT('IMP', LPAD(v_id_impuesto, 4, '0'));

  UPDATE impuesto
  SET codigo = v_codigo
  WHERE id_impuesto = v_id_impuesto;

  -- (3) NO crear cuotas aquí (eso será en módulo Cuotas)
END$$

DELIMITER ;



DROP PROCEDURE IF EXISTS sp_fraccionar_impuesto;
DELIMITER $$

CREATE PROCEDURE sp_fraccionar_impuesto(
  IN p_id_impuesto INT,
  IN p_numero_cuotas INT,
  IN p_fecha_primera DATE
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

  -- borrar cuotas existentes
  DELETE FROM cuota WHERE id_impuesto = p_id_impuesto;

  SET v_base = ROUND(v_total / p_numero_cuotas, 2);
  SET v_venc = LAST_DAY(p_fecha_primera);

  WHILE v_i <= p_numero_cuotas DO

    IF v_i < p_numero_cuotas THEN
      INSERT INTO cuota(id_impuesto, numero, total_cuotas, monto, vencimiento, estado)
      VALUES(p_id_impuesto, v_i, p_numero_cuotas, v_base, v_venc, 'PENDIENTE');

      SET v_id_cuota = LAST_INSERT_ID();

      UPDATE cuota
      SET codigo = CONCAT('CU', LPAD(v_id_cuota, 4, '0'))
      WHERE id_cuota = v_id_cuota;

      SET v_suma = v_suma + v_base;

    ELSE
      INSERT INTO cuota(id_impuesto, numero, total_cuotas, monto, vencimiento, estado)
      VALUES(p_id_impuesto, v_i, p_numero_cuotas, ROUND(v_total - v_suma, 2), v_venc, 'PENDIENTE');

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
DELIMITER ;