/* ==============================================================================
   CASO 1: MODELO ENTIDAD-RELACIÓN NORMALIZADO (3FN)
   EMPRESA: Forestal Bosques del Sur S.A.
   RDBMS: Oracle Database 21c
   ARQUITECTURA: 20 Tablas en 3FN (Supertipo DESTINO y MERE TRABAJADOR)
   ESTÁNDAR: Duoc UC - Bases de Datos Aplicada 1
   AUTOR: Solución de Ingeniería de Datos
   ============================================================================== */

/* ==============================================================================
   1. LIMPIEZA DE TABLAS PREVIAS (DROP CASCADE)
   ============================================================================== */
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE participacion_combate CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE incendio CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE detalle_guia CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE producto CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE guia_despacho CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE faena_cosecha CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE planta_celulosa CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE aserradero CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE destino CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE camion CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE brigadista CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE operador_maquinaria CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE motosierrista CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE trabajador CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE contratista CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE rodal CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE especie CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE predio CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE comuna CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE region CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

/* ==============================================================================
   2. SUBSISTEMA TERRITORIAL Y SILVÍCOLA (5 TABLAS)
   ============================================================================== */

-- Tabla 1: REGION
CREATE TABLE region (
    id_region     NUMBER(4) GENERATED ALWAYS AS IDENTITY,
    nombre        VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_region PRIMARY KEY (id_region),
    CONSTRAINT un_region_nombre UNIQUE (nombre)
);

COMMENT ON TABLE region IS 'División político-administrativa regional (Los Ríos, Los Lagos, etc.). Cumple 3FN territorial.';
COMMENT ON COLUMN region.id_region IS 'Identificador numérico autoincremental de la región.';
COMMENT ON COLUMN region.nombre IS 'Nombre oficial de la región.';

-- Tabla 2: COMUNA
CREATE TABLE comuna (
    id_comuna     NUMBER(6) GENERATED ALWAYS AS IDENTITY,
    nombre        VARCHAR2(100) NOT NULL,
    id_region     NUMBER(4) NOT NULL,
    CONSTRAINT pk_comuna PRIMARY KEY (id_comuna),
    CONSTRAINT fk_comuna_region FOREIGN KEY (id_region) REFERENCES region(id_region)
);

COMMENT ON TABLE comuna IS 'Comuna perteneciente de forma unívoca a una región. Resuelve dependencia transitiva en PREDIO.';
COMMENT ON COLUMN comuna.id_comuna IS 'Identificador numérico autoincremental de la comuna.';
COMMENT ON COLUMN comuna.nombre IS 'Nombre oficial de la comuna.';
COMMENT ON COLUMN comuna.id_region IS 'Clave foránea hacia REGION.';

-- Tabla 3: PREDIO
CREATE TABLE predio (
    rol_predio          VARCHAR2(20) NOT NULL,
    nombre              VARCHAR2(120) NOT NULL,
    superficie_total_ha NUMBER(10, 2) NOT NULL,
    id_comuna           NUMBER(6) NOT NULL,
    CONSTRAINT pk_predio PRIMARY KEY (rol_predio),
    CONSTRAINT fk_predio_comuna FOREIGN KEY (id_comuna) REFERENCES comuna(id_comuna),
    CONSTRAINT chk_predio_superficie CHECK (superficie_total_ha > 0)
);

COMMENT ON TABLE predio IS 'Propiedad territorial de la empresa identificada por su Rol del SII.';
COMMENT ON COLUMN predio.rol_predio IS 'Rol oficial de avalúo fiscal del SII (ej: 100-1). Clave primaria natural.';
COMMENT ON COLUMN predio.nombre IS 'Nombre del predio forestal (ej: Fundo El Roble).';
COMMENT ON COLUMN predio.superficie_total_ha IS 'Superficie total en hectáreas (ha). Mayor a cero.';
COMMENT ON COLUMN predio.id_comuna IS 'Clave foránea hacia COMUNA.';

