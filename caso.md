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



--
forma de resolverlo

Guía de estudio: del enunciado al modelo de datos
1. Comprender el problema antes de diseñar
El caso describe una empresa que necesita centralizar información que actualmente se encuentra repartida entre guías impresas, planillas y correos electrónicos.
El primer paso del analista no es crear tablas. Es identificar qué información necesita administrar el sistema y qué reglas debe respetar.
Una técnica útil de comprensión lectora consiste en realizar tres lecturas con objetivos diferentes.
Primera lectura: comprender el negocio. Lee el texto completo sin diseñar nada. Intenta explicar con tus propias palabras qué hace la empresa y qué problemas quiere resolver.
Segunda lectura: identificar los conceptos importantes. Marca los sustantivos que representan personas, objetos, organizaciones, lugares y acontecimientos. En este caso, aparecen predios, rodales, especies, contratistas, trabajadores, faenas, guías, camiones, productos e incendios, entre otros.
Tercera lectura: extraer reglas. Busca expresiones que indiquen identificación, pertenencia, cantidad, obligatoriedad, exclusividad, temporalidad o restricciones.
Por ejemplo:
Expresión del enunciado	Qué debes investigar
«Se identifica por»	Posible clave primaria o identificador candidato.
«Registra»	Posibles atributos.
«Pertenece a»	Posible relación de pertenencia.
«Se divide en»	Posible relación entre un todo y sus partes.
«Puede tener»	Posible opcionalidad o cardinalidad máxima.
«Varios» o «muchos»	Cardinalidad máxima de una relación.
«Cada» o «exactamente uno»	Restricciones de participación y obligatoriedad.
«Nunca a ambos»	Restricción de exclusividad.
«Mientras está activo»	Atributo opcional condicionado por el estado.
«No puede superar»	Restricción de negocio que debe verificarse.
Esta tabla es una herramienta de lectura, no un traductor automático. La palabra «puede», por ejemplo, no siempre significa lo mismo: puede expresar una relación opcional, una capacidad técnica o simplemente una posibilidad de negocio. Debes interpretar la frase completa.
2. Diferenciar los modelos que vas a construir
En el ejercicio se mezclan varios niveles de modelamiento. Comprender sus diferencias evita muchos errores.
Modelo conceptual

Describe los conceptos del negocio, sus atributos, identificadores y relaciones. Se concentra en qué información existe y cómo se relaciona, sin depender de un motor de base de datos.
Ejemplo: un predio se divide en rodales.


Modelo Entidad-Relación Extendido (MERE)

Incorpora las capacidades del modelo conceptual, como la especialización y la generalización de entidades.
Ejemplo: Trabajador se especializa en Motosierrista, Operador de Maquinaria y Brigadista.


Modelo lógico relacional

Traduce el diseño a relaciones (tablas), columnas, claves primarias, claves foráneas y restricciones de integridad.
Ejemplo: una tabla RODAL cuya clave primaria combina el rol del predio y el número del rodal.


Modelo físico

Define detalles concretos de implementación: tipos de datos Oracle, precisión numérica, restricciones SQL, índices y otras decisiones técnicas.
Ejemplo: NUMBER(12,2), VARCHAR2(100), DATE y restricciones CHECK.


