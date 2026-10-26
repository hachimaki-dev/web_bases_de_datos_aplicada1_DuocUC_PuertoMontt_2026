De acuerdo con caso entregado por el docente, el estudiante debe diseñar un modelo conceptual de datos, teniendo en consideración: 

- Representar entidades fuertes y débiles en el modelo conceptual, asociadas al problema planteado.
 
- Representar los atributos de las entidades, opcionales y obligatorios en el modelo conceptual, asociados al problema planteado
 
- Representar los identificadores únicos de las entidades en el modelo conceptual, asociados al problema planteado.
  
- Representar las relaciones y su cardinalidad entre las entidades del modelo conceptual, asociadas al problema planteado.
  
- Representar las relaciones del Modelo Entidad Relación Extendido (MERE) asociadas al problema planteado.
 
- Representar las relaciones (tablas) y sus columnas en el modelo relacional normalizado asociadas al problema planteado.
 
- Representar las claves primarias entre las relaciones del modelo relacional normalizado asociadas al problema planteado.
 
- Representar las claves primarias entre las relaciones del modelo relacional normalizado asociadas al problema planteado.
 
- Representar las claves foráneas entre las relaciones del modelo relacional normalizado asociados al problema planteado.
 

CASO 1: MODELO ENTIDAD RELACIÓN NORMALIZADO (3FN)
Gestión de Patrimonio Forestal, Cosecha y Despacho de Trozas — Forestal Bosques del Sur S.A.

Contexto General y Diagnóstico Operacional:
"Forestal Bosques del Sur S.A." es una compañía del sector silvícola y maderero que administra más de 45.000 hectáreas de plantaciones de *Pinus radiata* (Pino insigne) y *Eucalyptus nitens / globulus* distribuidas en las regiones de Los Ríos y Los Lagos, en el sur de Chile. Su cadena de valor abarca desde el establecimiento y manejo silvícola de rodales, la ejecución de faenas de cosecha mediante empresas contratistas externas, el transporte terrestre de trozas hacia clientes industriales (aserraderos y plantas de celulosa), hasta brigadas de combate para la protección contra incendios forestales.

Diagnóstico y Problemática Actual:
Actualmente, las operaciones se gestionan a través de sistemas desarticulados y procesos manuales con alta vulnerabilidad a errores e inconsistencias:
1. Control de Cosecha Descentralizado: Cada faena es reportada por los jefes de cuadrilla mediante planillas de cálculo (Excel) independientes y heterogéneas. Al no estar conectadas a un repositorio central, se producen discordancias entre el volumen teórico de madera en pie y lo efectivamente cortado en terreno.
2. Despachos en Papel Autocopiativo: La salida de camiones cargados con madera se documenta en talonarios físicos de guías de despacho en papel. El extravío frecuente de copias, la caligrafía ilegible y los errores de digitación posterior provocan retrasos de semanas en la liquidación de pagos a los contratistas y riesgos ante fiscalizaciones tributarias y del Servicio Agrícola y Ganadero.
3. Descontrol de Cargas y Destinos: No existe una validación sistémica que impida sobrecargar los camiones más allá de su capacidad nominal, ni se verifica en tiempo real que el destino de entrega corresponda al contrato comercial pactado.
4. Emergencias y Protección Forestal: Los avisos de focos de incendios y la asignación de recursos se coordinan de forma precaria mediante radiofrecuencia, llamadas telefónicas y cadenas de correos electrónicos, sin un registro auditable de los brigadistas en combate, sus horas efectivas ni el cumplimiento de sus cursos de seguridad.

El Encargo de Ingeniería:
Ante esta situación, la Gerencia de Operaciones y TI de la compañía ha convocado al equipo de ingeniería de datos para diseñar e implementar una arquitectura de datos relacional corporativa. El encargo exige construir el **Modelo Conceptual de Datos utilizando Notación Barker en Oracle SQL Developer Data Modeler** y posteriormente transformarlo al **Modelo Relacional en Tercera Forma Normal (3FN)**. Esta base de datos debe gobernar de manera integrada el patrimonio forestal, los contratos con empresas de servicios, el personal calificado, la trazabilidad de despachos de productos y el historial de emergencias territoriales.

1. Territorio y Predios:
Las regiones se identifican por un Código_Región (número) y tienen un nombre. Las comunas se identifican por un Código_Comuna (número), tienen un nombre y cada comuna pertenece a exactamente una región. Un Predio es una propiedad territorial de la empresa; se identifica por su Rol_Predio (identificador asignado por el SII, ej: '100-1') y registra nombre del predio, superficie total en hectáreas (ha) y la comuna en que se ubica.

