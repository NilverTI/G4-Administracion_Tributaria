INSERT INTO personas (
    tipo_documento,
    numero_documento,
    nombres,
    apellidos,
    telefono,
    email,
    direccion
) VALUES (
    'DNI',
    '00000001',
    'Admin',
    'Sistema',
    '999999999',
    'admin@tributaria.com',
    'Oficina Central'
);

INSERT INTO usuarios (
    id_persona,
    id_rol,
    username,
    password_hash,
    estado,
    primer_ingreso
) VALUES (
    1,
    1,
    'admin',
    '$2a$10$NxwV3yfFF8Cc3e3jbbD5tOs8HPcz8aC4zX8Eyk98KqCosqKVdoIJ.',
    'ACTIVO',
    false
);
