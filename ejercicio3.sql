create database ventas;
use ventas;

create table if not exists proveedor(
					id_proveedor int auto_increment,
                    nombre varchar(400) not null,
                    cuit int not null,
                    primary key (id_proveedor)
);


create table if not exists producto(
					id_producto int auto_increment,
                    descripcion varchar(400) not null,
                    estado varchar(400) not null,
                    id_proveedor int not null,
                    primary key (id_producto),
                    foreign key (id_proveedor) references proveedor (id_proveedor)
);

create table if not exists cliente(
					id_cliente int auto_increment,
                    nombre varchar(400) not null,
                    primary key (id_cliente)
);

create table if not exists vendedor(
					id_empleado int auto_increment,
                    nombreVendedor varchar(400) not null,
                    nombre varchar(400) not null,
                    dni int not null,
                    primary key (id_empleado)
);

create table if not exists venta(
					nro_factura int not null,
                    id_cliente int not null,
                    fecha time not null,
                    id_empleado int not null,
                    primary key (nro_factura),
                    foreign key (id_cliente) references cliente (id_cliente),
                    foreign key (id_empleado) references vendedor (id_empleado)
);

create table if not exists detalle_venta(
					nro_factura int not null,
                    nro_detalle int not null,
                    id_producto int not null,
                    cantidad int not null,
                    precio_unitario decimal (7,2) not null,
                    constraint detalle_venta_pk primary key (nro_factura, nro_detalle),
                    foreign key (id_producto) references producto (id_producto)
);

show tables;

-- Consulta 1
-- Listar la cantidad de productos que tiene la empresa.
select *
from producto;

-- Consulta 2
-- Listar la descripción de productos en estado 'en stock' que tiene la empresa.
select p.descripcion
from producto p
where estado = 'en stock';

-- Consulta 3
-- Listar los productos que nunca fueron vendidos.
select *
from producto p
where not exists(select 1
				from detalle_venta dv
                where not exists(select 1
								from venta v
								where p.id_producto = dv.id_producto and dv.nro_factura = v.nro_factura));
                                
-- Consulta 4
-- Listar la cantidad total de unidades que fueron vendidas de cada producto (descripción).
select count(*) as 'cantidad total de unidades'
from producto p join detalle_venta dv on p.id_producto = dv.id_producto
				join venta v on dv.nro_factura = v.nro_factura
group by p.descripcion;

-- Consulta 5
-- Listar el nombre de cada vendedor y la cantidad de ventas realizadas en el año 2015.
SELECT v.nombre, COUNT(*) AS cantidad_ventas
FROM vendedor v
JOIN venta vt ON v.id_empleado = vt.id_empleado
WHERE YEAR(vt.fecha) = 2015
GROUP BY v.nombre;

-- Consulta 6
-- Listar el monto total vendido por cada cliente (nombre)
select count(dv.precio_unitario) as 'monto total'
from detalle_venta dv join venta v on dv.nro_factura = v.nro_factura
					  join cliente cl on cl.id_cliente = v.id_cliente
group by cl.nombre;

-- Consulta 7
-- Listar la descripción de aquellos productos en estado ‘sin stock’ que se hayan vendido en el mes de Enero de 2015
select p.descripcion
from producto p join detalle_venta dv on p.id_producto = dv.id_producto
				join venta vt on vt.nro_factura = dv.nro_factura
where p.estado = 'sin stock' and year(vt.fecha) = 2015 and month(vt.fecha) = 1;

