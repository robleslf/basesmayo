-- OPERACIONES IMPLEMENTADAS
USE NUESTRO_ZOOLOGICO;

-- 1) Operación 10 → Añadir un registro de un nuevo empleado y su código de empleado a la tabla de su puesto de trabajo; si el puesto del empleado es VETERINARIO o CUIDADOR, habrá que hacer también la operación 15 o 16 respectivamente a continuación; además hay que añadirle un familiar o vincularle a uno ya existente para tener un contacto al menos, y si es un familiar nuevo, añadir un teléfono a este. También hay que añadir un teléfono al empleado

-- SELECT * FROM EMPLEADO;
-- SELECT * FROM TELEFONO_EMPLEADO;
-- SELECT * FROM VETERINARIO;
-- SELECT * FROM FAMILIAR;
-- SELECT * FROM TELEFONO_FAMILIAR;
-- SELECT * FROM TIENE;


START TRANSACTION;

INSERT INTO EMPLEADO (nombre, apellido_1, direccion, DNI, nº_SS, codigo_empleado_administrador)
VALUES 
	('Wenjuan', 'Guo', 'Rúa das Folerpas', '12365894W', '12552232314', 1);

INSERT INTO TELEFONO_EMPLEADO
VALUES 
	((SELECT MAX(codigo_empleado) FROM EMPLEADO), '987252526');

INSERT INTO FAMILIAR
SET nombre = 'Víctor',
	apellido_1 = 'de los Ríos',
    apellido_2 = 'Campos',
    DNI = '55566623J';

INSERT INTO TIENE
VALUES
	((SELECT MAX(codigo_empleado) FROM EMPLEADO),(SELECT MAX(cod_familiar) FROM FAMILIAR));

INSERT INTO TELEFONO_FAMILIAR
VALUES
	((SELECT MAX(cod_familiar) FROM FAMILIAR), '987125463');

INSERT INTO VETERINARIO
VALUES
	((SELECT MAX(codigo_empleado) FROM EMPLEADO));

INSERT INTO FORMA_VETERINARIO
VALUES
	(3,(SELECT MAX(codigo_empleado) FROM EMPLEADO), CURRENT_DATE(), (DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH)));

COMMIT;

-- 2) Operación 104 → Listar todos los veterinarios del zoo con un campo que indique si están en formación o no, y en caso de que no, cuándo la finalizaron:

-- ES RECOMENDABLE HABER HECHO LA OPERACIÓN ANTERIOR PARA QUE HAYA UN VETERINARIO FORMÁNDOSE ACTUALMENTE Y SE VEA MEJOR EL RESULTADO

-- SELECT * FROM EMPLEADO;
-- SELECT * FROM VETERINARIO;
-- SELECT * FROM FORMA_VETERINARIO;

(SELECT  em.codigo_empleado AS 'Código empleado',
		CONCAT(em.nombre," ",em.apellido_1," ",IFNULL(em.apellido_2,"")) AS 'Nombre veterinario',
        CONCAT('Formación finalizada el ',DATE_FORMAT(fv.fecha_final_formacion, '%d de %M de %Y')) AS 'Estado'
FROM EMPLEADO AS em
JOIN FORMA_VETERINARIO AS fv ON (fv.codigo_empleado_veterinario_principiante = em.codigo_empleado)
WHERE fv.fecha_final_formacion < CURRENT_DATE()
UNION
SELECT  em.codigo_empleado,
		CONCAT(em.nombre," ",em.apellido_1," ",IFNULL(em.apellido_2,"")),
        'En formación'
FROM EMPLEADO AS em
JOIN FORMA_VETERINARIO AS fv ON (fv.codigo_empleado_veterinario_principiante = em.codigo_empleado)
WHERE fv.fecha_final_formacion > CURRENT_DATE())
ORDER BY 2;


-- 3) Operación 26 → Modificar diagnóstico y tratamiento: Si un diagnóstico ha sido erróneo, se debe mantener su diagnóstico en la tabla DIAGNOSTICA para no perder información, pero hay que añadir uno nuevo a dicha tabla y a su vez poner fin a su antiguo tratamiento para iniciar uno nuevo; en las observaciones de ambos tratamientos es aconsejable dejar constancia de esto.

-- SELECT * FROM DIAGNOSTICA;
-- SELECT * FROM TRATAMIENTO;

START TRANSACTION;

INSERT INTO DIAGNOSTICA
VALUES
	(1, 'Fiebre aftosa', NOW(), 3);

UPDATE TRATAMIENTO
SET fecha_fin = NOW(),
	observaciones = 'Diagnóstico érroneo, se puso fin a este tratamiento para dar inicio a uno nuevo'
WHERE cod_tratamiento = 1;


INSERT INTO TRATAMIENTO
SET nombre_afeccion = 'Fiebre aftosa',
	medicamento = 'Aftosil',
    dosis = 150,
    frecuencia = 4,
    observaciones = 'Anteriormente se le había diagnosticado con insomnio erróneamente',
    fecha_inicio = NOW(),
    fecha_fin = DATE_ADD(NOW(), INTERVAL 1 MONTH),
    codigo_animal = 1,
    cod_empleado_veterinario = 3;

