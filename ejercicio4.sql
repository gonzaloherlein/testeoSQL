create database trabajo;
show databases;

create table if not exists persona(
			nro_persona int auto_increment,
            nombre varchar(255) not null,
            calle varchar(255) not null,
            ciudad varchar(255) not null,
            primary key (nro_persona)
);

create table if not exists empresa(
			nro_empresa int auto_increment,
            razon_social varchar(255) not null,
            calle varchar(255) not null,
            ciudad varchar(255) not null,
            primary key (nro_empresa)
);

create table if not exists trabaja(
			nro_persona int not null,
            nro_empresa int not null, 
            salario double(7,2) not null,
            fecha_ingreso date not null,
            constraint trabaja_pk primary key (nro_persona, nro_empresa),
            foreign key (nro_persona) references persona (nro_persona),
            foreign key (nro_empresa) references empresa (nro_empresa)
);

insert into persona (nro_persona,nombre,calle,ciudad) values (0,"Eduardo", "Kiernan 222", "Rosario");
insert into empresa (nro_empresa,razon_social,calle,ciudad) values (0,"Banelco","Aramburu 12","Rosario");
insert into trabaja (nro_persona,nro_empresa,salario,fecha_ingreso) values (1,1,123,"2023-01-01");


alter table trabaja modify column salario int not null;

select * from trabaja;

-- Consulta 1 
-- Listar el nombre y ciudad de todas las personas que trabajan en la empresa “Banelco”.
select p.nombre, p.ciudad
from persona p join trabaja t on p.nro_persona = t.nro_persona 
				join empresa e on e.nro_empresa = t.nro_empresa
where e.razon_social = "Banelco";

-- Consulta 2
-- Listar el nombre, calle y ciudad de todas las personas que trabajan para la empresa “Paulinas” y ganan más de $1500.
select p.nombre, p.calle, p.ciudad
from persona p join trabaja t on p.nro_persona = t.nro_persona 
				join empresa e on e.nro_empresa = t.nro_empresa
where e.razon_social = "Paulinas" and t.salario > 1500;

-- Consulta 3 
-- Listar el nombre de personas que viven en la misma ciudad en la que se halla la empresa en donde trabajan.
select p.nombre
from persona p join trabaja t on p.nro_persona = t.nro_persona 
				join empresa e on e.nro_empresa = t.nro_empresa
where e.ciudad = p.ciudad;

-- Consulta 4
-- Listar número y nombre de todas las personas que viven en la misma ciudad y en la misma calle que su supervisor.

-- Consulta 5
-- Listar el nombre y ciudad de todas las personas que ganan más que cualquier empleado de la empresa “Tecnosur”.

SELECT p.nombre, p.ciudad
FROM persona p
WHERE EXISTS (
  SELECT 1
  FROM trabaja t
  INNER JOIN empresa e ON t.nro_empresa = e.nro_empresa
  WHERE e.razon_social = 'Tecnosur'
  AND t.salario < (SELECT MAX(t2.salario) FROM trabaja t2)
  AND t.nro_persona = p.nro_persona
);


-- Consulta 6
-- Listar las ciudades en las que todos los trabajadores que vienen en ellas ganan más de $1000
select p.ciudad
from persona p join trabaja t on p.nro_persona = t.nro_persona
where t.salario > 1000;

-- Consulta 7 
-- Listar el nombre de los empleados que hayan ingresado en mas de 4 Empresas en el periodo 01-01-2000 y 31-03-2004
select p.nombre
from persona p join trabaja t on p.nro_persona = t.nro_persona 
where t.fecha_ingreso between "2000-01-01" and "2004-03-31"
group by p.nro_persona, p.nombre
having count(distinct t.nro_empresa) > 4;
 






