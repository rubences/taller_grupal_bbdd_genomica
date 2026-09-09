# Validación reproducible de la entrega

La evidencia siguiente se deriva directamente de los scripts y datos sintéticos versionados; no es una captura simulada de MySQL Workbench.

## Estado de validación

```text
PASS: 9 tablas, restricciones, 48 filas sintéticas, 9 pruebas, integridad semántica y entregables finales presentes.
```

## Recuento por tabla

| Tabla | Filas |
|---|---:|
| `gen` | 3 |
| `secuencia` | 6 |
| `variante` | 5 |
| `anotacion` | 5 |
| `estudio` | 4 |
| `gen_anotacion` | 6 |
| `variante_anotacion` | 5 |
| `estudio_gen` | 6 |
| `estudio_variante` | 8 |

**Total: 48 registros relacionales sintéticos.**

## V02 · gen → secuencia → variante

| Gen | Sec. | Tipo | Pos.sec. | Long. | Var. | Pos.var. | Alelos | Tipo var. |
|---|---:|---|---:|---:|---:|---:|---|---|
| HBB_DEMO | 1 | EXON | 1 | 33 | 1 | 7 | C>T | SNV |
| HBB_DEMO | 1 | EXON | 1 | 33 | 2 | 15 | C>- | DELECION |
| HBB_DEMO | 2 | INTRON | 80 | 37 | — | — | — | — |
| CFTR_DEMO | 3 | CDS | 120 | 36 | 3 | 10 | T>G | SNV |
| CFTR_DEMO | 4 | PROMOTOR | 1 | 36 | — | — | — | — |
| BRCA1_DEMO | 5 | EXON | 250 | 36 | 4 | 20 | G>A | SNV |
| BRCA1_DEMO | 6 | INTRON | 800 | 36 | 5 | 12 | ->A | INSERCION |

## V05 · estudio ↔ variante

| Ref. estudio | Variante | Gen | Tipo | Posición |
|---|---:|---|---|---:|
| geno/101 | 1 | HBB_DEMO | SNV | 7 |
| clin/202 | 4 | BRCA1_DEMO | SNV | 20 |
| clin/202 | 5 | BRCA1_DEMO | INSERCION | 12 |
| vari/303 | 1 | HBB_DEMO | SNV | 7 |
| vari/303 | 2 | HBB_DEMO | DELECION | 15 |
| vari/303 | 3 | CFTR_DEMO | SNV | 10 |
| vari/303 | 4 | BRCA1_DEMO | SNV | 20 |
| vari/303 | 5 | BRCA1_DEMO | INSERCION | 12 |

## Pruebas P01-P09

P01-P08 codifican casos que el modelo debe rechazar por restricciones de dominio, nulidad, unicidad o triggers. P09 codifica el caso de aceptación que comprueba el valor por defecto `-` en ambos alelos.

## Alcance

La validación automatizada confirma estructura, cardinalidades de carga e integridad semántica independiente del motor. Los scripts MySQL quedan listos para reproducir la ejecución en MySQL 8.0+.
