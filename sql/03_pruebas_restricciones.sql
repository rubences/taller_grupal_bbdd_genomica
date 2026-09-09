-- Pruebas controladas de restricciones.
-- El procedimiento ejecuta inserciones válidas e inválidas dentro de
-- transacciones que siempre se revierten, y devuelve una tabla-resumen.

USE `genomica_taller`;

DROP PROCEDURE IF EXISTS `sp_probar_restricciones`;
DELIMITER $$
CREATE PROCEDURE `sp_probar_restricciones`()
BEGIN
  DROP TEMPORARY TABLE IF EXISTS `resultado_pruebas_restriccion`;
  CREATE TEMPORARY TABLE `resultado_pruebas_restriccion` (
    `prueba` VARCHAR(8) NOT NULL,
    `regla` VARCHAR(160) NOT NULL,
    `esperado` ENUM('RECHAZADO','ACEPTADO') NOT NULL,
    `resultado` VARCHAR(40) NOT NULL
  );

  -- P01: longitud de ADN < 10 -> RECHAZADO
  BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
    START TRANSACTION;
    INSERT INTO `secuencia` (`gen_id`,`tipo`,`adn`,`posicion_relativa`)
    VALUES (1,'EXON','ACGTACGTA',10);
    ROLLBACK;
    INSERT INTO `resultado_pruebas_restriccion`
    VALUES ('P01','ADN con menos de 10 caracteres','RECHAZADO',IF(v_error,'RECHAZADO','ACEPTADO_INCORRECTAMENTE'));
  END;

  -- P02: longitud de ADN > 1000 -> RECHAZADO
  BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
    START TRANSACTION;
    INSERT INTO `secuencia` (`gen_id`,`tipo`,`adn`,`posicion_relativa`)
    VALUES (2,'EXON',REPEAT('A',1001),10);
    ROLLBACK;
    INSERT INTO `resultado_pruebas_restriccion`
    VALUES ('P02','ADN con más de 1000 caracteres','RECHAZADO',IF(v_error,'RECHAZADO','ACEPTADO_INCORRECTAMENTE'));
  END;

  -- P03: descripción de gen obligatoria -> RECHAZADO
  BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
    START TRANSACTION;
    INSERT INTO `gen` (`nombre`,`descripcion`,`cromosoma`,`posicion_inicio`,`posicion_fin`,`hebra`)
    VALUES ('GEN_SIN_DESC',NULL,'1',1,100,'+');
    ROLLBACK;
    INSERT INTO `resultado_pruebas_restriccion`
    VALUES ('P03','Descripción de gen NOT NULL','RECHAZADO',IF(v_error,'RECHAZADO','ACEPTADO_INCORRECTAMENTE'));
  END;

  -- P04: referencia de estudio inválida -> RECHAZADO
  BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
    START TRANSACTION;
    INSERT INTO `estudio` (`titulo`,`fecha_publicacion`,`referencia`)
    VALUES ('Referencia inválida','2026-01-01','ABC/12');
    ROLLBACK;
    INSERT INTO `resultado_pruebas_restriccion`
    VALUES ('P04','Referencia debe cumplir aaaa/111','RECHAZADO',IF(v_error,'RECHAZADO','ACEPTADO_INCORRECTAMENTE'));
  END;

  -- P05: posición de secuencia = 0 -> RECHAZADO
  BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
    START TRANSACTION;
    INSERT INTO `secuencia` (`gen_id`,`tipo`,`adn`,`posicion_relativa`)
    VALUES (1,'EXON','ACGTACGTACGT',0);
    ROLLBACK;
    INSERT INTO `resultado_pruebas_restriccion`
    VALUES ('P05','Posición de secuencia positiva','RECHAZADO',IF(v_error,'RECHAZADO','ACEPTADO_INCORRECTAMENTE'));
  END;

  -- P06: ADN con caracteres no válidos -> RECHAZADO
  BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
    START TRANSACTION;
    INSERT INTO `secuencia` (`gen_id`,`tipo`,`adn`,`posicion_relativa`)
    VALUES (1,'EXON','ACGTXYZACGT',10);
    ROLLBACK;
    INSERT INTO `resultado_pruebas_restriccion`
    VALUES ('P06','ADN restringido a A,C,G,T,N','RECHAZADO',IF(v_error,'RECHAZADO','ACEPTADO_INCORRECTAMENTE'));
  END;

  -- P07: variante fuera de la secuencia -> RECHAZADO por trigger
  BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
    START TRANSACTION;
    INSERT INTO `variante` (`secuencia_id`,`posicion_relativa`,`alelo_referencia`,`alelo_alternativo`,`tipo`)
    VALUES (1,999,'A','G','SNV');
    ROLLBACK;
    INSERT INTO `resultado_pruebas_restriccion`
    VALUES ('P07','Variante dentro de la longitud de secuencia','RECHAZADO',IF(v_error,'RECHAZADO','ACEPTADO_INCORRECTAMENTE'));
  END;

  -- P08: nombre de gen duplicado -> RECHAZADO
  BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
    START TRANSACTION;
    INSERT INTO `gen` (`nombre`,`descripcion`,`cromosoma`,`posicion_inicio`,`posicion_fin`,`hebra`)
    VALUES ('HBB_DEMO','Duplicado','11',400000,401000,'+');
    ROLLBACK;
    INSERT INTO `resultado_pruebas_restriccion`
    VALUES ('P08','Nombre de gen único','RECHAZADO',IF(v_error,'RECHAZADO','ACEPTADO_INCORRECTAMENTE'));
  END;

  -- P09: alelos omitidos -> ACEPTADO y deben adoptar '-'
  BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE v_ref VARCHAR(255);
    DECLARE v_alt VARCHAR(255);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
    START TRANSACTION;
    INSERT INTO `variante` (`secuencia_id`,`posicion_relativa`,`tipo`)
    VALUES (2,3,'INDEL');
    SELECT `alelo_referencia`,`alelo_alternativo`
      INTO v_ref,v_alt
    FROM `variante`
    WHERE `variante_id` = LAST_INSERT_ID();
    ROLLBACK;
    INSERT INTO `resultado_pruebas_restriccion`
    VALUES ('P09','Alelos por defecto = -','ACEPTADO',
      IF(NOT v_error AND v_ref='-' AND v_alt='-','ACEPTADO','FALLO_DEFAULT'));
  END;

  SELECT * FROM `resultado_pruebas_restriccion` ORDER BY `prueba`;
END$$
DELIMITER ;

CALL `sp_probar_restricciones`();
DROP PROCEDURE `sp_probar_restricciones`;
