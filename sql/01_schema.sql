-- MUBIO06 · Taller grupal · Modelo relacional genómico
-- MySQL 8.0.16+ (CHECK constraints activas)

USE `genomica_taller`;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `estudio_variante`;
DROP TABLE IF EXISTS `estudio_gen`;
DROP TABLE IF EXISTS `variante_anotacion`;
DROP TABLE IF EXISTS `gen_anotacion`;
DROP TABLE IF EXISTS `estudio`;
DROP TABLE IF EXISTS `anotacion`;
DROP TABLE IF EXISTS `variante`;
DROP TABLE IF EXISTS `secuencia`;
DROP TABLE IF EXISTS `gen`;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE `gen` (
  `gen_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(64) NOT NULL,
  `descripcion` VARCHAR(500) NOT NULL,
  `cromosoma` VARCHAR(16) NOT NULL,
  `posicion_inicio` INT UNSIGNED NOT NULL,
  `posicion_fin` INT UNSIGNED NOT NULL,
  `hebra` ENUM('+','-') NOT NULL,
  PRIMARY KEY (`gen_id`),
  CONSTRAINT `uq_gen_nombre` UNIQUE (`nombre`),
  CONSTRAINT `ck_gen_nombre_no_vacio` CHECK (CHAR_LENGTH(TRIM(`nombre`)) > 0),
  CONSTRAINT `ck_gen_descripcion_no_vacia` CHECK (CHAR_LENGTH(TRIM(`descripcion`)) > 0),
  CONSTRAINT `ck_gen_intervalo` CHECK (`posicion_fin` >= `posicion_inicio`)
) ENGINE=InnoDB;

CREATE TABLE `secuencia` (
  `secuencia_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `gen_id` BIGINT UNSIGNED NOT NULL,
  `tipo` ENUM('EXON','INTRON','CDS','PROMOTOR','UTR','OTRA') NOT NULL,
  `adn` VARCHAR(1000) NOT NULL,
  `posicion_relativa` INT UNSIGNED NOT NULL,
  `longitud` SMALLINT UNSIGNED GENERATED ALWAYS AS (CHAR_LENGTH(`adn`)) STORED,
  PRIMARY KEY (`secuencia_id`),
  KEY `idx_secuencia_gen` (`gen_id`),
  CONSTRAINT `fk_secuencia_gen`
    FOREIGN KEY (`gen_id`) REFERENCES `gen` (`gen_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT `ck_secuencia_longitud` CHECK (CHAR_LENGTH(`adn`) BETWEEN 10 AND 1000),
  CONSTRAINT `ck_secuencia_adn` CHECK (BINARY `adn` REGEXP '^[ACGTN]+$'),
  CONSTRAINT `ck_secuencia_posicion` CHECK (`posicion_relativa` > 0)
) ENGINE=InnoDB;

CREATE TABLE `variante` (
  `variante_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `secuencia_id` BIGINT UNSIGNED NOT NULL,
  `posicion_relativa` INT UNSIGNED NOT NULL,
  `alelo_referencia` VARCHAR(255) NOT NULL DEFAULT '-',
  `alelo_alternativo` VARCHAR(255) NOT NULL DEFAULT '-',
  `tipo` ENUM('SNV','INSERCION','DELECION','INDEL') NOT NULL,
  PRIMARY KEY (`variante_id`),
  KEY `idx_variante_secuencia` (`secuencia_id`),
  CONSTRAINT `uq_variante_local` UNIQUE (`secuencia_id`, `posicion_relativa`, `alelo_alternativo`),
  CONSTRAINT `fk_variante_secuencia`
    FOREIGN KEY (`secuencia_id`) REFERENCES `secuencia` (`secuencia_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT `ck_variante_posicion` CHECK (`posicion_relativa` > 0),
  CONSTRAINT `ck_variante_ref` CHECK (BINARY `alelo_referencia` REGEXP '^(-|[ACGTN]+)$'),
  CONSTRAINT `ck_variante_alt` CHECK (BINARY `alelo_alternativo` REGEXP '^(-|[ACGTN]+)$')
) ENGINE=InnoDB;

CREATE TABLE `anotacion` (
  `anotacion_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('FUNCIONAL','CLINICA','REGULADORA','BIBLIOGRAFICA','OTRA') NOT NULL,
  `descripcion` TEXT NOT NULL,
  PRIMARY KEY (`anotacion_id`),
  CONSTRAINT `ck_anotacion_descripcion` CHECK (CHAR_LENGTH(TRIM(`descripcion`)) > 0)
) ENGINE=InnoDB;

CREATE TABLE `estudio` (
  `estudio_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(300) NOT NULL,
  `fecha_publicacion` DATE NOT NULL,
  `referencia` CHAR(8) NOT NULL,
  PRIMARY KEY (`estudio_id`),
  CONSTRAINT `uq_estudio_referencia` UNIQUE (`referencia`),
  CONSTRAINT `ck_estudio_titulo` CHECK (CHAR_LENGTH(TRIM(`titulo`)) > 0),
  CONSTRAINT `ck_estudio_referencia`
    CHECK (BINARY `referencia` REGEXP '^[A-Za-z]{4}/[0-9]{3}$')
) ENGINE=InnoDB;

CREATE TABLE `gen_anotacion` (
  `gen_id` BIGINT UNSIGNED NOT NULL,
  `anotacion_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`gen_id`, `anotacion_id`),
  CONSTRAINT `fk_genanot_gen`
    FOREIGN KEY (`gen_id`) REFERENCES `gen` (`gen_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT `fk_genanot_anotacion`
    FOREIGN KEY (`anotacion_id`) REFERENCES `anotacion` (`anotacion_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `variante_anotacion` (
  `variante_id` BIGINT UNSIGNED NOT NULL,
  `anotacion_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`variante_id`, `anotacion_id`),
  CONSTRAINT `fk_varanot_variante`
    FOREIGN KEY (`variante_id`) REFERENCES `variante` (`variante_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT `fk_varanot_anotacion`
    FOREIGN KEY (`anotacion_id`) REFERENCES `anotacion` (`anotacion_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `estudio_gen` (
  `estudio_id` BIGINT UNSIGNED NOT NULL,
  `gen_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`estudio_id`, `gen_id`),
  CONSTRAINT `fk_estgen_estudio`
    FOREIGN KEY (`estudio_id`) REFERENCES `estudio` (`estudio_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT `fk_estgen_gen`
    FOREIGN KEY (`gen_id`) REFERENCES `gen` (`gen_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `estudio_variante` (
  `estudio_id` BIGINT UNSIGNED NOT NULL,
  `variante_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`estudio_id`, `variante_id`),
  CONSTRAINT `fk_estvar_estudio`
    FOREIGN KEY (`estudio_id`) REFERENCES `estudio` (`estudio_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE,
  CONSTRAINT `fk_estvar_variante`
    FOREIGN KEY (`variante_id`) REFERENCES `variante` (`variante_id`)
    ON UPDATE RESTRICT ON DELETE CASCADE
) ENGINE=InnoDB;

-- Restricción semántica: una secuencia no puede extenderse fuera del gen.
DROP TRIGGER IF EXISTS `trg_secuencia_bi`;
DROP TRIGGER IF EXISTS `trg_secuencia_bu`;
DROP TRIGGER IF EXISTS `trg_variante_bi`;
DROP TRIGGER IF EXISTS `trg_variante_bu`;

DELIMITER $$
CREATE TRIGGER `trg_secuencia_bi`
BEFORE INSERT ON `secuencia`
FOR EACH ROW
BEGIN
  DECLARE v_longitud_gen INT UNSIGNED;
  SELECT (`posicion_fin` - `posicion_inicio` + 1)
    INTO v_longitud_gen
  FROM `gen`
  WHERE `gen_id` = NEW.`gen_id`;

  IF NEW.`posicion_relativa` + CHAR_LENGTH(NEW.`adn`) - 1 > v_longitud_gen THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La secuencia excede los limites relativos del gen';
  END IF;
END$$

CREATE TRIGGER `trg_secuencia_bu`
BEFORE UPDATE ON `secuencia`
FOR EACH ROW
BEGIN
  DECLARE v_longitud_gen INT UNSIGNED;
  SELECT (`posicion_fin` - `posicion_inicio` + 1)
    INTO v_longitud_gen
  FROM `gen`
  WHERE `gen_id` = NEW.`gen_id`;

  IF NEW.`posicion_relativa` + CHAR_LENGTH(NEW.`adn`) - 1 > v_longitud_gen THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La secuencia excede los limites relativos del gen';
  END IF;
END$$

-- Restricción semántica: la variante debe caer dentro de su secuencia.
CREATE TRIGGER `trg_variante_bi`
BEFORE INSERT ON `variante`
FOR EACH ROW
BEGIN
  DECLARE v_longitud_secuencia INT UNSIGNED;
  SELECT `longitud`
    INTO v_longitud_secuencia
  FROM `secuencia`
  WHERE `secuencia_id` = NEW.`secuencia_id`;

  IF NEW.`posicion_relativa` > v_longitud_secuencia THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La variante queda fuera de la secuencia asociada';
  END IF;
END$$

CREATE TRIGGER `trg_variante_bu`
BEFORE UPDATE ON `variante`
FOR EACH ROW
BEGIN
  DECLARE v_longitud_secuencia INT UNSIGNED;
  SELECT `longitud`
    INTO v_longitud_secuencia
  FROM `secuencia`
  WHERE `secuencia_id` = NEW.`secuencia_id`;

  IF NEW.`posicion_relativa` > v_longitud_secuencia THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La variante queda fuera de la secuencia asociada';
  END IF;
END$$
DELIMITER ;
