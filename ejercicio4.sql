create database if not exists autos;
use autos;

create table if not exists auto (
		patente int not null,
        modelo varchar(255) not null,
        año int not null,
        primary key (patente)
);

create table if not exists chofer (
		nro_chofer int not null,
        nombre varchar(255) not null,
        fecha_ingreso date not null,
        telefono int not null,
        primary key (nro_chofer)
);

create table if not exists cliente (
		nro_cliente int not null,
        nombre varchar(255) not null,
        domicilio varchar(255) not null,
		localidad varchar(255) not null,
        primary key (nro_cliente)
);

create table if not exists viaje(
		nro_chofer int not null references chofer(nro_chofer),
        nro_cliente int not null references cliente(nro_cliente),
        patente int not null references auto(patente),
        fecha date not null,
        km_totales int not null,
        tiempo_espera time,
        constraint viaje_pk primary key (nro_chofer, nro_cliente, patente,fecha)
);

insert into auto (patente,modelo,año)
values 
	(12,"AS",2010),
    (13,"AS",2001),
    (15,"ASD",2019);
    
insert into chofer (nro_chofer,nombre,fecha_ingreso,telefono)
values 
	(1,"Jorge",20100129,1234),
    (2,"Adrian",20010129,5678),
    (3,"Alejandro",20190129,9101);

insert into cliente (nro_cliente,nombre,domicilio,localidad)
values 
	(1,"Alejo","Kiernan 222","Moron"),
    (2,"Esteban","Belgica 578","Hurlingham"),
    (3,"Sebastian","Belgrano 100", "Moron");

insert into viaje (nro_chofer,nro_cliente,patente,fecha,km_totales,tiempo_espera)
values 
	(1,1,12,20230626,12,120000),
    (2,1,13,20230626,12,120000),
    (3,1,14,20230626,12,120000);

select * from viaje;

-- Consulta 1
-- Cuál es el tiempo de espera promedio de los viajes del año 2005?
select avg(tiempo_espera) as 'Tiempo de espera promedio'
from viaje 
where YEAR(fecha) = 2005;

-- Consulta 2
-- Listar el nombre de los clientes que hayan viajado en todos los autos.
select c.nombre
from cliente c 
where not exists (select a.patente
from auto a
where not exists (
select v.nro_cliente
from viaje v 
where v.patente = a.patente and v.nro_cliente = c.nro_cliente));

-- Consulta 3
-- Listar nombre y teléfono de los choferes que no manejaron algún vehículo de modelo posterior al año 2010.
select c.nombre, c.telefono
from chofer c join viaje v on c.nro_chofer = v.nro_chofer 
where not exists(select a.patente
from auto a
where a.patente = v.patente and a.año >= 2010);

