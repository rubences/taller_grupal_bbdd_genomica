# Modelo relacional

```text
GEN(
  gen_id PK,
  nombre UQ NOT NULL,
  descripcion NOT NULL,
  cromosoma NOT NULL,
  posicion_inicio NOT NULL,
  posicion_fin NOT NULL,
  hebra NOT NULL
)

SECUENCIA(
  secuencia_id PK,
  gen_id FK -> GEN.gen_id,
  tipo NOT NULL,
  adn NOT NULL,
  posicion_relativa NOT NULL,
  longitud GENERATED
)

VARIANTE(
  variante_id PK,
  secuencia_id FK -> SECUENCIA.secuencia_id,
  posicion_relativa NOT NULL,
  alelo_referencia DEFAULT '-',
  alelo_alternativo DEFAULT '-',
  tipo NOT NULL,
  UQ(secuencia_id, posicion_relativa, alelo_alternativo)
)

ANOTACION(anotacion_id PK, tipo NOT NULL, descripcion NOT NULL)
ESTUDIO(estudio_id PK, titulo NOT NULL, fecha_publicacion NOT NULL, referencia UQ NOT NULL)

GEN_ANOTACION(gen_id PK/FK, anotacion_id PK/FK)
VARIANTE_ANOTACION(variante_id PK/FK, anotacion_id PK/FK)
ESTUDIO_GEN(estudio_id PK/FK, gen_id PK/FK)
ESTUDIO_VARIANTE(estudio_id PK/FK, variante_id PK/FK)
```

## Cardinalidades

| Relación | Cardinalidad |
|---|---|
| GEN - SECUENCIA | 1:N |
| SECUENCIA - VARIANTE | 1:N |
| GEN - ANOTACION | N:M |
| VARIANTE - ANOTACION | N:M |
| ESTUDIO - GEN | N:M |
| ESTUDIO - VARIANTE | N:M |

## Integridad

Las tablas puente usan una PK compuesta por las dos FK, impidiendo duplicar la misma relación. Los hijos usan `ON DELETE CASCADE` para evitar registros huérfanos cuando se elimina una entidad principal. Las PK técnicas son `BIGINT UNSIGNED AUTO_INCREMENT`, mientras que los identificadores de negocio relevantes (`nombre`, `referencia`) se protegen con `UNIQUE`.
