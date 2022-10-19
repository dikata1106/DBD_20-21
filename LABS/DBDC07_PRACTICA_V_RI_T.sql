-- ============================================================================================
-- VISTAS
-- ============================================================================================
DROP VIEW INFO_CAMISETAS;
DROP VIEW EMPLEADO_VIEW;
DROP VIEW CAMISETAS_VIEW;
SELECT * FROM INFO_CAMISETAS;
SELECT * FROM EMPLEADO_VIEW;
SELECT * FROM CAMISETAS_VIEW;
-- ==============================================
-- Vista que muestra la descripcion de diseño y marca de todas las camisetas
-- que son de marca junto con su codigo (personalizadas y no personalizadas)
CREATE VIEW INFO_CAMISETAS AS (
    SELECT *
    FROM (
            SELECT MARCA.CodCamiseta,
                PERSONALIZADA.DisenoPersonalizado AS DISENO,
                MARCA.MARCA
            FROM PERSONALIZADA
                JOIN MARCA ON MARCA.CodCamiseta = PERSONALIZADA.CodCamiseta
        )
    UNION
    (
        SELECT MARCA.CodCamiseta,
            NO_PERSONALIZADA.DisenoTemporada AS DISENO,
            MARCA.MARCA
        FROM NO_PERSONALIZADA
            JOIN MARCA ON MARCA.CodCamiseta = NO_PERSONALIZADA.CodCamiseta
    )
);
-- Vista que selecciona los atributos mas relevantes de los empleados
-- desde el punto de vista de las empresas
CREATE VIEW EMPLEADO_VIEW AS (
    SELECT DNI_E,
        NSS,
        NIF_EMPRESA,
        JORNADA,
        Sueldo
    FROM EMPLEADO
);
-- Vista que selecciona las camisetas y muestra los atributos necesarios
-- para poder localizarlas en los lotes de los almacenes
CREATE VIEW CAMISETAS_VIEW AS (
    SELECT CodCamiseta,
        Talla,
        NIF_F,
        IdAlmacen,
        Lote
    FROM CAMISETA
);
-- ============================================================================================
-- RESTRICCIONES DE INTEGRIDAD
-- ============================================================================================
ALTER TABLE CAMISETA DROP CONSTRAINT TALLA_VALIDA;
ALTER TABLE MATERIAS DROP CONSTRAINT MATERIALES;
ALTER TABLE CAMISETA DROP CONSTRAINT TIPO_CORRECTO;
ALTER TABLE CAMISETA DROP CONSTRAINT COD_INI_PERS;
ALTER TABLE CAMISETA DROP CONSTRAINT COD_INI_NO_PERS;
-- ==============================================
-- Restriccion de integridad que comprueba que la talla introducida de una 
-- camiseta es correcta (xs, s, m, l, xl, xxl, XS, S, M, L, XL, XXL).
ALTER TABLE CAMISETA
ADD CONSTRAINT TALLA_VALIDA CHECK (
        Talla IN (
            'xs',
            's',
            'm',
            'l',
            'xl',
            'xxl',
            'XS',
            'S',
            'M',
            'L',
            'XL',
            'XXL'
        )
    );
-- Restriccion de integridad que comprueba que los materiales introducidos
-- de una camiseta son correctos (algodon ringspun, algodon hilado,
-- algodon pre-encogido, poliester)
ALTER TABLE MATERIAS
ADD CONSTRAINT MATERIALES CHECK (
        Materia IN (
            'algodon ringspun',
            'algodon hilado',
            'algodon pre-encogido',
            'poliester'
        )
    );
-- Restriccion de integridad que comprueba que el tipo introducido de 
-- camiseta es correcto (personalizada, n personalizada)
ALTER TABLE CAMISETA
ADD CONSTRAINT TIPO_CORRECTO CHECK (
        Tipo IN (
            'personalizada',
            'n personalizada'
        )
    );