COMMIT;





-- 4) Operación 148 → Buscar cuántos ejemplares de una misma especie viven en zonas del mismo tipo:

-- SELECT * FROM ANIMAL;
-- SELECT * FROM ZONA;
-- SELECT * FROM VIVE;

-- Antes de realizar la operación 148, vamos a añadir dos pandas rojos (operación 1), y a cada uno de ellos le vamos a ingresar en una zona diferente, pero ambas de tipo jungla, para comprobar que la operación 148 funciona correctamente:
START TRANSACTION;

INSERT INTO ANIMAL 
SET especie = 'Ailurus fulgens', 
    nombre = 'Maggie', 
    genero = 'Hembra', 
    fecha_de_ingreso = NOW();

INSERT INTO ANIMAL 
SET especie = 'Ailurus fulgens', 
    nombre = 'Lisa', 
    genero = 'Hembra', 
    fecha_de_ingreso = NOW();

INSERT INTO VIVE
VALUES
	((SELECT MAX(codigo_animal)-1 FROM ANIMAL),1,NOW(),NULL),
	((SELECT MAX(codigo_animal) FROM ANIMAL),2,NOW(),NULL);

COMMIT;

-- Y ahora, si ejecutamos la operación 148, vemos que en las diferentes zonas de jungla del zoo viven actualmente dos pandas rojos (Ailurus fulgens).
SELECT  zo.tipo AS 'Tipo de zona',
		an.especie AS 'Especie',
		COUNT(*) AS 'Nº de ejemplares'
FROM ANIMAL AS an
JOIN VIVE AS vi ON (vi.codigo_animal = an.codigo_animal)
JOIN ZONA AS zo ON (vi.codigo_zona = zo.codigo_zona)
WHERE fecha_salida IS NULL
OR fecha_salida > NOW()
GROUP BY zo.tipo, an.especie;
		
		
-- 5) Operación 149 → Obtener las zonas en las que están conviviendo actualmente animales de especies diferentes.

-- SELECT * FROM ANIMAL;
-- SELECT * FROM VIVE;
-- SELECT * FROM ZONA;

-- Para comprobar que funciona la consulta, vamos a añadir a una misma zona (zona 6) tres especies diferentes:
START TRANSACTION;

INSERT INTO ANIMAL (especie,nombre,genero,fecha_de_ingreso)
VALUES
	('Syncerus caffer','Urano','Macho',NOW()),
	('Hippotragus niger','Neptuno','Macho',NOW()),
	('Eudorcas thomsonii','Venus','Hembra',NOW());
    
INSERT INTO VIVE
VALUES
	((SELECT MAX(codigo_animal)-2 FROM ANIMAL),6,NOW(),NULL),
	((SELECT MAX(codigo_animal)-1 FROM ANIMAL),6,NOW(),NULL),
	((SELECT MAX(codigo_animal) FROM ANIMAL),6,NOW(),NULL);

COMMIT;

-- Y ahora la zona 6 aparece entre las zonas en las que conviven actualmente animales de especies diferentes
SELECT  zo.codigo_zona AS 'Código zona',
		zo.tipo AS 'Tipo de zona',
		COUNT(DISTINCT an.especie) AS 'Nº de especies diferentes conviviendo'
FROM ANIMAL AS an
JOIN VIVE AS vi ON (vi.codigo_animal = an.codigo_animal)
JOIN ZONA AS zo ON (vi.codigo_zona = zo.codigo_zona)
WHERE fecha_salida IS NULL
OR fecha_salida > NOW()
GROUP BY vi.codigo_zona
HAVING COUNT(DISTINCT an.especie) > 1;



-- 6) Operación 165 → Contar cuántos veterinarios están a cargo de cada administrador:

-- SELECT * FROM EMPLEADO;
-- SELECT * FROM VETERINARIO;

SELECT ad.codigo_empleado AS 'Código administrador',
		CONCAT(ad.nombre," ",ad.apellido_1," ",IFNULL(ad.apellido_2, '')) AS 'Nombre Administrador',
        COUNT(em.codigo_empleado) AS 'Nº de veterinarios subordinados'
FROM EMPLEADO AS em
JOIN EMPLEADO AS ad ON (em.codigo_empleado_administrador = ad.codigo_empleado)
WHERE em.codigo_empleado = ANY (SELECT ve.codigo_empleado
							FROM VETERINARIO AS ve)
AND em.codigo_empleado_administrador IS NOT NULL  
GROUP BY em.codigo_empleado_administrador
ORDER BY COUNT(em.codigo_empleado) DESC;


-- 7) Operación 146 → Ver qué animales han sufrido un traslado de zona en el último mes

-- SELECT * FROM ANIMAL;
-- SELECT * FROM VIVE;

-- Trasladamos al animal 8 (Joe, la liebre de mar -Aplysia punctata-) de su zona actual a una nueva zona con la fecha de hoy (Operación 150 -Trasladar animal-):
START TRANSACTION;

