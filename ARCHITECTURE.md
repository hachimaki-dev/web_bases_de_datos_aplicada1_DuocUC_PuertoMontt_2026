# Arquitectura — Plataforma de Bases de Datos Aplicada 1

Este documento define la arquitectura técnica, la organización de archivos, los componentes reutilizables, los estándares de Oracle y el flujo de trabajo para crear y mantener contenidos en la plataforma de **Bases de Datos Aplicada 1**. Léelo completo antes de agregar o modificar archivos.

---

## 1. Stack Técnico y Herramientas del Curso

### Entorno Web de la Plataforma
- **HTML5 Semántico**: Estructura accesible y compatible con lectores de pantalla.
- **Vue 3 vía CDN**: Reactividad e interactividad declarativa en el cliente, **sin bundlers ni herramientas de compilación** (sin Node.js ni Vite en ejecución).
- **Highlight.js vía CDN**: Resaltado de sintaxis enfocado en **SQL** (`sql.min.js`).
- **CSS Vanilla**: Sistema de diseño con tokens CSS en variables `:root`, sin frameworks pesados (sin Tailwind ni Bootstrap).
- **Autocontención**: Cada archivo `.html` dentro de `contenidos/` es autónomo; enlaza las librerías CDN y los recursos de `shared/` mediante rutas relativas. Funciona abriéndose con doble clic o con Live Server.