-- Tabla 4: ESPECIE
CREATE TABLE especie (
    codigo_especie   NUMBER(6) GENERATED ALWAYS AS IDENTITY,
    nombre_comun     VARCHAR2(80) NOT NULL,
    nombre_cientifico VARCHAR2(100) NOT NULL,
    turno_rotacion   NUMBER(3) NOT NULL,
    CONSTRAINT pk_especie PRIMARY KEY (codigo_especie),
    CONSTRAINT un_especie_nombre_cien UNIQUE (nombre_cientifico),
    CONSTRAINT chk_especie_turno CHECK (turno_rotacion > 0)
);

COMMENT ON TABLE especie IS 'Especies forestales plantadas (Pino insigne, Eucalipto) con su turno de rotación en años.';
COMMENT ON COLUMN especie.codigo_especie IS 'Identificador único de la especie.';
COMMENT ON COLUMN especie.nombre_comun IS 'Nombre común del árbol.';
COMMENT ON COLUMN especie.nombre_cientifico IS 'Nombre científico de la especie.';
COMMENT ON COLUMN especie.turno_rotacion IS 'Años mínimos de crecimiento requeridos antes de cosechar.';

-- Tabla 5: RODAL (Entidad Débil por Identificación de PREDIO)
CREATE TABLE rodal (
    rol_predio       VARCHAR2(20) NOT NULL,
    numero_rodal     NUMBER(5) NOT NULL,
    superficie_ha    NUMBER(10, 2) NOT NULL,
    anio_plantacion  NUMBER(4) NOT NULL,
    densidad         NUMBER(6, 2) NULL,
    codigo_especie   NUMBER(6) NOT NULL,
    CONSTRAINT pk_rodal PRIMARY KEY (rol_predio, numero_rodal),
    CONSTRAINT fk_rodal_predio FOREIGN KEY (rol_predio) REFERENCES predio(rol_predio),
    CONSTRAINT fk_rodal_especie FOREIGN KEY (codigo_especie) REFERENCES especie(codigo_especie),
    CONSTRAINT chk_rodal_numero CHECK (numero_rodal > 0),
    CONSTRAINT chk_rodal_superficie CHECK (superficie_ha > 0),
    CONSTRAINT chk_rodal_anio CHECK (anio_plantacion >= 1900),
    CONSTRAINT chk_rodal_densidad CHECK (densidad IS NULL OR densidad > 0)
);

COMMENT ON TABLE rodal IS 'Unidad homogénea de plantación silvícola. Entidad débil con clave primaria compuesta (rol_predio, numero_rodal).';
COMMENT ON COLUMN rodal.rol_predio IS 'Clave foránea y parte de la PK hacia PREDIO.';
COMMENT ON COLUMN rodal.numero_rodal IS 'Número secuencial interno del rodal dentro del predio (1, 2, ...).';
COMMENT ON COLUMN rodal.superficie_ha IS 'Superficie cultivada del rodal en hectáreas.';
COMMENT ON COLUMN rodal.anio_plantacion IS 'Año de establecimiento de la plantación.';
COMMENT ON COLUMN rodal.densidad IS 'Densidad estimada en árboles/ha. Es opcional (NULL en plantaciones antiguas).';
COMMENT ON COLUMN rodal.codigo_especie IS 'Clave foránea hacia ESPECIE.';

/* ==============================================================================
   3. SUBSISTEMA DE PERSONAL, CONTRATISTAS Y MERE (6 TABLAS)
   ============================================================================== */

-- Tabla 6: CONTRATISTA
CREATE TABLE contratista (
    rut          VARCHAR2(12) NOT NULL,
    razon_social VARCHAR2(150) NOT NULL,
    telefono     VARCHAR2(25) NOT NULL,
    CONSTRAINT pk_contratista PRIMARY KEY (rut)
);

COMMENT ON TABLE contratista IS 'Empresa contratista externa prestadora de servicios de faena y transporte.';
COMMENT ON COLUMN contratista.rut IS 'RUT tributario de la empresa contratista.';
COMMENT ON COLUMN contratista.razon_social IS 'Razón social legal de la empresa.';
COMMENT ON COLUMN contratista.telefono IS 'Teléfono de contacto operacional.';