UPDATE VIVE 
SET fecha_salida = NOW()
WHERE codigo_animal = 8
AND codigo_zona = 4
AND fecha_entrada = '2010-03-18 16:25:56';

INSERT INTO VIVE
VALUES
	(8,1,NOW(),NULL);

COMMIT;

-- Ingresamos un animal nuevo (Miko, Leopardus pardalis) a una zona del zoo por primera vez (no es un traslado de una zona a otra, y por tanto más tarde no debería salirnos como animal trasladado en el último mes):
START TRANSACTION;

INSERT INTO ANIMAL (especie, nombre, genero, fecha_de_ingreso, fecha_de_nacimiento)
VALUES 
	('Leopardus pardalis','Miko','Macho',NOW(),(DATE_SUB(NOW(), INTERVAL 30 MINUTE)));

INSERT INTO VIVE
VALUES 
((SELECT MAX(codigo_animal) FROM ANIMAL),5,NOW(),NULL);

COMMIT;


-- Si quisieramos todos los animales que han sido ingresados en una zona nueva en el último mes:
SELECT an.codigo_animal AS 'Código animal',
		an.nombre AS 'Nombre animal',
        an.especie AS 'Especie'
FROM ANIMAL AS an
WHERE codigo_animal = ANY (SELECT DISTINCT vi.codigo_animal
							FROM VIVE AS vi
                            WHERE TIMESTAMPDIFF(MONTH, vi.fecha_entrada, CURRENT_DATE()) < 1
                            );
-- Y aquí nos saldrían tanto Joe, la liebre de mar, que ha sido trasladado de una zona a otra, como Miko, el ocelote (y si se han ejecutado las operaciones de los ejercicios anteriores, saldrán también los animales que habíamos ingresado para los otros ejemplos).
                            
-- Pero lo que queremos son solo los animales que han sido trasladados de una zona a otra en el último mes (Solamente Joe, la liebre de mar):
SELECT an.codigo_animal AS 'Código animal',
		an.nombre AS 'Nombre animal',
        an.especie AS 'Especie'
FROM ANIMAL AS an
WHERE codigo_animal = ANY (SELECT DISTINCT vi.codigo_animal
							FROM VIVE AS vi
                            WHERE TIMESTAMPDIFF(MONTH, vi.fecha_entrada, CURRENT_DATE()) < 1
                            )
AND codigo_animal = ANY (SELECT DISTINCT vi2.codigo_animal
							FROM VIVE AS vi2
                            WHERE TIMESTAMPDIFF(MONTH, vi2.fecha_salida, CURRENT_DATE()) < 1);



-- 8) Operación 110 → Comprobar si una animal está siguiendo algún tratamiento actualmente

-- Para el ejemplo, vamos a ver si la leona Margarita está siguiendo algún tratamiento:

-- SELECT * FROM ANIMAL;
-- SELECT * FROM TRATAMIENTO;
-- SELECT * FROM DIAGNOSTICA;

-- Creamos un nuevo tratamiento para Margarita que terminará dentro de un mes; antes debe ser diagnosticada (Operación 23).

START TRANSACTION;

INSERT INTO DIAGNOSTICA
VALUES
((SELECT codigo_animal FROM ANIMAL WHERE nombre LIKE 'Margarita' AND especie LIKE 'Panthera Leo'),'Insomnio',NOW(),3);

INSERT INTO TRATAMIENTO (nombre_afeccion,medicamento,dosis,frecuencia,observaciones,fecha_inicio,fecha_fin,codigo_animal,cod_empleado_veterinario)
VALUES
('Insomnio','Focusín',140,8,'Que coma algo antes',NOW(),(DATE_ADD(NOW(), INTERVAL 1 MONTH)), (SELECT codigo_animal FROM ANIMAL WHERE nombre LIKE 'Margarita' AND especie LIKE 'Panthera Leo'),3);

COMMIT;


-- Y ahora buscamos si Margarita está siguiendo actualmente algún tratamiento (ya sabemos que sí):

-- Si queremos ver qué tratamientos sigue actualmente (Operación 151):
SELECT *
FROM TRATAMIENTO AS tr
JOIN ANIMAL AS an ON (an.codigo_animal = tr.codigo_animal)
WHERE an.nombre LIKE 'Margarita'
AND an.especie LIKE 'Panthera leo'
AND tr.fecha_fin > NOW();

-- Si solo queremos saber si sigue algún tratamiento o no:
SELECT IF(COUNT(*) > 0, 'SÍ', 'NO') AS '¿Está tratándose?'
FROM TRATAMIENTO AS tr
JOIN ANIMAL AS an ON (an.codigo_animal = tr.codigo_animal)
WHERE an.nombre LIKE 'Margarita'
AND an.especie LIKE 'Panthera leo'
AND tr.fecha_fin > CURRENT_DATE();

