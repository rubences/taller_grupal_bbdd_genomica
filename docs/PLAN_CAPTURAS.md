# Plan de capturas para la entrega

La entrega debe mostrar resultados reales de MySQL. No se deben sustituir por capturas simuladas.

## Capturas mínimas recomendadas

1. **E-R**: `diagrams/modelo_er.png` o el modelo recreado en MySQL Workbench, mostrando entidades y cardinalidades.
2. **Modelo relacional**: vista de tablas y claves del esquema `genomica_taller` en Workbench.
3. **Creación**: ejecución correcta de `00_create_database.sql` + `01_schema.sql`, seguida de `SHOW CREATE TABLE secuencia` y `SHOW TRIGGERS`.
4. **Inserciones válidas**: ejecución de `02_inserts_validos.sql` y resultado de `04_consultas_verificacion.sql` V01/V02.
5. **Restricciones**: ejecutar `03_pruebas_restricciones.sql`; la tabla final debe mostrar P01-P08 como `RECHAZADO` y P09 como `ACEPTADO`.
6. **Relaciones N:M**: resultados de V03, V04 y V05 para demostrar anotaciones y estudios.

## Resultado esperado de recuentos

| Tabla | Filas |
|---|---:|
| gen | 3 |
| secuencia | 6 |
| variante | 5 |
| anotacion | 5 |
| estudio | 4 |
| gen_anotacion | 6 |
| variante_anotacion | 5 |
| estudio_gen | 6 |
| estudio_variante | 8 |

## Recomendación de maquetación

Recortar las capturas al SQL ejecutado y al `Result Grid` relevante. No hace falta mostrar toda la interfaz de Workbench. Con 5-6 capturas bien seleccionadas el informe puede mantenerse cómodamente por debajo de 20 páginas.
