INSERT INTO FABRICA
VALUES(
        '27919841Q',
        'Francia',
        'Le Pré Nonnain',
        'Baguette Cloth',
        '33629612760'
    );
INSERT INTO FABRICA
VALUES(
        '48195360R',
        'España',
        'Calle del General Eguía',
        'Todo Camisetas',
        '34698395175'
    );
INSERT INTO FABRICA
VALUES(
        '84934726A',
        'Alemania',
        'Althoffstrabe',
        'Kartoffen Kleidung',
        '49632195786'
    );
INSERT INTO FABRICA
VALUES(
        '59812679X',
        'Portugal',
        'Rua do Quanza',
        'tudo é barato',
        '351608607935'
    );
INSERT INTO ALMACEN
VALUES('27919841Q', '001');
INSERT INTO ALMACEN
VALUES('27919841Q', '002');
INSERT INTO ALMACEN
VALUES('84934726A', '001');
INSERT INTO ALMACEN
VALUES('59812679X', '001');
INSERT INTO CAMISETA
VALUES(
        '000001',
        'n personalizada',
        'negro',
        '20-MAY-2020',
        'm',
        '27919841Q',
        '001',
        'CCP-FR-0142-24D'
    );
INSERT INTO CAMISETA
VALUES(
        '100001',
        'personalizada',
        'negro',
        '20-MAY-2020',
        'm',
        '27919841Q',
        '001',
        'CCP-FR-0142-24D'
    );
INSERT INTO CAMISETA
VALUES(
        '000002',
        'n personalizada',
        'blanco',
        '01-OCT-2020',
        's',
        '84934726A',
        '001',
        'CCN-ES-9681-89A'
    );
INSERT INTO CAMISETA
VALUES(
        '100002',
        'personalizada',
        'azul',
        '30-SEP-2020',
        'xl',
        '84934726A',
        '001',
        'CCP-GR-5820-96X'
    );
INSERT INTO PERSONALIZADA
VALUES('100001', 'degradado inferior');
INSERT INTO PERSONALIZADA
VALUES('100002', 'degradado inferior');
INSERT INTO NO_PERSONALIZADA
VALUES('000001', 'temporada de verano');
INSERT INTO NO_PERSONALIZADA
VALUES('000002', 'temporada de primavera');
INSERT INTO MARCA
VALUES('100001', 'ADIDAS');
INSERT INTO MARCA
VALUES('000001', 'NIKE');
INSERT INTO TIENDA
VALUES(
        '25712965P',
        'Calle Hondarribia',
        'Facil Sport',
        '34678932145'
    );
INSERT INTO TIENDA
VALUES(
        '89645398B',
        'Paseo de la Estacion',
        'Todo Ropa',
        '34602163965'
    );
INSERT INTO TIENDA
VALUES(
        '96354896N',
        'Cleveland Square',
        'Cheap Cloth',
        '44633978801'
    );
--
INSERT INTO EMPLEADO
VALUES(
        '26596530W',
        'Ander',
        'Goikoetxea',
        'Arruti',
        'h',
        'Calle/Pio XII Portal/23 Piso/2Izq',
        '34679012360',
        '555501234',
        DATE '1972-01-21',
        'jefe',
        DATE '2010-06-20',
        '1700',
        '25712965P',
        'manana',
        '5'
    );
INSERT INTO EMPLEADO
VALUES(
        '45169853I',
        'Lara',
        'Gutierrez',
        'Santos',
        'm',
        'Calle/Baroja Portal/11 Piso/3C',
        '34696321056',
        '963656896',
        DATE '1990-10-01',
        'jefe',
        DATE '2017-07-01',
        '2200',
        '89645398B',
        'tarde',
        '6'
    );
INSERT INTO EMPLEADO
VALUES(
        '01298654J',
        'John',
        'McFly',
        'Baker',
        'h',
        'Calle/Jhonny Portal/XI Piso/1A',
        '346789345102',
        '017854109',
        DATE '1983-08-12',
        'reponedor',
        DATE '2019-12-30',
        '1300',
        '25712965P',
        'manana',
        '10'
    );
INSERT INTO EMPLEADO
VALUES(
        '74823615H',
        'Mikel',
        'Arozena',
        'Belarra',
        'h',
        'Calle/Consuelo Portal/9 Piso/7D',
        '34663089666',
        '120365965',
        DATE '1995-02-28',
        'caja',
        DATE '2013-08-03',
        '1500',
        '25712965P',
        'tarde',
        '9'
    );
INSERT INTO CLIENTE
VALUES(
        '45169853I',
        'Lara',
        'Gutierrez',
        'Santos',
        'm',
        'Calle/Baroja Portal/11 Piso/3C',
        '34696321056',
        DATE '1995-02-28'
    );
INSERT INTO CLIENTE
VALUES(
        '69836512F',
        'Maider',
        'Sagarzazu',
        'Echezurieta',
        'm',
        'Calle/Sancho Panza Portal/3 Piso/1A',
        '34632013960',
        DATE '1986-10-24'
    );
INSERT INTO EMPLEADO_CLIENTE
VALUES('45169853I', '21%');