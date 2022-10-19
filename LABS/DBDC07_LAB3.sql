-- DANIEL RUSKOV 03/11/2020
/*
 ALTER TABLE DBDC07.CUADRO DROP CONSTRAINT VAL_ESTILO;
 ALTER TABLE DBDC07.PINTORES DROP CONSTRAINT FECHA_VALIDA;
 ALTER TABLE DBDC07.CUADRO DROP CONSTRAINT COD3_OLEO;
 ALTER TABLE DBDC07.PINTORES DROP CONSTRAINT BORRAR_CASCADA;
 ALTER TABLE DBDC07.CUADRO DROP CONSTRAINT TECNICA_PLASTICA;
 ALTER TABLE DBDC07.PINTORES DROP CONSTRAINT NACIONALIDAD_ALEMANA;
 ALTER TABLE DBDC07.PINTORES DROP CONSTRAINT COD_PINTOR;
 DELETE FROM DBDC07.CUADRO;
 DELETE FROM DBDC07.PINTORES;
 DROP TABLE DBDC07.CUADRO;
 DROP TABLE DBDC07.PINTORES;
 */
-- APARTADO 1 - Crear las siguiente tablas usando la sentencia CREATE TABLE. Introducir las restricciones sobre las claves de tipo primario y extranjero.
CREATE TABLE DBDC07.PINTORES (
    CODPINTOR NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(20),
    NOMARTISTICO VARCHAR2(20),
    NACIONALIDAD VARCHAR2(10),
    FECHANAC DATE,
    FECHAFALLE DATE
);
CREATE TABLE DBDC07.CUADRO (
    TITULO VARCHAR2(20),
    CODPINTOR NUMBER REFERENCES PINTORES (CODPINTOR),
    FECHA DATE,
    TECNICA VARCHAR2(10),
    ESTILO VARCHAR2(10),
    PRIMARY KEY (TITULO, CODPINTOR)
);
-- APARTADO 2 - Insertar tuplas y comprobar que se cumplen las R.I sobre clave primaria y clave extranjera.
-- NO CUMPLEN R.I:
INSERT INTO DBDC07.PINTORES
VALUES(
        NULL,
        'Nombre1',
        'Artistico1',
        'Nacional1',
        DATE '1870-10-22',
        '1945-12-12'
    );
-- ORA-01400: no se puede realizar una inserci�n NULL en ("DBDC07"."PINTORES"."CODPINTOR")
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro1',
        1,
        DATE '1887-03-26',
        'Tecnica1',
        'Retrato'
    );
-- ORA-02291: restricci�n de integridad (DBDC07.SYS_C0065214) violada - clave principal no encontrada
-- CUMPLEN R.I:
INSERT INTO DBDC07.PINTORES
VALUES(
        1,
        'Nombre1',
        'Artistico1',
        'Nacional1',
        DATE '1870-07-26',
        DATE '1945-10-31'
    );
INSERT INTO DBDC07.PINTORES
VALUES(
        2,
        'Nombre2',
        'Artistico2',
        'Nacional1',
        DATE '1881-04-25',
        DATE '1973-04-08'
    );
INSERT INTO DBDC07.PINTORES
VALUES(
        3,
        'Nombre3',
        'Artistico3',
        'Nacional2',
        DATE '1853-03-30',
        DATE '1890-07-29'
    );
INSERT INTO DBDC07.PINTORES
VALUES(
        4,
        'Nombre4',
        'Artistico4',
        'Nacional3',
        DATE '1840-11-14',
        DATE '1926-12-05'
    );
INSERT INTO DBDC07.PINTORES
VALUES(
        5,
        'Nombre5',
        'Artistico5',
        'Nacional4',
        DATE '1904-05-11',
        DATE '1989-01-23'
    );
INSERT INTO DBDC07.PINTORES
VALUES(
        6,
        'Nombre6',
        'Artistico5',
        'Nacional5',
        DATE '1964-05-30',
        DATE '1990-11-23'
    );
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro1',
        1,
        DATE '1900-05-20',
        'Tecnica1',
        'Natural'
    );
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro2',
        1,
        DATE '1908-12-02',
        'Tecnica1',
        'Retrato'
    );
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro3',
        2,
        DATE '1907-01-05',
        'Tecnica2',
        'Surreal'
    );
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro4',
        2,
        DATE '1921-09-19',
        'Tecnica3',
        'Moderno'
    );
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro5',
        3,
        DATE '1889-10-15',
        'Tecnica1',
        'Retrato'
    );
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro6',
        3,
        DATE '1887-01-27',
        'Tecnica4',
        'Retrato'
    );
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro7',
        4,
        DATE '1921-02-08',
        'Tecnica1',
        'Clasico'
    );
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro8',
        5,
        DATE '1931-02-14',
        'Tecnica5',
        'Moderno'
    );