-- Xena no está siguiendo ningún tratamiento:
SELECT IF(COUNT(*) > 0, 'SÍ', 'NO') AS '¿Sigue tratamiento?'
FROM TRATAMIENTO AS tr
JOIN ANIMAL AS an ON (an.codigo_animal = tr.codigo_animal)
WHERE an.nombre LIKE 'Xena'
AND an.especie LIKE 'Canis lupus signatus'
AND tr.fecha_fin > CURRENT_DATE();


-- 8) Operación 153: Obtener una lista con todos los empleados que han tenido contacto con un animal determinado indicando el tipo o tipos de relaciones que han tenido con ellos, junto con un teléfono de contacto (en caso de tener más de un teléfono, seleccionar el más pequeño)

-- En el ejemplo vamos a buscar qué empleados han tenido contacto con Copito de Nieve, el gorila

-- SELECT * FROM VACUNA;
-- SELECT * FROM CUIDA;
-- SELECT * FROM ALIMENTA;
-- SELECT * FROM EMPLEADO;
-- SELECT * FROM TELEFONO_EMPLEADO;

((SELECT em.codigo_empleado AS 'Código empleado',
        CONCAT(em.nombre, " ", em.apellido_1, " ",IFNULL(em.apellido_2,"")) AS 'Empleado',
        (SELECT MIN(tefe.telefono) FROM TELEFONO_EMPLEADO AS tefe WHERE tefe.codigo_empleado = em.codigo_empleado) AS 'Teléfono de contacto',
        'Le vacunó' AS 'Tipo de relación'
FROM ANIMAL AS an
JOIN VACUNA AS va ON (an.codigo_animal = va.codigo_animal)
JOIN EMPLEADO AS em ON (va.codigo_empleado_veterinario = em.codigo_empleado)
WHERE an.nombre LIKE 'Copito de Nieve'
AND an.especie LIKE 'Troglodytes gorilla')
UNION
(SELECT em.codigo_empleado,
        CONCAT(em.nombre, " ", em.apellido_1, " ",IFNULL(em.apellido_2,"")),
        (SELECT MIN(tefe.telefono) FROM TELEFONO_EMPLEADO AS tefe WHERE tefe.codigo_empleado = em.codigo_empleado) AS 'Teléfono de contacto',
        CONCAT('Le trató (',cu.tipo_cuidado,') el día ', DATE_FORMAT(cu.fecha, '%d de %M de %Y a las %H:%i:%s'))
FROM ANIMAL AS an
JOIN CUIDA AS cu ON (an.codigo_animal = cu.codigo_animal)
JOIN EMPLEADO AS em ON (cu.codigo_empleado_cuidador = em.codigo_empleado)
WHERE an.nombre LIKE 'Copito de Nieve'
AND an.especie LIKE 'Troglodytes gorilla')
UNION
(SELECT em.codigo_empleado,
        CONCAT(em.nombre, " ", em.apellido_1, " ",IFNULL(em.apellido_2,"")),
        (SELECT MIN(tefe.telefono) FROM TELEFONO_EMPLEADO AS tefe WHERE tefe.codigo_empleado = em.codigo_empleado) AS 'Teléfono de contacto',
        CONCAT('Le dio de comer el día ', DATE_FORMAT(al.fecha, '%d de %M de %Y a las %H:%i:%s'))
FROM ANIMAL AS an
JOIN ALIMENTA AS al ON (an.codigo_animal = al.codigo_animal)
JOIN EMPLEADO AS em ON (al.codigo_empleado_cuidador = em.codigo_empleado)
WHERE an.nombre LIKE 'Copito de Nieve'
AND an.especie LIKE 'Troglodytes gorilla'))
ORDER BY Empleado;


-- 9) Operación 154 → Ver quiénes son los compañeros que conviven con un animal determinado

-- SELECT * FROM ANIMAL;
-- SELECT * FROM ZONA;
-- SELECT * FROM VIVE;

-- Para ver bien esta consulta es recomendable haber agregado los animales del ejercicio 5 (Urano, Neptuno y Venus), que estarían conviviendo actualmente, y agregar un animal más a esa zona 6 (operación 150), pero ajustarle el valor en fecha_salida a una fecha anterior a la actual, para que a día de hoy ya no fuese compañero de los otros tres y se vea la diferencia entre animales que conviven actualmente y animales que vivieron en la zona del animal pero a día de hoy ya no viven ahí. En este ejemplo trasladamos al animal 1 a la zona 6 pero diciéndo que la abandonó en 2006 (Operación 150 -Trasladar animal-).

START TRANSACTION;

UPDATE VIVE
SET fecha_salida = '2000-08-03 12:20:55'
WHERE codigo_animal = 1
AND codigo_zona = 1 
AND fecha_entrada = '1999-06-30 13:14:04';

INSERT INTO VIVE
VALUES
	(1,6,'2000-08-03 12:22:55','2006-08-03 12:20:55');
    
COMMIT;


-- Ahora si buscamos quiénes son los compañeros de Urano, solo deberían salir Neptuno y Venus, que son los que viven actualmente con él.
SELECT com.nombre AS 'Nombre',
		com.especie AS 'Especie'