-- Tabla 7: TRABAJADOR (Supertipo MERE con Relación Recursiva de Jefatura)
CREATE TABLE trabajador (
    rut              VARCHAR2(12) NOT NULL,
    nombres          VARCHAR2(80) NOT NULL,
    apellidos        VARCHAR2(80) NOT NULL,
    fecha_ingreso    DATE NOT NULL,
    rut_contratista  VARCHAR2(12) NOT NULL,
    rut_jefe         VARCHAR2(12) NULL,
    tipo_trabajador  VARCHAR2(25) NOT NULL,
    CONSTRAINT pk_trabajador PRIMARY KEY (rut),
    CONSTRAINT fk_trabajador_contratista FOREIGN KEY (rut_contratista) REFERENCES contratista(rut),
    CONSTRAINT fk_trabajador_jefe FOREIGN KEY (rut_jefe) REFERENCES trabajador(rut),
    CONSTRAINT chk_trabajador_no_auto_jefe CHECK (rut_jefe IS NULL OR rut_jefe <> rut),
    CONSTRAINT chk_tipo_trabajador CHECK (tipo_trabajador IN ('MOTOSIERRISTA', 'OPERADOR_MAQUINARIA', 'BRIGADISTA'))
);

COMMENT ON TABLE trabajador IS 'Supertipo de personal dependiente de un contratista. Incluye relación recursiva opcional de jefatura.';
COMMENT ON COLUMN trabajador.rut IS 'RUT de la persona trabajadora. Clave primaria.';
COMMENT ON COLUMN trabajador.nombres IS 'Nombres del trabajador.';
COMMENT ON COLUMN trabajador.apellidos IS 'Apellidos del trabajador.';
COMMENT ON COLUMN trabajador.fecha_ingreso IS 'Fecha de contratación o ingreso a la faena.';
COMMENT ON COLUMN trabajador.rut_contratista IS 'Clave foránea hacia CONTRATISTA.';
COMMENT ON COLUMN trabajador.rut_jefe IS 'Clave foránea autorreferenciada hacia TRABAJADOR(rut). Opcional para la cúspide jerárquica.';
COMMENT ON COLUMN trabajador.tipo_trabajador IS 'Discriminador de especialización MERE total y disjunta.';

-- Tabla 8: MOTOSIERRISTA (Subtipo MERE)
CREATE TABLE motosierrista (
    rut                  VARCHAR2(12) NOT NULL,
    numero_certificacion VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_motosierrista PRIMARY KEY (rut),
    CONSTRAINT fk_motosierrista_trabajador FOREIGN KEY (rut) REFERENCES trabajador(rut),
    CONSTRAINT un_motosierrista_cert UNIQUE (numero_certificacion)
);

COMMENT ON TABLE motosierrista IS 'Subtipo especializado de trabajador calificado en apeo y motosierra.';
COMMENT ON COLUMN motosierrista.rut IS 'PK y FK simultánea que hereda del supertipo TRABAJADOR.';
COMMENT ON COLUMN motosierrista.numero_certificacion IS 'Número de acreditación técnica de motosierrista.';

-- Tabla 9: OPERADOR_MAQUINARIA (Subtipo MERE)
CREATE TABLE operador_maquinaria (
    rut            VARCHAR2(12) NOT NULL,
    clase_licencia VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_operador_maquinaria PRIMARY KEY (rut),
    CONSTRAINT fk_operador_maq_trabajador FOREIGN KEY (rut) REFERENCES trabajador(rut)
);

COMMENT ON TABLE operador_maquinaria IS 'Subtipo especializado en operación de maquinaria pesada y transporte.';
COMMENT ON COLUMN operador_maquinaria.rut IS 'PK y FK simultánea que hereda del supertipo TRABAJADOR.';
COMMENT ON COLUMN operador_maquinaria.clase_licencia IS 'Clase de licencia de conducir (ej: A4, A5, D).';

-- Tabla 10: BRIGADISTA (Subtipo MERE)
CREATE TABLE brigadista (
    rut                VARCHAR2(12) NOT NULL,
    fecha_ultimo_curso DATE NOT NULL,
    CONSTRAINT pk_brigadista PRIMARY KEY (rut),
    CONSTRAINT fk_brigadista_trabajador FOREIGN KEY (rut) REFERENCES trabajador(rut)
);

