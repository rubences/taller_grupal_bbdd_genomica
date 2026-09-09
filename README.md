# MUBIO06 · Taller grupal · Creación de una base de datos genómica

[![Genomic Database QA](https://github.com/rubences/taller_grupal_bbdd_genomica/actions/workflows/ci.yml/badge.svg)](https://github.com/rubences/taller_grupal_bbdd_genomica/actions/workflows/ci.yml)

Proyecto reproducible para diseñar e implementar en MySQL una base de datos genómica relacional con genes, secuencias, variantes, anotaciones y estudios.

## Estado de la entrega

La solución cubre los cuatro criterios de la rúbrica: diseño E-R, transformación relacional normalizada, creación SQL con restricciones e inserciones válidas/erróneas documentadas. La validación automática del repositorio está en verde y la estructura canónica se conserva en `main`.

El único cierre académico que debe completarse fuera del repositorio es sustituir los marcadores del informe por capturas reales de MySQL Workbench y actualizar `CONTRIBUTORS.md` con los nombres y contribuciones efectivamente realizadas por todos los integrantes.

## Cobertura del taller

- análisis de requisitos;
- diagrama E-R con entidades, atributos y cardinalidades;
- transformación a modelo relacional normalizado (3FN);
- creación SQL con restricciones profundas;
- inserciones manuales sintéticas;
- pruebas positivas y negativas de restricciones;
- consultas de verificación para preparar las capturas de la entrega.

## Ejecución

En MySQL Workbench ejecutar, por este orden:

```text
sql/00_create_database.sql
sql/01_schema.sql
sql/02_inserts_validos.sql
sql/03_pruebas_restricciones.sql
sql/04_consultas_verificacion.sql
```

## Restricciones clave

El modelo implementa las restricciones explícitas del enunciado y añade controles de integridad semántica: longitud del ADN 10-1000, nombre/descripcion del gen obligatorios, referencia de estudio `aaaa/111`, alelos por defecto `-`, posiciones positivas, ADN válido, secuencias dentro de los límites relativos del gen y variantes dentro de la secuencia.

## Modelo

El diagrama E-R está disponible en:

- `diagrams/modelo_er.png`
- `diagrams/modelo_er.svg`
- `diagrams/modelo_er.dot`

Las relaciones N:M se resuelven con las tablas `gen_anotacion`, `variante_anotacion`, `estudio_gen` y `estudio_variante`.

## Datos de demostración

Los datos son **manuales y sintéticos**, tal como permite el enunciado. Algunos nombres se inspiran en genes conocidos (`HBB_DEMO`, `CFTR_DEMO`, `BRCA1_DEMO`), pero no deben interpretarse como un dataset biomédico real.

## Entregables

- `MUBIO06_Taller_Grupal_Base_Datos_Genomica.docx`
- `MUBIO06_Taller_Grupal_Base_Datos_Genomica.pdf`
- scripts SQL completos;
- documentación de requisitos, modelo relacional, rúbrica y plan de capturas;
- CI de validación estática.

## Trazabilidad de la rúbrica

| Criterio | Peso | Evidencia principal |
|---|---:|---|
| Modelo E-R | 30 % | `diagrams/modelo_er.*` + documentación del modelo |
| Modelo relacional y normalización | 20 % | `docs/MODELO_RELACIONAL.md` + 3FN |
| Creación SQL y restricciones | 30 % | `sql/01_schema.sql` + claves, checks, FKs y triggers |
| Inserción y control de errores | 20 % | `sql/02_inserts_validos.sql` + `sql/03_pruebas_restricciones.sql` |
| **Total** | **100 %** | Cobertura completa |

## Validación automática

GitHub Actions comprueba la estructura del proyecto y ejecuta `scripts/validate_project.py`. El proyecto incluye nueve tablas, restricciones explícitas y semánticas, datos sintéticos de demostración y pruebas negativas diseñadas para evidenciar que el modelo rechaza entradas inválidas.

## Evidencia real

El informe contiene marcadores para capturas reales de MySQL Workbench. No se han fabricado resultados gráficos de ejecución. Antes de la entrega deben reemplazarse por las capturas reales indicadas en `docs/PLAN_CAPTURAS.md`.

## Autoría grupal

`CONTRIBUTORS.md` contiene por ahora una propuesta de reparto y marcadores pendientes para el resto del grupo. Debe sustituirse por los nombres reales y por la contribución efectiva de cada integrante antes de la entrega final; no se atribuyen contribuciones no verificadas.
