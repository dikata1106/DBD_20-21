-- DANIEL RUSKOV 10/11/2020
/*
 DROP TABLE EMPLEADO;
 DROP TABLE DEPARTAMENTO;
 DROP TABLE CAMBIOSALARIO_LOG;
 DROP TRIGGER CONTROL_PRESUPUESTOPERSONAL;
 DROP TRIGGER DNI_66;
 DROP TRIGGER CAMBIO_SALARIO;
 DROP TRIGGER CAMBIO_SALARIO_NOVIEMBRE;
 DROP TRIGGER MAX3_EMPL_DEP;
 /**/
-- APARTADO 0 - Crear las siguientes tablas: 
-- Crear tuplas para la tabla DEPARTAMENTO con el atributo Presupuestopersonal a 0.
CREATE TABLE DEPARTAMENTO (
    NOMBRE VARCHAR2(20),
    PRESUPUESTOPERSONAL NUMBER,
    PRIMARY KEY(NOMBRE)
);
CREATE TABLE EMPLEADO (
    DNI NUMBER,
    SALARIO NUMBER,
    SUDPTO VARCHAR2(20) REFERENCES DEPARTAMENTO (NOMBRE),
    PRIMARY KEY (DNI)
);
INSERT INTO DEPARTAMENTO
VALUES ('Dpto1', 0);
INSERT INTO DEPARTAMENTO
VALUES ('Dpto2', 0);
INSERT INTO DEPARTAMENTO
VALUES ('Dpto3', 0);
INSERT INTO DEPARTAMENTO
VALUES ('Dpto4', 0);
-- APARTADO 1 - Crear un disparador que controle que el atributo presupuestoPersonal del departamento se calcula como la suma de
-- los salarios de los empleados que trabajan en dicho departamento (s?lo para los casos de inserci?n de nuevos empleados y de
-- modificaci?n del sueldo de los ya existentes). Verificar el funcionamiento del trigger 
CREATE OR REPLACE TRIGGER CONTROL_PRESUPUESTOPERSONAL
AFTER
INSERT
    OR
UPDATE OF SALARIO ON EMPLEADO FOR EACH ROW BEGIN IF INSERTING THEN
UPDATE DEPARTAMENTO
SET PRESUPUESTOPERSONAL = PRESUPUESTOPERSONAL + :NEW.SALARIO
WHERE NOMBRE = :NEW.SUDPTO;
ELSE
UPDATE DEPARTAMENTO
SET PRESUPUESTOPERSONAL = PRESUPUESTOPERSONAL + :NEW.SALARIO - :OLD.SALARIO
WHERE NOMBRE = :NEW.SUDPTO;
END IF;
END;
SELECT *
FROM DEPARTAMENTO
WHERE NOMBRE = 'Dpto1';
INSERT INTO EMPLEADO
VALUES(1, 4300, 'Dpto1');
SELECT *
FROM DEPARTAMENTO
WHERE NOMBRE = 'Dpto1';
UPDATE EMPLEADO
SET SALARIO = SALARIO - 250
WHERE DNI = 1;
SELECT *
FROM DEPARTAMENTO
WHERE NOMBRE = 'Dpto1';
ALTER TRIGGER CONTROL_PRESUPUESTOPERSONAL DISABLE;
-- APARTADO 2 - Crear un disparador que al introducir el empleado con DNI 66, introduzca su nuevo departamento en la tabla 
-- DEPARTAMENTO y que dicha tupla tenga como Presupuestopersonal el valor de 100000 euros. Usar la opci?n REFERENCING
SELECT *
FROM DEPARTAMENTO;
SELECT *
FROM EMPLEADO;
CREATE OR REPLACE TRIGGER DNI_66
AFTER
INSERT ON EMPLEADO REFERENCING NEW AS NUEVO_DPTO FOR EACH ROW
    WHEN (NUEVO_DPTO.DNI = 66) BEGIN
INSERT INTO DEPARTAMENTO
VALUES (:NUEVO_DPTO.SUDPTO, 100000);
END;
INSERT INTO EMPLEADO
VALUES(66, 1200, 'Dpto5');
SELECT *
FROM DEPARTAMENTO;
ALTER TRIGGER DNI_66 DISABLE;
-- APARTADO 3 - Realizar un seguimiento de los cambios en el salario de los empleados (inserciones y modificaciones). Estos
-- cambios se irAn registrando en la tabla CambioSalario_log. Verificar el funcionamiento del trigger.
-- CambioSalario_log (quien varchar2(20) not null, cuando date not null, dniEmpleado number not null, salarioAntes number,
-- salariodespues number); CREATE TABLE CambioSalario_log (quien varchar2(20) not null, cuando date not null, dniEmpleado number
-- not null, salarioAntes number, salariodespues number); Quien USER, cuando SYSDATE 
CREATE TABLE CAMBIOSALARIO_LOG (
    QUIEN VARCHAR2(20) NOT NULL,
    CUANDO DATE NOT NULL,
    DNIEMPLEADO NUMBER NOT NULL,
    SALARIOANTES NUMBER,
    SALARIODESPUES NUMBER
);
CREATE OR REPLACE TRIGGER CAMBIO_SALARIO
AFTER
INSERT
    OR