COMMENT ON TABLE brigadista IS 'Subtipo especializado de combatiente de incendios forestales.';
COMMENT ON COLUMN brigadista.rut IS 'PK y FK simultánea que hereda del supertipo TRABAJADOR.';
COMMENT ON COLUMN brigadista.fecha_ultimo_curso IS 'Fecha del último curso aprobado en combate de incendios.';

-- Tabla 11: CAMION
CREATE TABLE camion (
    patente         VARCHAR2(10) NOT NULL,
    capacidad_m3    NUMBER(6, 2) NOT NULL,
    rut_contratista VARCHAR2(12) NOT NULL,
    CONSTRAINT pk_camion PRIMARY KEY (patente),
    CONSTRAINT fk_camion_contratista FOREIGN KEY (rut_contratista) REFERENCES contratista(rut),
    CONSTRAINT chk_camion_capacidad CHECK (capacidad_m3 > 0)
);

COMMENT ON TABLE camion IS 'Vehículo de carga terrestre perteneciente a una empresa contratista.';
COMMENT ON COLUMN camion.patente IS 'Placa patente única del camión. Clave primaria.';
COMMENT ON COLUMN camion.capacidad_m3 IS 'Capacidad volumétrica máxima de carga en metros cúbicos (m³).';
COMMENT ON COLUMN camion.rut_contratista IS 'Clave foránea hacia CONTRATISTA propietario.';

/* ==============================================================================
   4. SUBSISTEMA DE DESTINOS INDUSTRIALES (3 TABLAS - SUPERTIPO DESTINO)
   ============================================================================== */

-- Tabla 12: DESTINO (Supertipo de Entrega)
CREATE TABLE destino (
    id_destino   NUMBER(8) GENERATED ALWAYS AS IDENTITY,
    nombre       VARCHAR2(120) NOT NULL,
    tipo_destino VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_destino PRIMARY KEY (id_destino),
    CONSTRAINT chk_destino_tipo CHECK (tipo_destino IN ('ASERRADERO', 'PLANTA_CELULOSA'))
);

COMMENT ON TABLE destino IS 'Supertipo de puntos de entrega industrial para despachos de madera.';
COMMENT ON COLUMN destino.id_destino IS 'Identificador único del destino de carga.';
COMMENT ON COLUMN destino.nombre IS 'Nombre comercial del complejo industrial.';
COMMENT ON COLUMN destino.tipo_destino IS 'Discriminador de subtipo (ASERRADERO o PLANTA_CELULOSA).';

-- Tabla 13: ASERRADERO (Subtipo de DESTINO)
CREATE TABLE aserradero (
    id_destino NUMBER(8) NOT NULL,
    id_comuna  NUMBER(6) NOT NULL,
    CONSTRAINT pk_aserradero PRIMARY KEY (id_destino),
    CONSTRAINT fk_aserradero_destino FOREIGN KEY (id_destino) REFERENCES destino(id_destino),
    CONSTRAINT fk_aserradero_comuna FOREIGN KEY (id_comuna) REFERENCES comuna(id_comuna)
);

COMMENT ON TABLE aserradero IS 'Subtipo de destino industrial correspondiente a aserradero, ubicado en una comuna.';
COMMENT ON COLUMN aserradero.id_destino IS 'PK y FK simultánea que hereda de DESTINO.';
COMMENT ON COLUMN aserradero.id_comuna IS 'Clave foránea hacia COMUNA.';

-- Tabla 14: PLANTA_CELULOSA (Subtipo de DESTINO)
CREATE TABLE planta_celulosa (
    id_destino        NUMBER(8) NOT NULL,
    capacidad_ton_dia NUMBER(10, 2) NOT NULL,
    CONSTRAINT pk_planta_celulosa PRIMARY KEY (id_destino),
    CONSTRAINT fk_planta_destino FOREIGN KEY (id_destino) REFERENCES destino(id_destino),
    CONSTRAINT chk_planta_capacidad CHECK (capacidad_ton_dia > 0)
);

