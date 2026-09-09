# Análisis de requisitos

## Entidades nucleares

- **Gen**: unidad principal, con nombre único, descripción obligatoria, cromosoma, intervalo genómico y hebra.
- **Secuencia**: fragmento perteneciente a un único gen; conserva cadena de ADN, tipo y posición relativa.
- **Variante**: cambio localizado dentro de una secuencia; conserva posición relativa, alelos y tipo.
- **Anotación**: información funcional, clínica, reguladora o bibliográfica. Se modela de forma reutilizable y puede asociarse a genes y variantes.
- **Estudio**: publicación o trabajo científico con título, fecha y referencia normalizada.

## Relaciones

- Un gen tiene cero o muchas secuencias; cada secuencia pertenece a un único gen (1:N).
- Una secuencia tiene cero o muchas variantes; cada variante pertenece a una única secuencia (1:N).
- Gen-Anotación y Variante-Anotación se modelan como N:M mediante tablas puente.
- Estudio-Gen y Estudio-Variante son N:M, tal como exige el enunciado.

## Reglas de negocio implementadas

1. ADN entre 10 y 1000 caracteres.
2. ADN restringido a símbolos IUPAC básicos usados en el taller: A, C, G, T y N.
3. Nombre y descripción del gen obligatorios; nombre además único.
4. Referencia de estudio: cuatro letras, barra y tres dígitos (`aaaa/111`).
5. Alelos de referencia y alternativo con valor por defecto `-`.
6. Posiciones relativas de secuencia y variante: enteros positivos no nulos.
7. Intervalo del gen válido (`fin >= inicio`).
8. La secuencia no puede desbordar la longitud relativa del gen (trigger).
9. La variante no puede situarse fuera de la secuencia (trigger).
10. Integridad referencial mediante claves foráneas y tablas puente con claves primarias compuestas.

## Decisión de normalización

El modelo está diseñado en **tercera forma normal (3FN)**: cada tabla representa un único concepto; no se almacenan listas en columnas; las relaciones N:M se resuelven con tablas intermedias; y los atributos no clave dependen únicamente de la clave de su tabla. La pertenencia de una variante a un gen se obtiene a través de `variante -> secuencia -> gen`, evitando duplicar `gen_id` en `variante` y con ello posibles inconsistencias.
