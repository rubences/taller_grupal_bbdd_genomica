#!/usr/bin/env python3
from pathlib import Path
import re, sys

root = Path(__file__).resolve().parents[1]
schema = (root/'sql/01_schema.sql').read_text(encoding='utf-8')
inserts = (root/'sql/02_inserts_validos.sql').read_text(encoding='utf-8')
tests = (root/'sql/03_pruebas_restricciones.sql').read_text(encoding='utf-8')

required_tables = [
    'gen','secuencia','variante','anotacion','estudio',
    'gen_anotacion','variante_anotacion','estudio_gen','estudio_variante'
]
for t in required_tables:
    assert re.search(rf'CREATE TABLE `?{re.escape(t)}`?', schema), f'Falta tabla {t}'

checks = {
    'longitud ADN': "CHAR_LENGTH(`adn`) BETWEEN 10 AND 1000",
    'gen nombre obligatorio': '`nombre` VARCHAR(64) NOT NULL',
    'gen descripcion obligatoria': '`descripcion` VARCHAR(500) NOT NULL',
    'referencia estudio': "'^[A-Za-z]{4}/[0-9]{3}$'",
    'alelo ref default': "`alelo_referencia` VARCHAR(255) NOT NULL DEFAULT '-'",
    'alelo alt default': "`alelo_alternativo` VARCHAR(255) NOT NULL DEFAULT '-'",
    'pos secuencia positiva': 'CHECK (`posicion_relativa` > 0)',
    'trigger secuencia': 'CREATE TRIGGER `trg_secuencia_bi`',
    'trigger variante': 'CREATE TRIGGER `trg_variante_bi`',
}
for name, token in checks.items():
    assert token in schema, f'Falta restricción: {name}'

assert schema.count('FOREIGN KEY') >= 9, 'Se esperaban al menos 9 claves foráneas'
assert schema.count('PRIMARY KEY') >= 9, 'Se esperaban PK en todas las tablas'

# Recuento de filas insertadas (conteo de tuplas de los bloques conocidos)
expected_counts = {
    'gen': 3, 'secuencia': 6, 'variante': 5, 'anotacion': 5,
    'gen_anotacion': 6, 'variante_anotacion': 5, 'estudio': 4,
    'estudio_gen': 6, 'estudio_variante': 8,
}
def extract_values_block(sql, table):
    m = re.search(rf"INSERT INTO `{table}`.*?VALUES\s*", sql, re.S)
    assert m, f'Falta INSERT de {table}'
    i = m.end()
    out = []
    in_quote = False
    while i < len(sql):
        ch = sql[i]
        if ch == "'":
            in_quote = not in_quote
        if ch == ';' and not in_quote:
            break
        out.append(ch)
        i += 1
    return ''.join(out)


def count_top_level_tuples(fragment):
    depth = 0
    in_quote = False
    count = 0
    for ch in fragment:
        if ch == "'":
            in_quote = not in_quote
            continue
        if in_quote:
            continue
        if ch == '(':
            if depth == 0:
                count += 1
            depth += 1
        elif ch == ')':
            depth -= 1
    return count

for table, expected in expected_counts.items():
    block = extract_values_block(inserts, table)
    tuple_count = count_top_level_tuples(block)
    assert tuple_count == expected, f'{table}: {tuple_count} filas, esperadas {expected}'

for p in range(1,10):
    assert f"P{p:02d}" in tests, f'Falta prueba P{p:02d}'
assert tests.count("'RECHAZADO'") >= 16  # esperado + salida por cada prueba negativa
assert "'ACEPTADO'" in tests

for f in [
    'diagrams/modelo_er.png','docs/ANALISIS_REQUISITOS.md','docs/MODELO_RELACIONAL.md',
    'docs/MATRIZ_RUBRICA.md','docs/PLAN_CAPTURAS.md',
    'MUBIO06_Taller_Grupal_Base_Datos_Genomica.docx',
    'MUBIO06_Taller_Grupal_Base_Datos_Genomica.pdf'
]:
    assert (root/f).exists(), f'Falta entregable {f}'

print('PASS: 9 tablas, restricciones, 48 filas sintéticas, 9 pruebas y entregables presentes.')
