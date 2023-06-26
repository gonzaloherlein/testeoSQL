CREATE DATABASE ModeloParcial2;
USE ModeloParcial2;

CREATE TABLE BICICLETA (
	id INT PRIMARY KEY, 
    rodado INT NOT NULL, 
    marca VARCHAR(20) NULL);
    
CREATE TABLE CASCO (
	idBici INT REFERENCES BICICLETA(id), 
    nro_casco INT NOT NULL, 
    talle VARCHAR(3) NOT NULL,
    PRIMARY KEY(idBici, nro_casco));

CREATE TABLE ACCESORIO (
	cod INT PRIMARY KEY, 
    nombre VARCHAR(50) NOT NULL, 
    personalizado VARCHAR(50) NULL);

CREATE TABLE ESTACION (
	cod INT PRIMARY KEY, 
    nombre VARCHAR(50) NOT NULL, 
    horario VARCHAR(10) NOT NULL, 
    ubicación VARCHAR(50) NOT NULL);
    
CREATE TABLE VECINO (
	tipodoc VARCHAR(3), 
    nro_doc INT,
    nombre VARCHAR(50) NOT NULL, 
    direccion VARCHAR(50) NULL, 
    foto BLOB NULL,
    PRIMARY KEY(tipodoc, nro_doc));

CREATE TABLE TIENE (
	idBici INT REFERENCES BICICLETA(id), 
    codAcc INT REFERENCES ACCESORIO(codAcc),
    PRIMARY KEY(idBici, codAcc));
    
CREATE TABLE OPERACION (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    fecha_hora DATETIME NOT NULL, 
    codEstacion INT NOT NULL REFERENCES ESTACION(cod), 
    idBici INT NOT NULL REFERENCES BICICLETA(id), 
    tipo CHAR(1) NOT NULL, 
    tipodoc VARCHAR(3) NOT NULL, 
    nrodoc INT NOT NULL,
    CONSTRAINT FK_Operacion_Vecino FOREIGN KEY (tipodoc, nrodoc) REFERENCES VECINO(tipodoc, nro_doc));

-- ALTER TABLE OPERACION DROP
-- CONSTRAINT FK_Operacion_Vecino
/*
BICICLETA (id, rodado, marca) PK=id
ACCESORIO (cod, nombre, personalizado) PK=cod
ESTACION (cod, nombre, horario, ubicación) PK=cod
VECINO (tipodoc, nro_doc, nombre, direccion, foto) PK=(tipodoc, nrodoc)
TIENE (idBici, codAcc) PK=(idBici, codAcc)
OPERACION (id, fecha_hora, codEstacion, idBici, tipo, tipodoc, nrodoc) PK=id
Lista de Claves Foráneas
CASCO.idBici --> BICICLETA.id
TIENE.idBici --> BICICLETA.id
TIENE.codAcc --> ACCESORIO.cod
OPERACION.CodEstacion --> ESTACION.cod
OPERACION.IdBici --> BICICLETA.id
OPERACION.tipodoc + nrodoc --> VECINO.tipodoc + nrodoc
*/
/* 1. DDL */
-- Construir la tabla OPERACION en el modelo físico y las necesarias para ésta, en AnsiSQL.
-- CREATE TABLE BICICLETA, VECINO, ESTACION, OPERACION

/* 2. ABM */
-- a. Insertar dos registros para una tabla a elección, que tengan más de 2 campos.
INSERT INTO VECINO
	(tipodoc, nro_doc, nombre, direccion)
VALUES
	('DNI', 33459054, 'Juan Sebastian Quevedo', 'Florencio Varela 1903'),
    ('DNI', 13245678, 'Eliana Pardeux', 'Florencio Varela 1903');
INSERT INTO OPERACION
	(/*id, */fecha_hora, cod_estacion)
VALUES
	('2023-06-24', 100);

-- b. Eliminar todos los cascos del rango de bicicletas con id=101 a id=123, que sean talle P.
-- DELETE FROM BICICLETA
DELETE FROM CASCO
WHERE idBici BETWEEN 101 AND 123 AND talle LIKE 'P';

-- c. Actualizar todos los accesorios que contengan personalizado ‘MVK-’ a ‘ECO RRR’.
UPDATE ACCESORIO
SET personlizado = 'ECO RRR'
WHERE perzonalizado LIKE '%MVK-%';

/* 3. DML */
-- a. Listar las bicis que tienen asiento para niño y cuántos cascos tienen asociados.
SELECT B.id, B.modelo, B.marca, COUNT(C.nro_casco) cantCascos -- , COUNT(*) cantReg -- , COUNT(T.codAcc)
FROM BICICLETA B
LEFT JOIN CASCO C ON C.idBici = B.id
JOIN TIENE T ON T.idBici = B.id
JOIN ACCESORIOS A ON T.codAcc = A.codAcc
WHERE A.nombre LIKE 'asiento niño'
GROUP BY B.id, B.modelo, B.marca;

