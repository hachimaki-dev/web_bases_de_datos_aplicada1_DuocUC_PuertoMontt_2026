-- ============================================================================
-- BASE DE DATOS: LIGA OFICIAL POKÉMON (MODELO 3FN - 10 TABLAS)
-- Motor: Oracle Database 19c / 21c / 23ai
-- Curso: Bases de Datos Aplicada 1 — Duoc UC Sede Puerto Montt
-- ============================================================================

-- Limpieza previa de tablas (incluye las 2 tablas del desafío por si se re-ejecuta):
DROP TABLE retos_gimnasio CASCADE CONSTRAINTS;
DROP TABLE gimnasios CASCADE CONSTRAINTS;
DROP TABLE participaciones_combate CASCADE CONSTRAINTS;
DROP TABLE inventario_entrenador CASCADE CONSTRAINTS;
DROP TABLE combates CASCADE CONSTRAINTS;
DROP TABLE pokemones_capturados CASCADE CONSTRAINTS;
DROP TABLE especies CASCADE CONSTRAINTS;
DROP TABLE entrenadores CASCADE CONSTRAINTS;
DROP TABLE objetos CASCADE CONSTRAINTS;
DROP TABLE arenas CASCADE CONSTRAINTS;
DROP TABLE tipos CASCADE CONSTRAINTS;
DROP TABLE regiones CASCADE CONSTRAINTS;

-- ============================================================================
-- 1. TABLAS CATÁLOGO (SIN CLAVES FORÁNEAS)
-- ============================================================================

CREATE TABLE regiones (
    id                NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo            VARCHAR2(10)  NOT NULL UNIQUE,
    nombre            VARCHAR2(40)  NOT NULL UNIQUE,
    profesor_regional VARCHAR2(50)  NOT NULL,
    generacion        NUMBER(2)     NOT NULL CHECK (generacion BETWEEN 1 AND 9)
);

CREATE TABLE tipos (
    id               NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre           VARCHAR2(30)  NOT NULL UNIQUE,
    categoria_ataque VARCHAR2(20)  NOT NULL CHECK (categoria_ataque IN ('Fisico', 'Especial', 'Mixto')),
    clima_favorable  VARCHAR2(30)  NOT NULL
);

CREATE TABLE arenas (
    id                NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre            VARCHAR2(60)  NOT NULL UNIQUE,
    ciudad            VARCHAR2(50)  NOT NULL,
    superficie        VARCHAR2(20)  NOT NULL CHECK (superficie IN ('Tierra', 'Agua', 'Roca', 'Hielo', 'Sintetico')),
    capacidad_publico NUMBER(6)     NOT NULL CHECK (capacidad_publico > 0)
);

CREATE TABLE objetos (
    id            NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre        VARCHAR2(50)  NOT NULL UNIQUE,
    categoria     VARCHAR2(25)  NOT NULL CHECK (categoria IN ('Pokeball', 'Medicina', 'Combate', 'Baya')),
    precio_tienda NUMBER(6)     NOT NULL CHECK (precio_tienda >= 0),
    es_consumible CHAR(1)       DEFAULT 'S' NOT NULL CHECK (es_consumible IN ('S', 'N'))
);

-- ============================================================================
-- 2. TABLAS DEPENDIENTES (RELACIONES 1:N)
-- ============================================================================

CREATE TABLE entrenadores (
    id               NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    alias_entrenador VARCHAR2(40)  NOT NULL UNIQUE,
    nombre_real      VARCHAR2(80)  NOT NULL,
    edad             NUMBER(2)     NOT NULL CHECK (edad BETWEEN 10 AND 80),
    rango            VARCHAR2(20)  DEFAULT 'Novato' NOT NULL CHECK (rango IN ('Novato', 'Veterano', 'Lider', 'Alto Mando', 'Campeon')),
    pokedolares      NUMBER(8)     DEFAULT 3000 NOT NULL CHECK (pokedolares >= 0),
    medallas         NUMBER(2)     DEFAULT 0 NOT NULL CHECK (medallas BETWEEN 0 AND 16),
    region_id        NUMBER        NOT NULL REFERENCES regiones(id)
);