COMMENT ON TABLE planta_celulosa IS 'Subtipo de destino industrial correspondiente a planta de pulpa/celulosa.';
COMMENT ON COLUMN planta_celulosa.id_destino IS 'PK y FK simultánea que hereda de DESTINO.';
COMMENT ON COLUMN planta_celulosa.capacidad_ton_dia IS 'Capacidad de procesamiento industrial en toneladas por día.';

/* ==============================================================================
   5. SUBSISTEMA DE COSECHA Y DESPACHOS (4 TABLAS)
   ============================================================================== */

-- Tabla 15: FAENA_COSECHA
CREATE TABLE faena_cosecha (
    id_faena        NUMBER(8) GENERATED ALWAYS AS IDENTITY,
    rol_predio      VARCHAR2(20) NOT NULL,
    numero_rodal    NUMBER(5) NOT NULL,
    rut_contratista VARCHAR2(12) NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_termino   DATE NULL,
    metodo          VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_faena_cosecha PRIMARY KEY (id_faena),
    CONSTRAINT fk_faena_rodal FOREIGN KEY (rol_predio, numero_rodal) REFERENCES rodal(rol_predio, numero_rodal),
    CONSTRAINT fk_faena_contratista FOREIGN KEY (rut_contratista) REFERENCES contratista(rut),
    CONSTRAINT chk_faena_metodo CHECK (metodo IN ('Tala rasa', 'Raleo')),
    CONSTRAINT chk_faena_fechas CHECK (fecha_termino IS NULL OR fecha_termino >= fecha_inicio)
);

COMMENT ON TABLE faena_cosecha IS 'Faena operativa de cosecha ejecutada sobre un rodal específico.';
COMMENT ON COLUMN faena_cosecha.id_faena IS 'Identificador único de la faena de cosecha.';
COMMENT ON COLUMN faena_cosecha.rol_predio IS 'Componente 1 de FK compuesta hacia RODAL.';
COMMENT ON COLUMN faena_cosecha.numero_rodal IS 'Componente 2 de FK compuesta hacia RODAL.';
COMMENT ON COLUMN faena_cosecha.rut_contratista IS 'Clave foránea hacia CONTRATISTA ejecutor.';
COMMENT ON COLUMN faena_cosecha.fecha_inicio IS 'Fecha de inicio efectivo de la faena.';
COMMENT ON COLUMN faena_cosecha.fecha_termino IS 'Fecha de término. Es opcional (NULL mientras está en ejecución).';
COMMENT ON COLUMN faena_cosecha.metodo IS 'Método silvícola aplicado: Tala rasa o Raleo.';

-- Tabla 16: GUIA_DESPACHO
CREATE TABLE guia_despacho (
    numero_guia         NUMBER(10) NOT NULL,
    fecha_hora_emision  DATE NOT NULL,
    id_faena            NUMBER(8) NOT NULL,
    patente             VARCHAR2(10) NOT NULL,
    rut_conductor       VARCHAR2(12) NOT NULL,
    id_destino          NUMBER(8) NOT NULL,
    CONSTRAINT pk_guia_despacho PRIMARY KEY (numero_guia),
    CONSTRAINT fk_guia_faena FOREIGN KEY (id_faena) REFERENCES faena_cosecha(id_faena),
    CONSTRAINT fk_guia_camion FOREIGN KEY (patente) REFERENCES camion(patente),
    CONSTRAINT fk_guia_conductor FOREIGN KEY (rut_conductor) REFERENCES trabajador(rut),
    CONSTRAINT fk_guia_destino FOREIGN KEY (id_destino) REFERENCES destino(id_destino)
);

