-- Insertar datos en la tabla ANIMAL
INSERT INTO ANIMAL (especie, nombre, genero, fecha_de_ingreso, fecha_de_nacimiento, fecha_de_fallecimiento) 
VALUES
('Troglodytes gorilla', 'Copito de Nieve', 'Macho', '1999-06-15 12:00:05', NULL, NULL),
('Canis lupus signatus', 'Xena', 'Hembra', '2000-12-07 11:45:12', NULL, NULL),
('Ailuropoda melanoleuca qinlingensis', 'Po', 'Macho', '2001-01-01 18:16:43', '2001-01-01 18:16:41', NULL),
('Ornithorhynchus anatinus', 'Perry', 'Macho', '2004-09-29 14:01:59', NULL, NULL),
('Panthera leo', 'Margarita', 'Hembra', '2004-12-13 15:15:15', NULL, '2004-12-20 15:15:15'),
('Elephas maximus maximus', 'Adelio', 'Macho', '2006-09-03 18:59:05', '2006-09-03 18:57:15', NULL),
('Vombatus ursinus', 'Ratchet', 'Macho', '2009-12-13 15:15:10', NULL, NULL),
('Aplysia punctata', 'Joe', 'Hermafrodita', '2010-03-18 16:14:25', NULL, NULL);

-- Insertar datos en la tabla ZONA
INSERT INTO ZONA (superficie, tipo, descripcion) 
VALUES
(3000.00, 'jungla', 'Destinada a una única especie de primates, para evitar conflictos, temperatura ambiente'),
(3500.00, 'jungla', 'Zona que emula jungla asiática, con abundante bambú; temperatura ambiente'),
(2120.00, 'río', 'Zona de agua dulce y una superficie rocosa; la temperatura no debe disminuir de los 15º'),
(1578.00, 'mar', 'Zona cubierta de agua salada destinada a fauna marina, piedras, algas, temperatura no inferior a 20º'),
(100.00, 'otra', 'Zona reservada para animales recién nacidos o ingresados, para pasar cuarentena antes de su introducción a una nueva zona'),
(2750.00, 'árida', 'Zona de llanura con apenas hierba'),
(3200.00, 'montaña', 'Zona con abundantes árboles y zonas cavernosas; temperatura ambiente');

-- Insertar datos en la tabla VIVE
INSERT INTO VIVE 
VALUES
(1, 1, '1999-06-30 13:14:04', NULL),
(1, 5, '1999-06-15 12:00:05', '1999-06-30 13:07:45'),
(2, 5, '2001-01-01 18:16:41', '2001-02-03 09:27:38'),
(2, 7, '2001-02-03 09:29:38', NULL),
(3, 2, '2001-01-10 12:59:12', NULL),
(3, 5, '2001-01-01 18:18:52', '2001-01-10 12:55:12'),
(5, 5, '2004-12-13 15:17:26', '2004-12-20 15:15:10'),
(8, 4, '2010-03-18 16:25:56', NULL);

-- Insertar datos de los administradores en la tabla EMPLEADO
INSERT INTO EMPLEADO 
VALUES
(1,'Pavel', 'Nedved', NULL, 'Calle Santa Nonia 33', '11111111A', '19999999999', NULL),
(4,'Joanne', 'Rowling', NULL, 'Travesía de la Candamia 93', '44444444D', '49999999999', NULL);

-- Insertar datos en la tabla ADMINISTRADOR
INSERT INTO ADMINISTRADOR 
VALUES
(1),
(4);