FROM ANIMAL AS com
JOIN VIVE AS vi ON (com.codigo_animal = vi.codigo_animal)
WHERE vi.codigo_zona = (SELECT vi.codigo_zona
						FROM VIVE AS vi
                        WHERE vi.codigo_animal = (SELECT an.codigo_animal
													FROM ANIMAL AS an
                                                    WHERE an.nombre LIKE 'Urano'
                                                    AND an.codigo_animal != com.codigo_animal))
AND (vi.fecha_salida > NOW()
OR vi.fecha_salida IS NULL);


-- 10) Operación 123 → Hacer una lista con todo los números de teléfono registrados en la base de datos y el nombre completo de la persona a la que pertenece cada uno, así como un campo que identifique quién es esa persona:

-- SELECT * FROM CLIENTE;
-- SELECT * FROM EMPLEADO;
-- SELECT * FROM FAMILIAR;
-- SELECT * FROM TELEFONO_EMPLEADO;
-- SELECT * FROM TELEFONO_CLIENTE;
-- SELECT * FROM TELEFONO_FAMILIAR;


((SELECT tel.telefono AS 'Teléfono',
		CONCAT(em.nombre," ",em.apellido_1," ",IFNULL(em.apellido_2,"")) AS 'Nombre',
        'Veterinario/a' AS '¿Quién es?'
FROM EMPLEADO AS em
JOIN TELEFONO_EMPLEADO AS tel ON (em.codigo_empleado = tel.codigo_empleado)
WHERE em.codigo_empleado = ANY (SELECT vet.codigo_empleado
								FROM VETERINARIO AS vet))
UNION
(SELECT tel.telefono,
		CONCAT(em.nombre," ",em.apellido_1," ",IFNULL(em.apellido_2,"")),
        'Administrador/a'
FROM EMPLEADO AS em
JOIN TELEFONO_EMPLEADO AS tel ON (em.codigo_empleado = tel.codigo_empleado)
WHERE em.codigo_empleado = ANY (SELECT ad.codigo_empleado
								FROM ADMINISTRADOR AS ad))
UNION
(SELECT tel.telefono,
		CONCAT(em.nombre," ",em.apellido_1," ",IFNULL(em.apellido_2,"")),
        'Cajero/a'
FROM EMPLEADO AS em
JOIN TELEFONO_EMPLEADO AS tel ON (em.codigo_empleado = tel.codigo_empleado)
WHERE em.codigo_empleado = ANY (SELECT caj.codigo_empleado
								FROM CAJERO AS caj))
UNION
(SELECT tel.telefono,
		CONCAT(em.nombre," ",em.apellido_1," ",IFNULL(em.apellido_2,"")),
        'Cuidador'
FROM EMPLEADO AS em
JOIN TELEFONO_EMPLEADO AS tel ON (em.codigo_empleado = tel.codigo_empleado)
WHERE em.codigo_empleado = ANY (SELECT cui.codigo_empleado
								FROM CUIDADOR AS cui))
UNION
(SELECT tel.telefono,
		CONCAT(em.nombre," ",em.apellido_1," ",IFNULL(em.apellido_2,"")),
        'Empleado/a de mantenimiento'
FROM EMPLEADO AS em
JOIN TELEFONO_EMPLEADO AS tel ON (em.codigo_empleado = tel.codigo_empleado)
WHERE em.codigo_empleado = ANY (SELECT man.codigo_empleado
								FROM VETERINARIO AS man))
UNION
(SELECT telf.telefono,
		CONCAT(fa.nombre," ",fa.apellido_1," ",IFNULL(fa.apellido_2,"")),
        CONCAT('Familiar de ',em.nombre,' ',em.apellido_1,' ',IFNULL(em.apellido_2,''))
FROM FAMILIAR AS fa
JOIN TELEFONO_FAMILIAR AS telf ON (fa.cod_familiar = telf.cod_familiar)
JOIN TIENE AS ti ON (ti.cod_familiar = fa.cod_familiar)
JOIN EMPLEADO AS em ON (em.codigo_empleado = ti.codigo_empleado))
UNION
(SELECT telc.telefono,
		CONCAT(cl.nombre," ",cl.apellido_1," ",IFNULL(cl.apellido_2,"")),
        'Cliente'
FROM CLIENTE AS cl
JOIN TELEFONO_CLIENTE AS telc ON (cl.cod_cliente = telc.cod_cliente)))
ORDER BY 2;

/* 
Con la consulta a la tabla FAMILIAR se está haciendo un JOIN para que en el campo '¿Quién es?' aparezca el nombre del empleado del que es familiar, y esto hace que si hay más de un familiar, como el caso de María Ruano Nicolás y Paula Ruano Nicolás, el número de teléfono y el familiar se dupliquen.

Si no se quieren duplicados se puede cambiar simplemente por esto, aunque solamente saldrá que es familiar sin especificar de quién:

(SELECT telf.telefono,
		CONCAT(fa.nombre," ",fa.apellido_1," ",IFNULL(fa.apellido_2,"")),
        'Familiar'
FROM FAMILIAR AS fa
JOIN TELEFONO_FAMILIAR AS telf ON (fa.cod_familiar = telf.cod_familiar))
*/ 



   
-- 11) Operación 156 → Ver qué animales siguen una dieta rica en fibra
   