-- Restriccion de integridad que verifica si una camiseta es personalizada,
-- entonces su codigo empieza por 1.
ALTER TABLE CAMISETA
ADD CONSTRAINT COD_INI_PERS CHECK (
        NOT (
            Tipo = 'personalizada'
            AND NOT (CodCamiseta LIKE '1%')
        )
    );
-- Restriccion de integridad que verifica si una camiseta es no personalizada,
-- entonces su codigo empieza por 0.
ALTER TABLE CAMISETA
ADD CONSTRAINT COD_INI_NO_PERS CHECK (
        NOT (
            Tipo = 'no personalizada'
            AND NOT (CodCamiseta LIKE '0%')
        )
    );
-- ============================================================================================
-- TRIGGERS
-- ============================================================================================
DROP TRIGGER INSERTAR_EN_SUBCLASES;
DROP TRIGGER MAX_SUELDO;
DROP TRIGGER CLIENTES_MAYORES_DE_EDAD;
-- ==============================================
-- Trigger que al insertar en la tabla camisetas, automaticamente y segun el codigo de camiseta
-- inserta la camiseta en la subclase disjunta correspondiente con descripcion null para que
-- pueda ser modificado posteriormente con facilidad mediante rango de codigos. Tambien se activa
-- al modificar y eliminar (pero al tratarse de FK y PK hay RI que actuan antes)
CREATE OR REPLACE TRIGGER INSERTAR_EN_SUBCLASES
AFTER INSERT OR UPDATE OR DELETE OF CodCamiseta ON CAMISETA
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF (:NEW.CodCamiseta LIKE '1%') THEN
            INSERT INTO PERSONALIZADA VALUES (:NEW.CodCamiseta, NULL);
        ELSE
            INSERT INTO NO_PERSONALIZADA VALUES (:NEW.CodCamiseta, NULL);
        END IF;
    END IF;
    IF UPDATING THEN
        IF ((:NEW.CodCamiseta LIKE '1%') AND (:OLD.CodCamiseta LIKE '0%')) THEN
            DELETE FROM NO_PERSONALIZADA WHERE CodCamiseta = :OLD.CodCamiseta;
            INSERT INTO PERSONALIZADA VALUES (:NEW.CodCamiseta, NULL);
        END IF;
        IF ((:NEW.CodCamiseta LIKE '0%') AND (:OLD.CodCamiseta LIKE '1%')) THEN
            DELETE FROM PERSONALIZADA WHERE CodCamiseta = :OLD.CodCamiseta;
            INSERT INTO NO_PERSONALIZADA VALUES (:NEW.CodCamiseta, NULL);
        END IF;
    END IF;
    IF DELETING THEN
        IF (:NEW.CodCamiseta LIKE '1%') THEN
            DELETE FROM PERSONALIZADA WHERE CodCamiseta = :OLD.CodCamiseta;
        ELSE
            DELETE FROM NO_PERSONALIZADA WHERE CodCamiseta = :OLD.CodCamiseta;
        END IF;
    END IF;
END;
-- Trigger que obliga que el sueldo de los empleados no supere el valor de  5000
CREATE OR REPLACE TRIGGER MAX_SUELDO
BEFORE INSERT OR UPDATE OF Sueldo ON EMPLEADO
REFERENCING NEW AS INSERTADO 
FOR EACH ROW WHEN (INSERTADO.Sueldo > 5000)
BEGIN 
    Raise_Application_Error (
        -20343,
        'Error, el salario maximo es de 5000 por persona'
    );
END;
-- Trigger que impide fidelizar a clientes menores de edad
CREATE OR REPLACE TRIGGER CLIENTES_MAYORES_DE_EDAD
BEFORE INSERT ON CLIENTE
FOR EACH ROW
DECLARE MENORES_EXCEPTION EXCEPTION;
BEGIN
    IF ((months_between(SYSDATE, :NEW.FechaNacim)/12) < 18) THEN
        RAISE MENORES_EXCEPTION;
    END IF;
    EXCEPTION
    WHEN MENORES_EXCEPTION THEN
        Raise_Application_Error (
        -20434,
        'Error, el cliente a registrar no puede ser menor de edad'
    );
END;