-- APARTADO 3 - A�adir la restricci�n en la tabla cuadro que exprese que el estilo puede ser o moderno o cl�sico y comprobar su funcionamiento.
-- SI NO SE A�ADE ENABLE NOVALIDATE, POR DEFECTO ES VALIDATE Y NO NOS DEJA. ORA-02293: no se puede validar (DBDC07.VAL_ESTILO) - restricci�n de control violada.
ALTER TABLE DBDC07.CUADRO
ADD CONSTRAINT VAL_ESTILO CHECK (
        ESTILO IN (
            'MODERNO',
            'CLASICO',
            'clasico',
            'moderno',
            'Moderno',
            'Clasico'
        )
    ) ENABLE NOVALIDATE;
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro9',
        5,
        DATE '1931-02-14',
        'Tecnica3',
        'Surreal'
    );
-- ORA-02290: restricci�n de control (DBDC07.VAL_ESTILO) violada
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro9',
        5,
        DATE '1931-02-14',
        'Tecnica3',
        'Clasico'
    );
-- APARTADO 4 - A�adir la restricci�n en la tabla PINTORES  que exprese que la fecha de nacimiento debe estar entre 1800 y 1850 o entre 1900 y 2000 y comprobar su funcionamiento. DOS OPCIONES.
ALTER TABLE DBDC07.PINTORES
ADD CONSTRAINT FECHA_VALIDA CHECK (
        (
            FECHANAC > (DATE '1800-01-01')
            AND FECHANAC < (DATE '1850-12-31')
        )
        OR (
            FECHANAC > (DATE '1900-01-01')
            AND FECHANAC < (DATE '2000-12-31')
        )
    ) ENABLE NOVALIDATE;
ALTER TABLE DBDC07.PINTORES
ADD CONSTRAINT FECHA_VALIDA CHECK (
        (
            FECHANAC BETWEEN (DATE '1800-01-01') AND (DATE '1850-12-31')
        )
        OR (
            FECHANAC BETWEEN (DATE '1900-01-01') AND (DATE '2000-12-31')
        )
    ) ENABLE NOVALIDATE;
INSERT INTO DBDC07.PINTORES
VALUES(
        7,
        'Nombre7',
        'Artistico7',
        'Nacional5',
        DATE '1875-05-30',
        DATE '1920-11-23'
    );
-- ORA-02290: restricci�n de control (DBDC07.FECHA_VALIDA) violada
INSERT INTO DBDC07.PINTORES
VALUES(
        7,
        'Nombre7',
        'Artistico7',
        'Nacional5',
        DATE '1924-05-30',
        DATE '1990-11-23'
    );
-- APARTADO 5 - Poner un ejemplo con la opci�n CHECK NOT (sobre dos atributos de una tabla). Ejemplo si el c�digo de pintor es 3 entonces la t�cnica debe ser �leo.
ALTER TABLE DBDC07.CUADRO
ADD CONSTRAINT COD3_OLEO CHECK (
        NOT (
            CODPINTOR = '3'
            AND NOT(ESTILO = 'OLEO')
        )
    ) ENABLE NOVALIDATE;
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro11',
        3,
        DATE '1931-02-14',
        'Tecnica6',
        'Moderno'
    );
-- ORA-02290: restricci�n de control (DBDC07.COD3_OLEO) violada
-- APARTADO 6 - A�adir una nueva restricci�n que exprese que al borrar un pintor se borren autom�ticamente sus cuadros. Si no funciona borrar la restricci�n ya existente.
ALTER TABLE DBDC07.CUADRO
ADD CONSTRAINT BORRAR_CASCADA 
    FOREIGN KEY (CODPINTOR) REFERENCES DBDC07.PINTORES (CODPINTOR) 
    ON DELETE CASCADE;
-- >>> FALTA BORRAR LA RESTRICCION YA EXISTENTE SI EXISTESELECT *
FROM DBDC07.PINTORES;
SELECT *
FROM DBDC07.CUADRO;
DELETE FROM DBDC07.PINTORES
WHERE CODPINTOR = 5;
SELECT *
FROM DBDC07.PINTORES;
SELECT *
FROM DBDC07.CUADRO;
-- APARTADO 7 - A�adir una nueva restricci�n sobre la tabla CUADRO que indique que la t�cnica s�lo podr� ser pl�stica en todas las tuplas de la BD (las existentes y las nuevas).
-- �Qu� ocurre si en la BD ya existen tuplas con t�cnica Oleo? �Cu�l es el valor por defecto a la hora de comprobar? ORA-02293: no se puede validar (DBDC07.TECNICA_PLASTICA) - restricci�n de control violada
-- DA ERROR, YA QUE EXISTEN TUPLAS QUE NO CUMPLEN LA RESTRICCION. POR DEFECTO ES VALIDATE.
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro10',
        5,
        DATE '1931-02-14',
        'Plastica',
        'Moderno'
    );
ALTER TABLE DBDC07.CUADRO
ADD CONSTRAINT TECNICA_PLASTICA CHECK (TECNICA IN ('PLASTICA', 'Plastica', 'plastica'));
SELECT *
FROM DBDC07.CUADRO;
-- APARTADO 8 - A�adir una nueva restricci�n sobre la tabla PINTORES que exprese que los nuevos pintores que se introduzcan en la BD deben tener nacionalidad alemana (los anteriores pueden no tenerla). Comprobar su funcionamiento.
ALTER TABLE DBDC07.PINTORES
ADD CONSTRAINT NACIONALIDAD_ALEMANA CHECK (
        NACIONALIDAD IN (
            'Aleman',
            'aleman',
            'ALEMAN',
            'Alemana',
            'alemana',
            'ALEMANA'
        )
    ) ENABLE NOVALIDATE;