-- Insertar datos en la tabla EMPLEADO
INSERT INTO EMPLEADO 
VALUES
(2,'Tadej', 'Pogaçart', NULL, 'Avenida de los Abedules 167', '22222222B', '29999999999', 1),
(3,'Alice Pleasance', 'Liddell', 'Hargreaves', 'Calle de Velázquez 14', '33333333C', '39999999999', 1),
(5,'Halima', 'al-Hawila', 'González', 'Calle Frontón 14', '55555555E', '59999999999', 4),
(6,'María', 'Ruano', 'Nicolás', 'Avenida de Carlo Ancelotti 14', '66666666F', '69999999999', 4),
(7,'Paula', 'Ruano', 'Nicolás', 'Avenida de Carlo Ancelotti 14', '66666667F', '79999999999', 4),
(8,'Cristiano', 'Messi', 'Neymar', 'Avenida de la Constitución 15', '88888888T', '89898989898', 1),
(9,'María Teresa', 'López', 'Vián', 'Calle Antonio Ralea 14', '99999999Y', '87845421225', 4),
(10,'Francisco', 'Ratzinger', 'Segundo', 'Calle Romareda 99', '78787878F', '87878787878', 1);

-- Insertar datos en la tabla MANTENIMIENTO
INSERT INTO MANTENIMIENTO
VALUES
(9),
(10);

-- Insertar datos en la tabla VETERINARIO
INSERT INTO VETERINARIO
VALUES
(3),
(6);

-- Insertar datos en la tabla FORMA_VETERINARIO
INSERT INTO FORMA_VETERINARIO 
VALUES
(3, 6, '2023-10-19', '2023-11-19');

-- Insertar datos en la tabla CUIDADOR
INSERT INTO CUIDADOR
VALUES
(2),
(5);

-- Insertar datos en la tabla CAJERO
INSERT INTO CAJERO 
VALUES
(7),
(8);

-- Insertar datos en la tabla FORMA_CUIDADOR
INSERT INTO FORMA_CUIDADOR
VALUES
(5, 2, '2023-10-19', '2023-11-19');

-- Insertar datos en la tabla MANTIENE
INSERT INTO MANTIENE
VALUES
(1, 9, '2020-02-11 09:39:23', '2020-12-31 12:55:45'),
(1, 10, '2021-01-01 12:00:00', '2022-01-01 12:00:00'),
(2, 9, '2021-01-01 12:00:00', '2022-01-01 12:00:00'),
(2, 10, '2022-06-02 12:00:00', '2023-01-01 12:00:00'),
(3, 9, '2022-01-01 12:00:00', '2022-06-01 12:00:00'),
(5, 10, '2022-01-01 12:00:00', '2022-06-01 12:00:00');

-- Insertar datos en la tabla AFECCION
INSERT INTO AFECCION 
VALUES
('Aspergilosis', 'Grave', 'Otro'),
('Enfermedad de Newcastle', 'Grave', 'Enfermedad vírica'),
('Fiebre aftosa', 'Grave', 'Enfermedad vírica'),
('Insomnio', 'Leve', 'Transtorno'),
('Salmonelosis', 'Grave', 'Enfermedad bacteriana'),
('Toxoplasmosis', 'Leve', 'Otro');

-- Insertar datos en la tabla TRATAMIENTO
INSERT INTO TRATAMIENTO (medicamento, dosis, frecuencia, observaciones, fecha_inicio, fecha_fin, codigo_animal, cod_empleado_veterinario) VALUES
('Focusín', '125', 8, 'Después de cada toma', '2020-02-17', '2020-02-20', 1, 3),
('Reparina', '500', 24, 'Antes de dormir', '2020-02-17', '2020-02-25', 1, 3),
('Focusín', '200', 8, 'Después de cada toma', '2020-11-04', '2020-12-04', 2, 6),
('Aftosil', '2000', 8, NULL,'2020-11-18', '2020-11-20', 6, 3),
('Toxoplasmosín', '3000', 12, NULL, '2020-02-22', '2020-02-22', 6, 6),
('Focusín', '150', 8, NULL, '2020-02-23', '2020-02-20', 1, 6);