-- SELECT * FROM ALIMENTA;
-- SELECT * FROM TIPO;
-- SELECT * FROM ANIMAL;

SELECT codigo_animal AS 'Código animal',
		nombre AS 'Nombre animal',
        especie AS 'Especie'
FROM ANIMAL 
WHERE codigo_animal IN (SELECT DISTINCT codigo_animal
						FROM ALIMENTA
                        WHERE cod_dieta IN (SELECT cod_dieta
											FROM TIPO
                                            WHERE tipo LIKE 'Fib'));


-- 12)Operación 159 → Ver quién es el animal de una determinada especie que lleva viviendo más tiempo en cada zona del zoo

-- SELECT * FROM ANIMAL;

-- Vamos a ingresar siete demonios de tasmania con diferentes fechas de ingreso en el zoo y viviendo en diferentes zonas para este ejemplo (Operación 1 -Insertar animal-):

START TRANSACTION;

INSERT INTO ANIMAL (especie,nombre,genero,fecha_de_ingreso,fecha_de_nacimiento)
VALUES
	('Sarcophilus harrisii','McManaman', 'Macho','2001-06-03 12:30:00','2001-06-02 12:30:00'),
    ('Sarcophilus harrisii','Guti','Macho','2008-06-03 12:30:00',NULL),
    ('Sarcophilus harrisii','Makelele','Macho','2011-06-03 12:30:00',NULL),
    ('Sarcophilus harrisii','Roberta Carlota','Hembra','2014-05-03 12:30:00',NULL),
    ('Sarcophilus harrisii','Raúl','Macho','2014-06-03 12:30:00',NULL),
    ('Sarcophilus harrisii','Michelle Salgado','Hembra','2011-06-03 10:30:00',NULL),
    ('Sarcophilus harrisii','Zidane','Macho','2001-01-03 12:30:00',NULL);
    
INSERT INTO VIVE
VALUES
	((SELECT MAX(codigo_animal) - 6 FROM ANIMAL), 3, '2001-06-04 12:30:00', NULL),
    ((SELECT MAX(codigo_animal) - 5 FROM ANIMAL), 3, '2008-06-04 12:30:00', NULL),
    ((SELECT MAX(codigo_animal) - 4 FROM ANIMAL), 3, '2011-06-04 12:30:00', NULL),
    ((SELECT MAX(codigo_animal) - 3 FROM ANIMAL), 3, '2014-05-04 12:30:00', NULL),
    ((SELECT MAX(codigo_animal) - 2 FROM ANIMAL), 1, '2014-06-04 12:30:00', NULL),
    ((SELECT MAX(codigo_animal) - 1 FROM ANIMAL), 1, '2011-06-04 10:30:00', NULL),
    ((SELECT MAX(codigo_animal) FROM ANIMAL), 1, '2001-01-04 12:30:00', NULL);
    
COMMIT;

-- Ahora vamos a buscar quién es el demonio de tasmania que lleva más tiempo viviendo en cada zona de este zoo:
-- SELECT * FROM ANIMAL;
-- SELECT * FROM VIVE;

SELECT (SELECT codigo_zona FROM VIVE AS vi WHERE vi.codigo_animal = an.codigo_animal) AS 'Zona',
		an.nombre AS 'Demonio más antigüo'
FROM ANIMAL AS an
WHERE an.codigo_animal IN (SELECT codigo_animal 
						FROM VIVE
                        WHERE fecha_entrada IN (SELECT MIN(fecha_entrada)
												FROM VIVE
                                                WHERE codigo_animal IN (SELECT codigo_animal
																		FROM ANIMAL
                                                                        WHERE especie LIKE 'Sarcophilus harrisii')
												GROUP BY codigo_zona));






-- 13) Operación 171 → Animales que han ingresado al zoo más tarde que un animal determinado
-- En este ejemplo vamos a buscar qué animales ingresaron en el zoo con posterioridad al último ornitorrinco ingresado

-- Con EXISTS:
SELECT *
FROM ANIMAL AS an1
WHERE EXISTS (
    SELECT an2.especie
    FROM ANIMAL AS an2
    WHERE an2.especie LIKE 'Ornithorhynchus anatinus'
    AND an1.fecha_de_ingreso >an2.fecha_de_ingreso
);
	
-- Con ANY:
SELECT *
FROM ANIMAL
WHERE fecha_de_ingreso > ANY (SELECT fecha_de_ingreso
					FROM ANIMAL
                    WHERE especie LIKE 'Ornithorhynchus anatinus');

-- Con MIN()
SELECT *
FROM ANIMAL
WHERE fecha_de_ingreso > ANY (SELECT MIN(fecha_de_ingreso)
					FROM ANIMAL
                    WHERE especie LIKE 'Ornithorhynchus anatinus');
                            
                            