### Entorno de Laboratorio y Modelado del Estudiante
- **Motor de Base de Datos Principal**: **Oracle Database** (sintaxis SQL Oracle, tipos de datos nativos como `VARCHAR2`, `NUMBER`, `DATE`, secuencias/identidades y funciones de conversión).
- **Herramienta de Modelado**: **Oracle SQL Developer Data Modeler**.
- **Notación de Diagramas**: **Patas de Gallo (Crow's Foot / Barker)** — notación por defecto en Oracle Data Modeler.
- **Entorno de Consultas y Reportes**: **Oracle APEX (Application Express)** para ejecución de scripts DDL/DML y construcción de Dashboards interactivos.

---

## 2. Componente de Diseño: Acordeón para Diferencias entre Motores

Para no sobrecargar a los estudiantes de 1° año (cuyo foco central es **Oracle**), cualquier sutileza o diferencia técnica con otros motores populares (PostgreSQL, MySQL, SQL Server) **debe presentarse oculta dentro de un acordeón colapsable**.

### Estructura HTML estándar:
```html
<details class="engine-tip">
  <summary>¿Cómo se hace esto en PostgreSQL o MySQL?</summary>
  <div class="engine-tip-content">
    <p>En <strong>Oracle</strong> utilizamos el tipo de dato <code>VARCHAR2(50)</code> y <code>NUMBER(10, 2)</code>.</p>
    <p>En <strong>PostgreSQL</strong> y <strong>MySQL</strong> se utiliza habitualmente <code>VARCHAR(50)</code> y <code>NUMERIC(10, 2)</code> o <code>DECIMAL(10, 2)</code>.</p>
    <pre class="code-block"><code class="language-sql">-- En PostgreSQL:
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);</code></pre>
  </div>
</details>
```

---

## 3. Estructura del Repositorio y Malla de Contenidos

```text
plataforma-bd/
├── ARCHITECTURE.md          # Este documento (arquitectura y guía técnica)
├── CONTENT_GUIDE.md         # Guía pedagógica, tono docente, DUA, 3FN y normas Oracle
├── index.html               # Portal principal con navegación por unidades y evaluaciones
├── shared/                  # Motor y diseño compartido
│   ├── fonts.css            # Tipografías: Inter (cuerpo) y JetBrains Mono (código/SQL)
│   ├── styles.css           # Design system (tokens, layout, engine-tip, DUA)
│   ├── slide-engine.js      # Motor para presentaciones interactivas por diapositivas
│   └── activity-engine.js   # Motor de componentes interactivos de evaluación formativa
└── contenidos/
    ├── 01_modelo_conceptual_mer/              # UNIDAD 1 (Semanas 1 a 4) -> Hacia EP1
    │   ├── 1.1_introduccion_y_entidades/
    │   │   ├── 1.1.1_PPT_Introduccion_Bases_de_Datos.html
    │   │   ├── 1.1.2_Guia_Elementos_Modelo_Conceptual.html
    │   │   ├── 1.1.3_Taller_Semana_1.1_Reconociendo_Informacion.html
    │   │   ├── 1.1.5_Taller_Semana_1.2_Identificando_Entidades.html
    │   │   └── 1.1.7_Quiz_Bases_de_Datos_y_Entidades.html
    │   ├── 1.2_atributos/
    │   │   ├── 1.2.1_PPT_Encontrando_Atributos_Entidades.html
    │   │   ├── 1.2.2_Taller_Semana_2_Identificando_Atributos.html
    │   │   └── 1.2.4_Quiz_Identificando_Atributos.html
    │   ├── 1.3_relaciones/
    │   │   ├── 1.3.1_PPT_Relacionando_Entidades_Modelo.html
    │   │   ├── 1.3.2_Taller_Semana_3_Relacionando_Entidades.html
    │   │   └── 1.3.4_Quiz_Relacionando_Entidades.html
    │   ├── 1.4_extendiendo_modelo/
    │   │   ├── 1.4.1_PPT_Extendiendo_el_Modelo.html
    │   │   └── 1.4.2_Taller_Semana_4_Extendiendo_el_Modelo.html
    │   └── EP1_Pauta_Construccion_MER.html    # Ev Parcial 1 (30%) - Práctica individual
    │
    ├── 02_normalizacion_modelo_relacional/     # UNIDAD 2 (Semanas 6 a 9) -> Hacia EP2
    │   ├── 2.1_mer_normalizado/
    │   │   ├── 2.1.1_PPT_Construyendo_MER_Normalizado.html
    │   │   ├── 2.1.2_Taller_Semana_6_Normalizacion.html
    │   │   └── 2.1.3_Guia_Inicio_APEX.html
    │   ├── 2.2_ejercicios_mer_normalizado/
    │   │   ├── 2.2.1_Guia_Ejercicios_MER_Normalizado.html
    │   │   └── 2.2.2_Taller_Semanas_6_7_Normalizacion.html
    │   ├── 2.3_modelo_relacional_mr/
    │   │   ├── 2.3.1_PPT_Construyendo_MR_Normalizado.html
    │   │   └── 2.3.2_Taller_Semana_8_Modelo_Relacional.html
    │   ├── 2.4_ejercicios_mr/
    │   │   ├── 2.4.1_Guia_Ejercicios_MR_Normalizado.html
    │   │   └── 2.4.2_Taller_Semanas_8_9_Modelo_Relacional.html
    │   └── EP2_Pauta_MER_Normalizado_MR.html  # Ev Parcial 2 - Práctica individual
    │
    ├── 03_sql_apex_dashboards/                # UNIDAD 3 (Semanas 10 a 16) -> Hacia EP3
    │   ├── 3.5_conociendo_apex/               # Semana 10 (Introducción práctica a APEX)
    │   │   ├── 3.5.1_PPT_Conociendo_y_Usando_APEX.html
    │   │   ├── 3.5.2_Taller_Semana_10_Conociendo_APEX.html
    │   │   └── 3.5.3_Quiz_Conociendo_APEX.html
    │   ├── 3.1_sql_gestion_tablas_ddl/        # Semana 12 (CREATE, ALTER, DROP, PK, FK)
    │   │   ├── 3.1.1_PPT_Conociendo_SQL_Gestion_Tablas.html
    │   │   ├── 3.1.2_Taller_Semana_12_Gestion_Tablas.html
    │   │   └── 3.1.7_Quiz_Gestion_Tablas_DDL.html
    │   ├── 3.2_poblando_tablas_dml/           # Semana 13 (INSERT, UPDATE, DELETE)
    │   │   ├── 3.2.1_PPT_Poblando_Tablas_BD.html
    │   │   ├── 3.2.2_Taller_Semana_13_Poblando_Tablas.html
    │   │   └── 3.2.7_Quiz_Poblando_Tablas.html
    │   ├── 3.3_visualizacion_alias_ordenamiento/ # Semana 14 (SELECT, ALIAS, ORDER BY)
    │   │   ├── 3.3.1_PPT_Visualizando_Datos.html
    │   │   ├── 3.3.2_Taller_Semana_14_Visualizando_Datos.html
    │   │   └── 3.3.6_Quiz_Visualizando_Datos.html
    │   ├── 3.4_restricciones_filtros_joins/   # Semana 15 (WHERE, operadores, JOINs)
    │   │   ├── 3.4.1_PPT_Filtrando_Datos.html
    │   │   ├── 3.4.2_Taller_Semana_15_Filtrando_Datos.html
    │   │   └── 3.4.6_Quiz_Filtrando_Datos.html
    │   ├── 3.6_dashboard_apex/                # Semana 16 (Creación de Dashboards)
    │   │   ├── 3.6.1_PPT_Dashboard_en_APEX.html
    │   │   ├── 3.6.2_Taller_Semana_16_Dashboard_APEX.html
    │   │   └── 3.6.3_Quiz_Dashboard_APEX.html
    │   └── EP3_Pauta_Consultas_SQL_Dashboard_APEX.html # Ev Parcial 3 (30%)
    │
    └── actividades/                           # Casos integrados transversales
        └── ACT1_Consultores_de_Datos.html     # Diagnóstico de datos planos y solución
```

---

## 4. Archivos del Sistema Compartido (`shared/`)

### `fonts.css`
Tipografías optimizadas:
- **Inter**: Para párrafos, encabezados, botones e interfaz de usuario.
- **JetBrains Mono**: Para sentencias SQL, esquemas de tablas, nombres de restricciones y bloques de código.

### `styles.css`
Design system completo:
- **Tokens**: Colores claros, bordes, sombras sutiles, acentos pasteles.
- **Componente `.engine-tip`**: Acordeón interactivo para comparar sintaxis entre motores SQL.
- **Componentes DUA**: Indicadores visuales de dificultad (🟢 Base `.tag-base`, 🔵 Intermedio `.tag-inter`, 🟣 Avanzado `.tag-avanzado`).
- **Retroalimentación formativa**: Clases `.correct`, `.incorrect`, `.hint-text`.

### `slide-engine.js`
Controlador para clases expositivas interactivas. API de montaje:
```javascript
SlideEngine.mount('#app', {
  title: '3.1 Conociendo SQL — Gestión de Tablas (DDL)',
  totalSlides: 22
});
```

### `activity-engine.js`
Biblioteca de componentes Vue para verificación inmediata:
- `<quiz-question>`: Alternativas y V/F (identificar formas normales, tipos de clave, cardinalidad).
- `<multi-select>`: Selección múltiple (seleccionar todas las dependencias transitivas o columnas a indexar).
- `<code-error>`: Encontrar errores en scripts DDL o consultas DML de Oracle.
- `<code-fill>`: Rellenar palabras clave (`PRIMARY KEY`, `FOREIGN KEY`, `REFERENCES`, `JOIN ... ON`).
- `<matching-pairs>`: Unir entidades con atributos, o tipos de datos Oracle con su descripción.
- `<order-steps>`: Ordenar el ciclo de vida de creación de tablas o el orden lógico de ejecución de un `SELECT`.

---

## 5. Hitos Evaluativos del Semestre

| Evaluación | Ponderación | Tipo de Entrega | Enfoque Principal |
|---|---|---|---|
| **Ev Parcial 1 (EP1)** | 30% | Ejecución práctica sin presentación | Construcción de MER conceptual en Oracle Data Modeler (entidades, atributos, cardinalidades patas de gallo). |
| **Ev Parcial 2 (EP2)** | Variable / Institucional | Ejecución práctica sin presentación | Construcción de MER Normalizado y paso a Modelo Relacional (MR) cumpliendo 1FN, 2FN y 3FN. |
| **Ev Parcial 3 (EP3)** | 30% | Ejecución práctica sin presentación | Implementación DDL, DML, consultas complejas con JOINs y creación de Dashboard interactivo en Oracle APEX. |

---

## 6. Convenciones de Código SQL para Oracle

1. **Tipos de Datos Oficiales de Oracle**:
   - Texto: `VARCHAR2(n)` (evitar `VARCHAR` plano por compatibilidad histórica de Oracle).
   - Numérico: `NUMBER(p, s)` para enteros y decimales con precisión.
   - Fechas: `DATE` (incluye fecha y hora) o `TIMESTAMP`.
2. **Generación de Claves Primarias**:
   - Usar `NUMBER GENERATED ALWAYS AS IDENTITY` (estándar moderno Oracle 12c+) o secuencias `SEQUENCE` según se indique en la guía.
3. **Nombres de Restricciones**:
   - Siempre nombrar explícitamente las constraints:
     ```sql
     CREATE TABLE producto (
         id_producto NUMBER GENERATED ALWAYS AS IDENTITY,
         nombre_producto VARCHAR2(100) NOT NULL,
         precio_unitario NUMBER(10, 2) NOT NULL,
         CONSTRAINT pk_producto PRIMARY KEY (id_producto),
         CONSTRAINT chk_precio_positivo CHECK (precio_unitario > 0)
     );
     ```
4. **Claves Foráneas**:
   - Nombrar con el prefijo `fk_[tabla_origen]_[tabla_destino]`:
     ```sql
     CONSTRAINT fk_orden_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
     ```
5. **Formateo de Consultas con JOIN**:
   - Siempre usar sintaxis ANSI explícita (`INNER JOIN ... ON`, `LEFT JOIN ... ON`). Prohibir el estilo antiguo de join en el `WHERE` (`FROM tablaA, tablaB WHERE tablaA.id = tablaB.id`).