-- Insertar datos en la tabla DIAGNOSTICA
INSERT INTO DIAGNOSTICA
VALUES
(1, 'Insomnio', '2017-02-10 00:00:00', 3),
(4, 'Insomnio', '2023-02-10 00:00:00', 3),
(6, 'Fiebre aftosa', '2018-11-04 00:00:00', 3),
(1, 'Insomnio', '2023-02-10 00:00:00', 6),
(2, 'Insomnio', '2018-11-04 00:00:00', 6),
(6, 'Toxoplasmosis', '2022-02-02 00:00:00', 6);

-- Insertar datos en la tabla SINTOMAS
INSERT INTO SINTOMAS
VALUES
('Fiebre aftosa', 'Ampollas en la lengua, ubres y pezuñas'),
('Fiebre aftosa', 'Fiebre'),
('Insomnio', 'Cansancio diurno'),
('Insomnio', 'Depresión'),
('Insomnio', 'Incapacidad para dormir'),
('Insomnio', 'Irratibilidad');

-- Insertar datos en la tabla VACUNA
INSERT INTO VACUNA
VALUES
(1, 3),
(4, 3),
(5, 3),
(2, 6),
(5, 6);

-- Insertar datos en la tabla DIETA
INSERT INTO DIETA (observaciones) 
VALUES
(NULL),
(NULL),
('No dar en ayunas'),
(NULL),
(NULL),
(NULL);

-- Insertar datos en la tabla ALIMENTA
INSERT INTO ALIMENTA 
VALUES
(1, 2, 1, '2023-02-10 09:56:56'),
(1, 2, 2, '2023-02-11 10:56:56'),
(6, 2, 3, '2023-02-12 12:56:56'),
(6, 5, 3, '2023-02-11 11:56:56');

-- Insertar datos en la tabla CUIDA
INSERT INTO CUIDA
VALUES
(1, 2, '2010-08-14 15:50:12', 'Observación', 'Todo correcto'),
(1, 2, '2013-10-18 08:09:45', 'Otro', 'Tiene parásitos'),
(2, 2, '2012-05-05 12:00:00', 'Observación', NULL),
(2, 5, '2010-08-14 12:14:00', 'Cura', 'El animal no puede caminar sin cojear, pero parece animado'),
(3, 2, '2012-08-14 12:00:00', 'Higiene', NULL),
(4, 5, '2013-08-14 14:56:34', 'Otro', 'Todo correcto'),
(4, 5, '2013-08-19 08:09:07', 'Otro', 'Todo bien');

-- Insertar datos en la tabla FAMILIAR
INSERT INTO FAMILIAR (nombre, apellido_1, apellido_2, DNI) 
VALUES
('Adelaida', 'Nicolás', 'Saldaña', '12345678T'),
('David', 'López', 'Vián', '98765432H'),
('Michael', 'Blake', NULL, '54612398T'),
('Jack', 'London', NULL, '96352418S'),
('Charles', 'Lutwidge', 'Dogson', '54612379U'),
('Virginia', 'Wolf', NULL, '35335362N'),
('Rashid', 'al-Hawila', NULL, '56564856N'),
('Joel Thomas', 'Zimmermann', NULL, '85632544D');

-- Insertar datos en la tabla TIENE
INSERT INTO TIENE
VALUES
(6, 1),
(7, 1),
(2, 2),
(9, 2),
(1, 3),
(4, 4),
(3, 5),
(2, 6),
(5, 7),
(8, 8),
(10, 8);

-- Insertar datos en la tabla TELEFONO_FAMILIAR
INSERT INTO TELEFONO_FAMILIAR
VALUES
(1, '695880604'),
(1, '979121212'),
(1, '987270010'),
(2, '987270010'),
(3, '632564125'),
(3, '987232526'),
(4, '987801080'),
(5, '987564584'),
(6, '615846574'),
(6, '987363532'),
(7, '987272910'),
(8, '987878754');

