-- SELECT COUNT(ALUMNOS.NOMBRE) FROM ALUMNOS WHERE NOMBRE = 'Alfredo';
-- SELECT COUNT(ALUMNOS.DNI) FROM ALUMNOS WHERE DNI = '10999999';
-- SELECT NOMBRE FROM (ALUMNOS INNER JOIN MATRICULACIONES ON (ALUMNOS.DNI = MATRICULACIONES.DNI)) WHERE (ALUMNOS.DNI BETWEEN '10000000' AND '11999999') GROUP BY NOMBRE HAVING COUNT (ASIGNATURA) > 9;
-- SELECT index_name, index_type, table_name, dropped FROM all_indexes WHERE table_name = 'ALUMNOS';
-- UPDATE ALUMNOS SET NACIMIENTO = '28-MAR-95', APELLIDOS = 'Martinez' WHERE NOMBRE = 'Alfredo';

-- DROP INDEX NOMBRES;
-- DROP INDEX DNIMAT;
-- CREATE INDEX NOMBRES ON ALUMNOS (NOMBRE);
-- CREATE INDEX DNI ON ALUMNOS (DNI);
-- CREATE INDEX DNIMAT ON MATRICULACIONES (DNI);
-- CREATE BITMAP INDEX NOMBRES ON ALUMNOS (NOMBRE);
-- CREATE INDEX NOMBRES ON ALUMNOS (NOMBRE) REVERSE;
-- CREATE INDEX NAC ON ALUMNOS (NACIMIENTO);
-- CREATE INDEX APES ON ALUMNOS (APELLIDOS);

-- SET TIMING ON AUTOTRACE ON;
-- ALTER SYSTEM FLUSH BUFFER_CACHE;
-- SET AUTOTRACE OFF;

-- DROP TABLE ALUMNOS;
-- DROP TABLE MATRICULACIONES;