UPDATE OF SALARIO ON EMPLEADO FOR EACH ROW BEGIN
INSERT INTO CAMBIOSALARIO_LOG
VALUES (
        USER,
        SYSDATE,
        :NEW.DNI,
        :OLD.Salario,
        :NEW.Salario
    );
END;
UPDATE EMPLEADO
SET SALARIO = 2200
WHERE DNI = 66;
SELECT *
FROM CAMBIOSALARIO_LOG;
ALTER TRIGGER CAMBIO_SALARIO DISABLE;
-- APARTADO 4 - Evitar que el salario sea actualizado durante el mes de Noviembre. MON- Abreviatura de MONTH.
-- Codigos de error entre -20000 y -20999 
CREATE OR REPLACE TRIGGER CAMBIO_SALARIO_NOVIEMBRE BEFORE DELETE
    OR
INSERT
    OR
UPDATE OF SALARIO ON EMPLEADO
DECLARE SIN_SALARIO_NOVIEMBRE EXCEPTION;
BEGIN IF (to_char(SYSDATE, 'MON') = 'NOV') THEN RAISE SIN_SALARIO_NOVIEMBRE;
END IF;
EXCEPTION
WHEN SIN_SALARIO_NOVIEMBRE THEN Raise_Application_Error (
    -20343,
    'Error. No se puede modificar el salario durante el mes de noviembre'
);
END;
UPDATE EMPLEADO
SET SALARIO = 0
WHERE DNI = 1;
INSERT INTO EMPLEADO
VALUES (67, 2000, 'Dpto2');
ALTER TRIGGER CAMBIO_SALARIO_NOVIEMBRE DISABLE;
-- APARTADO 5 - Restringir el nUmero mximo de empleados de un departamento a 3 
DROP TRIGGER MAX_EMPLEADOS_3;
CREATE OR REPLACE TRIGGER MAX3_EMPL_DEP BEFORE
INSERT
    OR
UPDATE OF SUDPTO ON EMPLEADO FOR EACH ROW
DECLARE NUM_EMPL NUMBER;
-- DECLARE MAX_3_EMPLEADOS_POR_DPTO EXCEPTION;
BEGIN
SELECT COUNT(*) INTO NUM_EMPL
FROM EMPLEADO
WHERE SUDPTO = :NEW.SUDPTO;
IF (NUM_EMPL >= 3) THEN Raise_Application_Error (
    -20344,
    'Error. No se pueden incluir más de 3 empleados por dpto'
);
END IF;
END;
INSERT INTO EMPLEADO
VALUES (67, 2000, 'Dpto1');
INSERT INTO EMPLEADO
VALUES (68, 2200, 'Dpto1');
INSERT INTO EMPLEADO
VALUES (69, 3500, 'Dpto1');
SELECT *
FROM EMPLEADO;
ALTER TRIGGER MAX3_EMPL_DEP DISABLE;
-- APARTADO 6 - Definir una restricciOn de integridad y un disparador que actUan sobre el mismo atributo y comprobar en quE
-- orden los verifica ORACLE (por ejemplo, poner una restricciOn de integridad sobre el Salario) 
-- >>> POR HACER 
-- APARTADO 7 - Desactivar el disparador anterior y volverlo a activar.
ALTER TRIGGER MAX3_EMPL_DEP ENABLE;
ALTER TRIGGER MAX3_EMPL_DEP DISABLE;
-- APARTADO 8 - Consultar la información existente en el diccionario/catálogo sobre el disparador EJEMPLO 3 
-- SELECT trigger_type, triggering_event, table_name FROM user_triggers WHERE trigger_name = ‘XXXX’;
-- Para ver los triggers de un usuario
-- SELECT trigger_name FROM user_triggers WHERE User = 'DBDCXX';
-- Nota SHOW ERRORS TRIGGER nombre trigger 
SELECT trigger_type,
    triggering_event,
    table_name
FROM user_triggers;
SELECT trigger_type,
    triggering_event,
    table_name
FROM user_triggers
WHERE trigger_name = 'CAMBIO_SALARIO';
SHOW ERRORS TRIGGER CAMBIO_SALARIO;
/**/