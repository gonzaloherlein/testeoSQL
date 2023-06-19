CREATE SCHEMA IF NOT EXISTS practicabd;
USE practicabd;

CREATE TABLE IF NOT EXISTS almacen (
	idAlmacen int primary key auto_increment not null,
	nombreAlmacen varchar(50) not null,
	dueño varchar(60) not null);

CREATE TABLE IF NOT EXISTS producto (
	idProducto int primary key auto_increment not null,
	nombreProducto varchar(50) not null,
	precioProducto decimal(7,2) not null
);

-- Material (cod_mat, descripción) --

CREATE TABLE IF NOT EXISTS material(
	cod_mat int primary key not null,
	descripcion varchar(40) not null
);
 
-- Ciudad (cod_ciu, nombre)
CREATE TABLE IF NOT EXISTS ciudad(
	cod_ciu int primary key auto_increment not null,
	nombreCiudad varchar(40)
);

-- Proveedor (cod_prov, nombre, domicilio, cod_ciu, fecha_alta)
CREATE TABLE IF NOT EXISTS proovedor(
	cod_prov int primary key auto_increment not null,
	nombre varchar(40) not null,
	domicilio varchar(40) not null,
	cod_ciu int,
	fecha_alta date,
	constraint foreign key (cod_ciu) references ciudad(cod_ciu)
);

-- Contiene (nro, cod_art)
CREATE TABLE IF NOT EXISTS contiene(
	nro int not null,
	idProducto int not null,
	constraint contiene_pk primary key (nro, idProducto),
	foreign key (nro)  references almacen(idAlmacen),
	foreign key (idProducto) references producto(idProducto)
);

-- Compuesto_por (cod_art, cod_mat) 
CREATE TABLE IF NOT EXISTS compuesto_por (
	idProducto int,
	cod_mat int,
	constraint compuesto_por_pk primary key (idProducto, cod_mat),
	foreign key (idProducto) references producto(idProducto),
	foreign key (cod_mat) references material(cod_mat)
);

-- Provisto_por (cod_mat, cod_prov)
CREATE TABLE IF NOT EXISTS provisto_por(
	cod_mat int,
    cod_prov int,
    constraint provisto_pk primary key (cod_mat, cod_prov),
	foreign key (cod_mat)  references material(cod_mat),
	foreign key (cod_prov) references proovedor(cod_prov)
);

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO producto values (0,'Asilla', 105);
INSERT INTO producto values (0,'Asssssilla', 230);
INSERT INTO producto values (0,'GAsssssilla', 230);

INSERT INTO almacen values(0,'Almacen la Perla', 'Jorge');

INSERT INTO ciudad values (0,'San Juan');
INSERT INTO ciudad values (0,'Neuquen');
INSERT INTO ciudad values (0,'La Rioja'),
						  (0,'Buenos Aires'),
						  (0,'La Pampa');
INSERT INTO ciudad values (0,'La Plata');
INSERT INTO ciudad values (0,'Rosario');
INSERT INTO ciudad values (0,'Zarate');
INSERT INTO ciudad values (0,'Capital Federal');

INSERT INTO proovedor values(0,'Eduardo','Kiernan 222',1,20200101);
INSERT INTO proovedor values(0,'Gonzalo','Kiernan 222',6,20200101);
INSERT INTO proovedor values(0,'Gaston','Kiernan 222',6,20200101);

INSERT INTO proovedor values(0,'Ricardo','Kiernan 222',2,20200201),
							(0,'Sergio','Kiernan 222',3,20200301);


INSERT INTO material values (1,'Acero'),
							(3,'Metal'),
							(6,'Plastico'),
							(9,'PVC'),
							(10,'Aluminio'),
							(18,'Polipropileno');

INSERT INTO proovedor values(0,'Eduardo','Suipacha 222',3,20010101);
INSERT INTO proovedor values(0,'Sebastian','Suipacha 223',3,20010501);
INSERT INTO proovedor values(0,'Marcelo','Suipachaense 222',3,20010120);
INSERT INTO proovedor values(0,'Juansito','Suipachaense 222',6,20010120);
INSERT INTO proovedor values(0,'Hernan','Suipachaense 222',7,20010120);
INSERT INTO proovedor values(0,'Lucas','Suipachaense 222',7,20010120);