-- b. Mostrar código y rodado de las bicicletas que tienen todos los accesorios.
SELECT B.id, B.modelo
FROM BICICLETA B
WHERE NOT EXISTS(SELECT 1
	FROM ACCESORIOS A
    WHERE NOT EXISTS(SELECT 1
		FROM TIENE T
        WHERE T.idBici = B.id AND T.codAcc = A.codAcc));

-- c. ¿Cuál es la cantidad de operaciones en el primer trimestre del año?
SELECT COUNT(O.id)
FROM OPERACION O
WHERE O.fecha_hora BETWEEN '2023-01-01 00:00:00' AND '2023-03-31 23:59:59'
WHERE O.fecha_hora >= '2023-01-01' AND O.fecha_hora < '2023-04-01';

-- d. ¿Cuál es la cantidad de bicis no devueltas en el último mes, 
-- en el día a día? ¿Y desde que empezó a funcionar el sistema? 
-- Se puede suponer que arrancó el 1/04/2022.

SELECT COUNT(Rid)
FROM (
	SELECT R.id Rid, D.id Did
	FROM OPERACION R
	LEFT JOIN OPERACION D ON R.idBici = D.idBici AND R.codEstacion = D.codEstacion
		AND R.tipodoc = D.tipodoc AND R.nrodoc = D.nrodoc 
		AND date(R.fecha_hora) = date(D.fecha_hora) 
		AND R.tipo = 'R' AND D.tipo = 'D'
)
WHERE Did IS NULL;

SELECT date(R.fecha_hora), COUNT(R.id)
FROM OPERACION R
WHERE R.tipo = 'R' AND NOT EXISTS(
 SELECT 1 FROM OPERACION D 
 WHERE R.idBici = D.idBici AND R.codEstacion = D.codEstacion
	AND R.tipodoc = D.tipodoc AND R.nrodoc = D.nrodoc 
    AND date(R.fecha_hora) = date(D.fecha_hora) 
	AND D.tipo = 'D')
GROUP BY date(R.fecha_hora);

-- e. ¿Cuáles son las bicis con más cantidad de accesorios?
SELECT B.*
FROM BICICLETA B
WHERE B.id IN (
	SELECT T.idBici -- , COUNT(T.codAcc) cantAcc
	FROM TIENE T
	GROUP BY T.idBici
	HAVING COUNT(T.codAcc) = (
		SELECT MAX(cantAcc)
		FROM (
			SELECT T.idBici, COUNT(T.codAcc) cantAcc
			FROM TIENE T
			GROUP BY T.idBici
		)
	)
);
    SELECT MAX(cantAcc)
	FROM (
		SELECT T.idBici, COUNT(T.codAcc) cantAcc
		FROM TIENE T
		GROUP BY T.idBici
	);

-- f. Listar nombre y ubicación de las estaciones preferidas de los vecinos, 
-- entendiendo preferidas como las que concentran más préstamos.


-- g. Listar los nombres de vecinos alfabéticamente de 
-- U a W (Ulises Bueno, Vicente López, Will Smith) junto a 
-- la cantidad de estaciones distintas que uso en la última semana, 
-- aún si no se prestó bicicleta (0 estaciones esa semana).
SELECT V.nombre, COUNT(DISTINCT O.codEstacion) cantEstaciones
FROM VECINO
LEFT JOIN OPERACION O ON O.tipodoc = V.tipodoc AND O.nrodoc = V.nrodoc
	AND O.fecha_hora >= '2023-06-19'
WHERE (nombre BETWEEN 'U' AND 'WZ' OR 
	(nombre LIKE 'U%' AND nombre LIKE 'V%' AND nombre LIKE 'W%'))
-- AND O.fecha_hora >= '2023-06-19'
AND (O.fecha_hora IS NULL OR O.fecha_hora >= '2023-06-19')
ORDER BY V.nombre

-- h. Mostrar el ránking de vecinos que han usado el sistema con más 
-- de 3 bicis distintas y que las devolvieron según las reglas.


-- i. ¿Cómo medirías el éxito del programa de Eco Transporte? 
-- Armar una consulta que lo resuelva.
SELECT AVG(a.prestamos) promedio, 
	COUNT(b.prestamos) 'cant con más de 100', 
    C.*
FROM (
	SELECT date(O.fech_hora), COUNT(*) prestamos
	FROM OPERACION O
	WHERE O.tipo = 'R'
) a, (
	SELECT date(O.fech_hora), COUNT(*) prestamos
	FROM OPERACION O
	WHERE O.tipo = 'R'
    HAVING COUNT(*) > 100
) b, (
(
	SELECT COUNT(Did)/COUNT(Rid) as 'Porcenaje devueltas en el dia'
    FROM (
		SELECT R.id Rid, D.id Did
		FROM OPERACION R
		LEFT JOIN OPERACION D ON R.idBici = D.idBici AND R.codEstacion = D.codEstacion
			AND R.tipodoc = D.tipodoc AND R.nrodoc = D.nrodoc 
			AND date(R.fecha_hora) = date(D.fecha_hora) 
			AND R.tipo = 'R' AND D.tipo = 'D'
		)
) c