CREATE TABLE especies (
    id               NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    num_pokedex      NUMBER(4)     NOT NULL UNIQUE CHECK (num_pokedex > 0),
    nombre           VARCHAR2(40)  NOT NULL UNIQUE,
    ataque_base      NUMBER(3)     NOT NULL CHECK (ataque_base BETWEEN 1 AND 255),
    defensa_base     NUMBER(3)     NOT NULL CHECK (defensa_base BETWEEN 1 AND 255),
    velocidad_base   NUMBER(3)     NOT NULL CHECK (velocidad_base BETWEEN 1 AND 255),
    es_legendario    CHAR(1)       DEFAULT 'N' NOT NULL CHECK (es_legendario IN ('S', 'N')),
    tipo_primario_id NUMBER        NOT NULL REFERENCES tipos(id),
    region_origen_id NUMBER        NOT NULL REFERENCES regiones(id)
);

CREATE TABLE pokemones_capturados (
    id            NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    apodo         VARCHAR2(40)  NOT NULL,
    nivel         NUMBER(3)     DEFAULT 5 NOT NULL CHECK (nivel BETWEEN 1 AND 100),
    puntos_salud  NUMBER(3)     NOT NULL CHECK (puntos_salud > 0),
    experiencia   NUMBER(7)     DEFAULT 0 NOT NULL CHECK (experiencia >= 0),
    es_shiny      CHAR(1)       DEFAULT 'N' NOT NULL CHECK (es_shiny IN ('S', 'N')),
    fecha_captura DATE          NOT NULL,
    entrenador_id NUMBER        NOT NULL REFERENCES entrenadores(id),
    especie_id    NUMBER        NOT NULL REFERENCES especies(id)
);

CREATE TABLE combates (
    id                 NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fase_torneo        VARCHAR2(30)  NOT NULL CHECK (fase_torneo IN ('Clasificatoria', 'Octavos de Final', 'Cuartos de Final', 'Semifinal', 'Gran Final')),
    fecha_combate      DATE          NOT NULL,
    duracion_min       NUMBER(3)     NOT NULL CHECK (duracion_min > 0),
    premio_pokedolares NUMBER(7)     NOT NULL CHECK (premio_pokedolares >= 0),
    asistencia_publico NUMBER(6)     DEFAULT 0 NOT NULL CHECK (asistencia_publico >= 0),
    arena_id           NUMBER        NOT NULL REFERENCES arenas(id)
);

-- ============================================================================
-- 3. TABLAS PIVOTE / MUCHOS A MUCHOS (N:M)
-- ============================================================================

CREATE TABLE inventario_entrenador (
    id                NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cantidad          NUMBER(3)     DEFAULT 1 NOT NULL CHECK (cantidad > 0),
    fecha_adquisicion DATE          NOT NULL,
    entrenador_id     NUMBER        NOT NULL REFERENCES entrenadores(id),
    objeto_id         NUMBER        NOT NULL REFERENCES objetos(id)
);

CREATE TABLE participaciones_combate (
    id                  NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dano_infligido      NUMBER(5)     DEFAULT 0 NOT NULL CHECK (dano_infligido >= 0),
    dano_recibido       NUMBER(5)     DEFAULT 0 NOT NULL CHECK (dano_recibido >= 0),
    debilitados_rivales NUMBER(1)     DEFAULT 0 NOT NULL CHECK (debilitados_rivales BETWEEN 0 AND 6),
    gano                CHAR(1)       NOT NULL CHECK (gano IN ('S', 'N')),
    combate_id          NUMBER        NOT NULL REFERENCES combates(id),
    pokemon_id          NUMBER        NOT NULL REFERENCES pokemones_capturados(id)
);

-- ============================================================================
-- 4. POBLAMIENTO DE DATOS (DML - ORACLE GENERA LOS ID AUTOMÁTICAMENTE)
-- ============================================================================