-- 14) Operación 177 → Cantidad de cada alimento consumida cada día
-- SELECT * FROM ALIMENTO;
-- SELECT * FROM ALIMENTA;
-- SELECT * FROM COMPONE;


SELECT al.nombre AS 'Alimento',
		DATE(enta.fecha) AS 'Día',
		CONCAT(ROUND(SUM(com.cantidad),2)," gramos") AS 'Cantidad total'
FROM COMPONE AS com
JOIN ALIMENTO AS al ON (com.cod_alimento = al.cod_alimento)
JOIN ALIMENTA AS enta ON (enta.cod_dieta = com.cod_dieta)
WHERE com.cod_dieta IN (SELECT cod_dieta
 					FROM ALIMENTA)
GROUP BY al.nombre, DATE(enta.fecha);
                    
                    
-- 15) Operación 178 → Campaña de vacunación 
-- Se quiere vacunar a todos los animales que entraron al zoo con una fecha posterior a Makelele y que son de la misma especie que él (A Makelele hay que vacunarle también). Si alguno entró el mismo día que entró Makelele, aunque fuesen unas horas antes, también se le debe vacunar (Salgado).
-- Además se van a repartir el trabajo entre los veterinarios 3 y 6, el primero se encargará de los machos y el segundo de las hembras.

-- SELECT * FROM VACUNA;
-- SELECT * FROM ANIMAL;

/* Para este ejemplo es necesario haber insertado los demonios de tasmania del ejercicio 12 */

START TRANSACTION;

INSERT INTO VACUNA (codigo_animal, codigo_empleado_veterinario)
SELECT codigo_animal, 3
FROM ANIMAL
WHERE especie = (SELECT especie 
                FROM ANIMAL
                WHERE nombre LIKE 'Makelele')
AND DATE(fecha_de_ingreso) >= (SELECT DATE(fecha_de_ingreso)
                        FROM ANIMAL
                        WHERE nombre Like 'Makelele')
AND genero LIKE 'Macho';

INSERT INTO VACUNA (codigo_animal, codigo_empleado_veterinario)
SELECT codigo_animal, 6
FROM ANIMAL
WHERE especie = (SELECT especie 
                FROM ANIMAL
                WHERE nombre LIKE 'Makelele')
AND DATE(fecha_de_ingreso) >= (SELECT DATE(fecha_de_ingreso)
                        FROM ANIMAL
                        WHERE nombre Like 'Makelele')
AND genero LIKE 'Hembra';

COMMIT;


-- 16) Operación 179 → Eliminar todas las dietas que llevan termitas y eliminar termitas de los alimentos

-- Como se fijaron en los constraints de clave foránea de las tablas ALIMENTA y COMPONE que los ON UPDATE y ON DELETE estuviesen en RESTRICT, antes habrá que borrar los registros donde aparecen termitas en estas tablas. Será necesaria una transacción.

-- SELECT * FROM ALIMENTO;
-- SELECT * FROM COMPONE;
-- SELECT * FROM ALIMENTA;

START TRANSACTION;

DELETE FROM ALIMENTA
WHERE cod_dieta = (SELECT cod_dieta FROM COMPONE
						WHERE cod_alimento = (SELECT cod_alimento
												FROM ALIMENTO
												WHERE nombre LIKE 'termitas'));
                                                
DELETE FROM COMPONE
WHERE cod_alimento = (SELECT cod_alimento
						FROM ALIMENTO
						WHERE nombre LIKE 'termitas');

DELETE FROM DIETA
WHERE cod_dieta = (SELECT cod_dieta FROM COMPONE
						WHERE cod_alimento = (SELECT cod_alimento
												FROM ALIMENTO
												WHERE nombre LIKE 'termitas'));
                                                

DELETE FROM ALIMENTO
WHERE cod_alimento = (SELECT * FROM (SELECT cod_alimento
						FROM ALIMENTO
						WHERE nombre LIKE 'Termitas') T);
                        
/* 
Se podría hacer así el borrado de termitas en ALIMENTO, pero entonces hay que desactivar el modo seguro en preferencias:

DELETE FROM ALIMENTO
WHERE nombre LIKE 'Termitas';
*/
                                                
COMMIT;


-- 17) Operación 180 → Modificar dieta insuficiente cantidad
-- Las dietas que lleven plátano, pero en una cantidad inferior a la media de gramos de plátano de todas las dietas con este alimento, van a aumentar su cantidad en dicho alimento en un 20%

-- SELECT * FROM COMPONE;
-- SELECT * FROM ALIMENTO;

/* Lo que se va a modificar es, en la tabla COMPONE, la dieta 2, alimento 1 (plátano), que tiene 1000 gramos de platano (7000 gramos menos que la media de gramos de plátano en dietas donde está presente este alimento), y va a aumentar a 1200 gramos al sumarle su 20% */


