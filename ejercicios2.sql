create database vuelos;
show databases;
use vuelos;

create table Avion(
		nro_avion int not null,
        tipo_avion varchar(400) not null,
        modelo varchar(400) not null,
        primary key (nro_avion)
);

create table if not exists Vuelo(
		nro_vuelo int not null,
        desde varchar(400) not null,
        hasta varchar(400) not null,
        fecha datetime,
        nro_avion int not null,
        primary key (nro_vuelo),
        foreign key (nro_avion) references Avion (nro_avion)
);


create table Pasajero(
		nro_vuelo int not null,
        documento int not null,
        desde varchar(400) not null,
        constraint pasajero_pk primary key (nro_vuelo, documento),
        foreign key (nro_vuelo) references Vuelo (nro_vuelo)
);

show tables;

alter table Vuelo change fecha fechaa date;
alter table Pasajero change desde nombre varchar(400) not null;

insert into Avion (nro_avion,tipo_avion,modelo) values (01,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (02,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (03,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (04,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (05,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (06,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (07,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (08,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (09,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (10,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (11,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (12,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (13,'Comercial','10');
insert into Avion (nro_avion,tipo_avion,modelo) values (14,'Comercial','10');

insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (01,'Argentina','Francia',20231129,01);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (02,'Argelia','Finlandia',20231129,02);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (03,'Eslovaquia','Francia',20231129,03);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (04,'Argentina','Brasil',20231129,04);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (05,'Argentina','Dinamarca',20231129,05);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (06,'Croacia','Finlandia',20231129,06);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (07,'China','Francia',20231129,07);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (08,'Chile','Brasil',20231129,08);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (09,'Costa Rica','Dinamarca',20231129,09);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (10,'Argentina','Brasil',20231129,10);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (11,'Argentina','Dinamarca',20231129,11);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (12,'Argentina','Holanda',20231129,12);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (13,'Argentina','Honduras',20231129,13);
insert into Vuelo (nro_vuelo,desde,hasta,fechaa,nro_avion) values (14,'Argentina','Chile',20231129,13);


insert into Pasajero(nro_vuelo,documento,nombre) values (05,43861369,'Ricardo');
insert into Pasajero(nro_vuelo,documento,nombre) values (05,43861364,'Esteban');
insert into Pasajero(nro_vuelo,documento,nombre) values (05,43861365,'Pedro');


-- Consulta 1
-- Hallar los números de vuelo desde el origen A hasta el destino F
select v.nro_vuelo
from Vuelo v
where v.desde like 'A%' and v.hasta like 'F%';

-- Consulta 2
-- Hallar los nombres de pasajeros y números de vuelo para aquellos pasajeros que viajan desde A a D

select p.nombre, v.nro_vuelo
from pasajero p join vuelo v on p.nro_vuelo = v.nro_vuelo
where v.desde like 'A%' and v.hasta like 'D%';

-- Consulta 3
-- Hallar los tipos de avión para vuelos que parten desde C
select a.tipo_avion
from avion a join vuelo v on a.nro_avion = v.nro_avion
where v.desde like 'C%';

-- Consulta 4
--  Listar los distintos tipo y nro. de avión que tienen a H como destino
select a.tipo_avion, a.nro_avion
from avion a join vuelo v on a.nro_avion = v.nro_avion
where v.hasta like 'H%';

-- Consulta 5
-- Mostrar por cada Avión (número y modelo) la cantidad de vuelos en que se encuentra registrado.
select a.nro_avion, a.tipo_avion, count(*) as 'cantidad de vuelos '
from avion a join vuelo v on a.nro_avion = v.nro_avion
where nro_vuelo is not null
group by a.nro_avion, a.tipo_avion;

-- Consulta 6
-- Cuántos pasajeros diferentes han volado en un avión de modelo ‘B-777’
select count(*) as 'pasajeros'
from pasajero p join vuelo v on p.nro_vuelo = v.nro_vuelo
				 join avion a on a.nro_avion = v.nro_avion
where a.tipo_avion like 'C%';

-- Consulta 7
-- Listar la cantidad promedio de pasajeros transportados por los aviones de la compañía, por tipo de avión
SELECT a.tipo_avion, avg(CANT_PASAJEROS) AS 'Promedio'
FROM VUELO V
INNER JOIN (SELECT COUNT(1) 'CANT_PASAJEROS',NRO_VUELO AS 'NRO_VUELO' 
			FROM PASAJERO 
			GROUP BY NRO_VUELO )PAS ON (PAS.NRO_VUELO = V.NRO_VUELO )
GROUP BY tipo_avion;

-- Consulta 8
--  Hallar los tipos de avión que no son utilizados en algún vuelo que pase por B
select a.tipo_avion, a.nro_avion
from avion a
where not exists(select 1
					from vuelo v
					where a.nro_avion = v.nro_avion and v.hasta like 'B%');