-- 4.1 REGIONES (IDs 1 al 6)
INSERT INTO regiones (codigo, nombre, profesor_regional, generacion) VALUES ('KAN', 'Kanto', 'Profesor Oak', 1);
INSERT INTO regiones (codigo, nombre, profesor_regional, generacion) VALUES ('JOH', 'Johto', 'Profesor Elm', 2);
INSERT INTO regiones (codigo, nombre, profesor_regional, generacion) VALUES ('HOE', 'Hoenn', 'Profesor Abedul', 3);
INSERT INTO regiones (codigo, nombre, profesor_regional, generacion) VALUES ('SIN', 'Sinnoh', 'Profesor Serbal', 4);
INSERT INTO regiones (codigo, nombre, profesor_regional, generacion) VALUES ('TES', 'Teselia', 'Profesora Encina', 5);
INSERT INTO regiones (codigo, nombre, profesor_regional, generacion) VALUES ('KAL', 'Kalos', 'Profesor Cipres', 6);

-- 4.2 TIPOS ELEMENTALES (IDs 1 al 10)
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Fuego', 'Especial', 'Soleado');
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Agua', 'Especial', 'Lluvia');
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Planta', 'Especial', 'Soleado');
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Electrico', 'Especial', 'Tormenta');
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Dragon', 'Mixto', 'Viento Fuerte');
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Psiquico', 'Especial', 'Despejado');
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Roca', 'Fisico', 'Tormenta Arena');
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Acero', 'Fisico', 'Tormenta Arena');
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Lucha', 'Fisico', 'Nublado');
INSERT INTO tipos (nombre, categoria_ataque, clima_favorable) VALUES ('Volador', 'Mixto', 'Viento Fuerte');

-- 4.3 ARENAS DE COMBATE (IDs 1 al 6)
INSERT INTO arenas (nombre, ciudad, superficie, capacidad_publico) VALUES ('Estadio Meseta Anil', 'Meseta Anil', 'Sintetico', 25000);
INSERT INTO arenas (nombre, ciudad, superficie, capacidad_publico) VALUES ('Acuario Celeste', 'Ciudad Celeste', 'Agua', 12000);
INSERT INTO arenas (nombre, ciudad, superficie, capacidad_publico) VALUES ('Coliseo Pirita', 'Ciudad Pirita', 'Roca', 14500);
INSERT INTO arenas (nombre, ciudad, superficie, capacidad_publico) VALUES ('Domo Lavacalda', 'Pueblo Lavacalda', 'Tierra', 9500);
INSERT INTO arenas (nombre, ciudad, superficie, capacidad_publico) VALUES ('Palacio Invernal', 'Ciudad Puntaneva', 'Hielo', 16000);
INSERT INTO arenas (nombre, ciudad, superficie, capacidad_publico) VALUES ('Estadio Luminalia', 'Ciudad Luminalia', 'Sintetico', 32000);

-- 4.4 OBJETOS (IDs 1 al 10)
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Poke Ball', 'Pokeball', 200, 'S');
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Super Ball', 'Pokeball', 600, 'S');
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Ultra Ball', 'Pokeball', 1200, 'S');
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Master Ball', 'Pokeball', 0, 'S');
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Superpocion', 'Medicina', 700, 'S');
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Restaurar Todo', 'Medicina', 3000, 'S');
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Revivir Maximo', 'Medicina', 4000, 'S');
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Restos', 'Combate', 4500, 'N');
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Vidasfera', 'Combate', 5000, 'N');
INSERT INTO objetos (nombre, categoria, precio_tienda, es_consumible) VALUES ('Baya Zidra', 'Baya', 400, 'S');

