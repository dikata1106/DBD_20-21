--DANIEL RUSKOV 27/10/2020
-- apartado 1 - crear las siguientes tablas e introducir tuplas.
CREATE TABLE PELIS(
    PID Number,
    Titulo varchar2(20),
    Anno Number,
    Director varchar2(20),
    primary key(PID)
);
CREATE TABLE CRITICOCINE(
    CID Number,
    Nombre varchar2(20),
    primary key(CID)
);
CREATE TABLE VALORACION(
    PID Number,
    CID Number,
    Puntuacion Number,
    Fecha Date,
    Primary key(PID, CID),
    Foreign key(PID) REFERENCES PELIS(PID),
    Foreign Key(CID) REFERENCES CRITICOCINE(CID)
);
INSERT INTO PELIS
VALUES('1', 'Peli1', '2001', 'Director1');
INSERT INTO PELIS
VALUES('2', 'Peli2', '2002', 'Director2');
INSERT INTO PELIS
VALUES('3', 'Peli3', '2003', 'Director1');
INSERT INTO PELIS
VALUES('4', 'Peli4', '2003', 'Director3');
INSERT INTO PELIS
VALUES('5', 'Peli5', '1975', 'Director4');
INSERT INTO PELIS
VALUES('6', 'Peli4', '2011', 'Director1');
INSERT INTO CRITICOCINE
VALUES('10', 'Critico10');
INSERT INTO CRITICOCINE
VALUES('11', 'Critico11');
INSERT INTO CRITICOCINE
VALUES('12', 'Critico12');
INSERT INTO VALORACION
VALUES('1', '10', '4', DATE '2015-12-17');
INSERT INTO VALORACION
VALUES('1', '11', '8', DATE '2017-12-20');
INSERT INTO VALORACION
VALUES('1', '12', '5', DATE '2008-01-17');
INSERT INTO VALORACION
VALUES('2', '10', '10', DATE '2015-09-15');
INSERT INTO VALORACION
VALUES('2', '12', '2', DATE '2011-11-11');
INSERT INTO VALORACION
VALUES('3', '11', '7', DATE '2020-10-27');
-- apartado 2 - crear vista que contenga info sobre titulo, nombre y puntuacion y obtener sus tuplas.
CREATE VIEW VAP2 AS
SELECT Titulo,
    Nombre,
    Puntuacion
FROM PELIS,
    CRITICOCINE,
    VALORACION
WHERE PELIS.PID = VALORACION.PID
    AND CRITICOCINE.CID = VALORACION.CID;
SELECT *
FROM VAP2;
-- apartado 3 - pregunta sql que permita obtener la maxima puntuacion que ha obtenido la pelicula con pid=XXX (usando vista join tabla).
SELECT MAX(Puntuacion)
FROM PELIS,
    VAP2
WHERE PELIS.Titulo = VAP2.Titulo
    AND PELIS.PID = 1;
-- apartado 4 - crear vista usando solo los datos de la vista creada anteriormente que refleje el titulo de la pelicula, el numero de valoraciones y el valor medio de las valoraciones.
CREATE VIEW VAP4 AS
SELECT Titulo,
    COUNT(Puntuacion) AS Num_Valoraciones,
    AVG(Puntuacion) AS Media
FROM VAP2
GROUP BY Titulo;
SELECT *
FROM VAP4;
-- apartado 5 - crear vista post80 que refleje el titulo y el a�o de las peliculas posteriores a 1980.
CREATE VIEW POST80 AS
SELECT Titulo,
    Anno