-- Insertar datos en la tabla TELEFONO_EMPLEADO
INSERT INTO TELEFONO_EMPLEADO
VALUES
(1, '987123456'),
(2, '692326548'),
(2, '987212121'),
(3, '633633633'),
(3, '648591265'),
(3, '987256562'),
(4, '631245645'),
(4, '987142515'),
(5, '695632144'),
(5, '987252536'),
(6, '689524563'),
(6, '987270010'),
(7, '695324657'),
(7, '987270010'),
(8, '987316421');

-- Insertar datos en la tabla ORGANIZA
INSERT INTO ORGANIZA
VALUES
(3, 1),
(6, 1),
(3, 2),
(3, 3),
(6, 4),
(3, 5),
(6, 5),
(3, 6),
(6, 6);

-- Insertar datos en la tabla TIPO
INSERT INTO TIPO (cod_dieta, tipo) 
VALUES
(1, 'Fib'),
(1, 'Omn'),
(2, 'Veg'),
(3, 'Prot'),
(3, 'Car');

-- Insertar datos en la tabla ALIMENTO
INSERT INTO ALIMENTO (nombre, grasas, proteinas, hidratos, stock) 
VALUES
('Plátano', 0.30, 1.10, 21.10, 1000.00),
('Bambú', 0.30, 2.60, 5.20, 500.00),
('Termitas', 46.00, 38.00, 12.50, 1005.00),
('Carne de pollo', 0.90, 19.88, 1.40, 500.00),
('Placton', 1.10, 8.80, 5.40, 1000.00),
('Manzana', 0.50, 1.10, 45.80, 400.00);

-- Insertar datos en la tabla COMPONE
INSERT INTO COMPONE
VALUES
(1, 1, 15000.00),
(1, 2, 5000.00),
(1, 3, 10000.00),
(2, 1, 1000.00),
(2, 2, 1000.00),
(3, 5, 1001.00),
(4, 4, 2000.00);

-- Insertar datos en la tabla CLIENTE
INSERT INTO CLIENTE (DNI, nombre, apellido_1, apellido_2) 
VALUES
('73498288G', 'Pascual', 'Navidad', 'Caridad'),
(NULL, 'Pedro', 'Alegría', 'Felicidad'),
(NULL, 'Pablo', 'Fernández', 'Fernández'),
('54621823G', 'Freddie', 'Seitaridis', NULL),
('65356321G', 'Philip', 'Fry', NULL),
(NULL, 'Earl', 'Hickey', NULL);

-- Insertar datos en la tabla TELEFONO_CLIENTE
INSERT INTO TELEFONO_CLIENTE
VALUES
(1, '987251365'),
(1, '987545456'),
(2, '987125412'),
(3, '987526324'),
(4, '987454545'),
(4, '987632532');

-- Insertar datos en la tabla MEMBRESIA
INSERT INTO MEMBRESIA (porcentaje, precio_anual, fecha_membresia, tipo_membresia, cod_cliente) 
VALUES
(60, 10.00, '2022-02-10', 'Inf', 1),
(50, 33.70, '2022-03-10', 'Sta', 2);

-- Insertar datos en la tabla ENTRADA
INSERT INTO ENTRADA (tipo_de_entrada, precio_base, precio_final, fecha_compra, fecha_visita, codigo_empleado_cajero, codigo_cliente, n_membresia) 
VALUES
('O', 20.95, 20.95, '2020-01-01 10:01:15', '2020-01-10 08:00:00', 7, 1, NULL),
('M', 20.95, 7.43, '2020-01-01 10:01:15', '2020-01-01 10:01:15', 8, 2, 1),
('O', 20.95, 20.95, '2020-02-10 12:01:15', '2020-02-14 09:00:00', 7, 3, NULL),
('M', 20.95, 20.95, '2020-02-10 12:01:15', '2020-02-10 12:01:15', 8, 4, 2),
('O', 20.95, 20.95, '2021-05-15 10:01:15', '2021-05-15 11:00:00', 7, 5, NULL),
('M', 20.95, 8.36, '2021-05-15 10:01:15', '2021-05-15 10:01:15', 8, 6, 2);