Aunque el enunciado te pide pasar del modelo lógico al MER en Data Modeler, conviene conocer el flujo completo. En un trabajo profesional normalmente se parte del modelo conceptual, se transforma al lógico y luego se genera o ajusta el modelo relacional físico.
Importante: Oracle SQL Developer Data Modeler permite trabajar con modelos lógicos y relacionales y generar uno a partir del otro. No necesitas resolver todo directamente sobre un diagrama físico.
3. Cómo identificar entidades
Una entidad representa un concepto del negocio sobre el cual es necesario conservar información individualizada.
Para decidir si un concepto debe ser una entidad, aplica estas preguntas:
1. ¿Necesitamos guardar información sobre él?
2. ¿Existen múltiples ejemplares que debamos distinguir?
3. ¿Tiene atributos propios?
4. ¿Se relaciona con otras entidades?
5. ¿Necesita identificarse independientemente o forma parte identificable de otra entidad?
Cuantas más respuestas afirmativas obtengas, más probable es que estés ante una entidad. No obstante, no es una regla mecánica: algunos conceptos pueden modelarse como atributos o tablas de referencia, según los requisitos.
En el caso forestal podemos descubrir entidades candidatas a partir de los sustantivos:
Concepto	¿Qué representa?	Análisis inicial
Predio	Una unidad territorial forestal.	Entidad clara.
Rodal	Una unidad de plantación dentro de un predio.	Entidad clara; hay que estudiar su identificación.
Especie	Un tipo de árbol plantado.	Entidad con atributos propios.
Comuna	Una división territorial.	Entidad candidata porque tiene relación con Región y otras entidades.
Región	Una división territorial superior.	Entidad candidata.
Contratista	Una empresa que realiza labores.	Entidad clara.
Trabajador	Una persona que trabaja para un contratista.	Entidad clara.
Faena de Cosecha	Un acontecimiento operativo.	Entidad clara.
Camión	Un vehículo de transporte.	Entidad clara.
Guía de Despacho	Un documento que registra un despacho.	Entidad clara.
Producto	Un tipo de producto transportado.	Entidad clara.
Incendio	Un acontecimiento de protección forestal.	Entidad clara.
Brigadista	Un tipo específico de trabajador.	Probablemente una especialización de Trabajador.
Participación en combate	La intervención de un brigadista en un incendio.	Puede ser una entidad asociativa con atributos propios.
Esta lista todavía no es el modelo definitivo. Por ejemplo, «Motosierrista» no debe convertirse automáticamente en una entidad independiente sin examinar primero la especialización de Trabajador. Del mismo modo, una relación puede necesitar su propia tabla cuando tiene atributos.
Entidad frente a atributo
La diferencia fundamental es si el concepto necesita identidad propia y administración independiente.
Por ejemplo, la comuna de un predio podría parecer un simple atributo. Sin embargo, el enunciado dice que cada comuna pertenece a una región. Esa regla nos revela que Comuna posee una característica y una relación propias.
Si guardáramos únicamente el nombre de la comuna como texto en cada predio, no representaríamos de forma estructurada su pertenencia a una región.
Por eso, en este caso, Comuna y Región son candidatas naturales a entidades.
En cambio, la superficie de un predio es una característica numérica de ese predio, no un objeto que necesite una identidad independiente.
4. Entidades fuertes y débiles
Una entidad fuerte posee un identificador propio que permite distinguir sus instancias sin depender de la clave de otra entidad.
Una entidad débil depende de otra para su identificación. En el modelo conceptual clásico, su identificador se construye con la clave de la entidad propietaria más una clave parcial propia.
El caso contiene una pista especialmente importante:
Un predio se divide en rodales numerados desde 1 dentro del predio; el rodal 2 existe en muchos predios.

¿Por qué esta frase importa?
Porque el número del rodal no identifica globalmente un rodal. Puede haber un rodal 2 en el predio A y otro rodal 2 en el predio B.
La identificación requiere dos elementos:
- El rol del predio.
- El número del rodal dentro de ese predio.
Por lo tanto, el identificador conceptual de Rodal es compuesto: \((Rol\_Predio, Numero\_Rodal)\).
Esto es una señal de que Rodal se modela naturalmente como entidad débil respecto de Predio.
EJEMPLO ILUSTRATIVO
Identificación de rodales
Rol_Predio	Numero_Rodal	Identidad resultante
100-1	2	(100-1, 2)
200-7	2	(200-7, 2)
Ambos rodales tienen número 2, pero son instancias diferentes porque pertenecen a predios distintos.

