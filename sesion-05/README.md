# Módulo 4 · ADLS aplicado, secretos y Databricks — material de la sesión 5

- `slides/` — `contenido.py`, `S05-deck-v1.html` (34 slides), `deck.css`, `deck.js`, builders.
- `lab/` — `CONSIGNA.md`, `plantilla-evidencia.md` y `notebooks/01_load_bronze_andina.py`.
- `guias/` — guía visual paso a paso con las capturas del montaje.
- `instructor/` — notas privadas y clave del laboratorio.
- `capturas/` — 23 capturas reales del portal y del workspace.
- `qa/` — audit en 4 viewports × 3 temas.

**Idea central:** el lago ya tiene los datos; S05 le da cómputo y gobierno. Unity Catalog resuelve el acceso con identidad, Key Vault resuelve los secretos de aplicación y Delta deja el bronce consultable.

**Estado:** v1 lista para revisión humana. Gate estructural PASS (34 slides, 12 fuentes). Audit visual PASS.

**Nota de cómputo:** el workspace de la demo no logró aprovisionar clústeres (quedan en `Pending` sin crear la VMSS, aunque la suscripción sí puede crear VMs). El laboratorio usa el SQL warehouse serverless; el notebook PySpark queda como alternativa para cuentas con clúster.