2. Rodales y Especies:
Cada predio se divide internamente en uno o más Rodales (sectores homogéneos de plantación). Los rodales se numeran secuencialmente desde 1 dentro de cada predio (por ejemplo, el predio '100-1' tiene su Rodal 1, 2 y 3; y el predio '200-7' también tiene su propio Rodal 1 y 2). Por lo tanto, el número de rodal por sí solo no identifica unívocamente un rodal: la identificación de un rodal requiere obligatoriamente conocer el Rol_Predio al que pertenece junto con su Número_Rodal.
De cada rodal se registra la superficie (ha), el año de plantación, la densidad estimada (árboles/ha; dato opcional que no se conoce en rodales antiguos) y la Especie plantada. Cada rodal tiene una única especie.
Cada Especie se identifica por un Código_Especie y registra nombre común, nombre científico y turno de rotación (años mínimos requeridos de crecimiento desde su plantación para poder ser cosechado).

3. Contratistas y Trabajadores (MERE):
Las faenas y traslados son ejecutados por empresas Contratistas (RUT, razón social, teléfono). De cada Trabajador se registra RUT, nombres, apellidos, fecha de ingreso y la empresa contratista a la que pertenece.
Cada trabajador puede tener a lo más un jefe de cuadrilla (que también es trabajador registrado en el sistema); un jefe puede supervisar a varios trabajadores.
Todo trabajador pertenece exactamente a uno de los siguientes tipos especializados (especialización total y disjunta):
- Motosierrista: registra su número de certificación técnica.
- Operador de Maquinaria: registra la clase de su licencia de conducir.
- Brigadista: registra la fecha de su último curso de combate de incendios.

4. Faenas de Cosecha:
Una Faena de Cosecha se identifica por ID_Faena, se realiza sobre un rodal específico y es ejecutada por una empresa contratista. Registra fecha de inicio, fecha de término (se completa al finalizar la faena, por lo que es opcional mientras la faena está en ejecución) y el método aplicado (Tala rasa o Raleo). Un rodal puede albergar varias faenas a lo largo de los años.

5. Despachos y Destinos:
La madera cosechada se despacha en camiones mediante Guías de Despacho (identificadas por N°_Guía). Cada guía registra su fecha y hora de emisión, la faena de origen de donde proviene la carga, el Camión asignado (identificado por su Patente, capacidad máxima en m³ y contratista dueño) y el conductor responsable. Por norma de seguridad y competencias, el conductor de un despacho debe ser un trabajador de tipo Operador de Maquinaria.
Cada guía se destina obligatoriamente a un único punto de entrega: a un Aserradero (Código_Aserradero, nombre, comuna de ubicación) o a una Planta de Celulosa (Código_Planta, nombre, capacidad en ton/día), nunca a ambos ni a ninguno.

6. Detalle de Carga y Productos:
Una guía transporta uno o varios Productos madereros (identificados por Código_Producto, con descripción como 'Troza aserrable', 'Troza pulpable', etc.). Cada producto aparece como máximo una vez en una misma guía. Para cada producto transportado en la guía se registra: largo en metros (m), número de trozas y volumen total en metros cúbicos (m³).

7. Incendios y Combate:
Cuando se detecta un Incendio forestal (ID_Incendio) dentro de un predio, se registra fecha y hora de detección, fecha y hora de control (desconocida mientras el siniestro sigue activo) y la superficie afectada (ha).
En el combate participan varios brigadistas y un brigadista puede combatir en múltiples incendios. Por cada participación (una por brigadista en un mismo incendio) se registra fecha-hora de llegada y fecha-hora de retiro (esta última opcional mientras el brigadista siga combatiendo en terreno).

Reglas de Negocio Explícitas:
1. El volumen total sumado de los productos de una GUÍA DE DESPACHO no puede superar la capacidad máxima (m³) del CAMIÓN asignado.
2. No se puede iniciar una FAENA DE COSECHA sobre un rodal si la edad del rodal al inicio de la faena (año de inicio de faena − año de plantación) es menor al turno de rotación establecido para su especie.
3. Solo trabajadores especializados de tipo BRIGADISTA pueden registrarse en la participación del combate de un INCENDIO.
4. Solo trabajadores de tipo OPERADOR DE MAQUINARIA pueden registrarse como conductores en una GUÍA DE DESPACHO.