La consecuencia para el modelo lógico es importante: la tabla RODAL utilizará una clave primaria compuesta por ROL_PREDIO y NUMERO_RODAL. ROL_PREDIO también será una clave foránea hacia PREDIO.
Una advertencia técnica: que una entidad tenga una clave compuesta no significa, por sí solo, que sea débil. La debilidad se determina por su dependencia de identificación. También existen entidades fuertes con claves compuestas.
5. Cómo identificar los atributos y sus tipos de datos
Un atributo describe una propiedad de una entidad. Para extraerlos correctamente, busca información que se registra explícitamente en el enunciado.
Por ejemplo, para Trabajador encontramos RUT, nombres, apellidos y fecha de ingreso. Además, se indica que pertenece a un contratista y puede tener un jefe de cuadrilla.
No todos esos elementos tienen la misma naturaleza:
- RUT, nombres, apellidos y fecha de ingreso son atributos descriptivos.
- El contratista al que pertenece representa una relación con otra entidad.
- El jefe de cuadrilla representa una relación recursiva con Trabajador.
En el modelo lógico, las relaciones terminarán representándose mediante claves foráneas cuando corresponda.
Cómo decidir el tipo de dato
Debes distinguir el significado del dato de su representación técnica. No elijas un tipo de dato únicamente porque el valor parece un número.
Tipo de información	Tipo Oracle habitual	Ejemplo
Identificadores alfanuméricos	VARCHAR2	RUT, patente, rol del predio
Nombres y descripciones	VARCHAR2	Razón social, especie, producto
Fechas	DATE	Fecha de ingreso
Fecha y hora con precisión explícita	TIMESTAMP	Detección de incendio
Cantidades enteras	NUMBER(p,0)	Número de trozas
Superficies y volúmenes	NUMBER(p,s)	Hectáreas, m³
Valores decimales de medición	NUMBER(p,s)	Largo, densidad
p representa la precisión total y s la cantidad de decimales. Son ejemplos de familias de tipos, no una especificación definitiva de tamaños.
Hay dos errores frecuentes que conviene evitar.
Error 1: almacenar el RUT como NUMBER. Un RUT es un identificador, no una cantidad que se calcule aritméticamente. Conviene almacenarlo como texto, conservando el formato acordado para el sistema.
Error 2: usar un tipo entero para todas las mediciones. Una superficie forestal o un volumen pueden requerir decimales. El tipo debe permitir la precisión que exige el negocio.
También recuerda que Oracle DATE almacena fecha y hora hasta el segundo. Si necesitas fracciones de segundo o precisión temporal explícita, puedes usar TIMESTAMP.
¿Qué atributos son obligatorios y cuáles opcionales?
El criterio fundamental es la regla del negocio, no la intuición del diseñador.
Un atributo obligatorio debe tener un valor en el momento en que se registra la información, de acuerdo con las reglas del sistema. En el modelo relacional normalmente se implementa con NOT NULL.
Un atributo opcional puede quedar sin valor cuando se registra la entidad. En Oracle, normalmente se representa con NULL.
Consideremos tres ejemplos del caso:
Atributo	Decisión	Justificación
RUT de Trabajador	Obligatorio	Identifica al trabajador.
Densidad del Rodal	Opcional	El enunciado indica que no se conoce en algunos rodales antiguos.
Fecha de término de Faena	Opcional	Se completa cuando se cierra la faena.
Fecha de control de Incendio	Opcional	Mientras el incendio está activo, se desconoce.
El tercer ejemplo es particularmente importante: una fecha de término desconocida no significa que la faena no exista. Significa que la faena puede encontrarse en ejecución.
Por tanto, no debes inventar una fecha de término, utilizar una fecha ficticia ni guardar automáticamente la fecha actual.
Hay otra distinción esencial: un atributo opcional no es lo mismo que una relación opcional. Un trabajador puede tener un jefe opcional, pero la fecha de ingreso de ese trabajador puede seguir siendo obligatoria.
Un método para documentar cada atributo
Antes de dibujar, crea una ficha de diseño con esta información:
Campo de análisis	Pregunta
Entidad	¿A qué concepto pertenece?
Atributo	¿Qué dato se almacena?
Significado	¿Qué representa?
Tipo lógico	¿Texto, número, fecha o booleano?
Tipo físico	¿VARCHAR2, NUMBER, DATE o TIMESTAMP?
Obligatorio	¿Puede faltar al registrar el objeto?
Identificador	¿Forma parte de una clave candidata?
Regla	¿Existe alguna restricción especial?
No necesitas rellenar todo desde el primer minuto. Lo importante es que aprendas a justificar las decisiones y no a elegirlas por intuición.
6. Cómo descubrir las relaciones y sus cardinalidades
Una relación representa una asociación entre entidades. Para identificarla, busca verbos y expresiones de pertenencia en el enunciado.
Por ejemplo:
- Un predio se divide en rodales.
- Un rodal tiene una especie plantada.
- Un trabajador pertenece a un contratista.
- Una faena se realiza sobre un rodal.
- Una guía tiene un camión y un conductor.
- Un brigadista combate incendios.
Una vez identificada una relación, debes responder tres preguntas:
1. ¿Cuál es la cardinalidad mínima?
2. ¿Cuál es la cardinalidad máxima?
3. ¿En qué sentido se interpreta la relación?
La cardinalidad mínima determina si la participación es opcional u obligatoria. La máxima indica cuántas instancias pueden participar.
Las combinaciones más comunes son:
Cardinalidad	Interpretación
0..1	Ninguna o una instancia.
1..1	Exactamente una instancia.
0..N	Ninguna, una o muchas instancias.
1..N	Una o muchas instancias.
La letra N significa muchos; no representa una cantidad fija.
Ejemplo: Predio y Rodal
El texto dice que un predio se divide en rodales y que cada rodal se identifica dentro de un predio.
La interpretación es:
- Cada Rodal pertenece a un único Predio.
- Un Predio puede tener varios Rodales.
- La existencia de Rodal depende de Predio para su identificación.
Esto sugiere una relación de uno a muchos (1:N), con participación obligatoria de Rodal en la relación. Para afirmar la cardinalidad mínima de Predio, debes comprobar si el enunciado exige que todo predio tenga al menos un rodal. Si no lo especifica, no conviene inventar esa restricción.
Ejemplo: Contratista y Trabajador
El enunciado establece que cada trabajador pertenece a un contratista.
Esto determina que, desde Trabajador hacia Contratista, la relación es obligatoria y de uno a uno por trabajador: cada trabajador tiene exactamente un contratista.
En sentido contrario, un contratista puede tener varios trabajadores. La cantidad mínima de trabajadores por contratista no está expresamente establecida.
Por eso, la lectura prudente es que la relación tiene una cardinalidad máxima de muchos trabajadores por contratista y una cardinalidad máxima de un contratista por trabajador.
Ejemplo: Faena y Rodal
El enunciado establece que una faena se realiza sobre un rodal y que un rodal puede tener varias faenas a lo largo del tiempo.
La relación es 1:N desde Rodal hacia Faena:
- Cada Faena corresponde a un Rodal.
- Un Rodal puede aparecer en varias Faenas.
Esto es importante porque no debes colocar una única columna ID_FAENA en RODAL para representar todas las faenas históricas. Eso impediría registrar varias cosechas sobre el mismo rodal.
Regla fundamental para el modelo relacional
Cuando una relación es 1:N, normalmente la clave foránea se coloca en el lado N.
Por ejemplo:
- PREDIO tiene su clave primaria.
- RODAL incluye la clave de PREDIO como parte de su identificación y como clave foránea.
- FAENA incluye la identificación del RODAL al que corresponde.
En una relación 1:1, la decisión depende de la obligatoriedad, la dependencia y las reglas del negocio.
En una relación N:M, normalmente se crea una tabla asociativa. Veremos dos casos fundamentales: los productos de una guía y los brigadistas que combaten incendios.
7. Las relaciones recursivas
Una relación recursiva aparece cuando una entidad se relaciona consigo misma.
El caso dice que cada trabajador puede tener un jefe de cuadrilla, que también es trabajador.
No necesitas crear una entidad JEFE y otra entidad TRABAJADOR. El jefe es una instancia de la misma entidad Trabajador.
La relación puede interpretarse así:
- Un trabajador puede tener cero o un jefe.
- Un trabajador puede supervisar a varios trabajadores.
- El jefe, cuando existe, debe ser una persona registrada como trabajador.
En el modelo lógico, una solución habitual es incorporar RUT_JEFE en TRABAJADOR como clave foránea que referencia RUT_TRABAJADOR de esa misma tabla.
Además, el modelo puede necesitar reglas adicionales para impedir que una persona sea su propio jefe o para evitar ciclos jerárquicos, según los requisitos de la organización.
8. Relaciones N:M y entidades asociativas
Una relación muchos a muchos aparece cuando varias instancias de una entidad pueden relacionarse con varias instancias de otra.
El caso forestal contiene dos ejemplos muy claros.
Guía de Despacho y Producto
Una guía transporta varios productos y un mismo tipo de producto puede aparecer en diferentes guías.
Además, el enunciado exige registrar, para cada producto de cada guía:
- Largo.
- Número de trozas.
- Volumen.
Estos datos no pertenecen exclusivamente a GUIA ni exclusivamente a PRODUCTO. Describen la participación de un producto concreto en una guía concreta.
Por eso se necesita una entidad asociativa, que podemos llamar DETALLE_GUIA.
La idea es:
GUIA — DETALLE_GUIA — PRODUCTO
DETALLE_GUIA almacena las claves de las dos entidades relacionadas y los atributos propios de esa asociación.
Una decisión de diseño razonable, si cada producto aparece una sola vez por guía, es utilizar la combinación (N_GUIA, CODIGO_PRODUCTO) como clave primaria. Si el negocio permite varias líneas del mismo producto con largos diferentes dentro de una misma guía, se necesitará una clave de línea o una regla adicional para distinguirlas.
Brigadista e Incendio
El enunciado dice que en el combate participan varios brigadistas y que un brigadista puede combatir muchos incendios.
Es otra relación N:M.
Además, cada participación registra hora de llegada y hora de retiro. Por lo tanto, la asociación necesita atributos propios y debe convertirse en una entidad asociativa, por ejemplo PARTICIPACION_COMBATE.
Una posible identificación, cuando solo puede existir una participación por brigadista en cada incendio, es (ID_INCENDIO, RUT_BRIGADISTA). Si se permiten varias participaciones de la misma persona en un mismo incendio, habrá que identificar cada intervención por separado.
La idea general es sencilla: cuando una relación N:M tiene atributos propios, no basta con dibujar una línea; necesitas modelar la asociación como un concepto con información propia.
9. Cómo modelar la especialización del MERE
El Modelo Entidad-Relación Extendido incorpora una capacidad que el modelo ER básico no expresa con la misma riqueza: la especialización y la generalización.
El enunciado establece:
Todo trabajador es exactamente de uno de estos tipos: Motosierrista, Operador de Maquinaria o Brigadista.