-- 4.5 ENTRENADORES (IDs 1 al 12 -> region_id 1..6)
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Red', 'Satoshi Tajiri', 19, 'Campeon', 95000, 16, 1);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Blue', 'Shigeru Oak', 19, 'Alto Mando', 72000, 16, 1);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Misty', 'Kasumi Waterflower', 18, 'Lider', 34000, 8, 1);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Brock', 'Takeshi Slate', 21, 'Lider', 31000, 8, 1);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Lance', 'Wataru Dragon', 26, 'Campeon', 88000, 16, 2);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Silver', 'Kamon Giovannison', 17, 'Veterano', 18500, 10, 2);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Steven', 'Daigo Stone', 25, 'Campeon', 120000, 12, 3);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('May', 'Haruka Birch', 15, 'Veterano', 22000, 8, 3);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Cynthia', 'Shirona Master', 27, 'Campeon', 135000, 16, 4);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Barry', 'Jun Palmer', 14, 'Novato', 8500, 5, 4);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('N', 'Natural Harmonia', 20, 'Alto Mando', 64000, 8, 5);
INSERT INTO entrenadores (alias_entrenador, nombre_real, edad, rango, pokedolares, medallas, region_id) VALUES ('Serena', 'Yvonne Gabena', 16, 'Novato', 12500, 4, 6);

-- 4.6 ESPECIES POKÉMON (IDs 1 al 16 -> tipo_primario_id 1..10, region_origen_id 1..6)
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (3, 'Venusaur', 82, 83, 80, 'N', 3, 1);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (6, 'Charizard', 84, 78, 100, 'N', 1, 1);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (9, 'Blastoise', 83, 100, 78, 'N', 2, 1);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (25, 'Pikachu', 55, 40, 90, 'N', 4, 1);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (95, 'Onix', 45, 160, 70, 'N', 7, 1);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (121, 'Starmie', 75, 85, 115, 'N', 2, 1);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (149, 'Dragonite', 134, 95, 80, 'N', 5, 1);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (150, 'Mewtwo', 110, 90, 130, 'S', 6, 1);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (248, 'Tyranitar', 134, 110, 61, 'N', 7, 2);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (249, 'Lugia', 90, 130, 110, 'S', 6, 2);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (257, 'Blaziken', 120, 70, 80, 'N', 1, 3);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (376, 'Metagross', 135, 130, 70, 'N', 8, 3);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (384, 'Rayquaza', 150, 90, 95, 'S', 5, 3);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (445, 'Garchomp', 130, 95, 102, 'N', 5, 4);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (448, 'Lucario', 110, 70, 90, 'N', 9, 4);
INSERT INTO especies (num_pokedex, nombre, ataque_base, defensa_base, velocidad_base, es_legendario, tipo_primario_id, region_origen_id) VALUES (644, 'Zekrom', 150, 120, 90, 'S', 5, 5);