FROM PELIS
WHERE Anno > 1980;
SELECT *
FROM POST80;
-- apartado 6 - actualizaciones en la vista post80
-- 6a - insertar una tupla en la vista post80. �que ocurre? NO DEJA: ORA-01400: no se puede realizar una inserci�n NULL en ("DBDC07"."PELIS"."PID")
INSERT INTO POST80
VALUES('Peli6', '2012');
-- 6b - borrar una tupla de la vista post80. �que ocurre? NO DEJA: ORA-02292: restricci�n de integridad (DBDC07.SYS_C0064741) violada - registro secundario encontrado
DELETE FROM POST80
WHERE POST80.Titulo = 'Peli3';
-- 6c - modificar una tupla de la vista post80. �que ocurre? ACTUALIZA
UPDATE POST80
SET Anno = 1970
WHERE POST80.Titulo = 'Peli3';
SELECT *
FROM PELIS;
SELECT *
FROM CRITICOCINE;
SELECT *
FROM VALORACION;
SELECT *
FROM VAP2;
SELECT *
FROM VAP4;
SELECT *
FROM POST80;
-- apartado 7 - una pelicula puede rodarse con el mismo titulo en a�os diferentes con distintos directores. Crear vista que seleccione todos los titulos diferentes de peliculas que se almacenan en la BD. 
-- Modificar una tupla en la vista creada. �que ocurre? NO DEJA (SIEMPRE QUE SE USE UNIQUE, DISTINCT, ...) SQL: ORA-01732: operaci�n de manipulaci�n de datos no v�lida en esta vista
-- CREATE VIEW VAP7 AS SELECT UNIQUE Titulo FROM PELIS;
CREATE VIEW VAP7 AS
SELECT DISTINCT Titulo
FROM PELIS;
-- SELECT * FROM VAP7;
UPDATE VAP7
SET Titulo = 'Peli0'
WHERE Titulo = 'Peli1';
-- apartado 8 - crear una vista que refleje el codigo de la pelicula, el titulo y a�o siempre que el a�o sea posterior a 1980.
CREATE VIEW VAP8 AS
SELECT PID,
    Titulo,
    Anno
FROM PELIS
WHERE Anno > 1980;
-- 8a - introducio una tupla con a�o = 1970 a traves de la vista creada. �que ocurre en la tabla pelis y en la vista creada? LA A�ADE A PELIS (SN DIRECTOR), PERO NO A VAP8
INSERT INTO VAP8
VALUES('7', 'Peli7', '1970');
SELECT *
FROM VAP8;
SELECT *
FROM PELIS;
-- 8b - borrar la vista y volver a crearla con la opcion check option. Introducio una tupla con a�o 1970 y ver lo que ocurre. ORA-01402: violaci�n de la cl�usula WHERE en la vista WITH CHECK OPTION
DROP VIEW VAP8;
CREATE VIEW VAP8 AS
SELECT PID,
    Titulo,
    Anno
FROM PELIS
WHERE Anno > 1980 WITH CHECK OPTION;
INSERT INTO VAP8
VALUES('8', 'Peli8', '1970');
-- apartado 9 - actualizaciones en la vista creada en el apartado 2.
-- 9a - insertar tupla. VAP2 definido sobre varias tuplas: SQL: ORA-01779: no se puede modificar una columna que se corresponde con una tabla no reservada por clave
INSERT INTO VAP2
VALUES ('Peli5', 'Critico 11', '8');
SELECT *
FROM VAP2;
SELECT *
FROM PELIS;
SELECT *
FROM CRITICOCINE;
SELECT *
FROM VALORACION;
-- 9b - borrar tupla. BORRA DE TODAS PARTES
DELETE FROM VAP2
WHERE Titulo = 'Peli1'
    AND Nombre = 'Critico11';
SELECT *
FROM VAP2;
SELECT *
FROM PELIS;
SELECT *
FROM CRITICOCINE;
SELECT *
FROM VALORACION;
-- 9c - modificar tupla. ACTUALIZA EN TODAS PARTES
UPDATE VAP2
SET Puntuacion = 1
WHERE Titulo = 'Peli1'
    AND Nombre = 'Critico10';
SELECT *
FROM VAP2;
SELECT *
FROM PELIS;
SELECT *
FROM CRITICOCINE;
SELECT *
FROM VALORACION;
-- apartado 10 - borrar la vista creada en el punto 5 y volver a crearla con la opcion read only. Insertar una tupla en la vista creada. NO INSERTA: ORA-42399: no se puede realizar una operaci�n DML en una vista de s�lo lectura
DROP VIEW POST80;
CREATE VIEW POST80 AS
SELECT Titulo,
    Anno
FROM PELIS
WHERE AnnO > 1980 WITH READ ONLY;
INSERT INTO POST80
VALUES ('Peli8', '2019');
-- apartado 11 - probar el funcionamiento del borrado en cascada de las vistas en oracle. borrar la vista creada en le apartado 2. Oracle siempre borra en cascada, si se pone cascade da error.
DROP VIEW VAP2;