COMMENT ON TABLE guia_despacho IS 'Documento tributario y de trazabilidad que ampara el traslado de madera.';
COMMENT ON COLUMN guia_despacho.numero_guia IS 'Número oficial de la guía de despacho. Clave primaria.';
COMMENT ON COLUMN guia_despacho.fecha_hora_emision IS 'Fecha y hora de salida de la carga desde el rodal.';
COMMENT ON COLUMN guia_despacho.id_faena IS 'Clave foránea hacia FAENA_COSECHA de origen.';
COMMENT ON COLUMN guia_despacho.patente IS 'Clave foránea hacia CAMION asignado.';
COMMENT ON COLUMN guia_despacho.rut_conductor IS 'Clave foránea hacia TRABAJADOR (conductor responsable).';
COMMENT ON COLUMN guia_despacho.id_destino IS 'Clave foránea hacia DESTINO (punto único de entrega).';

-- Tabla 17: PRODUCTO
CREATE TABLE producto (
    codigo_producto NUMBER(6) GENERATED ALWAYS AS IDENTITY,
    descripcion     VARCHAR2(120) NOT NULL,
    CONSTRAINT pk_producto PRIMARY KEY (codigo_producto),
    CONSTRAINT un_producto_desc UNIQUE (descripcion)
);

COMMENT ON TABLE producto IS 'Catálogo normalizado de productos madereros en 3FN (evita dependencias parciales en detalle).';
COMMENT ON COLUMN producto.codigo_producto IS 'Identificador único del producto.';
COMMENT ON COLUMN producto.descripcion IS 'Descripción del producto (ej: Troza aserrable, Troza pulpable).';

-- Tabla 18: DETALLE_GUIA (Entidad Asociativa Guía - Producto)
CREATE TABLE detalle_guia (
    numero_guia     NUMBER(10) NOT NULL,
    codigo_producto NUMBER(6) NOT NULL,
    largo_m         NUMBER(6, 2) NOT NULL,
    numero_trozas   NUMBER(6) NOT NULL,
    volumen_m3      NUMBER(8, 2) NOT NULL,
    CONSTRAINT pk_detalle_guia PRIMARY KEY (numero_guia, codigo_producto),
    CONSTRAINT fk_detalle_guia FOREIGN KEY (numero_guia) REFERENCES guia_despacho(numero_guia),
    CONSTRAINT fk_detalle_producto FOREIGN KEY (codigo_producto) REFERENCES producto(codigo_producto),
    CONSTRAINT chk_detalle_largo CHECK (largo_m > 0),
    CONSTRAINT chk_detalle_trozas CHECK (numero_trozas > 0),
    CONSTRAINT chk_detalle_volumen CHECK (volumen_m3 > 0)
);

COMMENT ON TABLE detalle_guia IS 'Entidad asociativa que descompone la relación N:M entre GUIA_DESPACHO y PRODUCTO.';
COMMENT ON COLUMN detalle_guia.numero_guia IS 'Clave foránea y parte de la PK hacia GUIA_DESPACHO.';
COMMENT ON COLUMN detalle_guia.codigo_producto IS 'Clave foránea y parte de la PK hacia PRODUCTO.';
COMMENT ON COLUMN detalle_guia.largo_m IS 'Largo comercial de las trozas en metros.';
COMMENT ON COLUMN detalle_guia.numero_trozas IS 'Cantidad entera de piezas o trozas transportadas.';
COMMENT ON COLUMN detalle_guia.volumen_m3 IS 'Volumen total transportado de ese producto en metros cúbicos.';

/* ==============================================================================
   6. SUBSISTEMA DE PROTECCIÓN FORESTAL Y EMERGENCIAS (2 TABLAS)
   ============================================================================== */

-- Tabla 19: INCENDIO
CREATE TABLE incendio (
    id_incendio             NUMBER(8) GENERATED ALWAYS AS IDENTITY,
    rol_predio              VARCHAR2(20) NOT NULL,
    fecha_hora_deteccion    DATE NOT NULL,
    fecha_hora_control      DATE NULL,
    superficie_afectada_ha  NUMBER(10, 2) NOT NULL,
    CONSTRAINT pk_incendio PRIMARY KEY (id_incendio),
    CONSTRAINT fk_incendio_predio FOREIGN KEY (rol_predio) REFERENCES predio(rol_predio),
    CONSTRAINT chk_incendio_superficie CHECK (superficie_afectada_ha >= 0),
    CONSTRAINT chk_incendio_fechas CHECK (fecha_hora_control IS NULL OR fecha_hora_control >= fecha_hora_deteccion)
);

