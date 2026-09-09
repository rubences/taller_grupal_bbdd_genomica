-- Datos de ejemplo manuales y sintéticos.
-- Los nombres se inspiran en genes conocidos, pero las coordenadas y registros
-- se han construido exclusivamente para demostrar el modelo de datos.

USE `genomica_taller`;

START TRANSACTION;

INSERT INTO `gen` (`gen_id`,`nombre`,`descripcion`,`cromosoma`,`posicion_inicio`,`posicion_fin`,`hebra`) VALUES
(1,'HBB_DEMO','Gen sintético inspirado en beta-globina para demostrar el modelo relacional.','11',100000,101600,'-'),
(2,'CFTR_DEMO','Gen sintético inspirado en CFTR para pruebas de secuencias y variantes.','7',200000,220000,'+'),
(3,'BRCA1_DEMO','Gen sintético inspirado en BRCA1 para ilustrar anotaciones clínicas.','17',300000,315000,'-');

INSERT INTO `secuencia` (`secuencia_id`,`gen_id`,`tipo`,`adn`,`posicion_relativa`) VALUES
(1,1,'EXON','ATGGTGCACCTGACTCCTGAGGAGAAGTCTGCC',1),
(2,1,'INTRON','GTGAGTCTATGGGACCCTTGATGTTTTCTTTCCCCTT',80),
(3,2,'CDS','ATGCAGAGGTCGCCTCTGGAAAAGGCCAGCGTTGTC',120),
(4,2,'PROMOTOR','TATAAAGGCGCTGAGCCTGGGAGGTGGTGCTTTGCA',1),
(5,3,'EXON','ATGGATTTATCTGCTCTTCGCGTTGAAGAAGTACAA',250),
(6,3,'INTRON','GTAAGTACAGTGATGTTGCCTTTGTTTTCCAGGCAA',800);

INSERT INTO `variante` (`variante_id`,`secuencia_id`,`posicion_relativa`,`alelo_referencia`,`alelo_alternativo`,`tipo`) VALUES
(1,1,7,'C','T','SNV'),
(2,1,15,'C','-','DELECION'),
(3,3,10,'T','G','SNV'),
(4,5,20,'G','A','SNV'),
(5,6,12,'-','A','INSERCION');

INSERT INTO `anotacion` (`anotacion_id`,`tipo`,`descripcion`) VALUES
(1,'FUNCIONAL','Participación demostrativa en transporte o metabolismo; anotación sintética.'),
(2,'CLINICA','Variante de ejemplo con posible interés clínico; sin valor diagnóstico real.'),
(3,'REGULADORA','Región promotora sintética asociada a control transcripcional.'),
(4,'BIBLIOGRAFICA','Registro usado para demostrar la trazabilidad entre estudios y entidades.'),
(5,'CLINICA','Anotación clínica ficticia asociada a una variante de demostración.');

INSERT INTO `gen_anotacion` (`gen_id`,`anotacion_id`) VALUES
(1,1),(1,4),(2,1),(2,3),(3,2),(3,4);

INSERT INTO `variante_anotacion` (`variante_id`,`anotacion_id`) VALUES
(1,2),(2,5),(3,2),(4,5),(5,4);

INSERT INTO `estudio` (`estudio_id`,`titulo`,`fecha_publicacion`,`referencia`) VALUES
(1,'Caracterización sintética de genes y variantes','2024-03-15','geno/101'),
(2,'Modelo demostrativo de anotación clínica','2025-01-20','clin/202'),
(3,'Estudio de variantes de ejemplo','2025-05-08','vari/303'),
(4,'Relaciones funcionales en una base genómica docente','2026-02-10','func/404');

INSERT INTO `estudio_gen` (`estudio_id`,`gen_id`) VALUES
(1,1),(1,2),(2,3),(4,1),(4,2),(4,3);

INSERT INTO `estudio_variante` (`estudio_id`,`variante_id`) VALUES
(1,1),(2,4),(2,5),(3,1),(3,2),(3,3),(3,4),(3,5);

COMMIT;