INSERT INTO contiene (nro,idProducto) values (1,1);
INSERT INTO contiene (nro,idProducto) values (1,2);

INSERT INTO provisto_por (cod_mat,cod_prov) values (1,10);
INSERT INTO provisto_por (cod_mat,cod_prov) values (1,11);
INSERT INTO provisto_por (cod_mat,cod_prov) values (6,10);
INSERT INTO provisto_por (cod_mat,cod_prov) values (6,11);

SELECT idProducto, nombreProducto
FROM producto
WHERE precioProducto BETWEEN 100 AND 1000 AND nombreProducto LIKE 'A%';

SELECT cod_prov, nombre
FROM proovedor
WHERE cod_prov like 1;

SELECT *
FROM ciudad;

SELECT descripcion
FROM material
WHERE cod_mat in (1,3,6,9,18);

SELECT cod_prov, nombre
FROM proovedor
WHERE domicilio like 'Suipacha%' and fecha_alta between '20010101' and '20020101';

SELECT *
FROM proovedor;


SELECT proovedor.nombre, ciudad.nombre
FROM proovedor, ciudad
WHERE proovedor.cod_ciu = ciudad.cod_ciu;

SELECT proovedor.nombre
FROM proovedor, ciudad
WHERE proovedor.cod_ciu = ciudad.cod_ciu AND proovedor.cod_ciu = 6;

SELECT almacen.idAlmacen, producto.nombreProducto
FROM almacen JOIN contiene ON almacen.idAlmacen = contiene.nro JOIN producto ON producto.idProducto = contiene.idProducto
WHERE producto.nombreProducto like 'A%';

SELECT material.cod_mat, material.descripcion
FROM material JOIN provisto_por ON material.cod_mat = provisto_por.cod_mat JOIN proovedor ON proovedor.cod_prov = provisto_por.cod_prov
WHERE proovedor.cod_ciu = 7;

SELECT proovedor.nombre
from provisto_por join proovedor
on provisto_por.cod_prov = proovedor.cod_prov
join material
on provisto_por.cod_mat = material.cod_mat
join compuesto_por
on material.cod_mat = compuesto_por.cod_mat
join producto
on compuesto_por.idProducto = producto.idProducto
join contiene
on producto.idProducto = contiene.idProducto
join almacen
on contiene.nro = almacen.idAlmacen
where almacen.dueño = "Martin Gomez";

-- Consulta 10
UPDATE contiene
set contiene.nro = 20
where contiene.idProducto = 10;

-- Consulta 11
-- Eliminar a los proveedores que contengan la palabra ABC en su nombre
delete from proovedor 
where proovedor.nombre like 'ABC%';

-- Consulta 12
-- Indicar la cantidad de proveedores que comienzan con la letra F
SELECT count(*) as 'cantidad de proveedores'
 FROM proovedor
 WHERE nombre LIKE 'F%';

-- Consulta 13
-- Listar el promedio de precios de los artículos por cada almacén (nombre)
select almacen.nombreAlmacen as 'almacen', avg(producto.precioProducto) as 'precio promedio'
from producto join contiene on producto.idProducto = contiene.idProducto join almacen on almacen.idAlmacen = contiene.nro
group by almacen.idAlmacen, almacen.nombreAlmacen;

-- Consulta 14
-- Listar la descripción de artículos compuestos por al menos 2 materiales.
SELECT a.nombreProducto
FROM producto a JOIN compuesto_por c ON a.idProducto= c.idProducto
GROUP BY a.idProducto,a.nombreProducto
HAVING COUNT(*) >= 2;
 
-- Consulta 15
-- Listar cantidad de materiales que provee cada proveedor (código, nombre y domicilio)”
SELECT p.cod_prov,
		p.nombre,
		p.domicilio,
 COUNT(pp.cod_mat) AS 'cantidad de materiales'
 FROM proovedor p LEFT JOIN provisto_por pp ON p.cod_prov = pp.cod_prov