-- 4.7 POKÉMONES CAPTURADOS (IDs 1 al 20 -> entrenador_id 1..12, especie_id 1..16)
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('Sparky', 88, 210, 145000, 'N', TO_DATE('2025-05-12', 'YYYY-MM-DD'), 1, 4);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('Ignis', 84, 285, 132000, 'S', TO_DATE('2025-06-20', 'YYYY-MM-DD'), 1, 2);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('Gaia', 80, 270, 118000, 'N', TO_DATE('2025-07-04', 'YYYY-MM-DD'), 1, 1);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('HydroTank', 82, 290, 125000, 'N', TO_DATE('2025-05-15', 'YYYY-MM-DD'), 2, 3);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('PsychoKing', 78, 265, 110000, 'N', TO_DATE('2026-01-19', 'YYYY-MM-DD'), 2, 8);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('AquaStar', 62, 195, 72000, 'N', TO_DATE('2025-09-10', 'YYYY-MM-DD'), 3, 6);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('RocaViva', 58, 205, 64000, 'N', TO_DATE('2025-08-22', 'YYYY-MM-DD'), 4, 5);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('DracoLord', 85, 310, 138000, 'N', TO_DATE('2025-04-03', 'YYYY-MM-DD'), 5, 7);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('AeroGuard', 80, 300, 120000, 'S', TO_DATE('2026-02-14', 'YYYY-MM-DD'), 5, 10);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('Despot', 66, 240, 82000, 'N', TO_DATE('2026-03-01', 'YYYY-MM-DD'), 6, 9);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('Titanum', 86, 305, 140000, 'S', TO_DATE('2025-03-18', 'YYYY-MM-DD'), 7, 12);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('SkyRuler', 82, 295, 128000, 'N', TO_DATE('2026-04-11', 'YYYY-MM-DD'), 7, 13);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('PyroKick', 64, 215, 76000, 'N', TO_DATE('2026-01-25', 'YYYY-MM-DD'), 8, 11);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('Valkiria', 92, 340, 165000, 'N', TO_DATE('2025-02-09', 'YYYY-MM-DD'), 9, 14);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('AuraFist', 85, 275, 136000, 'S', TO_DATE('2025-11-30', 'YYYY-MM-DD'), 9, 15);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('RushJet', 45, 155, 42000, 'N', TO_DATE('2026-05-08', 'YYYY-MM-DD'), 10, 11);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('VoltBlack', 80, 310, 122000, 'N', TO_DATE('2026-02-28', 'YYYY-MM-DD'), 11, 16);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('Kantobolt', 38, 120, 29000, 'N', TO_DATE('2026-06-15', 'YYYY-MM-DD'), 12, 4);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('AuraJunior', 42, 145, 35000, 'N', TO_DATE('2026-07-01', 'YYYY-MM-DD'), 12, 15);
INSERT INTO pokemones_capturados (apodo, nivel, puntos_salud, experiencia, es_shiny, fecha_captura, entrenador_id, especie_id) VALUES ('Coloso', 70, 250, 91000, 'N', TO_DATE('2026-03-19', 'YYYY-MM-DD'), 4, 9);

-- 4.8 COMBATES (IDs 1 al 8 -> arena_id 1..6)
INSERT INTO combates (fase_torneo, fecha_combate, duracion_min, premio_pokedolares, asistencia_publico, arena_id) VALUES ('Clasificatoria', TO_DATE('2026-08-02', 'YYYY-MM-DD'), 14, 5000, 8200, 4);
INSERT INTO combates (fase_torneo, fecha_combate, duracion_min, premio_pokedolares, asistencia_publico, arena_id) VALUES ('Clasificatoria', TO_DATE('2026-08-03', 'YYYY-MM-DD'), 18, 5000, 11500, 2);
INSERT INTO combates (fase_torneo, fecha_combate, duracion_min, premio_pokedolares, asistencia_publico, arena_id) VALUES ('Octavos de Final', TO_DATE('2026-08-08', 'YYYY-MM-DD'), 22, 10000, 13800, 3);
INSERT INTO combates (fase_torneo, fecha_combate, duracion_min, premio_pokedolares, asistencia_publico, arena_id) VALUES ('Cuartos de Final', TO_DATE('2026-08-12', 'YYYY-MM-DD'), 25, 18000, 15500, 5);
INSERT INTO combates (fase_torneo, fecha_combate, duracion_min, premio_pokedolares, asistencia_publico, arena_id) VALUES ('Cuartos de Final', TO_DATE('2026-08-13', 'YYYY-MM-DD'), 28, 18000, 21000, 1);
INSERT INTO combates (fase_torneo, fecha_combate, duracion_min, premio_pokedolares, asistencia_publico, arena_id) VALUES ('Semifinal', TO_DATE('2026-08-19', 'YYYY-MM-DD'), 34, 35000, 24500, 1);
INSERT INTO combates (fase_torneo, fecha_combate, duracion_min, premio_pokedolares, asistencia_publico, arena_id) VALUES ('Semifinal', TO_DATE('2026-08-20', 'YYYY-MM-DD'), 31, 35000, 29000, 6);
INSERT INTO combates (fase_torneo, fecha_combate, duracion_min, premio_pokedolares, asistencia_publico, arena_id) VALUES ('Gran Final', TO_DATE('2026-08-27', 'YYYY-MM-DD'), 45, 80000, 32000, 6);