Esta frase contiene dos reglas importantes.
Totalidad: todo trabajador debe pertenecer a alguno de los tres subtipos.
Disyunción: un trabajador pertenece exactamente a uno de ellos, no a varios simultáneamente.
En términos de modelamiento, Trabajador es el supertipo y las tres clases de trabajador son subtipos.
TRABAJADOR
RUT, nombres, apellidos, fecha de ingreso

Motosierrista

Número de certificación


Operador de maquinaria

Clase de licencia


Brigadista

Fecha del último curso



Especialización total y disjunta: cada trabajador pertenece a un solo subtipo.

¿Por qué no colocar los tres atributos específicos directamente en TRABAJADOR?
Porque eso permitiría que una fila de trabajador tuviera simultáneamente número de certificación, clase de licencia y fecha de curso de incendios, aunque las reglas indiquen que pertenece a un solo tipo. También generaría muchas columnas vacías y debilitaría la integridad semántica del diseño.
En el modelo relacional, una transformación habitual es crear cuatro tablas:
- TRABAJADOR: los atributos comunes.
- MOTOSIERRISTA: la clave del trabajador y su certificación.
- OPERADOR_MAQUINARIA: la clave del trabajador y su clase de licencia.
- BRIGADISTA: la clave del trabajador y la fecha del último curso.
La clave primaria de cada subtipo es también una clave foránea hacia TRABAJADOR.
Existe una precisión técnica: que las tres tablas de subtipos tengan claves foráneas hacia TRABAJADOR garantiza que no haya subtipos sin trabajador, pero por sí solo no garantiza que todo trabajador pertenezca a exactamente un subtipo. Esa regla de totalidad y disyunción debe controlarse adicionalmente, por ejemplo mediante lógica de aplicación, procedimientos o mecanismos de integridad apropiados.
Esto es especialmente importante porque solo los brigadistas pueden participar en el combate de incendios. Si PARTICIPACION_COMBATE referencia directamente a BRIGADISTA, la estructura del modelo ayuda a impedir que se registre a un trabajador de otro tipo.
10. Exclusividad del destino de una guía
Otro requisito importante del MERE es el destino de cada guía:
Cada guía se destina a un Aserradero o a una Planta de Celulosa, nunca a ambos.

