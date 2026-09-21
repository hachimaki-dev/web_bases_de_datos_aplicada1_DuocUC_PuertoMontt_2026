# Guía de Contenido — Plataforma de Bases de Datos Aplicada 1

Este documento establece las directrices pedagógicas, el tono editorial, el diseño instruccional bajo el marco DUA (Diseño Universal para el Aprendizaje), los estándares de modelado con **Oracle SQL Developer Data Modeler**, la normalización hasta **3FN** y las convenciones de **Oracle SQL** y **Oracle APEX** para todos los contenidos de la plataforma.

---

## 1. Contexto Pedagógico y Perfil del Estudiante

### Perfil del Estudiante de 1° Año
- Estudiantes novatos en modelamiento relacional. Su experiencia previa con datos proviene casi exclusivamente de **hojas de cálculo planas (Excel / Google Sheets)** o variables simples en programación.
- Tienden a crear modelos basados en "una sola gran tabla", con severos problemas de redundancia, celdas con listas de valores separados por comas y falta de claves unívocas.
- El curso acoge a un grupo diverso con distintos ritmos de aprendizaje, incluyendo estudiantes con **Necesidades Educativas Especiales (NEE)**. Por ello, la explicación debe ser precisa, estructurada, visualmente limpia y libre de ambigüedades.