COMMENT ON TABLE incendio IS 'Registro de siniestros forestales detectados dentro de los predios patrimoniales.';
COMMENT ON COLUMN incendio.id_incendio IS 'Identificador único del incendio.';
COMMENT ON COLUMN incendio.rol_predio IS 'Clave foránea hacia PREDIO territorial donde ocurrió.';
COMMENT ON COLUMN incendio.fecha_hora_deteccion IS 'Momento de primera alerta o detección del fuego.';
COMMENT ON COLUMN incendio.fecha_hora_control IS 'Momento de control del siniestro. Opcional mientras esté activo.';
COMMENT ON COLUMN incendio.superficie_afectada_ha IS 'Superficie de bosque dañada en hectáreas.';

-- Tabla 20: PARTICIPACION_COMBATE (Entidad Asociativa Incendio - Brigadista)
CREATE TABLE participacion_combate (
    id_incendio         NUMBER(8) NOT NULL,
    rut_brigadista      VARCHAR2(12) NOT NULL,
    fecha_hora_llegada  DATE NOT NULL,
    fecha_hora_retiro   DATE NULL,
    CONSTRAINT pk_participacion_combate PRIMARY KEY (id_incendio, rut_brigadista),
    CONSTRAINT fk_part_incendio FOREIGN KEY (id_incendio) REFERENCES incendio(id_incendio),
    CONSTRAINT fk_part_brigadista FOREIGN KEY (rut_brigadista) REFERENCES brigadista(rut),
    CONSTRAINT chk_part_fechas CHECK (fecha_hora_retiro IS NULL OR fecha_hora_retiro >= fecha_hora_llegada)
);

COMMENT ON TABLE participacion_combate IS 'Entidad asociativa entre INCENDIO y BRIGADISTA. FK apunta directamente a BRIGADISTA para asegurar la Regla 3 a nivel de esquema.';
COMMENT ON COLUMN participacion_combate.id_incendio IS 'Clave foránea y parte de la PK hacia INCENDIO.';
COMMENT ON COLUMN participacion_combate.rut_brigadista IS 'Clave foránea y parte de la PK hacia BRIGADISTA(rut).';
COMMENT ON COLUMN participacion_combate.fecha_hora_llegada IS 'Fecha y hora de arribo del combatiente a la línea de fuego.';
COMMENT ON COLUMN participacion_combate.fecha_hora_retiro IS 'Fecha y hora de desmovilización. Opcional mientras siga combatiendo.';

/* ==============================================================================
   7. ÍNDICES DE RENDIMIENTO PARA CLAVES FORÁNEAS (OPTIMIZACIÓN ORACLE)
   ============================================================================== */
CREATE INDEX idx_comuna_region      ON comuna(id_region);
CREATE INDEX idx_predio_comuna      ON predio(id_comuna);
CREATE INDEX idx_rodal_especie      ON rodal(codigo_especie);
CREATE INDEX idx_trab_contratista   ON trabajador(rut_contratista);
CREATE INDEX idx_trab_jefe          ON trabajador(rut_jefe);
CREATE INDEX idx_camion_contratista ON camion(rut_contratista);
CREATE INDEX idx_aserradero_comuna  ON aserradero(id_comuna);
CREATE INDEX idx_faena_rodal        ON faena_cosecha(rol_predio, numero_rodal);
CREATE INDEX idx_faena_contratista  ON faena_cosecha(rut_contratista);
CREATE INDEX idx_guia_faena         ON guia_despacho(id_faena);
CREATE INDEX idx_guia_camion        ON guia_despacho(patente);
CREATE INDEX idx_guia_conductor     ON guia_despacho(rut_conductor);
CREATE INDEX idx_guia_destino       ON guia_despacho(id_destino);
CREATE INDEX idx_det_guia_prod      ON detalle_guia(codigo_producto);
CREATE INDEX idx_incendio_predio    ON incendio(rol_predio);
CREATE INDEX idx_part_brigadista    ON participacion_combate(rut_brigadista);

COMMIT;