Esta regla no es una relación N:M. Es una restricción de exclusividad: una guía debe tener exactamente uno de esos dos destinos.
Hay varias estrategias de diseño.
Una alternativa sencilla es mantener dos claves foráneas opcionales en GUIA: una hacia ASERRADERO y otra hacia PLANTA_CELULOSA. Debes añadir una restricción que impida que ambas tengan valor nulo y otra que impida que ambas tengan valor simultáneamente. En conjunto, deben garantizar que exactamente una esté informada.
Otra alternativa consiste en crear un supertipo DESTINO y especializarlo en ASERRADERO y PLANTA_CELULOSA. Esto permite que GUIA tenga una única clave foránea hacia DESTINO, aunque exige definir correctamente cómo se representan los identificadores y los subtipos.
La segunda alternativa puede resultar más elegante cuando existen muchos tipos de destinos o atributos compartidos. La primera puede ser más directa para un ejercicio académico de alcance acotado.
No debes confundir «nunca ambos» con «puede elegir cualquiera». El sistema no puede aceptar cero destinos si el enunciado exige que toda guía se destine a uno.
11. Cómo transformar el diseño en un modelo lógico relacional
Una vez identificadas las entidades, sus identificadores y las relaciones, comienza la transformación al modelo lógico.
Las reglas principales son:
Elemento conceptual	Transformación relacional habitual
Entidad fuerte	Una tabla con su clave primaria.
Entidad débil	Una tabla cuya clave suele incluir la clave de su propietaria.
Atributo simple	Una columna.
Atributo compuesto	Se descompone en atributos simples, si corresponde.
Relación 1:N	Una clave foránea en el lado N.
Relación N:M	Una tabla asociativa.
Relación recursiva 1:N	Una clave foránea autorreferenciada.
Especialización	Una tabla para el supertipo y tablas para los subtipos, entre otras estrategias posibles.
Restricción exclusiva	Una restricción de integridad que impida combinaciones no válidas.
Veamos cómo aplicar esas reglas a nuestro caso sin confundir las decisiones conceptuales con las físicas.
A. Tablas de referencia territorial y forestal
PREDIO, RODAL, ESPECIE, COMUNA y REGION son candidatas a formar parte del modelo lógico.
PREDIO almacena su rol, nombre, superficie y referencia a comuna. RODAL registra sus características y se identifica mediante el predio propietario y el número de rodal. ESPECIE almacena el código, nombre común, nombre científico y turno de rotación.
COMUNA se relaciona con REGION, y PREDIO se relaciona con COMUNA. De esta forma no necesitas repetir el nombre de la región en cada predio.
B. Personal y contratistas
CONTRATISTA contiene la información de la empresa. TRABAJADOR contiene los datos comunes de las personas y las relaciones con el contratista y con su jefe.
Los subtipos se representan mediante sus propias tablas, si elegimos la transformación de especialización que acabamos de estudiar.
CAMION se relaciona con CONTRATISTA porque cada camión registra a su contratista propietario.
C. Operaciones de cosecha
FAENA registra su identificador, el rodal sobre el que se ejecuta, el contratista ejecutor, las fechas y el método.
La clave del rodal debe permitir identificarlo inequívocamente, por lo que no basta con almacenar solamente NUMERO_RODAL. Debes conservar los componentes necesarios para referenciar el rodal correcto.
D. Despachos
GUIA registra el documento de despacho, su fecha y hora, el camión, el conductor, el destino y la faena de origen según la interpretación natural del enunciado.
DETALLE_GUIA resuelve la relación entre GUÍA y PRODUCTO y almacena largo, número de trozas y volumen.
E. Protección forestal
INCENDIO registra los datos del siniestro y el predio afectado.
PARTICIPACION_COMBATE vincula los incendios con los brigadistas y registra la llegada y el retiro.
Estas decisiones permiten mantener separadas las características de las entidades de los datos que describen sus asociaciones.
12. Cómo escoger las claves primarias y foráneas
Una clave primaria identifica de forma única cada fila de una tabla. Debe ser única y no puede contener valores nulos.
Una clave foránea referencia una clave primaria o candidata única de otra tabla y garantiza la integridad referencial, según las restricciones definidas.
En el caso, el enunciado proporciona algunos identificadores explícitos: RUT, Rol_Predio, Código_Especie, ID_Faena, Patente, N.º de Guía, Código_Producto e ID_Incendio.
Cuando no especifica un identificador para un concepto, como Comuna o Región, debes tomar una decisión de diseño documentada. Podrías utilizar un código oficial si está definido en los requisitos o incorporar una clave sustituta, como ID_COMUNA. No debes asumir que el nombre de una comuna es globalmente único.
Una clave sustituta es un identificador técnico creado para el modelo, mientras que una clave natural proviene del dominio del negocio.
No es obligatorio crear un identificador artificial para todas las entidades. Si la clave natural es estable y cumple las condiciones requeridas, puede utilizarse directamente.
También debes distinguir una clave primaria de una clave foránea: una columna puede cumplir ambas funciones, como RUT_TRABAJADOR en BRIGADISTA, que identifica la fila del subtipo y referencia al trabajador del que procede.
13. Inventario propuesto de entidades, atributos y claves
Esta es una propuesta de trabajo para el caso. No es la única solución válida, pero sirve como referencia para verificar que has considerado todos los requisitos.
En la siguiente tabla, los atributos marcados con * son identificadores principales o componentes de la clave primaria; (FK) indica una clave foránea. Los atributos marcados como opcionales pueden admitir NULL de acuerdo con las reglas descritas.
Tabla	Atributos principales
REGION	ID_REGION*, nombre
COMUNA	ID_COMUNA*, nombre, ID_REGION (FK)
PREDIO	ROL_PREDIO*, nombre, superficie_ha, ID_COMUNA (FK)
ESPECIE	CODIGO_ESPECIE*, nombre_comun, nombre_cientifico, turno_rotacion
RODAL	ROL_PREDIO* (FK), NUMERO_RODAL*, superficie_ha, anio_plantacion, densidad (opcional), CODIGO_ESPECIE (FK)
CONTRATISTA	RUT*, razon_social, telefono
TRABAJADOR	RUT*, nombres, apellidos, fecha_ingreso, RUT_CONTRATISTA (FK), RUT_JEFE (FK, opcional)
MOTOSIERRISTA	RUT_TRABAJADOR* (FK), numero_certificacion
OPERADOR_MAQUINARIA	RUT_TRABAJADOR* (FK), clase_licencia
BRIGADISTA	RUT_TRABAJADOR* (FK), fecha_ultimo_curso (opcional si el dominio permite que nunca se haya realizado uno)
CAMION	PATENTE*, capacidad_m3, RUT_CONTRATISTA (FK)
FAENA	ID_FAENA*, rodal, contratista, fecha_inicio, fecha_termino (opcional), metodo
ASERRADERO	CODIGO_ASERRADERO*, nombre, ID_COMUNA (FK)
PLANTA_CELULOSA	CODIGO_PLANTA*, nombre, capacidad_ton_dia
PRODUCTO	CODIGO_PRODUCTO*, descripcion
GUIA	NUMERO_GUIA*, fecha_hora, camión, conductor, destino, faena de origen
DETALLE_GUIA	NUMERO_GUIA* (FK), CODIGO_PRODUCTO* (FK), largo_m, numero_trozas, volumen_m3
INCENDIO	ID_INCENDIO*, predio, fecha_hora_deteccion, fecha_hora_control (opcional), superficie_afectada_ha
PARTICIPACION_COMBATE	ID_INCENDIO* (FK), RUT_BRIGADISTA* (FK), hora_llegada, hora_retiro (posiblemente opcional mientras siga activo)
Hay varias decisiones que debes justificar antes de implementar esta propuesta.
Primero, las claves foráneas de FAENA hacia RODAL deben incluir los dos componentes del identificador del rodal. En la tabla resumida aparecen como «rodal» para facilitar la lectura, pero en el modelo físico deben estar representadas las columnas correspondientes.
Segundo, en GUIA las referencias al destino pueden implementarse mediante las dos claves foráneas opcionales y la restricción de exclusividad, o mediante un supertipo DESTINO. Debes escoger una estrategia coherente y mantenerla en todo el modelo.
Tercero, el enunciado no especifica todos los detalles sobre unicidad de nombres, códigos geográficos o formato de teléfono. No debes inventar restricciones únicas que no tengan fundamento.
Cuarto, si el número de certificación, la clase de licencia o la fecha del último curso pueden faltar legítimamente, debes definirlo con claridad. Que un trabajador pertenezca obligatoriamente a un subtipo no significa automáticamente que cada atributo específico de ese subtipo tenga que ser obligatorio, aunque algunos puedan serlo por reglas profesionales externas al enunciado.
14. Normalización: cómo comprobar que el modelo está bien diseñado
La normalización organiza los datos para evitar redundancias, anomalías de actualización y dependencias incorrectas.
En este ejercicio interesa, como mínimo, comprender las tres primeras formas normales.
Primera forma normal (1FN). Cada columna debe contener valores atómicos para el dominio definido, sin listas de valores ni grupos repetitivos dentro de una misma celda.
Por ejemplo, no debes almacenar en una columna de GUIA una lista como «Troza aserrable, Troza pulpable, Troza aserrable» para representar sus productos. Cada producto asociado a la guía debe tener su propio registro en DETALLE_GUIA.
Segunda forma normal (2FN). La tabla debe estar en 1FN y cada atributo no primo debe depender funcionalmente de la clave completa, no de una parte de una clave compuesta.
Imagina una tabla DETALLE_GUIA con clave (NUMERO_GUIA, CODIGO_PRODUCTO). El volumen de esa combinación depende de la guía y del producto dentro de ella. En cambio, la descripción del producto depende de CODIGO_PRODUCTO, no de la clave completa.
Por eso, la descripción debe almacenarse en PRODUCTO y no repetirse en cada detalle.
Tercera forma normal (3FN). La tabla debe estar en 2FN y evitar dependencias transitivas inapropiadas de atributos no clave respecto de la clave.
En el caso territorial, si cada comuna pertenece a una región, la región se determina a partir de la comuna. Guardar el nombre de la región repetidamente en PREDIO generaría redundancia.
Una estructura más adecuada es PREDIO → COMUNA → REGION, representada mediante claves foráneas.
La normalización no consiste en crear la mayor cantidad posible de tablas. Consiste en ubicar cada dato donde corresponde, respetando las dependencias funcionales y las reglas de integridad.
15. Restricciones de negocio: lo que las claves no resuelven por sí solas
Una base de datos puede tener claves primarias y foráneas correctas y aun así permitir información que contradiga el negocio. El caso contiene tres restricciones que debes estudiar por separado.
Restricción 1: volumen de la guía y capacidad del camión.
El volumen total de una guía no puede superar la capacidad del camión asignado.
Conceptualmente:
\[
\sum \text{Volumen de los detalles de la guía}
\leq \text{Capacidad del camión}
\]

