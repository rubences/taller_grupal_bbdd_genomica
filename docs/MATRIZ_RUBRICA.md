# Matriz de trazabilidad de la rúbrica

| Criterio | Peso | Cobertura |
|---|---:|---|
| Modelo E-R correcto | 30 % | Diagrama con 5 entidades principales, 4 tablas asociativas, atributos, PK/FK y cardinalidades 1:N / N:M. |
| Conversión al modelo relacional | 20 % | Esquema en 3FN, nomenclatura consistente, PK, FK, UQ y relaciones N:M normalizadas. |
| Creación SQL y restricciones | 30 % | DDL MySQL completo con `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`, `ENUM`, FK, índices y triggers semánticos. |
| Inserción de datos y control de errores | 20 % | Datos manuales sintéticos + procedimiento con 8 rechazos esperados y 1 prueba de aceptación/default. |
| **Total** | **100 %** | Cobertura completa de los 10 puntos. |

## Elementos de nivel alto

- La variante no duplica `gen_id`; se obtiene por la cadena `variante -> secuencia -> gen`.
- Las anotaciones son reutilizables y se pueden vincular tanto a genes como a variantes.
- Estudios se relacionan N:M de manera independiente con genes y variantes.
- Triggers añaden reglas que un `CHECK` no puede expresar entre tablas.
- El script de pruebas convierte las restricciones en evidencia reproducible y no se limita a describir errores teóricos.