### Gran Meta Formativa del Semestre
1. **Modelado Conceptual (MER)**: Interpretar requerimientos de negocio y diseñar diagramas de Entidad-Relación usando la notación de **Patas de Gallo (Crow's Foot / Barker)** en **Oracle SQL Developer Data Modeler**.
2. **Normalización Rigurosa (3FN)**: Descomponer planillas y modelos defectuosos paso a paso (0FN → 1FN → 2FN → 3FN), eliminando dependencias parciales y transitivas.
3. **Modelo Relacional (MR)**: Transformar el MER normalizado en un esquema relacional con claves primarias (`PK`) y claves foráneas (`FK`) perfectamente definidas.
4. **Dominio de DDL y DML (Nivel Experto 1° Año)**:
   - **DDL**: Crear tablas en Oracle con tipos de datos nativos (`VARCHAR2`, `NUMBER`, `DATE`), claves primarias y foráneas, y restricciones `CHECK` / `UNIQUE` / `NOT NULL`.
   - **DML**: Manipular y consultar datos con precisión: inserciones limpias, actualizaciones y borrados seguros con `WHERE`, y consultas con `INNER JOIN`, `LEFT JOIN`, agrupaciones (`GROUP BY`), filtros agregados (`HAVING`) y ordenamientos (`ORDER BY`).
5. **Visualización en Oracle APEX**: Implementar scripts en el taller de SQL de APEX y construir **Dashboards interactivos** con gráficos y reportes para la toma de decisiones empresariales.

---

## 2. Mapa Curricular y Planificación por Semanas

El semestre se organiza en tres unidades articuladas con las evaluaciones prácticas:

### UNIDAD 1: Introducción y Modelo Conceptual (Semanas 1 a 4) — Meta: EP1 (30%)
*Enfoque: Pasar de la narrativa de negocio a entidades, atributos y relaciones con patas de gallo.*

- **1.1 Introducción a las Bases de Datos y Elementos Conceptuales (Semana 1)**
  - `1.1.1` Introducción a las bases de datos (Conceptos de SGBD, datos vs información).
  - `1.1.2` Elementos de un modelo conceptual (Entidades y ocurrencias).
  - `1.1.3` Taller semana 1.1 — Reconociendo información.
  - `1.1.4` Material Docente: Taller semana 1.1 — Solucionario biblioteca.
  - `1.1.5` Taller semana 1.2 — Identificando entidades.
  - `1.1.6` Material Docente: Taller semana 1.2 — Solucionarios 1 y 2.
  - `1.1.7` Quiz — Base de datos y entidades.
- **1.2 Identificando Atributos de las Entidades (Semana 2)**
  - `1.2.1` PPT: Encontrando atributos de las entidades (Atributos simples, compuestos, obligatorios `*`, opcionales `o`, identificadores `#`).
  - `1.2.2` Taller semana 2 — Identificando atributos de las entidades.
  - `1.2.3` Material Docente: Taller semana 2 — Solucionario.
  - `1.2.4` Quiz — Identificando atributos de las entidades.
- **1.3 Relacionando las Entidades del Modelo (Semana 3)**
  - `1.3.1` Relacionando las entidades del modelo (Cardinalidades 1:1, 1:N, N:M, opcionalidad y obligatoriedad con patas de gallo).
  - `1.3.2` Taller semana 3 — Relacionando las entidades del modelo.
  - `1.3.3` Material Docente: Taller semana 3 — Solucionario caso 01.
  - `1.3.4` Quiz — Relacionando las entidades del modelo.
- **1.4 Extendiendo el Modelo (Semana 4)**
  - `1.4.1` PPT: Extendiendo el modelo (Relaciones de muchos a muchos resueltas con entidades intermedias/asociativas, entidades débiles).
  - `1.4.2` Taller semana 4 — Extendiendo el modelo.
  - `1.4.3` Material Docente: Taller semana 4 — Solucionario caso 01.
- **Evaluación Parcial 1 (EP1 — 30%)**: Ejecución práctica individual en Oracle Data Modeler (Construcción completa de MER conceptual a partir de un caso de negocio).

---

### UNIDAD 2: Normalización y Modelo Relacional (Semanas 6 a 9) — Meta: EP2
*Enfoque: Depuración rigurosa de redundancias hasta 3FN y paso a Modelo Relacional.*

- **2.1 Construyendo un MER Normalizado (Semana 6)**
  - `2.1.1` PPT: Construyendo un MER normalizado (Anomalías de inserción, modificación y borrado).
  - `2.1.2` Taller semana 6 — Normalización (Caso práctico: planillas de solicitud de crédito).
  - `2.1.3` Guía de Inicio en Oracle APEX (Creación de workspace y entorno).
  - `2.1.3` Docente: Normalización Solicitud Crédito C18.
  - `2.1.4` Docente: MER Solicitud Crédito C18.
  - `2.1.5` Docente: Formato Excel de Normalización.
  - `2.1.6` Material complementario.
- **2.2 Ejercicios de MER Normalizado (Semanas 6 y 7)**
  - `2.2.1` Construyendo un MER normalizado (Profundización en dependencias funcionales).
  - `2.2.2` Taller semanas 6 y 7 — Normalización.
  - `2.2` Material Docente y solucionarios.
  - `2.2.6` Material complementario.
- **2.3 Construyendo un Modelo Relacional (MR) Normalizado (Semana 8)**
  - `2.3.1` PPT: Construyendo un MR normalizado (Reglas de transformación de MER a MR: propagación de claves primarias a claves foráneas).
  - `2.3.2` Taller semana 8 — Modelo relacional en Oracle Data Modeler.
  - `2.3` Material Docente.
  - `2.3.4` Material complementario.
- **2.4 Ejercicios Avanzados de Modelo Relacional (Semanas 8 y 9)**
  - `2.4.1` Construyendo un MR normalizado (Casos complejos con claves compuestas y relaciones reflexivas/recursivas).
  - `2.4.2` Taller semanas 8 y 9 — Modelo relacional.
  - `2.4` Material Docente.
  - `2.4.3` Material complementario.
- **Evaluación Parcial 2 (EP2)**: Ejecución práctica individual (Normalización completa de un caso caótico hasta 3FN y generación del Modelo Relacional final).

---

### UNIDAD 3: SQL, DDL, DML y APEX Dashboards (Semanas 10 a 16) — Meta: EP3 (30%)
*Enfoque: Implementación física, consultas avanzadas y visualización ejecutiva.*

- **3.5 Conociendo y Usando APEX (Semana 10)**
  - `3.5.1` PPT: Conociendo y usando APEX (Navegación, SQL Workshop, SQL Commands, Object Browser).
  - `3.5.2` Taller semana 10 — Conociendo y usando APEX.
  - `3.5.3` Quiz — Conociendo y usando APEX.
  - `3.5.4` Material complementario.
- **3.1 Conociendo SQL: Gestión de Tablas DDL (Semana 12)**
  - `3.1.1` PPT: Conociendo SQL. Gestión de tablas (`CREATE TABLE`, tipos Oracle `VARCHAR2`, `NUMBER`, `DATE`, `PRIMARY KEY`, `FOREIGN KEY`, `ALTER TABLE`, `DROP TABLE`).
  - `3.1.2` Taller semana 12 — Gestión de tablas.
  - `3.1.4` Material complementario.
  - `3.1.7` Quiz — Conociendo SQL. Gestión de tablas.
- **3.2 Poblando Tablas de la Base de Datos (Semana 13)**
  - `3.2.1` PPT: Poblando tablas (`INSERT INTO`, `TO_DATE`, `UPDATE` con `WHERE`, `DELETE` con `WHERE`, transacciones `COMMIT` y `ROLLBACK`).
  - `3.2.2` Taller semana 13 — Poblando tablas de la base de datos.
  - `3.2.4` Material complementario.
  - `3.2.7` Quiz — Poblando tablas.
- **3.3 Visualización, Alias, Operaciones Matemáticas y Ordenamiento (Semana 14)**
  - `3.3.1` PPT: Visualizando datos (`SELECT`, proyecciones, alias con `AS`, operadores aritméticos, `ORDER BY ASC/DESC`, `NULLS LAST`).
  - `3.3.2` Taller semana 14 — Visualizando datos.
  - `3.3.4` Material complementario.
  - `3.3.6` Quiz — Visualizando datos.
- **3.4 Restricciones en la Visualización de Datos y Consultas Relacionales (Semana 15)**
  - `3.4.1` PPT: Filtrando datos y JOINs (`WHERE`, `AND`, `OR`, `BETWEEN`, `IN`, `LIKE`, `IS NULL`, `INNER JOIN ... ON`, `LEFT JOIN ... ON`, funciones `COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`).
  - `3.4.2` Taller semana 15 — Filtrando datos.
  - `3.4.4` Material complementario.
  - `3.4.6` Quiz — Filtrando datos.
- **3.6 Dashboard en APEX (Semana 16)**
  - `3.6.1` PPT: Dashboard en APEX (Creación de aplicaciones, componentes de gráficos: barras, líneas, torta basados en consultas SQL con agregaciones).
  - `3.6.2` Taller semana 16 — Dashboard en APEX.
  - `3.6.3` Quiz — Dashboard en APEX.
  - `3.6.4` Material complementario.
- **Evaluación Parcial 3 (EP3 — 30%)**: Ejecución práctica individual (Creación de tablas DDL con restricciones, poblamiento DML, consultas complejas de reportería y montaje de Dashboard interactivo en APEX).

---

## 3. Notación Gráfica: Patas de Gallo en Oracle Data Modeler

Todo material visual de modelado conceptual debe apegarse a la **notación de Patas de Gallo (Barker / Crow's Foot)** que usa Oracle SQL Developer Data Modeler por defecto:

1. **Entidades**:
   - Caja rectangular con nombre en **singular y mayúsculas** (ej. `CLIENTE`, `PRODUCTO`, `VENTA`).
2. **Atributos y Simbología**:
   - `#` : Identificador Único / Clave Primaria (UID).
   - `*` : Atributo obligatorio (`NOT NULL`).
   - `o` : Atributo opcional (puede ser nulo).
3. **Líneas de Relación**:
   - **Línea continua**: Relación obligatoria (participación mandatoria).
   - **Línea punteada**: Relación opcional (participación opcional).
   - **Pata de gallo en el extremo**: Cardinalidad "Muchos" ($N$).
   - **Línea recta simple en el extremo**: Cardinalidad "Uno" ($1$).

---

## 4. Guía Pedagógica para la Normalización (0FN → 3FN)

El aprendizaje de la normalización debe presentarse como la **cura médica a las anomalías de los datos**:

```text
[ Planilla Caótica (0FN) ]
          │  (Eliminar grupos repetitivos y celdas no atómicas; definir PK)
          ▼
[ 1° Forma Normal (1FN) ]
          │  (Eliminar dependencias parciales de PK compuestas)
          ▼
[ 2° Forma Normal (2FN) ]
          │  (Eliminar dependencias transitivas entre atributos no clave)
          ▼
[ 3° Forma Normal (3FN) ]  ───>  Modelo Relacional Óptimo
```

### Reglas para Explicar cada Forma Normal

1. **0FN a 1FN**:
   - *Problema*: Celda con múltiples valores (ej. "Teléfonos: 91111111, 92222222") o columnas repetidas (`hijo1`, `hijo2`, `hijo3`).
   - *Solución*: Cada celda contiene un único valor indivisible (atómico) y cada fila se identifica con una Clave Primaria unívoca.
2. **1FN a 2FN**:
   - *Condición previa*: Aplica exclusivamente cuando la **clave primaria es compuesta** (formada por 2 o más columnas).
   - *Problema*: Un atributo depende solo de **una parte** de la clave (dependencia parcial).
   - *Solución*: Mover los atributos que dependen parcialmente a una nueva tabla donde esa parte sea la clave primaria completa.
3. **2FN a 3FN**:
   - *Problema*: Un atributo no clave depende de otro atributo no clave (dependencia transitiva: $PK \to A$ y $A \to B$). Ejemplo: en la tabla `EMPLEADO(id_empleado, nombre, id_departamento, nombre_departamento)`, el `nombre_departamento` depende de `id_departamento`, no directamente de `id_empleado`.
   - *Solución*: Extraer `id_departamento` y `nombre_departamento` a una tabla independiente `DEPARTAMENTO`.

---

## 5. Regla Editorial: Acordeones para Diferencias entre Motores

> [!IMPORTANT]
> **El contenido principal siempre enseña el estándar de Oracle Database.**
> Para evitar confusión cognitiva en estudiantes de primer año, las diferencias con otros motores (PostgreSQL, MySQL, SQL Server) **NUNCA deben interrumpir el flujo del texto principal**.

Deben colocarse obligatoriamente dentro de un acordeón colapsable con la clase `.engine-tip`:

```html
<details class="engine-tip">
  <summary>¿Cómo se hace esto en PostgreSQL o MySQL?</summary>
  <div class="engine-tip-content">
    <p>En <strong>Oracle</strong> la fecha actual del sistema se obtiene con <code>SYSDATE</code>:</p>
    <pre class="code-block"><code class="language-sql">SELECT SYSDATE FROM dual;</code></pre>
    <p>En <strong>PostgreSQL</strong> se utiliza <code>CURRENT_DATE</code> o <code>NOW()</code>, y no se requiere la tabla ficticia <code>dual</code>:</p>
    <pre class="code-block"><code class="language-sql">SELECT NOW();</code></pre>
    <p>En <strong>MySQL</strong> se utiliza <code>CURRENT_TIMESTAMP()</code> o <code>NOW()</code>.</p>
  </div>
</details>
```

---

## 6. Tono y Estilo Docente ("Profe Carlitos")

1. **Directo, profesional y formativo**: Respetar la inteligencia de los alumnos de ingeniería.
2. **Cero frases decorativas o de relleno**:
   - ✗ *"¡Prepárate para adentrarte en el fascinante cosmos de las bases de datos relacionales!"*
   - ✗ *"¡Muy bien hecho! Ahora que eres todo un pro de las entidades..."*
3. **Ejemplos comparativos de redacción**:
   - ✓ *"Una relación de muchos a muchos (N:M) no puede implementarse directamente en el modelo relacional físico; requiere una tabla asociativa con claves foráneas referenciando a ambas entidades maestras."*
   - ✓ *"En Oracle, la función NVL(comision, 0) reemplaza los valores nulos por cero para evitar que los cálculos matemáticos retornen NULL."*

---

## 7. Diseño Universal para el Aprendizaje (DUA)

Todo taller, quiz y presentación debe incorporar los tres principios del DUA:

1. **Múltiples Formas de Representación**:
   - Explicación textual concisa del concepto o regla de negocio.
   - Diagrama visual en notación de patas de gallo o tabla de datos coloreada.
   - Código Oracle SQL DDL/DML real y comentado.
2. **Múltiples Formas de Acción y Expresión**:
   - Actividades interactivas de:
     - Identificar violaciones a 1FN, 2FN o 3FN en tablas dadas.
     - Completar sentencias SQL con `<code-fill>`.
     - Detectar errores de integridad referencial con `<code-error>`.
     - Emparejar términos y conceptos con `<matching-pairs>`.
     - Ordenar el script de creación de tablas maestras e hijas con `<order-steps>`.
3. **Múltiples Formas de Compromiso (Niveles Explícitos)**:
   - **🟢 Base (`level="base"`)**: Identificar entidades, distinguir atributos atómicos, reconocer claves primarias.
   - **🔵 Intermedio (`level="inter"`)**: Aplicar normalización hasta 3FN, definir claves foráneas en DDL, consultas con `INNER JOIN`.
   - **🟣 Avanzado (`level="avanzado"`)**: Resolver relaciones complejas (reflexivas, ternarias), consultas con agregaciones múltiples y filtros `HAVING`, y diseño de dashboards en APEX.
   - Pistas (`hint`) siempre disponibles sin penalización.