Esto requiere sumar varios registros de DETALLE_GUIA y comparar el resultado con CAMION. Una restricción CHECK convencional de Oracle no puede realizar directamente esa suma sobre otras filas y tablas. Debes diseñar una validación apropiada, por ejemplo mediante lógica transaccional de aplicación o mecanismos de base de datos cuidadosamente implementados.
Restricción 2: turno de rotación de la especie.
No se puede iniciar una faena cuando la edad del rodal es menor que el turno de rotación de su especie.
La regla compara tres datos: el año de plantación del rodal, la fecha de inicio de la faena y el turno de la especie.
Es importante utilizar la fecha de inicio para evaluar la edad que tenía el rodal cuando comenzó la faena, y no recalcularla usando la fecha actual cada vez que se consulta el registro histórico. La comparación debe definirse de acuerdo con la precisión temporal y la interpretación que establezca el docente.
Restricción 3: solamente los brigadistas pueden combatir incendios.
Esta regla puede apoyarse estructuralmente haciendo que RUT_BRIGADISTA en PARTICIPACION_COMBATE sea una clave foránea hacia BRIGADISTA, en lugar de referenciar directamente a TRABAJADOR.
Así, la asociación solo admite identificadores que existan en la tabla del subtipo correcto.
También conviene definir restricciones adicionales coherentes con el dominio, como que una fecha de término no sea anterior a la fecha de inicio o que las cantidades físicas no sean negativas. Estas reglas adicionales deben distinguirse de los requisitos explícitos del caso.
16. Resumen de las relaciones que debes representar
Antes de pasar a Data Modeler, prepara un inventario de relaciones. Este es el control que debes utilizar para comprobar que ninguna conexión importante quedó fuera.
Entidades relacionadas	Cardinalidad máxima	Implementación habitual
Región – Comuna	1:N	FK en COMUNA
Comuna – Predio	1:N	FK en PREDIO
Predio – Rodal	1:N	FK compuesta en RODAL; relación identificadora
Especie – Rodal	1:N	FK en RODAL
Contratista – Trabajador	1:N	FK en TRABAJADOR
Trabajador – Trabajador (jefatura)	1:N recursiva	FK autorreferenciada
Contratista – Camión	1:N	FK en CAMION
Rodal – Faena	1:N	FK compuesta en FAENA
Contratista – Faena	1:N	FK en FAENA
Faena – Guía	1:N, según la interpretación de una faena con varios despachos	FK en GUIA
Camión – Guía	1:N	FK en GUIA
Trabajador – Guía (conductor)	1:N	FK en GUIA
Guía – Producto	N:M	DETALLE_GUIA
Guía – Destino	Cada guía tiene exactamente un destino	FK exclusiva o supertipo DESTINO
Predio – Incendio	1:N	FK en INCENDIO
Brigadista – Incendio	N:M	PARTICIPACION_COMBATE
Trabajador – Motosierrista	Especialización	Tabla de subtipo
Trabajador – Operador	Especialización	Tabla de subtipo
Trabajador – Brigadista	Especialización	Tabla de subtipo
Las cardinalidades máximas de esta tabla son una propuesta de lectura del caso. Las cardinalidades mínimas deben establecerse según las reglas expresas del enunciado. Por ejemplo, no debemos imponer que todo contratista tenga obligatoriamente un trabajador o un camión si el texto no lo exige.
Existe otra consideración importante: el enunciado no dice expresamente si una guía debe estar asociada a una faena mediante una referencia directa o si podría existir un despacho sin faena de cosecha. La interpretación más natural es que una guía corresponde a una faena, pero conviene documentar ese supuesto si el docente no lo ha especificado.
17. Cómo llevar el modelo a Oracle SQL Developer Data Modeler
Una vez que hayas resuelto el análisis, puedes pasar al modelamiento visual. Te recomiendo trabajar por fases y no dibujar todas las entidades de una vez.

