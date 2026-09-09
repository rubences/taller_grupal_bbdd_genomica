-- Consultas de verificación y apoyo a las capturas de pantalla.
USE `genomica_taller`;

-- V01: recuento por tabla.
SELECT 'gen' AS tabla, COUNT(*) AS filas FROM `gen`
UNION ALL SELECT 'secuencia', COUNT(*) FROM `secuencia`
UNION ALL SELECT 'variante', COUNT(*) FROM `variante`
UNION ALL SELECT 'anotacion', COUNT(*) FROM `anotacion`
UNION ALL SELECT 'estudio', COUNT(*) FROM `estudio`
UNION ALL SELECT 'gen_anotacion', COUNT(*) FROM `gen_anotacion`
UNION ALL SELECT 'variante_anotacion', COUNT(*) FROM `variante_anotacion`
UNION ALL SELECT 'estudio_gen', COUNT(*) FROM `estudio_gen`
UNION ALL SELECT 'estudio_variante', COUNT(*) FROM `estudio_variante`;

-- V02: genes con sus secuencias y variantes.
SELECT g.`nombre` AS gen,
       s.`secuencia_id`, s.`tipo` AS tipo_secuencia,
       s.`posicion_relativa` AS pos_secuencia, s.`longitud`,
       v.`variante_id`, v.`posicion_relativa` AS pos_variante,
       v.`alelo_referencia`, v.`alelo_alternativo`, v.`tipo` AS tipo_variante
FROM `gen` g
JOIN `secuencia` s ON s.`gen_id` = g.`gen_id`
LEFT JOIN `variante` v ON v.`secuencia_id` = s.`secuencia_id`
ORDER BY g.`gen_id`, s.`secuencia_id`, v.`variante_id`;

-- V03: anotaciones asociadas a genes.
SELECT g.`nombre`, a.`tipo`, a.`descripcion`
FROM `gen` g
JOIN `gen_anotacion` ga ON ga.`gen_id` = g.`gen_id`
JOIN `anotacion` a ON a.`anotacion_id` = ga.`anotacion_id`
ORDER BY g.`nombre`, a.`tipo`;

-- V04: estudios y genes estudiados.
SELECT e.`referencia`, e.`titulo`, g.`nombre`
FROM `estudio` e
JOIN `estudio_gen` eg ON eg.`estudio_id` = e.`estudio_id`
JOIN `gen` g ON g.`gen_id` = eg.`gen_id`
ORDER BY e.`referencia`, g.`nombre`;

-- V05: estudios y variantes estudiadas.
SELECT e.`referencia`, v.`variante_id`, g.`nombre` AS gen,
       v.`tipo`, v.`posicion_relativa`
FROM `estudio` e
JOIN `estudio_variante` ev ON ev.`estudio_id` = e.`estudio_id`
JOIN `variante` v ON v.`variante_id` = ev.`variante_id`
JOIN `secuencia` s ON s.`secuencia_id` = v.`secuencia_id`
JOIN `gen` g ON g.`gen_id` = s.`gen_id`
ORDER BY e.`referencia`, v.`variante_id`;

-- V06: configuración de tablas y triggers para capturas.
SHOW CREATE TABLE `gen`;
SHOW CREATE TABLE `secuencia`;
SHOW CREATE TABLE `variante`;
SHOW CREATE TABLE `estudio`;
SHOW TRIGGERS FROM `genomica_taller`;
