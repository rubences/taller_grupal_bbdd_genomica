# Cierre de la entrega grupal

## Estado técnico

- Modelo E-R disponible en PNG, SVG y DOT.
- Modelo relacional documentado y normalizado a 3FN.
- DDL MySQL completo con PK, FK, `CHECK`, valores por defecto y triggers semánticos.
- Inserciones manuales sintéticas preparadas.
- Pruebas negativas preparadas para demostrar el rechazo de entradas inválidas.
- Consultas de verificación disponibles para las capturas.
- DOCX y PDF de la actividad presentes.
- Validación automática del proyecto configurada en GitHub Actions.

## Checklist previo a la entrega académica

- [ ] Ejecutar `sql/00_create_database.sql` en MySQL Workbench.
- [ ] Ejecutar `sql/01_schema.sql` y capturar la creación/configuración de tablas y triggers.
- [ ] Ejecutar `sql/02_inserts_validos.sql` y capturar el contenido insertado.
- [ ] Ejecutar `sql/03_pruebas_restricciones.sql` y documentar los rechazos esperados.
- [ ] Ejecutar `sql/04_consultas_verificacion.sql` y capturar las relaciones entre entidades.
- [ ] Sustituir en el DOCX/PDF todos los marcadores por capturas reales de MySQL Workbench.
- [ ] Verificar que las capturas muestran sentencia y resultado de forma legible.
- [ ] Completar `CONTRIBUTORS.md` con los nombres reales del grupo.
- [ ] Sustituir el reparto propuesto por las contribuciones realmente realizadas.
- [ ] Confirmar Calibri 12, interlineado simple y máximo de 20 páginas.
- [ ] Exportar de nuevo el PDF final y revisar visualmente todas las páginas.

## Correspondencia con la rúbrica

| Criterio | Peso | Estado |
|---|---:|---|
| Diseño E-R: entidades, relaciones, atributos y cardinalidades | 30 % | Cubierto |
| Modelo relacional, nomenclatura y normalización | 20 % | Cubierto |
| SQL de creación con restricciones profundas | 30 % | Cubierto |
| Inserciones correctas e incorrectas documentadas | 20 % | Cubierto técnicamente; falta evidencia real en Workbench |
| **Total** | **100 %** | Cobertura estructural completa |

## Restricciones que deben evidenciarse

La ejecución real debe permitir demostrar, como mínimo, que la longitud de la secuencia está entre 10 y 1000 caracteres, que nombre y descripción del gen son obligatorios, que la referencia de estudio sigue el patrón de cuatro letras, `/` y tres números, que los alelos tienen `-` por defecto y que las posiciones relativas son enteros positivos. Las restricciones adicionales de ADN válido, límites relativos y unicidad refuerzan la integridad del modelo.

## Nota de autoría

Este documento no convierte el reparto propuesto de `CONTRIBUTORS.md` en una declaración de autoría. Antes de entregar debe reflejarse exclusivamente el trabajo realmente realizado por cada integrante.