GROUP BY p.cod_prov, p.nombre, p.domicilio;

-- Consulta 16
-- Cuál es el precio máximo de los artículos que proveen los proveedores de la ciudad de Zárate

SELECT max(a.precioProducto)
 FROM proovedor p JOIN provisto_por pp ON p.cod_prov = pp.cod_prov
				 JOIN compuesto_por cp ON pp.cod_mat = cp.cod_mat
				 JOIN producto a ON cp.idProducto = a.idProducto
				 JOIN ciudad c ON c.cod_ciu = p.cod_ciu
 WHERE c.nombre = 'Zarate';
 
 -- Consulta 17
 -- Listar los nombres de aquellos proveedores que no proveen ningún material
select proovedor.nombre
from proovedor 
where not exists(select 1
					from provisto_por pp
					where pp.cod_prov = proovedor.cod_prov);

-- Consulta 18
-- Listar los códigos de los materiales que provea el proveedor 10 y no los provea el proveedor 15
select material.cod_mat
from material
where exists (select 1
				from provisto_por pp 
                where pp.cod_mat = material.cod_mat and pp.cod_prov = 10) 
AND not exists(select 1
				from provisto_por pp2 
                where pp2.cod_mat = material.cod_mat and pp2.cod_prov = 15);
                
-- Consulta 19
-- Listar número y nombre de almacenes que contienen los artículos de descripción A y los de descripción B (ambos)
select a.idAlmacen, a.nombreAlmacen
from almacen a
where exists (select 1
				from contiene c join producto p on c.idProducto = p.idProducto
                where a.idAlmacen = c.nro and p.nombreProducto = 'A')
and exists (select 1
				from contiene c join producto p2 on c.idProducto = p2.idProducto
                where a.idAlmacen = c.nro and p2.nombreProducto = 'B');

-- Consulta 20
-- Listar la descripción de artículos compuestos por todos los materiales.
select p.nombreProducto
from producto p
where not exists (select 1
					from material m
                    where not exists (select 1
										from compuesto_por cp
										where p.idProducto = cp.idProducto and m.cod_mat = cp.cod_mat));
                                        
-- Consulta 21
-- Hallar los códigos y nombres de los proveedores que proveen al menos un material que se usa en algún artículo cuyo precio es mayor a $100
select p.cod_prov, p.nombre
from proovedor p
where exists(select 1
				from provisto_por pp join compuesto_por cp on pp.cod_mat = cp.cod_mat
									 join producto prod on cp.cod_mat = prod.idProducto
				where prod.precioProducto > 100 and p.cod_prov = pp.cod_prov);
                
-- Consulta 22
-- Listar la descripción de los artículos de mayor precio
select p.nombreProducto 
from producto p
where p.precioProducto = (select max(precioProducto) from producto b);

-- Consulta 23
-- Listar los nombres de proveedores de Capital Federal que sean únicos proveedores de algún material.
SELECT DISTINCT p.nombre
FROM proovedor p
WHERE p.cod_ciu = 9
AND p.nombre IN (
    SELECT pm.cod_prov
    FROM provisto_por pm join material m on pm.cod_mat = m.cod_mat
    HAVING COUNT(DISTINCT pm.cod_mat) = 1
);

-- Consulta 24 
-- Listar los nombres de almacenes que almacenan la mayor cantidad de artículos.
select a.nombreAlmacen
from almacen a join contiene c on a.idAlmacen = c.nro
			   join producto p on p.idProducto = c.idProducto
where exists (select max(count(p.idProducto))
				from contiene c);
                
-- Consulta 25
-- Listar la ciudades donde existan proveedores que proveen todos los materiales.
select *
from ciudad
where not exists(select 1
					from proovedor p 
					where not exists(select 1
										from provisto_por pp 
                                        where pp.cod_prov = p.cod_prov and p.cod_ciu = ciudad.cod_ciu)) 