INSERT INTO DBDC07.PINTORES
VALUES(
        8,
        'Nombre8',
        'Artistico8',
        'Naciona8',
        DATE '1964-05-30',
        DATE '1990-11-23'
    );
-- ORA-02290: restricci�n de control (DBDC07.NACIONALIDAD_ALEMANA) violada
INSERT INTO DBDC07.PINTORES
VALUES(
        8,
        'Nombre8',
        'Artistico8',
        'Aleman',
        DATE '1964-05-30',
        DATE '1990-11-23'
    );
-- APARTADO 9 - Poner un ejemplo de uso de DISABLE. Alter Table nombre tabla DISABLE CONSTRAINT nombre RI. COMPROBAR su funcionamiento.
ALTER TABLE DBDC07.CUADRO DISABLE CONSTRAINT COD3_OLEO;
INSERT INTO DBDC07.CUADRO
VALUES(
        'Cuadro11',
        3,
        DATE '1931-02-14',
        'Tecnica6',
        'Moderno'
    );
-- APARTADO 10 - A�adir una nueva restricci�n sobre la tabla PINTORES que exprese que los c�digos de los nuevos pintores que se introduzcan en la BD deben estar entre 1 y 100 y su verificaci�n siempre ser� al final de la transacci�n.
-- A) �qu� opci�n debemos usar DEFERRABLE/NOT DEFERRABLE, IMMEDIATE/DEFERRED ? 
ALTER TABLE DBDC07.PINTORES
ADD CONSTRAINT COD_PINTOR CHECK (
        CODPINTOR BETWEEN 1 AND 100
    ) NOT DEFERRABLE INITIALLY IMMEDIATE ENABLE NOVALIDATE;
-- B) Cambiar para que se compruebe en el momento
SET CONSTRAINT COD_PINTOR DEFERRED;
-- ORA-02447: no se puede diferir una restricci�n que no es diferible
-- C) Si no quisi�ramos que su verificaci�n fuera siempre deferred sino que se pudiera cambiar de deferred a immediate �C�mo definir�amos la restricci�n? (inicialmente deferred). Comprobar su funcionamiento
ALTER TABLE DBDC07.PINTORES DROP CONSTRAINT COD_PINTOR;
-- PRIMERO BORRAR LA ANTERIOR
ALTER TABLE DBDC07.PINTORES
ADD CONSTRAINT COD_PINTOR CHECK (
        CODPINTOR BETWEEN 1 AND 100
    ) DEFERRABLE INITIALLY IMMEDIATE ENABLE NOVALIDATE;
-- NO DA ERROR
SET CONSTRAINT COD_PINTOR DEFERRED;
-- DEJA CAMBIAR A DEFERRED:
- - >> > NO SE SI FUNCIONA CORRECTAMENTE.� DEBE INSERTAR CON CODIGO 900 ?
INSERT INTO DBDC07.PINTORES
VALUES(
        900,
        'Nombre9',
        'Artistico9',
        'Aleman',
        DATE '1964-05-30',
        DATE '1990-11-23'
    );
INSERT INTO DBDC07.PINTORES
VALUES(
        9,
        'Nombre9',
        'Artistico9',
        'Aleman',
        DATE '1964-05-30',
        DATE '1990-11-23'
    );
SELECT *
FROM DBDC07.PINTORES;
DELETE FROM DBDC07.PINTORES
WHERE CODPINTOR = 900;
DELETE FROM DBDC07.PINTORES
WHERE CODPINTOR = 9;
SELECT *
FROM DBDC07.PINTORES;
-- APARTADO 11 - Indicar que las restricciones alemanes (punto8) se deben verificar al final de la transacci�n.
-- Primero hay que borrar la restricci�n y luego introducir la nueva restricci�n. Nota: Hay que fijarse en lo que ocurre despu�s del COMMIT.
ALTER TABLE DBDC07.PINTORES DROP CONSTRAINT NACIONALIDAD_ALEMANA;
ALTER TABLE DBDC07.PINTORES
ADD CONSTRAINT NACIONALIDAD_ALEMANA CHECK (
        NACIONALIDAD IN (
            'Aleman',
            'aleman',
            'ALEMAN',
            'Alemana',
            'alemana',
            'ALEMANA'
        )
    ) DEFERRABLE INITIALLY DEFERRED ENABLE NOVALIDATE;
-- Al no poner que SIEMPRE se deben modificar al final, usamos DEFERRABLE
-- APARTADO 12 - Modificar el tipo de R.I. de DEFFERED a INMEDIATE (o viceversa) en una sesi�n.
-- POR DEFECTO: NOT DEFERRABLE INITIALLY IMMEDIATE ENABLE VALIDATE
ALTER SESSION
SET CONSTRAINTS = DEFERRED;
ALTER SESSION
SET CONSTRAINTS = IMMEDIATE;