
-- 102
((SELECT  em.codigo_empleado,
        em.nombre,
        em.apellido_1,
        em.apellido_2,
        fv.fecha_final_formación,
        'Actualmente en formación' AS 'Estado'
FROM EMPLEADO
WHERE fv.fecha_final_formación > CURRENT_DATE())
UNION
(SELECT  em.codigo_empleado,
        em.nombre,
        em.apellido_1,
        em.apellido_2,
        fv.fecha_final_formación,
        'Formación finalizada'
FROM EMPLEADO
WHERE fv.fecha_final_formación > CURRENT_DATE()))
ORDER BY ESTADO;


-- Consultas seleccionadas

-- 26 → Modificar diagnóstico y tratamiento: Si un diagnóstico ha sido erróneo, se debe mantener su diagnóstico en la tabla DIAGNOSTICA para no perder información, pero hay que añadir uno nuevo a dicha tabla y a su vez poner fin a su antiguo tratamiento para iniciar uno nuevo; en las observaciones de ambos tratamientos es aconsejable dejar constancia de esto; Tablas afectadas: DIAGNOSTICA, TRATAMIENTO; Requiere transacción.

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

INSERT INTO TRATAMIENTO (nombre_afeccion, medicamento, dosis, frecuencia, observaciones, fecha_inicio, fecha_fin, codigo_animal, cod_empleado_veterinario)
VALUES ('Fiebre aftosa', 'Aftosil', 150, 4, 'Anteriormente se le había diagnosticado con insomnio erróneamente', NOW(), DATE_ADD(NOW(), INTERVAL 1 MONTH), 1, 3);

COMMIT;


-- 10 → Insertar empleado → Añadir un registro de un nuevo empleado y su código de empleado a la tabla de su puesto de trabajo; si el puesto del empleado es VETERINARIO o CUIDADOR, habrá que hacer también la operación 15 o 16 respectivamente a continuación; además hay que añadirle un familiar o vincularle a uno ya existente para tener un contacto al menos, y si es un familiar nuevo, añadir un teléfono a este. También hay que añadir un teléfono al empleado     |      EMPLEADO, ADMINISTRADOR VETERINARIO CUIDADOR CAJERO, MANTENIMIENTO, FAMILIAR           |   SÍ

-- SELECT * FROM EMPLEADO;
-- SELECT * FROM TELEFONO_EMPLEADO;
-- SELECT * FROM VETERINARIO;
-- SELECT * FROM FAMILIAR;
-- SELECT * FROM TELEFONO_FAMILIAR;
-- SELECT * FROM TIENE;


START TRANSACTION;

INSERT INTO EMPLEADO (nombre, apellido_1, direccion, DNI, nº_SS, codigo_empleado_administrador)
VALUES ('Wenjuan', 'Guo', 'Rúa das Folerpas', '12365894W', '12552232314', 1);

INSERT INTO TELEFONO_EMPLEADO
VALUES ((SELECT MAX(codigo_empleado) FROM EMPLEADO), '987252526');

INSERT INTO FAMILIAR (nombre,apellido_1,apellido_2,DNI)
VALUES
('Víctor','de los Ríos','Campos','55566623J');

INSERT INTO TIENE
VALUES
((SELECT MAX(codigo_empleado) FROM EMPLEADO),(SELECT MAX(cod_familiar) FROM FAMILIAR));

INSERT INTO TELEFONO_FAMILIAR
VALUES
((SELECT MAX(cod_familiar) FROM FAMILIAR), '987125463');

INSERT INTO VETERINARIO
((SELECT MAX(codigo_empleado) FROM EMPLEADO));

INSERT INTO FORMA_VETERINARIO
VALUES
(3,(SELECT MAX(codigo_empleado) FROM EMPLEADO), CURRENT_DATE(), (DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH)));

COMMIT;

-- |90  ? Obtener los tipos de zona del zoo donde están viviendo más de una especie diferente    
-- SELECT * FROM ANIMAL;
-- SELECT * FROM ZONA;
-- SELECT * FROM VIVE;

SELECT COUNT(DISTINCT an.especie) AS 'Número de especies',
		zo.tipo AS 'Tipo de zona'
FROM ANIMAL AS an
JOIN VIVE AS vi ON (vi.codigo_animal = an.codigo_animal)
JOIN ZONA AS zo ON (vi.codigo_zona = zo.codigo_zona)
GROUP BY zo.tipo
HAVING COUNT(DISTINCT an.especie) > 1;


-- Buscar cuántos ejemplares de una misma especie viven en zonas del mismo tipo
SELECT  zo.tipo AS 'Tipo de zona',
		an.especie AS 'Especie',
		COUNT(*) AS 'Nº de ejemplares'
FROM ANIMAL AS an
JOIN VIVE AS vi ON (vi.codigo_animal = an.codigo_animal)
JOIN ZONA AS zo ON (vi.codigo_zona = zo.codigo_zona)
GROUP BY zo.tipo, an.especie;
		
		
-- Obtener las zonas en las que están conviviendo animales de especies diferentes.
SELECT  zo.codigo_zona AS 'Código zona',
		zo.tipo AS 'Tipo de zona',
		COUNT(DISTINCT an.especie) AS 'Nº de especies diferentes conviviendo'
FROM ANIMAL AS an
JOIN VIVE AS vi ON (vi.codigo_animal = an.codigo_animal)
JOIN ZONA AS zo ON (vi.codigo_zona = zo.codigo_zona)
GROUP BY vi.codigo_zona
HAVING COUNT(DISTINCT an.especie) > 1;



-- 96  Contar cuántos empleados están a cargo de cada administrador

-- ANIMALES TRASLADADOS EN EL ÚLTIMO MES
SELECT * FROM ANIMAL;
SELECT * FROM VIVE;


-- Trasladamos al animal 8 (Joe, la liebre de mar -Aplysia punctata-) de su zona actual a una nueva zona con la fecha de hoy:
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

-- Ingresamos un animal nuevo (Miko, el ocelote -Leopardus pardalis-) a una zona del zoo por primera vez (No es un traslado de una zona a otra)
START TRANSACTION;

INSERT INTO ANIMAL (especie, nombre, genero, fecha_de_ingreso, fecha_de_nacimiento)
VALUES 
('Leopardus pardalis','Miko','Macho',NOW(),(DATE_SUB(NOW(), INTERVAL 30 MINUTE)));

INSERT INTO VIVE
VALUES 
((SELECT MAX(codigo_animal) FROM ANIMAL),5,NOW(),NULL);

COMMIT;





-- Si queremos todos los animales que han sido ingresados en una zona nueva en el último mes:
SELECT an.codigo_animal AS 'Código animal',
		an.nombre AS 'Nombre animal',
        an.especia AS 'Especie'
FROM ANIMAL AS an
WHERE codigo_animal = ANY (SELECT DISTINCT vi.codigo_animal
							FROM VIVE AS vi
                            WHERE TIMESTAMPDIFF(MONTH, vi.fecha_entrada, CURRENT_DATE()) < 1
                            );
-- Y aquí nos saldrían tanto Joe, la liebre de mar, que ha sido trasladado de una zona a otra, como Miko, el ocelote, que ha ingresado a una zona del zoo por primera vez sin ser trasladado de otra
                            
               
-- Si queremos todos los animales que han sido trasladados de una zona a otra en el último mes:
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
-- Solo nos debería salir Joe, la liebre de mar, que ha sido el único en ser trasladado de una zona a otra en el último mes.


                            
                            