-- 4.9 INVENTARIO DE ENTRENADORES (IDs 1 al 16 -> entrenador_id 1..12, objeto_id 1..10)
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (15, TO_DATE('2026-07-01', 'YYYY-MM-DD'), 1, 3);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (8, TO_DATE('2026-07-05', 'YYYY-MM-DD'), 1, 6);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (2, TO_DATE('2026-07-10', 'YYYY-MM-DD'), 1, 9);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (12, TO_DATE('2026-07-02', 'YYYY-MM-DD'), 2, 3);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (5, TO_DATE('2026-07-08', 'YYYY-MM-DD'), 2, 7);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (20, TO_DATE('2026-06-20', 'YYYY-MM-DD'), 3, 2);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (10, TO_DATE('2026-06-22', 'YYYY-MM-DD'), 4, 5);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (6, TO_DATE('2026-07-12', 'YYYY-MM-DD'), 5, 6);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (1, TO_DATE('2026-07-15', 'YYYY-MM-DD'), 5, 4);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (3, TO_DATE('2026-07-18', 'YYYY-MM-DD'), 7, 8);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (10, TO_DATE('2026-07-19', 'YYYY-MM-DD'), 7, 6);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (14, TO_DATE('2026-07-21', 'YYYY-MM-DD'), 8, 10);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (4, TO_DATE('2026-07-22', 'YYYY-MM-DD'), 9, 9);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (9, TO_DATE('2026-07-23', 'YYYY-MM-DD'), 9, 7);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (25, TO_DATE('2026-07-25', 'YYYY-MM-DD'), 10, 1);
INSERT INTO inventario_entrenador (cantidad, fecha_adquisicion, entrenador_id, objeto_id) VALUES (6, TO_DATE('2026-07-26', 'YYYY-MM-DD'), 11, 8);

-- 4.10 PARTICIPACIONES EN COMBATES (IDs 1 al 24 -> combate_id 1..8, pokemon_id 1..20)
-- Combate 1 (Clasificatoria: May vs Barry)
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (840, 410, 2, 'S', 1, 13);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (410, 840, 0, 'N', 1, 16);
-- Combate 2 (Clasificatoria: Misty vs Brock)
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (960, 520, 2, 'S', 2, 6);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (520, 960, 1, 'N', 2, 7);
-- Combate 3 (Octavos: Brock vs Silver)
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1150, 780, 2, 'S', 3, 20);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (780, 1150, 1, 'N', 3, 10);
-- Combate 4 (Cuartos: Blue vs N)
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1320, 980, 2, 'S', 4, 4);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1480, 890, 2, 'S', 4, 5);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1650, 1520, 2, 'N', 4, 17);
-- Combate 5 (Cuartos: Steven vs Lance)
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1740, 1100, 3, 'S', 5, 11);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1290, 950, 1, 'S', 5, 12);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1420, 1580, 2, 'N', 5, 8);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (980, 1450, 0, 'N', 5, 9);
-- Combate 6 (Semifinal: Red vs Blue)
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1890, 1120, 3, 'S', 6, 1);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1640, 1050, 2, 'S', 6, 2);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1310, 1760, 1, 'N', 6, 4);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1220, 1770, 1, 'N', 6, 5);
-- Combate 7 (Semifinal: Cynthia vs Steven)
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (2150, 1180, 3, 'S', 7, 14);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1490, 990, 2, 'S', 7, 15);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1580, 1820, 2, 'N', 7, 11);
-- Combate 8 (Gran Final: Cynthia vs Red)
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (2480, 1420, 4, 'S', 8, 14);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1720, 1310, 2, 'S', 8, 15);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1950, 2100, 2, 'N', 8, 1);
INSERT INTO participaciones_combate (dano_infligido, dano_recibido, debilitados_rivales, gano, combate_id, pokemon_id) VALUES (1680, 2100, 1, 'N', 8, 2);

COMMIT;
