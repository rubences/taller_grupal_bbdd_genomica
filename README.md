# MUBIO06 · Taller grupal · Creación de una base de datos genómica

[![Genomic Database QA](https://github.com/rubences/taller_grupal_bbdd_genomica/actions/workflows/ci.yml/badge.svg)](https://github.com/rubences/taller_grupal_bbdd_genomica/actions/workflows/ci.yml)

Proyecto reproducible para diseñar e implementar en **MySQL 8.0+** una base de datos genómica relacional con genes, secuencias, variantes, anotaciones y estudios.

## Estado

**CERRADO / READY FOR SUBMISSION**

La solución cubre el 100 % de la rúbrica: modelo E-R, transformación a 3FN, DDL MySQL con restricciones profundas, 48 registros sintéticos manuales, pruebas positivas/negativas, consultas de verificación y validación automatizada.

La versión académica definitiva del informe se ha cerrado en 6 páginas (Calibri 12, interlineado simple) e integra el diagrama E-R, SQL, recuentos, matriz de restricciones y resultados relacionales reproducibles. Para evitar inventar evidencia, no se simulan capturas de MySQL Workbench.

**Integridad de los artefactos definitivos generados:**

- DOCX SHA-256: `427edac69e17ca2f025a0f8f765a612bad39150993941905506d3a94fd256186`
- PDF SHA-256: `50f26d2431c85805739db7bfcd0d563e2dc2fb6f134f3e9104941452f227a96e`
- ZIP de cierre SHA-256: `208db1d3ad6b4f38775fb25b9521292cc02d56aaaa20e5184e3b2e2b5711fdda`

## Ejecución

En MySQL Workbench, ejecutar por este orden:

```text
sql/00_create_database.sql
sql/01_schema.sql
sql/02_inserts_validos.sql
sql/03_pruebas_restricciones.sql
sql/04_consultas_verificacion.sql
```

## Cobertura de la rúbrica

| Criterio | Peso | Cobertura |
|---|---:|---|
| Modelo E-R | 30 % | Entidades, atributos, cardinalidades y relaciones N:M |
| Modelo relacional | 20 % | Transformación normalizada a 3FN |
| SQL y restricciones | 30 % | PK/FK, CHECK, DEFAULT, UNIQUE, ENUM, índices y triggers |
| Inserciones y control de errores | 20 % | 48 filas sintéticas + P01-P09 |
| **Total** | **100 %** | **Cobertura completa** |

## Restricciones clave

El modelo implementa longitud de ADN 10-1000, nombre/descripcion de gen obligatorios, referencia `aaaa/111`, alelos por defecto `-`, posiciones positivas, ADN restringido a A/C/G/T/N, intervalos coherentes, secuencias dentro de los límites del gen y variantes dentro de su secuencia.

## Estructura de cierre

- `diagrams/modelo_er.png` / `.svg` / `.dot`
- `sql/00_create_database.sql` ... `sql/04_consultas_verificacion.sql`
- `docs/ANALISIS_REQUISITOS.md`
- `docs/MODELO_RELACIONAL.md`
- `docs/MATRIZ_RUBRICA.md`
- `docs/VALIDACION_REPRODUCIBLE.md`
- `docs/CIERRE_ENTREGA.md`
- `CONTRIBUTORS.md`

## Evidencia y reproducibilidad

La evidencia cuantitativa y relacional procede directamente de los datos sintéticos versionados. `scripts/validate_project.py` y GitHub Actions controlan la estructura del proyecto. Una ejecución visual en MySQL Workbench puede añadirse como evidencia complementaria, pero no se sustituye por imágenes fabricadas.

## Datos

Los datos son **manuales y sintéticos**, tal como permite el enunciado. Los identificadores `HBB_DEMO`, `CFTR_DEMO` y `BRCA1_DEMO` son ejemplos docentes y no constituyen un dataset biomédico real.