Fase 1. Preparar el diseño
Documenta entidades, atributos, identificadores, obligatoriedad y reglas de negocio. No empieces por las líneas del diagrama.




Fase 2. Construir el modelo lógico
Crea las entidades y sus atributos, define las claves primarias y representa las relaciones con sus cardinalidades. Incluye la especialización de Trabajador y las entidades asociativas.




Fase 3. Transformar al modelo relacional
Genera o construye el modelo relacional a partir del lógico. Comprueba las tablas resultantes, las claves primarias compuestas, las claves foráneas y las relaciones identificadoras.




Fase 4. Revisar y generar el modelo físico
Asigna tipos de datos Oracle, configura restricciones y comprueba que el diseño pueda generar un DDL coherente.



En el diagrama lógico, revisa especialmente lo siguiente:
- Que RODAL tenga una clave primaria compuesta y una relación identificadora con PREDIO.
- Que FAENA pueda referenciar correctamente un rodal compuesto por dos columnas.
- Que las relaciones N:M hayan sido resueltas mediante tablas asociativas.
- Que los subtipos de TRABAJADOR hereden su identificador correctamente.
- Que GUIA no pueda quedar sin destino ni tener dos destinos simultáneamente.
- Que PARTICIPACION_COMBATE solo admita brigadistas.
- Que las reglas de negocio que involucran sumas, fechas y comparaciones entre tablas estén documentadas, aunque no se expresen todas directamente en el diagrama.
No confundas una relación identificadora con una relación obligatoria cualquiera. Una relación identificadora significa que la clave del padre forma parte de la clave primaria del hijo. Por eso, en RODAL la clave de PREDIO participa en la identificación del rodal.
18. Errores frecuentes y cómo evitarlos
Crear una tabla por cada sustantivo. No todo sustantivo es una entidad. Primero debes determinar si el concepto tiene identidad propia, atributos o reglas que justifiquen su existencia independiente.
Confundir atributo opcional con relación opcional. Que la fecha de control de un incendio sea desconocida no significa que el incendio pueda existir sin un predio asociado.
Olvidar las claves compuestas. Si el rodal se identifica dentro del predio, no puedes referenciarlo usando solo el número de rodal.
Resolver una relación N:M con una sola clave foránea. Si una guía puede contener varios productos y un producto aparecer en muchas guías, necesitas una asociación que permita registrar todas esas combinaciones.
Duplicar atributos para facilitar el diagrama. Guardar en PREDIO el nombre de la región además de la comuna puede producir inconsistencias cuando cambia la información territorial.
Creer que una clave foránea implementa todas las reglas del negocio. Las claves garantizan ciertas relaciones, pero no resuelven automáticamente restricciones como el volumen acumulado, el turno de rotación o la exclusividad de un destino.
Dibujar sin documentar las decisiones. Si decides utilizar identificadores artificiales, permitir valores nulos o elegir una estrategia de especialización, debes poder justificarlo.