UPDATE COMPONE
SET cantidad = cantidad + (cantidad * 0.2)
WHERE cantidad < (SELECT * FROM (SELECT AVG(cantidad)
									FROM 	COMPONE
									WHERE cod_alimento = (SELECT cod_alimento
															FROM ALIMENTO
															WHERE nombre LIKE 'Plátano') ) media_gramos_platano)
AND cod_alimento = (SELECT cod_alimento
					FROM ALIMENTO
					WHERE nombre LIKE 'Plátano');
                    
-- 18) Operación 181 → Borrar los alimentos que no están presentes en ninguna dieta

-- HAY QUE DESACTIVAR EL MODO SEGURO EN PREFERENCIAS.

-- SELECT * FROM ALIMENTO;
-- SELECT * FROM COMPONE;


-- Con NOT IN:
DELETE FROM ALIMENTO
WHERE cod_alimento NOT IN (SELECT cod_alimento
							FROM COMPONE);
                            
-- Con NOT EXISTS:
DELETE FROM ALIMENTO AS al
WHERE NOT EXISTS (SELECT cod_alimento
					FROM COMPONE AS com
                    WHERE al.cod_alimento = com.cod_alimento);
                    
				
                
-- 19) Eliminar los clientes cuya última compra fue hace más de 10 años y no tienen membresía
-- SELECT * FROM ENTRADA;
-- SELECT * FROM MEMBRESIA;
-- SELECT * FROM CLIENTE;

/* No hay ningún cliente con esas condiciones así que vamos a crear dos clientes, uno que cumpla con ambas y por lo tanto tendrá que ser eliminado, y otro que haya hecho su última compra antes de 2010, pero es miembro del zoo y no se le puede eliminar*/

-- Para el primero haremos la operación 67 -Añadir cliente por primera vez-:
START TRANSACTION;

INSERT INTO CLIENTE
SET nombre = 'José María',
	apellido_1 = 'Gasso',
    apellido_2 = 'Grimaldo';
    
INSERT INTO ENTRADA
SET tipo_de_entrada = 'O',
	precio_base = 20.95,
    precio_final = 20.95,
    fecha_compra = '2008-02-04 14:12:13',
    fecha_visita = '2008-02-05 10:12:13',
    codigo_empleado_cajero = 7,
    codigo_cliente = (SELECT MAX(cod_cliente) FROM CLIENTE);
    
COMMIT;


-- Para el segundo vamos a aplicar la operación 182 -Miembro en la primera visita-:
START TRANSACTION;

INSERT INTO CLIENTE
SET nombre = 'Verónica Manuela',
	apellido_1 = 'Trinidad-Consuelo',
    apellido_2 = 'de la Santísima Cruz';
    
INSERT INTO MEMBRESIA
SET porcentaje = 50,
	precio_anual = 33.70,
    fecha_membresia = '2008-02-04',
    tipo_membresia = 'Sta',
    cod_cliente = (SELECT MAX(cod_cliente) FROM CLIENTE);
    
INSERT INTO ENTRADA
SET tipo_de_entrada = 'M',
	precio_base = 20.95,
    precio_final = ROUND(20.95 - (20.95 * (SELECT porcentaje
							FROM MEMBRESIA
                            WHERE n_membresia = (SELECT MAX(n_membresia) FROM MEMBRESIA)) / 100),2),
    fecha_compra = '2008-02-04 13:12:13',
    fecha_visita = '2008-02-05 11:12:13',
    codigo_empleado_cajero = 7,
    codigo_cliente = (SELECT MAX(cod_cliente) FROM CLIENTE);
    
COMMIT;

-- Y ahora vamos a eliminar al cliente 1 que es el que cumple las condiciones para ser eliminado; va a ser necesario eliminarle tambien las entradas que están a su nombre, modificando el campo cliente a NULL; por tanto, requerirá transacción:

START TRANSACTION;


UPDATE ENTRADA
SET codigo_cliente = NULL
WHERE n_entrada IN (SELECT * FROM (SELECT n_entrada
								FROM ENTRADA
                                WHERE fecha_compra < DATE_SUB(CURRENT_DATE, INTERVAL 10 YEAR)) T )
AND codigo_cliente NOT IN (SELECT cod_cliente
						FROM MEMBRESIA);
                        
/* 
Se puede actualizar la tabla ENTRADA de una forma más simple, pero hay que desactivar el modo seguro en preferencias:

UPDATE ENTRADA
SET codigo_cliente = NULL
WHERE fecha_compra < DATE_SUB(CURRENT_DATE, INTERVAL 10 YEAR)
AND codigo_cliente NOT IN (SELECT cod_cliente
						FROM MEMBRESIA);
*/
                        
                        

DELETE FROM CLIENTE
WHERE cod_cliente IN (SELECT codigo_cliente
					  FROM ENTRADA
                      WHERE fecha_compra < DATE_SUB(CURRENT_DATE, INTERVAL 10 YEAR))
AND cod_cliente NOT IN (SELECT cod_cliente
						FROM MEMBRESIA);
                        
COMMIT;
                      

