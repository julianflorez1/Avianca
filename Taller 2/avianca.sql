/*2. Create 2 Tablespaces a.first one with 2 Gb and 1 datafile, tablespace should be named " avianca "*/
create tablespace Avianca
datafile 'avianca.dbf' size 2G;
/*b.Undo tablespace with 25Mb of space and 1 datafile and 3. */ 
create undo tablespace undoavianca_01
datafile 'undoavianca.dbf'
size 25M autoextend on;
/*4. Create a DBA user (with the role DBA) and assign it to the tablespace called " avianca ", this user has
unlimited space on the tablespace (The user should have permission to connect)*/
alter session set "_ORACLE_SCRIPT"=true;
create user avianca
identified by avianca
default tablespace Avianca
quota UNLIMITED on Avianca;
grant DBA, connect to AVIANCA



DROP DATABASE AVIANCA;


/*5. Create 2 profiles. (0.125)
a. Profile 1: "clerk" password life 40 days, one session per user, 10 minutes idle, 4 failed login
attempts*/
SELECT * FROM DBA_PROFILES;

CREATE PROFILE CLERK LIMIT
PASSWORD_LIFE_TIME              40
SESSIONS_PER_USER               1
IDLE_TIME                       15
FAILED_LOGIN_ATTEMPTS           4;

/*b. Profile 3: "development " password life 100 days, two session per user, 30 minutes idle, no
failed login attempts*/

CREATE PROFILE DEVELOPMENT LIMIT
PASSWORD_LIFE_TIME              100
SESSIONS_PER_USER               2
IDLE_TIME                       30
FAILED_LOGIN_ATTEMPTS           UNLIMITED;

/*6. Create 4 users, assign them the tablespace " avianca "; 2 of them should have the clerk profile and the
remaining the development profile, all the users should be allow to connect to the database. (0.125)*/

CREATE USER USER1
IDENTIFIED BY user1
DEFAULT tablespace avianca
PROFILE CLERK;

CREATE USER USER2
IDENTIFIED BY user2
DEFAULT tablespace avianca
PROFILE CLERK;

CREATE USER USER3
IDENTIFIED BY user3
DEFAULT tablespace avianca
PROFILE DEVELOPMENT;

CREATE USER USER4
IDENTIFIED BY user4
DEFAULT tablespace avianca
PROFILE DEVELOPMENT;

/* 7.Lock one user associate with clerk profile (0.125)*/

ALTER USER USER1 ACCOUNT LOCK;
ALTER USER USER2 ACCOUNT LOCK;

/*8. Create tables with its columns according to your normalization (0.125) .
i. If you are using Oracle 11g: Create sequences for every primary key.
ii. If you are using Oracle 12c: Use identity columns.
b. Create primary and foreign keys.*/
create table ciudades
(
    id_ciudades integer not null primary key,
    nombre_ciudad varchar(255),
    nombre_pais varchar(255)
);

create table Tripulaciones
(
    id_empleados integer not null primary key,
    id_azafatas integer,
    nombres varchar2(255),
    apellidos varchar2(255),
    tipo varchar2(255) not null check(tipo in ('piloto','auxiliar')),
    fecha_de_nacimiento date,
    antiguedad varchar(100),
    fecha_ultimo_entrenamiento_recibido date,
    correo varchar2(255),
    celular varchar2(255),
    horas_descanso_ultimo_vuelo integer,
    estado varchar(255) not null check(estado in ('en vuelo','activo','inactivo','jubilado','suspendido','despedido','entrenamiento','licencia','vacaciones')),
    ubicacion_actual varchar(255),
    id_ciudades integer
);

create table Pilotos
(
    id_piloto integer not null primary key,
    nivel_ingles varchar(255) not null check(nivel_ingles in ('1_pre-elementary','2_elementary','3_pre-operational','4_operational','5_extended','6_expert')),
    cantidad_horas_vuelo integer,
    tipo_licencia varchar(255) not null check(tipo_licencia in ('CPL','IFR','ME','ATPL')),
    cargo varchar(255) not null check(cargo in ('comandante','primer oficial')),
    id_empleado integer  
);

create table Aeropuertos
(
    id_aeropuerto integer not null primary key,
    nombre varchar2(255),
    id_ciudades integer,
    longitud varchar2(255),
    latitud varchar2(255),
    abreviatura_aeropuerto varchar2(255)
);

create table Rutas
(
    id_ruta integer not null primary key,
    id_aeropuerto_origen integer not null,
    id_aeropuerto_destino integer not null,
    distancia_kilometro integer,
    cantidad_promedio integer
);

create table logs_vuelo
(
    id_log_vuelo integer not null primary key,
    log_timestamp varchar(255),
    horaUTC varchar(255),
    callsign varchar(255),
    position varchar2(255),
    altitud varchar(255),
    velocidad varchar(255),
    direccion varchar(255),
    id_vuelo integer not null  
);
 
create table tripuvuelo
(
    id_tripulaciones integer not null,
    id_vuelo integer not null 
);

create table Vuelos
(
    id_vuelo integer not null primary key,
    id_piloto integer not null,
    id_copiloto integer not null,
    estado varchar2(255) not null check(estado in ('en vuelo','cancelado','retrasado','confirmado','abordando','programado')),
    frecuencia_semanal integer,    
    duracion_real integer,
    aeronave_asignada varchar(255),
    cantidad_pasajeros_ejecutiva integer,
    cantidad_pasajeros_economica integer,   
    id_avion integer not null,
    hora_estimada_salida varchar(255),
    hora_estimada_llegada varchar(255),
    hora_real_salida varchar(255),
    hora_real_llegada varchar(255)
);


create table checkin
(
    id_checkin integer not null primary key,
    numero_vuelo integer not null,
    tipo_de_identificacion varchar(255)not null check(tipo_de_identificacion in('Cédula','Pasaporte','DNI','Cédula Extranjería')),
    numero_confirmacion_checkin varchar2(255)not null,
    contacto_emergencia integer not null,
    ciudad_emergencia varchar2(255),
    correo_emergencia varchar2(255),
    numero_telefono_emergencia integer,
    tipo_silla varchar2(255) not null check(tipo_silla in ('ejecutiva','economia'))
);

create table pasajeros
(
    id_pasajeros integer not null primary key,
    nombre varchar2(255),
    apellidos varchar2(255),
    telefono integer,
    celular integer,
    email varchar2(255),
    id_ciudades integer
);

create table itinerarios
(
    id_itinerario integer not null primary key,
    id_ruta integer not null,
    id_vuelo integer not null,
    id_avion integer not null,
    id_aeropuerto integer not null
);

create table aviones 
(
    id_avion integer not null primary key,
    registration varchar(50),
    serial_number varchar(45),
    age varchar(255),
    aircraft_type varchar(255),
    bussiness_seats integer,
    economy_seats integer,
    estado varchar(255)not null check(estado in('vuelo','tierra','mantenimiento','reparacion')),
    id_aeropuerto integer not null
);
drop table ciudades CASCADE CONSTRAINTS;
 drop table tripulaciones CASCADE CONSTRAINTS;
 drop table pilotos CASCADE CONSTRAINTS;
  drop table Aeropuertos CASCADE CONSTRAINTS;
   drop table Rutas CASCADE CONSTRAINTS;
 DROP TABLE logs_vuelo CASCADE CONSTRAINTS;
 drop table tripuvuelo CASCADE CONSTRAINTS;
 drop table Vuelos CASCADE CONSTRAINTS;
 drop table checkin CASCADE CONSTRAINTS;
 drop table pasajeros CASCADE CONSTRAINTS;
 drop table itinerarios CASCADE CONSTRAINTS;
 drop table aviones CASCADE CONSTRAINTS;
DROP sequence inc_id
create sequence inc_id with start 1
increment by 1 
minvalue 1
nocycle
nocache
order;
create sequence inc_id2 increment by 1 start with 300

--Crear las claves foraneas a cada uno 
 ALTER TABLE Tripulaciones
ADD CONSTRAINT FK_Tripulacion_Ciudades
  FOREIGN KEY (id_ciudades)
  REFERENCES ciudades(id_ciudades);
ALTER TABLE Pilotos
ADD CONSTRAINT FK_Pilotos_Tripulacion
  FOREIGN KEY (id_empleado)
  REFERENCES Tripulaciones(id_empleados);
  
  ALTER TABLE Aeropuertos
ADD CONSTRAINT FK_aeropuertos_ciudades
  FOREIGN KEY (id_ciudades)
  REFERENCES ciudades(id_ciudades);
  
  ALTER TABLE Rutas
ADD CONSTRAINT FK_ruta_id_aeropuerto_origen
  FOREIGN KEY (id_aeropuerto_origen)
  REFERENCES Aeropuertos(id_aeropuerto);
  
   ALTER TABLE aviones
ADD CONSTRAINT FK_aviones_aeropuerto
  FOREIGN KEY (id_aeropuerto)
  REFERENCES Aeropuertos(id_aeropuerto);
  
  ALTER TABLE Rutas
ADD CONSTRAINT FK_ruta_id_aeropuerto_destino
  FOREIGN KEY (id_aeropuerto_destino)
  REFERENCES Aeropuertos(id_aeropuerto);
  
ALTER TABLE logs_vuelo
ADD CONSTRAINT FK_log_vuelo_id_vuelo
  FOREIGN KEY (id_vuelo)
  REFERENCES Vuelos(id_vuelo);

ALTER TABLE Vuelos
ADD CONSTRAINT FK_vuelo_id_piloto
  FOREIGN KEY (id_piloto)
  REFERENCES Pilotos(id_piloto);
  
  ALTER TABLE Vuelos
ADD CONSTRAINT FK_vuelo_id_copiloto
  FOREIGN KEY (id_copiloto)
  REFERENCES Pilotos(id_piloto);
  

  
  ALTER TABLE Vuelos
ADD CONSTRAINT FK_vuelo_id_avion
  FOREIGN KEY (id_avion)
  REFERENCES aviones(id_avion);
 
   ALTER TABLE tripuvuelo
ADD CONSTRAINT FK_tripvuelo_tripulaciones
  FOREIGN KEY (id_tripulaciones)
  REFERENCES tripulaciones(id_empleados);
    ALTER TABLE tripuvuelo
ADD CONSTRAINT FK_tripvuelo_vuelo
  FOREIGN KEY (id_vuelo)
  REFERENCES vuelos(id_vuelo);
  
    ALTER TABLE checkin
ADD CONSTRAINT FK_checkin_id_vuelo
  FOREIGN KEY (numero_vuelo)
  REFERENCES Vuelos(id_vuelo);
  
  ALTER TABLE checkin
ADD CONSTRAINT FK_checkin_pasajeros
  FOREIGN KEY (contacto_emergencia)
  REFERENCES pasajeros(id_pasajeros);
  
  ALTER TABLE pasajeros
ADD CONSTRAINT FK_pasajeros_ciudades
  FOREIGN KEY (id_ciudades)
  REFERENCES ciudades(id_ciudades);
  
  ALTER TABLE itinerarios
ADD CONSTRAINT FK_itinerarios_id_ruta
  FOREIGN KEY (id_ruta)
  REFERENCES Rutas(id_ruta);
  
  ALTER TABLE itinerarios
ADD CONSTRAINT FK_programacion_id_vuelo
  FOREIGN KEY (id_vuelo)
  REFERENCES Vuelos(id_vuelo);
  
   ALTER TABLE itinerarios
ADD CONSTRAINT FK_programacion_id_avion
  FOREIGN KEY (id_avion)
  REFERENCES aviones(id_avion);
  
  ALTER TABLE itinerarios
ADD CONSTRAINT FK_programacion_id_aeropuerto
  FOREIGN KEY (id_aeropuerto)
  REFERENCES Aeropuertos(id_aeropuerto);
  
 
  
select * from dba_tablespaces;
select * from dba_data_files;

--insertar las ciudades
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (1,'Medellin','Colombia');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (2,'Cali','Colombia');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (3,'Cartagena','Colombia');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (4,'San luis de tipal','El salvador');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (5,'Lima','Peru');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (6,'Madrid','España');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (7,'Miami','Estados Unidos');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (8,'New York','Estados Unidos');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (9,'Santiago','Chile');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (10,'Toronto','Canadá');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (11,'Bucaramanga','Colombia');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (12,'Pasto','Colombia');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (13,'Pekin','China');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (14,'Tokio','Japón');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (15,'Barranquilla','Colombia');
INSERT INTO CIUDADES (id_ciudades, nombre_ciudad, nombre_pais) VALUES (16,'Bogota','Colombia');

--insertar tripulaciones

INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (1,200,'Wade','Gentry','piloto','01-07-90',24,'08-02-91','in.faucibus@ipsumCurabitur.edu',3125459874,22,'activo','-63.64641, -19.30826',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (2,201,'Nita','Mckenzie','auxiliar','16-05-96',44,'27-08-89','Sed@turpis.com',3190477054,14,'suspendido','-39.11757, 132.35881',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (3,202,'Aaron','Best','piloto','19-09-90',25,'18-02-96','lorem.tristique.aliquet@Crasvehicula.co.uk',3173455183,16,'inactivo','-18.30023, -167.35845',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (4,203,'Allistair','Page','auxiliar','10-11-80',28,'14-03-89','neque.sed.sem@ullamcorpernislarcu.co.uk',3133163050,11,'vacaciones','-72.18018, 72.62448',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (5,204,'Ryder','Wiley','auxiliar','21-04-53',47,'29-10-14','eget@luctuset.net',3121618733,17,'jubilado','-66.38732, 69.1086',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (6,205,'Kibo','Puckett','auxiliar','13-03-64',28,'19-12-98','sagittis.lobortis@dolor.edu',3086840787,5,'vacaciones','79.5129, -178.48836',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (7,206,'Selma','Allison','auxiliar','15-01-87',49,'09-03-13','tristique@Duisvolutpatnunc.edu',3047759483,4,'entrenamiento','-65.96372, -62.78502',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (8,207,'Elliott','Bailey','piloto','01-11-70',17,'09-02-91','lorem.fringilla@tempordiamdictum.com',3094025443,22,'en vuelo','-46.13909, -134.57587',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (9,208,'Maggy','Wolfe','piloto','03-07-74',24,'02-03-89','consequat@dolorelit.net',3172213033,8,'entrenamiento','40.94574, 103.92872',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (10,209,'Nathaniel','Hardy','piloto','01-06-50',14,'21-12-98','ligula@consequatauctor.com',3005403769,2,'inactivo','44.30097, 19.63806',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (11,210,'Halee','Mullins','auxiliar','29-12-97',3,'03-05-99','Integer.vitae.nibh@Curabitur.net',3095707274,4,'en vuelo','-83.02305, -141.14572',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (12,211,'Hasad','Pitts','piloto','16-08-77',12,'25-06-14','Suspendisse@ipsumDonecsollicitudin.edu',3001544914,5,'entrenamiento','14.75269, 36.79496',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (13,212,'Josiah','Erickson','auxiliar','04-09-97',14,'29-03-92','ut@Cumsociis.com',3168570003,13,'en vuelo','-63.63609, -48.15991',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (14,213,'Jared','Britt','piloto','10-02-97',19,'24-05-99','dolor.Quisque.tincidunt@nonleo.com',3088480821,21,'inactivo','83.12727, -69.45133',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (15,214,'Remedios','Wheeler','piloto','18-06-03',9,'27-05-13','neque.et.nunc@erosProin.ca',3202303496,3,'jubilado','26.42692, -15.50135',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (16,215,'Delilah','Rios','auxiliar','30-08-77',15,'23-01-09','sapien.gravida@Quisqueaclibero.ca',3052808225,3,'inactivo','-5.6982, -52.45601',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (17,216,'Illana','Collins','piloto','07-06-78',15,'01-05-04','Nulla.semper.tellus@PhasellusnullaInteger.com',3145421540,19,'vacaciones','-89.46752, -46.5467',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (18,217,'Maggie','William','auxiliar','02-08-63',1,'11-12-99','lectus.Cum@interdumligulaeu.edu',3099129283,2,'despedido','-53.36922, 146.88241',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (19,218,'Zahir','Mullins','auxiliar','19-10-78',25,'03-12-94','facilisis.Suspendisse@nequeNullamut.edu',3051723060,2,'vacaciones','-49.69545, 47.814',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (20,219,'Velma','Nguyen','piloto','07-12-56',45,'11-08-05','ornare@mollisnon.edu',3041137977,17,'licencia','47.58144, 125.4544',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (21,220,'Katelyn','Petty','auxiliar','14-01-80',33,'20-07-97','egestas@Sednuncest.net',3010641345,12,'jubilado','68.42926, 87.49507',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (22,221,'Isadora','Castaneda','piloto','21-08-73',23,'21-05-06','convallis@porttitoreros.edu',3035841347,21,'en vuelo','54.47271, 144.55661',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (23,222,'Dillon','Avila','auxiliar','04-10-63',45,'09-09-99','sit@Aliquam.edu',3030610754,16,'entrenamiento','-50.51135, 82.67741',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (24,223,'Chiquita','Hester','piloto','03-11-74',37,'19-08-92','ultrices.Vivamus.rhoncus@consectetuer.edu',3191348241,24,'suspendido','51.56852, -107.50673',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (25,224,'Astra','Mosley','auxiliar','17-08-61',50,'20-03-02','et@orci.com',3178097374,2,'jubilado','63.49869, -144.28715',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (26,225,'Troy','Sears','piloto','21-02-75',8,'30-11-08','enim@tinciduntnequevitae.com',3220876192,24,'activo','30.33005, 35.37332',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (27,226,'Kuame','Miranda','auxiliar','11-03-79',18,'27-09-11','fringilla.porttitor@Sednullaante.co.uk',3220064836,4,'despedido','24.74436, 32.8358',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (28,227,'Brock','Reed','auxiliar','17-11-90',45,'25-02-00','ut.aliquam@nullaInteger.ca',3182339649,21,'inactivo','85.69688, 103.588',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (29,228,'Lillian','Harvey','auxiliar','19-07-66',11,'18-03-97','metus.Vivamus@incursus.edu',3029417284,2,'en vuelo','-9.86955, 116.31975',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (30,229,'Kalia','Spence','auxiliar','30-09-55',20,'05-04-91','penatibus.et@enimSed.co.uk',3082817929,21,'jubilado','-33.46901, -163.12036',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (31,230,'Ross','Bennett','auxiliar','13-03-94',47,'10-11-87','mi@ut.ca',3104405439,4,'en vuelo','-12.4038, -100.05671',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (32,231,'Cailin','Mckay','auxiliar','25-06-79',11,'10-03-02','euismod@nostra.org',3176201213,20,'despedido','-32.92352, -57.62464',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (33,232,'Yoko','Cochran','piloto','12-12-97',2,'11-11-12','Ut.tincidunt.orci@metussitamet.edu',3027935928,18,'suspendido','88.23345, -162.44199',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (34,233,'Dakota','Weaver','piloto','11-09-64',22,'28-11-03','Vestibulum.accumsan@laciniaorci.ca',3186417130,24,'licencia','-0.84733, 31.97719',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (35,234,'Daquan','Bowman','auxiliar','22-02-02',36,'04-08-09','mauris.eu.elit@atvelit.edu',3195765870,12,'licencia','-80.64867, 79.17574',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (36,235,'Levi','Bradshaw','piloto','12-08-08',19,'01-08-98','risus.In@variusultricesmauris.edu',3138677111,10,'licencia','-33.6912, 55.32114',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (37,236,'Melinda','Summers','piloto','31-05-98',12,'25-08-90','nibh.sit.amet@non.net',3208125199,15,'inactivo','72.78647, 154.41502',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (38,237,'Carter','Alford','piloto','24-12-79',41,'21-06-08','id.magna.et@consectetuer.com',3021230943,19,'suspendido','58.20509, -87.92781',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (39,238,'Harrison','Farley','auxiliar','20-09-03',22,'05-03-93','venenatis.lacus.Etiam@nonmagnaNam.edu',3097446918,8,'inactivo','-75.93099, -42.93147',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (40,239,'Ahmed','Holman','auxiliar','28-11-57',9,'06-08-05','nonummy@commodo.net',3052365462,4,'despedido','-40.0427, 94.21529',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (41,240,'Dahlia','Conley','piloto','25-02-80',47,'15-10-14','quis.lectus@eueros.co.uk',3096734704,9,'vacaciones','63.43319, -56.59595',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (42,241,'Kane','Leon','piloto','30-04-07',34,'19-03-03','mus.Proin.vel@scelerisque.ca',3198079931,24,'en vuelo','64.65825, 73.97242',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (43,242,'Zachary','Clarke','auxiliar','10-11-65',42,'19-06-12','at.pretium.aliquet@rhoncus.ca',3004914904,10,'licencia','32.8349, 150.70625',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (44,243,'Amy','Carson','piloto','03-09-81',25,'31-08-96','quam@sedfacilisisvitae.co.uk',3040632296,4,'inactivo','-23.57498, -81.38156',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (45,244,'Tashya','Lyons','piloto','21-08-06',3,'28-02-05','vestibulum.massa.rutrum@pedeet.net',3189561699,15,'vacaciones','-37.38488, -137.69108',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (46,245,'Jordan','Colon','auxiliar','16-05-07',9,'19-03-94','diam@venenatislacusEtiam.org',3196044119,22,'inactivo','-59.0084, -72.42079',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (47,246,'Nicholas','Mccoy','auxiliar','31-08-07',34,'09-10-91','Sed.eu@urnajustofaucibus.ca',3184780779,4,'jubilado','41.40058, 41.88622',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (48,247,'Raymond','York','piloto','02-01-94',47,'20-11-85','consectetuer.adipiscing@diam.edu',3212748641,3,'suspendido','49.64764, -143.4579',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (49,248,'Bo','Parrish','piloto','27-12-80',25,'12-04-05','Integer.mollis@risusquisdiam.org',3205026792,11,'en vuelo','-8.62414, 130.18459',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (50,249,'Dorian','Middleton','auxiliar','02-11-87',17,'16-04-14','luctus.et@egestas.net',3040180408,2,'despedido','74.07217, 106.08023',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (51,250,'Isabelle','Hurst','auxiliar','18-07-93',45,'12-12-14','elementum.at.egestas@ipsumac.net',3053238130,19,'licencia','33.98688, 27.38756',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (52,251,'Veronica','Bowman','auxiliar','05-03-92',8,'20-09-95','nisi.a@tellus.com',3117322027,19,'activo','34.28117, 78.76988',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (53,252,'Astra','Turner','piloto','16-08-84',10,'04-08-88','odio.Etiam.ligula@utlacus.org',3132834617,20,'en vuelo','-13.98857, -11.36363',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (54,253,'Jin','Phillips','piloto','03-05-87',46,'26-05-12','sit.amet@ultriciesligula.ca',3198677319,17,'suspendido','65.7056, 50.23783',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (55,254,'Mohammad','Workman','piloto','07-06-82',4,'02-06-86','mauris.sapien@magnisdisparturient.com',3156524104,23,'activo','-0.11748, 124.18888',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (56,255,'Marvin','Obrien','piloto','26-02-76',10,'14-02-92','felis.adipiscing@idsapien.edu',3144483133,22,'suspendido','45.81856, 91.21412',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (57,256,'Leroy','Gross','auxiliar','10-06-89',46,'22-06-03','Sed.malesuada.augue@sit.com',3103185589,18,'jubilado','-34.47468, -93.08183',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (58,257,'Kylynn','Cochran','piloto','04-02-67',2,'09-10-00','porttitor.interdum.Sed@tempor.org',3013979390,2,'vacaciones','57.35117, 69.40356',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (59,258,'Octavia','Perez','piloto','14-07-65',40,'11-11-89','Donec.consectetuer@ultricesa.co.uk',3181090070,6,'licencia','24.08682, -4.60263',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (60,259,'Scarlett','Chandler','auxiliar','10-07-93',24,'14-07-07','Nam@Fuscealiquet.edu',3188418221,12,'en vuelo','-75.37858, -97.92945',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (61,260,'Andrew','Mckinney','piloto','14-11-85',20,'21-03-06','pharetra.Quisque@ultricesa.ca',3099439439,10,'despedido','87.09182, -137.67043',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (62,261,'Lareina','Bowen','piloto','20-01-85',34,'14-05-05','Nunc.sollicitudin.commodo@pedenecante.ca',3170216705,23,'en vuelo','-65.19328, -108.18984',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (63,262,'Sarah','Campos','auxiliar','29-08-64',34,'15-08-87','mi.tempor@risusodio.org',3185022201,2,'activo','88.24042, 43.10409',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (64,263,'Tyler','Zimmerman','auxiliar','12-08-92',45,'26-02-11','Praesent.eu@quislectusNullam.ca',3029775026,4,'activo','-49.8361, -51.45298',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (65,264,'Malachi','Pennington','auxiliar','04-10-88',8,'30-10-08','in@imperdiet.org',3114984690,17,'activo','53.45312, -41.79871',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (66,265,'Prescott','Carey','auxiliar','26-04-05',43,'06-10-85','dui@luctusutpellentesque.org',3137588827,11,'vacaciones','-16.04866, 173.37493',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (67,266,'Carson','Roach','auxiliar','12-06-00',47,'03-02-00','Aliquam.gravida@vel.org',3021007129,17,'suspendido','-0.15256, -90.55836',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (68,267,'Timothy','Mack','piloto','07-12-56',42,'30-05-09','non.hendrerit@liberolacus.org',3188734378,2,'en vuelo','-65.4746, 31.74954',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (69,268,'Jada','Cleveland','piloto','10-09-91',18,'13-12-07','ullamcorper.Duis@mattisCraseget.org',3097612661,13,'suspendido','-54.77623, -30.27977',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (70,269,'Donovan','Berg','piloto','17-09-88',3,'13-06-89','aliquet.diam@nec.edu',3023839395,15,'entrenamiento','64.4766, -96.45664',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (71,270,'Cain','Mathis','piloto','20-08-91',43,'11-07-06','nec.quam@estvitae.edu',3206995362,21,'despedido','-3.69885, 139.29279',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (72,271,'Xerxes','Diaz','auxiliar','13-05-03',44,'07-09-09','sem.egestas@dictumProineget.ca',3031230838,17,'suspendido','-57.96082, -28.65956',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (73,272,'Lawrence','Hubbard','piloto','18-12-03',26,'25-01-95','convallis.ante@mollis.edu',3197256039,3,'en vuelo','-16.02257, -50.97337',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (74,273,'Ignatius','Knapp','piloto','29-07-04',10,'16-09-13','eleifend@velsapien.org',3031093099,3,'licencia','82.401, 102.69098',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (75,274,'Keiko','Day','piloto','16-01-90',2,'22-12-89','molestie@tortordictumeu.net',3182475422,3,'entrenamiento','-80.35703, 103.97713',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (76,275,'Farrah','Wilder','auxiliar','03-08-73',11,'13-07-03','Ut.tincidunt@vitaenibhDonec.ca',3176652578,4,'activo','60.24364, 1.93797',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (77,276,'Herrod','Bean','piloto','19-02-78',48,'07-05-08','Vestibulum.ante@fames.net',3029493327,6,'vacaciones','31.1922, -176.96242',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (78,277,'Dillon','Stanley','piloto','16-01-64',45,'24-12-04','adipiscing.Mauris@dignissimlacus.co.uk',3209839745,18,'activo','46.06533, 66.28487',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (79,278,'Basil','Dixon','piloto','01-05-62',16,'18-09-00','gravida.sagittis@egetnisidictum.ca',3048216443,6,'entrenamiento','43.61407, 35.01653',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (80,279,'Cairo','Bennett','piloto','08-06-91',16,'18-12-09','Cum@Aeneanegestas.co.uk',3018407033,4,'licencia','77.63395, 50.74267',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (81,280,'Brett','Santiago','piloto','12-05-89',37,'25-08-93','sapien.Nunc.pulvinar@sitamet.org',3109015726,20,'entrenamiento','25.66077, -85.02415',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (82,281,'Beau','Huff','piloto','08-08-72',43,'12-08-11','Nulla.dignissim.Maecenas@nonummy.ca',3139831554,4,'vacaciones','8.67002, 36.41177',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (83,282,'Xaviera','Silva','piloto','06-04-57',24,'08-01-07','hendrerit.Donec.porttitor@Pellentesquehabitant.net',3069813535,14,'en vuelo','-80.83492, 154.553',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (84,283,'Shelly','Cohen','piloto','06-11-79',8,'08-08-05','Fusce@interdumSed.co.uk',3114055272,2,'vacaciones','-11.32826, 155.10268',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (85,284,'Adam','Sexton','auxiliar','19-04-64',31,'21-01-13','egestas.nunc@dolordapibusgravida.co.uk',3158863761,15,'suspendido','58.35551, 152.31276',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (86,285,'Quinlan','Malone','auxiliar','31-08-65',9,'04-07-05','est@velest.org',3178381211,20,'licencia','-60.4889, 34.94372',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (87,286,'Madeson','Morgan','auxiliar','27-03-62',9,'24-12-13','placerat.Cras@urnaconvallis.edu',3085059590,7,'en vuelo','69.403, -110.05176',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (88,287,'Robin','Holloway','auxiliar','08-05-08',43,'10-05-11','turpis@rhoncus.ca',3104215645,10,'entrenamiento','-58.78917, 150.63087',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (89,288,'Avram','Summers','auxiliar','13-01-74',12,'28-10-01','purus@nequenon.co.uk',3072476268,12,'jubilado','20.89373, -116.77051',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (90,289,'Ishmael','Wade','piloto','06-02-81',3,'27-01-09','Duis@anteiaculisnec.ca',3079033562,24,'despedido','12.20951, 44.86446',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (91,290,'Caesar','Carver','auxiliar','26-05-57',45,'25-07-15','Donec.elementum.lorem@vehiculaetrutrum.co.uk',3105393185,20,'suspendido','57.20065, -116.96143',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (92,291,'Signe','House','piloto','10-07-03',27,'09-11-91','aliquet.metus.urna@molestiedapibusligula.edu',3205569425,17,'en vuelo','-33.66565, 123.05672',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (93,292,'Thaddeus','Townsend','auxiliar','23-09-72',36,'16-05-13','sit.amet@lobortis.org',3090738060,17,'inactivo','69.73438, -46.0091',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (94,293,'Geoffrey','Sheppard','auxiliar','13-05-87',12,'08-03-13','et.ipsum@duiquisaccumsan.net',3042523380,9,'jubilado','2.99566, 126.6581',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (95,294,'Hannah','Reynolds','auxiliar','08-11-85',7,'15-01-15','Nullam@erateget.org',3005143227,18,'jubilado','34.35594, -135.74781',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (96,295,'Idola','Underwood','piloto','25-05-97',45,'02-08-07','odio.Nam@sitamet.net',3152878787,22,'suspendido','-28.39031, -38.88872',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (97,296,'Sawyer','Wade','auxiliar','08-04-52',13,'24-01-07','tempor@laoreetposuereenim.com',3103292373,7,'activo','-51.48973, -104.74924',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (98,297,'Shelby','Bradford','piloto','16-02-84',50,'20-10-98','arcu.Vestibulum@tellusnonmagna.ca',3022648016,8,'vacaciones','70.67141, 95.18061',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (99,298,'Adara','George','auxiliar','15-08-57',19,'02-02-06','sed.turpis@leoelementumsem.org',3128496970,15,'inactivo','-84.42113, 135.75087',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (100,299,'Trevor','Campbell','piloto','17-03-83',19,'15-02-92','facilisis.magna@musProin.edu',3064534362,15,'suspendido','57.77153, 157.03106',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (101,300,'Randall','Becker','auxiliar','08-02-75',2,'16-10-08','Aenean.euismod@augueeutempor.co.uk',3114327747,11,'inactivo','74.25939, 29.49146',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (102,301,'Danielle','Terry','piloto','11-04-95',29,'22-04-13','urna@aliquetlibero.ca',3110253068,23,'suspendido','49.56127, 7.57237',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (103,302,'Tanek','Wolfe','auxiliar','17-01-03',10,'13-03-08','tellus.imperdiet@turpis.ca',3033928740,15,'licencia','-24.40436, 146.3476',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (104,303,'Ira','Battle','auxiliar','31-10-50',8,'03-01-91','dolor.dolor.tempus@Fusce.com',3043446523,10,'entrenamiento','-53.71475, -126.34558',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (105,304,'Renee','Hodge','auxiliar','26-02-07',50,'13-05-07','metus.facilisis.lorem@urnaUttincidunt.ca',3183303078,19,'jubilado','-38.85026, -113.84376',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (106,305,'Carl','Owen','piloto','02-04-57',36,'20-07-92','quam.elementum@mauris.edu',3001449555,3,'licencia','-45.45614, -79.02142',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (107,306,'Byron','Cox','auxiliar','26-06-99',35,'04-01-11','nibh.Phasellus.nulla@nequeseddictum.co.uk',3116591282,10,'despedido','8.36577, -42.22287',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (108,307,'Josephine','Gibson','auxiliar','10-03-60',45,'07-01-95','Sed.nulla@necquamCurabitur.ca',3018491961,10,'suspendido','-44.87825, 14.25333',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (109,308,'Dexter','Roy','piloto','11-10-76',33,'27-04-02','et.magnis@velitPellentesque.net',3192897208,3,'licencia','65.07884, -105.43981',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (110,309,'Jena','Santiago','piloto','18-06-71',39,'04-11-90','dictum@sollicitudinadipiscing.co.uk',3218056656,21,'vacaciones','47.84368, 110.05558',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (111,310,'Conan','Gross','piloto','16-08-92',6,'10-07-10','Quisque.fringilla@diam.org',3016381780,7,'despedido','-61.39124, 159.40186',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (112,311,'Sopoline','Fernandez','piloto','01-05-81',28,'10-03-98','Duis@facilisiSed.edu',3189209114,17,'jubilado','-51.81034, -161.62234',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (113,312,'Aristotle','Yang','piloto','20-05-86',27,'27-05-85','eu.metus.In@nequeSed.ca',3073754993,14,'despedido','45.08018, -56.51993',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (114,313,'Cole','Dunlap','piloto','04-10-86',39,'25-08-87','Cras.eu@eliterat.co.uk',3116132369,5,'vacaciones','-84.91738, -125.22858',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (115,314,'Ross','Greer','piloto','24-10-59',12,'12-01-04','risus@viverraDonectempus.net',3150448431,21,'despedido','-30.07231, 87.64947',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (116,315,'Carolyn','Foley','auxiliar','19-11-76',19,'11-03-01','Integer.eu@adlitoratorquent.co.uk',3199510448,5,'activo','2.02489, -129.10768',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (117,316,'Wang','Barnett','piloto','03-04-53',21,'16-08-85','ac.risus@Maecenasornareegestas.ca',3121571647,6,'activo','50.59432, -157.70052',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (118,317,'Marsden','Wood','piloto','26-11-02',20,'01-08-92','libero.at.auctor@magnaa.com',3172777005,24,'activo','44.77207, 92.00333',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (119,318,'Hayfa','Dalton','auxiliar','22-05-88',42,'19-01-12','eros.Proin.ultrices@temporaugue.org',3190566938,9,'en vuelo','39.88704, -159.52539',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (120,319,'Amber','Johnston','auxiliar','29-08-99',25,'14-06-11','sit@Maecenasiaculis.ca',3150886013,9,'inactivo','5.13601, 104.75793',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (121,320,'George','Robbins','auxiliar','06-07-94',13,'02-12-13','magna@etultrices.edu',3218300262,8,'entrenamiento','36.26984, 39.38181',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (122,321,'Cade','Hunt','auxiliar','24-01-50',31,'30-09-05','at.sem@Suspendisse.org',3006852588,17,'jubilado','84.75762, 59.10104',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (123,322,'Damon','Slater','auxiliar','24-08-04',4,'26-11-06','adipiscing.elit.Etiam@diamloremauctor.ca',3156974902,2,'vacaciones','-43.38603, -19.39013',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (124,323,'Samson','Moreno','auxiliar','10-06-82',24,'21-12-07','Cras.dolor@Uttincidunt.ca',3060953718,11,'inactivo','-47.54998, -14.81282',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (125,324,'Dakota','Wade','auxiliar','14-05-03',6,'18-10-86','aliquet.Phasellus@a.ca',3060073623,16,'activo','-86.70811, -150.80892',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (126,325,'Sylvia','Leach','auxiliar','01-07-61',5,'06-11-99','condimentum.eget@euelit.org',3028756786,14,'activo','18.33056, 85.62923',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (127,326,'Summer','Walls','auxiliar','05-10-60',7,'11-02-04','consectetuer.adipiscing@elitCurabitur.ca',3175539643,22,'jubilado','-14.304, -78.27099',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (128,327,'Amaya','Watkins','piloto','16-12-83',15,'17-10-94','suscipit@sem.ca',3022032576,8,'despedido','85.72618, -169.75667',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (129,328,'Ora','Pitts','auxiliar','22-10-62',26,'12-10-06','urna.convallis.erat@ipsumcursus.ca',3100165999,19,'inactivo','-42.47525, -83.75282',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (130,329,'Lillian','Cleveland','auxiliar','15-09-94',44,'19-12-08','consectetuer.adipiscing.elit@ornareliberoat.net',3163491729,10,'suspendido','-2.008, -66.58358',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (131,330,'Brett','Vincent','auxiliar','06-07-62',48,'19-02-03','vitae.erat.vel@Duisrisusodio.org',3097966703,12,'inactivo','29.12811, 44.92392',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (132,331,'Kylan','Wise','auxiliar','31-05-72',4,'28-05-11','fringilla.Donec@tellus.ca',3206716777,15,'en vuelo','68.28201, 148.1116',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (133,332,'Zia','Martin','auxiliar','18-11-97',30,'19-01-87','Phasellus.elit@eu.edu',3091157341,23,'inactivo','-46.24018, -127.81808',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (134,333,'Fuller','Munoz','piloto','09-04-05',17,'12-08-85','Quisque.nonummy@mollis.co.uk',3109646940,22,'en vuelo','-56.71005, 11.46463',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (135,334,'Violet','Serrano','auxiliar','04-05-74',44,'23-10-05','eget.venenatis.a@necorci.com',3075654911,7,'licencia','6.80485, 87.40708',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (136,335,'Audrey','Wilder','piloto','28-09-82',14,'02-04-00','lacinia.vitae@Utnecurna.com',3113554590,8,'entrenamiento','88.91133, 119.67551',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (137,336,'Caesar','Dodson','auxiliar','07-09-81',18,'04-05-06','lorem.eu.metus@Nulladignissim.org',3105484772,2,'activo','73.52489, -166.87366',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (138,337,'Hoyt','Levine','auxiliar','13-08-65',49,'18-08-08','mi.tempor@dictumeu.ca',3040080424,2,'jubilado','-42.38856, 140.48519',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (139,338,'Ashton','Herman','piloto','13-08-06',27,'09-09-10','auctor.non@ametdiameu.org',3092588451,11,'inactivo','-57.90831, -73.28996',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (140,339,'Alexis','Stout','auxiliar','15-12-08',28,'26-04-09','mauris.ipsum@sed.com',3040361186,20,'inactivo','-76.73088, -53.47233',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (141,340,'Jillian','Bradshaw','piloto','02-02-86',18,'24-12-92','semper.Nam.tempor@vehiculaPellentesquetincidunt.net',3131010087,3,'inactivo','7.87831, 111.50868',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (142,341,'Germaine','Hahn','auxiliar','17-11-64',44,'12-03-91','vitae.erat@milorem.org',3203132256,15,'vacaciones','11.58263, 70.66442',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (143,342,'Beatrice','Silva','auxiliar','09-10-63',19,'04-12-87','dictum.ultricies.ligula@ipsumprimis.co.uk',3106688882,16,'despedido','-77.1373, 168.61445',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (144,343,'Yvonne','Mcmillan','piloto','07-01-91',22,'10-09-99','ultricies@velarcueu.ca',3031619368,4,'suspendido','-84.08383, -77.70352',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (145,344,'Macon','Craft','piloto','30-12-68',15,'12-06-08','commodo.at.libero@orciquislectus.org',3139591275,19,'en vuelo','-20.03044, -131.89155',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (146,345,'Deacon','Mcpherson','auxiliar','08-10-79',47,'24-05-87','egestas.Fusce@Quisqueornare.edu',3184845859,19,'jubilado','-82.25312, 100.72298',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (147,346,'Ashely','Stephens','auxiliar','17-01-89',18,'07-10-99','cursus.et@maurisut.co.uk',3004515333,4,'suspendido','15.85682, 95.34672',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (148,347,'Hector','Cook','piloto','14-02-87',11,'18-09-94','quis@orciUtsagittis.edu',3088844138,8,'en vuelo','61.9002, -177.71319',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (149,348,'Paul','Lowe','auxiliar','28-12-78',16,'19-04-89','diam@natoquepenatibus.edu',3127917008,12,'jubilado','-42.07662, -9.40631',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (150,349,'Barrett','Mullen','auxiliar','24-09-65',46,'18-01-97','et.commodo.at@etnunc.com',3141445275,22,'en vuelo','-72.19096, -151.7051',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (151,350,'Barry','Avery','piloto','05-02-63',10,'26-01-11','Nunc.quis@sedpede.net',3109589174,5,'activo','0.51178, 60.45527',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (152,351,'Leilani','Powers','piloto','19-05-89',19,'08-08-13','quis.accumsan.convallis@venenatis.edu',3186887898,13,'inactivo','25.01188, 61.27762',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (153,352,'Fuller','Delaney','piloto','09-09-08',37,'25-05-08','venenatis.vel@placeratorcilacus.edu',3117782415,5,'inactivo','-29.16776, 122.08475',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (154,353,'Porter','Beard','auxiliar','08-08-88',15,'11-06-01','gravida.sit.amet@torquentper.co.uk',3102414300,13,'licencia','-56.98656, -7.6844',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (155,354,'Aimee','Smith','piloto','17-04-06',49,'16-02-99','ante@estac.ca',3150166193,15,'activo','46.5103, -122.93745',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (156,355,'Nolan','Mcguire','auxiliar','04-06-79',47,'10-04-92','neque@ornareInfaucibus.com',3098902798,11,'jubilado','-49.82889, 145.85927',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (157,356,'Benedict','Mcintosh','auxiliar','07-03-89',19,'18-12-00','erat.eget@utsem.ca',3144405071,10,'inactivo','-32.23063, -68.85717',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (158,357,'Fritz','Estes','piloto','04-10-64',2,'16-07-03','mattis.Integer@urnaetarcu.edu',3063578262,15,'en vuelo','-3.24897, -141.05833',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (159,358,'Sandra','Porter','auxiliar','25-11-61',42,'30-03-06','nec@liberomaurisaliquam.co.uk',3159432385,23,'entrenamiento','-83.21146, -170.31732',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (160,359,'Conan','Santana','piloto','17-12-66',35,'07-09-90','Duis.volutpat.nunc@nulla.edu',3105858889,20,'jubilado','-66.65186, 142.84115',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (161,360,'Ryan','Salazar','auxiliar','03-04-86',45,'10-11-90','tincidunt.nunc@ligulaAliquam.edu',3014887835,6,'entrenamiento','-31.4005, 93.62155',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (162,361,'Zenia','Golden','piloto','22-01-79',49,'18-05-11','vel.vulputate@malesuada.ca',3151988277,20,'licencia','31.57976, 178.07138',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (163,362,'Knox','Finley','auxiliar','13-03-04',14,'14-02-97','lectus.Cum.sociis@arcu.net',3210552892,4,'activo','-21.09308, -60.0811',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (164,363,'Ivory','Chavez','auxiliar','09-12-96',38,'15-10-86','quis@enimnislelementum.org',3059083125,3,'activo','16.94063, -15.66317',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (165,364,'Kamal','Nolan','piloto','10-02-88',26,'17-11-09','Donec.nibh.Quisque@utipsum.edu',3051440797,5,'jubilado','-63.58699, -37.49202',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (166,365,'Larissa','Wynn','auxiliar','18-07-82',34,'24-11-03','sit.amet@nonloremvitae.org',3194904764,18,'despedido','89.93161, -118.30711',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (167,366,'Beck','Vazquez','piloto','09-01-60',34,'31-01-87','ac.metus.vitae@lacusQuisque.net',3165521068,20,'suspendido','-48.7202, 147.81965',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (168,367,'Cameron','Whitney','auxiliar','21-11-76',19,'29-09-13','luctus@augueut.co.uk',3120421963,6,'activo','-70.78421, -117.91884',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (169,368,'Wynne','Kane','auxiliar','17-07-89',13,'03-11-12','dis.parturient@Suspendisse.org',3040553545,7,'licencia','-67.9097, -127.48731',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (170,369,'Constance','Monroe','auxiliar','29-06-59',15,'01-12-87','tempus@purusmauris.org',3154874275,13,'licencia','-51.221, 24.77986',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (171,370,'Henry','Tate','auxiliar','31-12-93',47,'15-02-03','vehicula.risus.Nulla@magna.com',3114632567,17,'suspendido','40.80175, 144.94761',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (172,371,'Carl','Burton','auxiliar','24-02-93',40,'11-06-96','semper.dui.lectus@purussapiengravida.com',3212021780,17,'despedido','-9.60872, -101.72605',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (173,372,'Melvin','Cole','auxiliar','04-11-82',7,'25-03-86','ornare.In.faucibus@aliquam.edu',3220119824,16,'activo','-43.61517, -150.09813',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (174,373,'Fritz','Green','piloto','14-12-76',44,'26-05-04','Duis.a.mi@semNullainterdum.org',3200703778,4,'entrenamiento','-57.54211, 1.75838',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (175,374,'Lyle','Ballard','piloto','30-10-69',18,'01-05-93','aliquet.odio@interdumenimnon.co.uk',3216712651,20,'inactivo','-54.17612, 66.82322',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (176,375,'Damian','Huber','piloto','04-02-09',23,'10-07-88','euismod@Namnullamagna.co.uk',3033977520,6,'suspendido','2.44706, -120.27684',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (177,376,'Quinn','Mosley','auxiliar','09-05-75',12,'16-05-04','pede@convallisconvallisdolor.co.uk',3070337878,24,'jubilado','87.56199, -22.42164',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (178,377,'Samson','Cross','auxiliar','06-04-82',11,'23-08-90','ut@necurnasuscipit.com',3083288158,14,'licencia','-56.35944, 158.95192',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (179,378,'Cameron','Moss','piloto','06-11-61',19,'14-03-98','Fusce.diam.nunc@ligulaAenean.net',3028423345,22,'licencia','-89.53142, 61.13963',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (180,379,'Tanisha','Conrad','auxiliar','26-12-75',38,'19-07-12','lectus.ante@nislarcuiaculis.edu',3046187888,16,'entrenamiento','-49.05871, 30.68981',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (181,380,'Fiona','Hatfield','auxiliar','04-02-79',12,'17-01-03','volutpat.nunc@Quisque.co.uk',3154221232,14,'en vuelo','52.17806, -37.15721',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (182,381,'Rose','Henry','auxiliar','26-12-99',1,'30-05-98','nec@Naminterdum.ca',3105521622,8,'activo','-41.70301, 161.72122',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (183,382,'Sean','Mcdonald','auxiliar','09-12-79',49,'30-11-90','nisi.sem.semper@a.ca',3015235933,21,'despedido','25.42722, 149.67888',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (184,383,'David','Coleman','piloto','13-04-00',4,'19-04-06','ac@sed.net',3117626693,16,'vacaciones','86.94262, -100.18742',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (185,384,'Lacota','York','piloto','15-10-87',3,'08-02-87','facilisis.non@anuncIn.co.uk',3116378234,7,'entrenamiento','69.45968, 17.69562',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (186,385,'Bradley','Finch','piloto','11-02-99',48,'19-08-90','Mauris@convallis.org',3141892704,2,'activo','76.53094, 124.04978',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (187,386,'Zachery','Wagner','piloto','22-08-98',40,'05-06-09','mi.tempor@dignissimmagna.co.uk',3118564665,23,'entrenamiento','15.0487, 21.1728',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (188,387,'Rana','Davidson','auxiliar','16-03-53',36,'02-10-87','egestas.ligula.Nullam@consectetuercursuset.com',3179606741,5,'suspendido','-74.71508, -112.29888',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (189,388,'Shelly','Fleming','piloto','29-04-58',31,'12-12-10','Suspendisse@blandit.org',3159270402,16,'despedido','48.15209, 58.21995',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (190,389,'Glenna','Prince','auxiliar','08-03-61',19,'08-04-98','fames.ac.turpis@eu.ca',3125970928,14,'entrenamiento','88.18606, 5.78966',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (191,390,'Shea','Silva','piloto','10-04-78',3,'19-01-11','Suspendisse@aliquetodioEtiam.ca',3078138837,3,'licencia','52.2713, -135.73903',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (192,391,'Wyatt','Mcgowan','auxiliar','18-02-05',41,'16-04-05','id.nunc.interdum@pedemalesuada.ca',3040716307,12,'entrenamiento','60.74319, 179.05254',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (193,392,'Hiram','Prince','auxiliar','04-03-77',21,'05-02-03','ullamcorper.nisl@Ut.com',3091471434,22,'activo','-88.36002, -33.04379',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (194,393,'Michelle','Dennis','auxiliar','15-05-99',43,'20-12-05','sollicitudin@anteipsumprimis.org',3163413046,21,'jubilado','85.61511, 108.60103',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (195,394,'Jamalia','Campbell','piloto','08-06-56',50,'01-06-00','Duis.cursus.diam@Suspendisse.com',3073706905,3,'activo','48.50015, -119.17226',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (196,395,'Elvis','Paul','piloto','27-05-70',25,'02-12-91','In.condimentum.Donec@aptent.edu',3076247021,6,'vacaciones','-36.87961, -109.18668',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (197,396,'Linus','Rice','piloto','22-07-08',1,'25-02-88','nulla@ProinmiAliquam.net',3088389731,18,'licencia','-3.37846, -67.04303',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (198,397,'Rylee','Moore','auxiliar','14-09-82',16,'13-04-00','convallis.ligula.Donec@adipiscing.org',3151872990,16,'jubilado','72.52328, -51.19512',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (199,398,'Drew','Hernandez','auxiliar','02-10-56',30,'16-02-92','egestas.blandit@Vivamus.net',3029609013,20,'activo','-31.91143, 168.36578',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (200,399,'Benedict','Davidson','auxiliar','09-12-70',23,'17-05-85','ultrices.mauris@dui.edu',3166757940,12,'en vuelo','66.56804, -89.67556',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (201,400,'Marvin','Lowery','auxiliar','03-03-58',33,'08-12-00','fames.ac.turpis@amet.ca',3092623245,14,'activo','-33.12296, -20.96015',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (202,401,'Florence','Leon','auxiliar','14-06-93',25,'24-01-09','tellus.non.magna@magnaSed.edu',3210203349,4,'jubilado','-44.337, -16.51913',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (203,402,'Quail','Glover','piloto','19-07-78',44,'02-10-06','taciti.sociosqu@eu.ca',3118053065,13,'suspendido','-24.45827, -50.11078',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (204,403,'Beatrice','Morse','auxiliar','03-01-60',16,'20-03-12','nulla@Sed.edu',3190429950,21,'en vuelo','22.86314, 135.43509',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (205,404,'Jelani','Foster','auxiliar','08-06-82',40,'17-06-07','mus.Donec.dignissim@nunc.co.uk',3160150385,14,'en vuelo','74.17745, -21.70032',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (206,405,'Beverly','Mccray','auxiliar','18-03-09',18,'15-01-91','gravida.non@necimperdietnec.edu',3179687449,4,'activo','-65.48594, 130.14558',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (207,406,'Cole','Copeland','piloto','03-03-06',18,'10-11-96','imperdiet.dictum@felis.com',3172216408,2,'activo','-72.70989, 109.56132',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (208,407,'Dominique','Leonard','piloto','23-02-59',36,'28-12-11','libero.Proin@facilisis.co.uk',3067870470,16,'despedido','63.48469, 145.72915',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (209,408,'Gemma','Mosley','piloto','21-01-90',7,'06-02-88','egestas.hendrerit@Donec.org',3100909260,22,'despedido','51.3409, 137.60098',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (210,409,'Sonya','Hebert','piloto','03-05-89',46,'09-08-99','aliquet.molestie.tellus@nonummyFusce.com',3134485347,5,'jubilado','18.9011, 34.79569',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (211,410,'Hasad','Romero','auxiliar','09-01-64',14,'09-04-97','fringilla@sagittisplaceratCras.ca',3063520798,24,'entrenamiento','19.07185, -73.34518',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (212,411,'Vance','Diaz','piloto','15-04-03',1,'07-03-89','mi.pede@augueacipsum.org',3171293245,5,'inactivo','15.76637, -70.65645',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (213,412,'Paki','Gregory','auxiliar','13-01-54',4,'12-04-00','adipiscing.lacus.Ut@dignissim.ca',3220336040,18,'suspendido','5.94477, 174.98772',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (214,413,'Vivien','Banks','piloto','12-07-84',9,'09-11-98','luctus.aliquet@auctor.net',3123162713,8,'licencia','-40.23426, 52.43535',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (215,414,'Tamara','Stuart','piloto','11-04-94',13,'07-12-15','mauris.a.nunc@molestiedapibus.org',3181388243,8,'vacaciones','-21.89722, 130.1246',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (216,415,'Jordan','Stark','piloto','31-08-00',49,'10-10-93','mollis@lectusconvallis.com',3181611261,24,'activo','87.46128, -67.33293',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (217,416,'Cruz','Hansen','piloto','18-06-03',34,'16-07-87','nunc.risus@auctorMaurisvel.com',3022850668,24,'en vuelo','38.50751, -9.64328',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (218,417,'Castor','Porter','piloto','12-12-91',25,'14-03-15','vel@arcuVestibulumut.net',3126503183,11,'en vuelo','87.44128, -170.60739',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (219,418,'Xanthus','Hensley','piloto','12-07-66',9,'04-06-86','ultricies.adipiscing@dolorFusce.co.uk',3203396406,17,'en vuelo','-58.68119, -82.41845',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (220,419,'Yardley','Weeks','piloto','01-01-00',8,'05-02-90','In.lorem.Donec@a.co.uk',3082995815,16,'suspendido','85.41405, 85.36551',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (221,420,'Philip','Goff','piloto','30-10-78',35,'18-07-08','blandit@anteMaecenasmi.com',3081157434,2,'suspendido','-72.24913, 154.95127',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (222,421,'Cairo','Simon','piloto','14-09-93',21,'24-07-05','Quisque@Duis.com',3096844099,19,'inactivo','-38.79979, 20.18457',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (223,422,'Ashton','Barber','auxiliar','13-09-82',9,'15-07-87','faucibus@Suspendisse.com',3091981433,8,'despedido','21.48386, 151.26194',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (224,423,'Noelani','Allison','piloto','13-02-02',31,'14-06-95','faucibus@vestibulumMaurismagna.org',3156548620,8,'vacaciones','54.67393, -94.43625',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (225,424,'Lars','Webster','piloto','17-11-09',39,'29-07-02','Proin.vel@quispedePraesent.org',3214924855,15,'inactivo','-60.70812, -40.4711',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (226,425,'Hall','Alvarado','piloto','12-11-50',50,'04-05-95','auctor.odio.a@ultricesposuere.net',3024630488,6,'despedido','60.39135, 75.40532',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (227,426,'Neil','Avila','piloto','15-07-70',3,'07-01-86','vitae.sodales@Aeneanegetmagna.com',3109872359,20,'activo','-6.0165, 59.32562',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (228,427,'Clio','Zimmerman','piloto','14-07-84',38,'06-08-13','mauris.Morbi.non@ultricesposuerecubilia.net',3162427351,4,'licencia','17.6094, 20.00492',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (229,428,'Vernon','Sharp','auxiliar','07-11-09',11,'01-12-88','sodales.nisi.magna@Donec.org',3131578531,10,'licencia','-78.94646, -98.88756',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (230,429,'Sebastian','Richardson','auxiliar','16-12-06',25,'30-08-01','est@etmalesuada.edu',3149838891,17,'vacaciones','18.92576, -11.34969',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (231,430,'Nadine','Rodriquez','piloto','27-03-04',5,'04-07-95','risus.Nulla@Morbinonsapien.ca',3127403438,3,'activo','-20.41207, -13.5276',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (232,431,'Boris','Olsen','auxiliar','25-10-84',3,'04-06-89','mollis.dui.in@Donec.ca',3203618406,5,'activo','-31.55979, 73.80056',13);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (233,432,'Nyssa','Dillard','piloto','29-06-80',36,'21-05-08','a@estMauriseu.org',3025394652,7,'entrenamiento','-70.68846, -122.67404',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (234,433,'Ori','Hebert','piloto','22-05-91',29,'11-12-85','luctus.ut.pellentesque@quispedeSuspendisse.net',3138386764,16,'jubilado','-3.32362, 67.44419',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (235,434,'Piper','Weiss','auxiliar','13-11-91',36,'03-04-15','commodo.auctor.velit@vulputate.org',3167734756,12,'suspendido','72.4872, 141.06184',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (236,435,'Rahim','Bowman','auxiliar','10-02-09',1,'15-12-92','Integer.urna@idmollisnec.org',3094608069,22,'inactivo','54.9559, -19.8828',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (237,436,'Willa','Melton','auxiliar','11-08-77',35,'06-09-98','mi.felis@est.com',3093840165,7,'entrenamiento','-0.58807, 79.97286',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (238,437,'Molly','Quinn','piloto','11-06-01',9,'03-01-04','eget.mollis.lectus@nullaInteger.org',3014507469,6,'activo','-59.08952, 4.73035',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (239,438,'Dawn','Wilkerson','piloto','22-01-02',17,'17-10-12','vestibulum.neque@aultricies.ca',3156160283,24,'jubilado','-69.9018, -149.89536',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (240,439,'Teagan','Chase','auxiliar','11-03-93',32,'02-12-13','a@turpisegestasAliquam.net',3129653996,2,'licencia','58.99758, -160.23436',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (241,440,'Macon','Massey','auxiliar','05-02-56',42,'15-06-87','Quisque@Aliquam.co.uk',3070588030,19,'licencia','-33.33981, -45.51527',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (242,441,'Ingrid','Simon','auxiliar','01-03-58',30,'14-05-15','Phasellus@Crasloremlorem.ca',3053864491,13,'suspendido','66.31653, 139.22079',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (243,442,'India','House','piloto','01-01-74',8,'17-08-03','lobortis.nisi.nibh@euligulaAenean.ca',3198498033,15,'en vuelo','-27.90891, -31.18284',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (244,443,'Jeanette','Dunn','piloto','18-11-74',9,'03-11-88','nisi.a@liberoProin.edu',3061852281,4,'jubilado','-63.59437, -137.00338',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (245,444,'Kylee','Guzman','piloto','10-09-52',8,'26-03-99','dui.nec@aliquetodioEtiam.org',3182450479,19,'despedido','0.51801, -36.24929',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (246,445,'Galvin','Sweet','piloto','26-09-72',20,'18-03-91','euismod.ac.fermentum@Loremipsum.com',3142063591,12,'entrenamiento','-46.88163, -79.13592',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (247,446,'Nita','Munoz','piloto','04-05-98',12,'30-07-99','ut.lacus@Curabitur.com',3104568527,2,'activo','69.86875, -28.05612',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (248,447,'Beck','Burks','auxiliar','22-11-86',49,'24-07-07','sed.leo@enim.ca',3217712065,22,'licencia','53.15584, -97.33958',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (249,448,'Hyacinth','Schroeder','piloto','01-04-81',48,'01-01-92','justo.sit@ligula.co.uk',3114484133,4,'suspendido','33.46638, 132.66579',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (250,449,'Lani','Shannon','auxiliar','20-05-78',48,'06-05-12','ligula.Nullam@etmagnaPraesent.net',3031658052,12,'despedido','42.78734, 69.25504',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (251,450,'Camden','Johns','piloto','29-01-64',6,'24-07-04','in.molestie@malesuadaaugue.co.uk',3140665736,16,'inactivo','-61.6369, -64.76005',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (252,451,'Silas','Obrien','auxiliar','13-03-56',44,'16-02-12','ligula.tortor.dictum@Donec.com',3028718637,7,'jubilado','-34.90995, -50.62951',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (253,452,'Branden','Robles','piloto','25-05-51',5,'09-04-97','rutrum.justo.Praesent@Donecporttitor.edu',3080991777,14,'vacaciones','43.28223, 21.58837',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (254,453,'Gisela','Potts','piloto','19-03-80',33,'10-09-14','nisl.arcu.iaculis@egestas.co.uk',3009671223,5,'activo','-48.59386, -115.5025',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (255,454,'Gillian','Burt','piloto','25-06-77',17,'15-12-00','rutrum.non.hendrerit@iaculis.org',3200326569,3,'licencia','23.43319, -67.16039',1);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (256,455,'Brody','English','piloto','16-09-69',37,'31-03-09','pellentesque.eget.dictum@molestiedapibus.org',3089162244,12,'jubilado','-87.24908, 166.2269',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (257,456,'Carol','Woodward','auxiliar','06-02-72',2,'17-03-05','ac.urna@elitsed.org',3154306585,14,'licencia','-49.93471, -132.141',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (258,457,'Olga','Gay','auxiliar','17-04-75',44,'15-01-02','Nunc.ac.sem@penatibus.org',3041929990,19,'suspendido','52.68463, -64.69235',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (259,458,'Karyn','Rocha','auxiliar','12-08-05',8,'03-07-91','Fusce.fermentum.fermentum@NulladignissimMaecenas.org',3062955378,18,'inactivo','-75.95112, -78.58726',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (260,459,'Jacob','Talley','auxiliar','18-06-78',50,'03-04-14','porttitor@Sedmolestie.ca',3049237151,9,'inactivo','13.9507, 151.84063',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (261,460,'Hilda','Bird','auxiliar','28-10-65',26,'03-01-96','Quisque@natoque.co.uk',3095402363,21,'en vuelo','66.59245, 76.80619',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (262,461,'Raya','Jacobson','auxiliar','16-01-55',30,'20-06-07','velit.Cras@eleifendCrassed.ca',3130780082,8,'suspendido','-29.27972, -128.35697',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (263,462,'Fatima','Roth','piloto','11-11-87',3,'16-05-86','fermentum.arcu.Vestibulum@Aliquamtincidunt.co.uk',3207768589,11,'activo','27.66186, -60.09401',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (264,463,'Margaret','Haney','piloto','26-04-84',21,'07-06-88','ut@necleoMorbi.com',3082300615,9,'suspendido','3.08183, -116.14259',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (265,464,'Jordan','Baird','auxiliar','05-05-50',13,'19-01-87','sed.sapien@arcuVivamus.ca',3189039119,18,'inactivo','81.50691, 94.94016',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (266,465,'Ryan','Ellison','piloto','23-06-65',49,'23-07-05','mi@non.net',3087349124,17,'inactivo','72.59691, -128.16758',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (267,466,'Whoopi','Moore','auxiliar','06-02-78',45,'05-04-14','magna@In.org',3053275619,11,'jubilado','-20.03637, 50.31334',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (268,467,'Wyatt','Hull','auxiliar','23-11-73',19,'01-05-01','non.bibendum@pellentesquemassa.ca',3083964688,21,'despedido','53.48808, 65.50974',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (269,468,'Zahir','Mcdowell','auxiliar','17-10-95',32,'29-06-85','vel@consectetuer.org',3039399478,23,'entrenamiento','42.63995, -171.59563',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (270,469,'Dale','Diaz','auxiliar','14-05-91',9,'09-02-94','nec.ante.blandit@duinectempus.edu',3199367585,6,'activo','-59.56446, -130.65368',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (271,470,'Libby','Pennington','piloto','02-08-68',41,'17-05-15','enim.Mauris@Vestibulum.ca',3049779792,10,'inactivo','85.8209, 160.28772',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (272,471,'Eliana','Lawrence','auxiliar','08-08-09',1,'20-09-05','auctor@nisi.org',3136238538,16,'suspendido','-39.77714, 129.3512',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (273,472,'Jordan','Sharp','auxiliar','05-04-68',46,'25-07-88','Cum.sociis@nequeet.edu',3184673870,8,'jubilado','-30.87889, 120.74694',12);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (274,473,'Keaton','Carver','auxiliar','17-09-70',8,'15-07-00','Cras.sed@imperdietnec.com',3136206661,11,'entrenamiento','-41.29915, 76.50688',2);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (275,474,'Celeste','Cobb','auxiliar','17-12-03',8,'01-11-90','Integer.vitae@vitae.edu',3210871821,16,'suspendido','26.63696, -151.62661',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (276,475,'Leandra','Hammond','piloto','08-07-98',13,'15-08-00','magna@convallisantelectus.com',3069586848,2,'jubilado','33.91844, -132.6764',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (277,476,'Justina','Gordon','piloto','14-10-72',16,'26-08-11','eros@velitPellentesqueultricies.org',3109985162,18,'suspendido','65.52379, -155.9438',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (278,477,'Keefe','Mcpherson','piloto','23-07-78',4,'29-10-93','posuere.vulputate.lacus@maurissapiencursus.edu',3160602424,7,'suspendido','-23.72205, 167.62595',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (279,478,'Melodie','Glover','auxiliar','07-04-95',11,'24-01-86','quam.Pellentesque@iaculisodio.net',3060463310,2,'licencia','29.31225, 57.08656',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (280,479,'Kiona','Lucas','auxiliar','26-12-53',35,'27-01-09','Lorem.ipsum@nec.net',3126671532,20,'inactivo','-3.09742, -121.7751',7);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (281,480,'Yasir','Moses','piloto','09-11-06',2,'20-01-94','cursus@lobortisquispede.com',3111184851,23,'jubilado','79.97881, -13.51622',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (282,481,'Ciaran','Willis','piloto','15-08-61',7,'11-04-95','nec.mauris.blandit@odioauctor.edu',3058265046,16,'inactivo','-32.79584, -16.59022',8);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (283,482,'Dominique','Burt','auxiliar','14-10-92',3,'02-05-07','at.fringilla@faucibus.net',3163119937,4,'entrenamiento','-81.06645, 176.67176',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (284,483,'Moses','Anthony','piloto','21-06-08',34,'09-02-09','interdum.Sed@congueelitsed.org',3163954931,8,'en vuelo','-39.4386, -84.41944',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (285,484,'Jaden','Morrison','auxiliar','07-05-91',6,'20-11-90','volutpat@miac.net',3217622646,13,'en vuelo','69.25415, -172.51795',5);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (286,485,'Jessica','Eaton','piloto','02-01-62',50,'09-02-02','nisl@Praesent.org',3134378458,7,'licencia','-52.11001, -38.18254',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (287,486,'Hollee','Williams','auxiliar','05-07-08',3,'24-09-93','Integer.urna.Vivamus@metussitamet.edu',3040959174,16,'jubilado','16.82523, 28.38488',11);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (288,487,'Julian','Buckley','piloto','20-11-59',11,'21-12-98','sagittis.lobortis@Intinciduntcongue.edu',3182691711,6,'despedido','-79.39459, 152.4417',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (289,488,'Leilani','Mills','piloto','07-12-91',34,'30-12-87','odio@semperrutrumFusce.net',3157096762,5,'en vuelo','87.5742, 102.65254',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (290,489,'Sopoline','Gomez','auxiliar','17-09-79',33,'28-02-05','Integer.vulputate.risus@Sednunc.ca',3012021556,2,'entrenamiento','87.47587, -80.84077',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (291,490,'Avye','Sanford','auxiliar','04-12-78',19,'13-02-98','luctus.vulputate@etmalesuadafames.org',3069662256,8,'inactivo','74.13877, 151.90786',4);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (292,491,'Gloria','Villarreal','auxiliar','17-11-58',9,'28-01-11','dictum@adipiscing.ca',3006817746,22,'entrenamiento','19.49959, 139.49499',3);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (293,492,'Charissa','Nolan','piloto','05-09-67',1,'20-10-90','nulla.magna@nislMaecenasmalesuada.edu',3010938054,12,'en vuelo','73.79929, 146.42074',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (294,493,'Stephen','David','auxiliar','10-11-97',18,'19-05-87','massa.Quisque.porttitor@nequeNullam.edu',3134002374,17,'vacaciones','77.51531, -15.43254',6);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (295,494,'Zane','Mccarthy','auxiliar','09-10-08',6,'28-02-10','ac.metus.vitae@ligulaeuenim.ca',3217389133,6,'vacaciones','74.07114, -72.95376',9);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (296,495,'Ian','Watts','piloto','25-01-71',37,'28-09-99','vitae.posuere.at@atvelit.co.uk',3041467932,10,'vacaciones','-47.65116, 165.06295',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (297,496,'Dorothy','Bryant','piloto','03-05-70',16,'17-10-94','sem.Pellentesque@SuspendissesagittisNullam.org',3207580617,24,'suspendido','-20.92437, -35.70556',15);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (298,497,'Talon','Holt','piloto','01-06-75',30,'10-06-05','enim@cubilia.edu',3084205812,21,'licencia','-83.12982, -88.05011',14);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (299,498,'Plato','Gomez','auxiliar','28-05-92',45,'10-01-10','lorem.ac.risus@infelis.com',3204801390,18,'suspendido','-47.51462, -85.74182',10);
INSERT INTO tripulaciones (id_empleados,id_azafatas,nombres,apellidos,tipo,fecha_de_nacimiento,antiguedad,fecha_ultimo_entrenamiento_recibido,correo,celular,horas_descanso_ultimo_vuelo,estado,ubicacion_actual,id_ciudades) VALUES (300,499,'Vera','Mcgowan','piloto','13-03-93',34,'16-08-94','imperdiet.erat@MaurismagnaDuis.com',3115173055,24,'activo','20.07057, -165.25644',6);

--insert pilotos
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (300,'1_pre-elementary',364,'CPL','primer oficial','12');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (301,'3_pre-operational',244,'ATPL','primer oficial','78');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (302,'3_pre-operational',513,'IFR','primer oficial','41');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (303,'6_expert',591,'ME','comandante','102');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (304,'1_pre-elementary',164,'ATPL','comandante','106');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (305,'2_elementary',486,'IFR','comandante','165');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (306,'3_pre-operational',55,'CPL','primer oficial','288');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (307,'1_pre-elementary',277,'IFR','comandante','22');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (308,'2_elementary',393,'ATPL','primer oficial','233');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (309,'1_pre-elementary',32,'CPL','comandante','81');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (310,'6_expert',430,'ATPL','primer oficial','54');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (311,'1_pre-elementary',32,'ATPL','comandante','225');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (312,'1_pre-elementary',379,'ME','comandante','210');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (313,'1_pre-elementary',342,'CPL','primer oficial','226');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (314,'2_elementary',417,'ATPL','comandante','271');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (315,'6_expert',283,'ME','comandante','187');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (316,'1_pre-elementary',147,'CPL','comandante','74');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (317,'1_pre-elementary',478,'IFR','primer oficial','8');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (318,'2_elementary',307,'CPL','primer oficial','106');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (319,'2_elementary',125,'CPL','comandante','53');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (320,'1_pre-elementary',519,'ME','comandante','197');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (321,'6_expert',159,'ATPL','primer oficial','289');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (322,'6_expert',440,'CPL','primer oficial','254');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (323,'2_elementary',547,'IFR','comandante','114');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (324,'4_operational',579,'IFR','comandante','84');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (325,'4_operational',152,'IFR','comandante','219');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (326,'6_expert',214,'IFR','comandante','214');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (327,'3_pre-operational',306,'IFR','comandante','214');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (328,'2_elementary',174,'CPL','primer oficial','165');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (329,'2_elementary',426,'CPL','primer oficial','38');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (330,'5_extended',497,'CPL','comandante','33');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (331,'4_operational',357,'ME','comandante','55');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (332,'5_extended',384,'IFR','primer oficial','117');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (333,'6_expert',364,'IFR','comandante','246');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (334,'4_operational',301,'CPL','comandante','59');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (335,'2_elementary',593,'IFR','comandante','17');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (336,'5_extended',50,'IFR','comandante','203');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (337,'3_pre-operational',386,'CPL','primer oficial','228');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (338,'1_pre-elementary',405,'IFR','primer oficial','153');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (339,'4_operational',483,'ATPL','comandante','81');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (340,'4_operational',334,'CPL','comandante','59');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (341,'3_pre-operational',202,'ME','comandante','249');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (342,'4_operational',157,'ME','primer oficial','71');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (343,'2_elementary',355,'CPL','comandante','98');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (344,'6_expert',375,'ME','comandante','78');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (345,'3_pre-operational',85,'IFR','primer oficial','271');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (346,'4_operational',241,'ME','primer oficial','68');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (347,'4_operational',307,'ME','primer oficial','55');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (348,'1_pre-elementary',183,'CPL','comandante','278');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (349,'4_operational',377,'ME','primer oficial','148');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (350,'3_pre-operational',318,'ME','comandante','58');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (351,'6_expert',93,'CPL','primer oficial','37');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (352,'5_extended',117,'ME','comandante','10');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (353,'2_elementary',532,'ATPL','comandante','215');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (354,'4_operational',481,'IFR','primer oficial','210');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (355,'1_pre-elementary',66,'ATPL','comandante','34');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (356,'1_pre-elementary',7,'IFR','comandante','56');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (357,'4_operational',413,'ATPL','primer oficial','34');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (358,'3_pre-operational',508,'ATPL','primer oficial','256');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (359,'1_pre-elementary',222,'IFR','primer oficial','117');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (360,'2_elementary',304,'IFR','primer oficial','233');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (361,'4_operational',351,'ATPL','primer oficial','225');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (362,'1_pre-elementary',172,'ATPL','primer oficial','225');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (363,'2_elementary',315,'ATPL','comandante','114');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (364,'3_pre-operational',208,'ATPL','comandante','189');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (365,'1_pre-elementary',587,'IFR','comandante','68');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (366,'3_pre-operational',354,'ME','primer oficial','145');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (367,'3_pre-operational',589,'IFR','primer oficial','228');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (368,'6_expert',280,'ME','primer oficial','111');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (369,'6_expert',373,'IFR','comandante','288');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (370,'4_operational',452,'IFR','primer oficial','249');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (371,'5_extended',588,'CPL','primer oficial','165');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (372,'1_pre-elementary',204,'CPL','comandante','191');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (373,'5_extended',177,'CPL','comandante','160');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (374,'6_expert',427,'ME','comandante','233');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (375,'2_elementary',105,'ME','comandante','207');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (376,'3_pre-operational',216,'CPL','primer oficial','8');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (377,'3_pre-operational',537,'ATPL','primer oficial','162');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (378,'3_pre-operational',115,'CPL','comandante','136');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (379,'4_operational',97,'ATPL','comandante','134');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (380,'1_pre-elementary',169,'ME','comandante','255');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (381,'6_expert',393,'CPL','comandante','3');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (382,'3_pre-operational',528,'CPL','primer oficial','84');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (383,'6_expert',559,'ME','primer oficial','10');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (384,'4_operational',402,'CPL','primer oficial','256');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (385,'4_operational',496,'ME','comandante','219');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (386,'1_pre-elementary',134,'CPL','primer oficial','276');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (387,'3_pre-operational',325,'ME','comandante','297');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (388,'2_elementary',200,'CPL','comandante','243');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (389,'3_pre-operational',134,'ATPL','comandante','222');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (390,'5_extended',458,'IFR','comandante','9');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (391,'4_operational',378,'ME','comandante','228');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (392,'1_pre-elementary',110,'ME','comandante','167');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (393,'2_elementary',336,'ME','comandante','186');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (394,'1_pre-elementary',233,'CPL','primer oficial','238');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (395,'1_pre-elementary',181,'IFR','primer oficial','55');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (396,'1_pre-elementary',251,'ATPL','comandante','251');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (397,'4_operational',480,'IFR','primer oficial','78');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (398,'6_expert',43,'ATPL','primer oficial','36');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (399,'3_pre-operational',2,'ATPL','primer oficial','114');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (400,'6_expert',295,'CPL','comandante','112');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (401,'3_pre-operational',298,'IFR','comandante','276');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (402,'5_extended',212,'IFR','comandante','74');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (403,'1_pre-elementary',527,'IFR','comandante','114');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (404,'4_operational',262,'IFR','primer oficial','300');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (405,'6_expert',365,'ATPL','comandante','152');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (406,'6_expert',327,'ATPL','primer oficial','288');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (407,'2_elementary',77,'CPL','primer oficial','215');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (408,'5_extended',8,'ME','primer oficial','48');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (409,'3_pre-operational',522,'ME','primer oficial','216');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (410,'4_operational',470,'IFR','primer oficial','244');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (411,'4_operational',479,'CPL','primer oficial','90');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (412,'2_elementary',570,'CPL','comandante','225');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (413,'3_pre-operational',431,'ATPL','primer oficial','17');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (414,'3_pre-operational',169,'IFR','primer oficial','17');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (415,'6_expert',288,'ATPL','primer oficial','288');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (416,'6_expert',479,'IFR','comandante','203');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (417,'1_pre-elementary',292,'ATPL','primer oficial','12');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (418,'3_pre-operational',154,'ATPL','comandante','26');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (419,'4_operational',435,'ME','primer oficial','17');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (420,'1_pre-elementary',45,'IFR','primer oficial','227');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (421,'6_expert',525,'ATPL','comandante','80');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (422,'1_pre-elementary',563,'IFR','primer oficial','185');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (423,'2_elementary',578,'ATPL','primer oficial','80');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (424,'1_pre-elementary',32,'CPL','comandante','62');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (425,'1_pre-elementary',298,'ME','comandante','225');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (426,'6_expert',346,'ATPL','primer oficial','207');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (427,'6_expert',185,'CPL','primer oficial','3');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (428,'6_expert',312,'CPL','comandante','186');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (429,'4_operational',69,'IFR','primer oficial','239');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (430,'4_operational',102,'IFR','comandante','167');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (431,'5_extended',440,'ATPL','comandante','218');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (432,'6_expert',553,'ME','comandante','36');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (433,'6_expert',49,'IFR','comandante','54');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (434,'4_operational',531,'ME','primer oficial','98');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (435,'6_expert',429,'IFR','comandante','118');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (436,'6_expert',161,'ME','primer oficial','134');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (437,'3_pre-operational',169,'ME','comandante','10');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (438,'5_extended',546,'CPL','comandante','284');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (439,'4_operational',367,'ATPL','comandante','117');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (440,'6_expert',547,'IFR','primer oficial','134');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (441,'6_expert',94,'CPL','primer oficial','266');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (442,'1_pre-elementary',240,'ATPL','comandante','58');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (443,'5_extended',49,'ATPL','primer oficial','244');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (444,'3_pre-operational',59,'CPL','primer oficial','228');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (445,'6_expert',7,'ATPL','comandante','289');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (446,'4_operational',486,'IFR','comandante','155');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (447,'2_elementary',285,'IFR','comandante','38');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (448,'5_extended',4,'ME','primer oficial','74');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (449,'2_elementary',385,'ATPL','primer oficial','187');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (450,'1_pre-elementary',322,'IFR','comandante','226');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (451,'5_extended',551,'ATPL','primer oficial','167');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (452,'1_pre-elementary',328,'ATPL','primer oficial','208');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (453,'2_elementary',40,'ME','comandante','288');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (454,'5_extended',526,'IFR','primer oficial','79');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (455,'2_elementary',217,'IFR','comandante','74');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (456,'2_elementary',547,'IFR','primer oficial','42');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (457,'6_expert',472,'ATPL','comandante','73');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (458,'2_elementary',189,'IFR','comandante','78');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (459,'1_pre-elementary',578,'IFR','comandante','263');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (460,'6_expert',489,'ATPL','primer oficial','282');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (461,'1_pre-elementary',265,'ME','comandante','20');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (462,'6_expert',97,'IFR','comandante','197');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (463,'5_extended',422,'CPL','comandante','54');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (464,'2_elementary',600,'IFR','comandante','41');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (465,'3_pre-operational',252,'ATPL','primer oficial','3');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (466,'4_operational',513,'CPL','comandante','17');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (467,'2_elementary',320,'CPL','comandante','148');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (468,'4_operational',441,'ATPL','comandante','98');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (469,'6_expert',366,'CPL','comandante','34');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (470,'2_elementary',91,'ATPL','comandante','24');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (471,'3_pre-operational',487,'IFR','primer oficial','109');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (472,'5_extended',537,'ME','comandante','90');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (473,'5_extended',249,'ME','comandante','278');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (474,'2_elementary',401,'IFR','comandante','234');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (475,'4_operational',138,'ME','comandante','92');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (476,'1_pre-elementary',362,'ATPL','comandante','37');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (477,'4_operational',545,'ATPL','comandante','174');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (478,'5_extended',55,'ME','comandante','128');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (479,'4_operational',230,'ATPL','primer oficial','244');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (480,'2_elementary',226,'ME','primer oficial','12');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (481,'4_operational',240,'ATPL','primer oficial','296');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (482,'6_expert',47,'IFR','primer oficial','10');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (483,'2_elementary',178,'ATPL','primer oficial','71');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (484,'1_pre-elementary',544,'ME','primer oficial','221');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (485,'1_pre-elementary',300,'IFR','primer oficial','179');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (486,'4_operational',116,'CPL','primer oficial','153');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (487,'1_pre-elementary',523,'ATPL','comandante','184');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (488,'4_operational',101,'IFR','primer oficial','73');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (489,'3_pre-operational',503,'IFR','comandante','239');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (490,'3_pre-operational',390,'CPL','primer oficial','222');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (491,'3_pre-operational',96,'ME','comandante','217');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (492,'5_extended',409,'IFR','comandante','112');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (493,'4_operational',145,'ATPL','primer oficial','22');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (494,'4_operational',186,'IFR','comandante','207');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (495,'1_pre-elementary',135,'IFR','comandante','96');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (496,'4_operational',495,'IFR','primer oficial','186');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (497,'2_elementary',316,'IFR','comandante','110');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (498,'5_extended',558,'ME','primer oficial','41');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (499,'2_elementary',562,'CPL','primer oficial','59');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (500,'6_expert',567,'CPL','primer oficial','128');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (501,'5_extended',345,'ATPL','primer oficial','61');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (502,'6_expert',466,'CPL','primer oficial','62');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (503,'6_expert',195,'CPL','comandante','106');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (504,'3_pre-operational',165,'IFR','comandante','24');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (505,'4_operational',594,'IFR','comandante','62');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (506,'2_elementary',430,'ME','comandante','212');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (507,'3_pre-operational',116,'CPL','comandante','216');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (508,'4_operational',247,'CPL','primer oficial','114');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (509,'4_operational',273,'ATPL','comandante','68');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (510,'1_pre-elementary',109,'IFR','primer oficial','225');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (511,'5_extended',203,'ME','primer oficial','226');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (512,'4_operational',588,'CPL','comandante','238');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (513,'6_expert',557,'ATPL','primer oficial','227');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (514,'4_operational',286,'CPL','comandante','42');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (515,'6_expert',438,'ME','comandante','266');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (516,'3_pre-operational',37,'ATPL','comandante','234');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (517,'4_operational',308,'ATPL','primer oficial','106');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (518,'3_pre-operational',365,'CPL','comandante','96');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (519,'6_expert',468,'ATPL','comandante','186');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (520,'1_pre-elementary',446,'IFR','comandante','207');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (521,'2_elementary',280,'IFR','comandante','3');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (522,'3_pre-operational',398,'ME','primer oficial','148');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (523,'5_extended',371,'IFR','comandante','300');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (524,'5_extended',592,'IFR','primer oficial','174');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (525,'5_extended',417,'IFR','comandante','189');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (526,'5_extended',492,'ME','primer oficial','284');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (527,'5_extended',32,'IFR','comandante','209');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (528,'1_pre-elementary',170,'IFR','comandante','186');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (529,'4_operational',337,'ATPL','primer oficial','98');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (530,'4_operational',104,'CPL','primer oficial','221');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (531,'4_operational',60,'ATPL','primer oficial','216');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (532,'2_elementary',500,'ME','comandante','48');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (533,'1_pre-elementary',263,'ME','primer oficial','185');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (534,'6_expert',242,'IFR','comandante','281');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (535,'3_pre-operational',164,'CPL','primer oficial','167');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (536,'5_extended',177,'ME','primer oficial','284');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (537,'4_operational',274,'ME','primer oficial','61');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (538,'2_elementary',533,'ATPL','comandante','96');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (539,'3_pre-operational',378,'ATPL','comandante','106');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (540,'5_extended',177,'ME','comandante','217');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (541,'6_expert',523,'ATPL','primer oficial','74');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (542,'3_pre-operational',437,'CPL','primer oficial','185');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (543,'4_operational',131,'CPL','comandante','243');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (544,'2_elementary',503,'IFR','comandante','73');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (545,'3_pre-operational',304,'ME','comandante','54');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (546,'2_elementary',44,'CPL','primer oficial','82');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (547,'2_elementary',497,'ME','primer oficial','81');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (548,'4_operational',367,'ATPL','comandante','238');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (549,'1_pre-elementary',573,'ME','comandante','8');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (550,'5_extended',488,'IFR','primer oficial','136');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (551,'5_extended',13,'CPL','primer oficial','227');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (552,'4_operational',353,'ME','primer oficial','197');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (553,'4_operational',446,'ME','comandante','207');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (554,'3_pre-operational',547,'ATPL','primer oficial','203');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (555,'6_expert',329,'CPL','comandante','78');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (556,'6_expert',100,'CPL','comandante','224');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (557,'2_elementary',407,'ME','primer oficial','145');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (558,'4_operational',221,'ATPL','comandante','179');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (559,'4_operational',333,'ME','comandante','17');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (560,'5_extended',151,'ATPL','comandante','26');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (561,'1_pre-elementary',294,'ATPL','comandante','158');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (562,'4_operational',43,'ATPL','primer oficial','298');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (563,'1_pre-elementary',498,'IFR','primer oficial','243');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (564,'6_expert',12,'CPL','comandante','33');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (565,'4_operational',82,'ME','primer oficial','112');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (566,'4_operational',2,'CPL','comandante','45');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (567,'5_extended',253,'IFR','comandante','276');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (568,'2_elementary',427,'ATPL','primer oficial','55');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (569,'2_elementary',566,'CPL','comandante','115');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (570,'3_pre-operational',259,'CPL','comandante','251');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (571,'6_expert',139,'CPL','primer oficial','231');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (572,'4_operational',533,'CPL','primer oficial','114');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (573,'4_operational',44,'ME','primer oficial','17');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (574,'5_extended',401,'ME','primer oficial','231');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (575,'5_extended',511,'IFR','primer oficial','113');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (576,'3_pre-operational',266,'ME','comandante','70');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (577,'6_expert',452,'IFR','primer oficial','62');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (578,'6_expert',430,'ME','primer oficial','136');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (579,'6_expert',27,'ATPL','primer oficial','297');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (580,'3_pre-operational',259,'CPL','primer oficial','73');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (581,'6_expert',249,'ATPL','primer oficial','78');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (582,'2_elementary',367,'IFR','primer oficial','134');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (583,'3_pre-operational',193,'ME','primer oficial','45');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (584,'3_pre-operational',105,'ATPL','comandante','3');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (585,'5_extended',415,'IFR','primer oficial','297');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (586,'5_extended',461,'IFR','primer oficial','106');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (587,'4_operational',527,'CPL','primer oficial','167');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (588,'1_pre-elementary',342,'ATPL','primer oficial','139');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (589,'2_elementary',338,'ATPL','comandante','226');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (590,'3_pre-operational',193,'CPL','comandante','53');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (591,'4_operational',554,'CPL','comandante','176');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (592,'4_operational',369,'CPL','comandante','160');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (593,'6_expert',157,'CPL','comandante','231');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (594,'3_pre-operational',351,'CPL','primer oficial','144');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (595,'2_elementary',178,'IFR','comandante','111');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (596,'1_pre-elementary',561,'ME','primer oficial','111');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (597,'6_expert',398,'CPL','comandante','136');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (598,'5_extended',203,'IFR','comandante','80');
INSERT INTO pilotos (id_piloto,nivel_ingles,cantidad_horas_vuelo,tipo_licencia,cargo,id_empleado) VALUES (599,'4_operational',561,'ATPL','primer oficial','215');

select * from ciudades;
update ciudades set nombre_ciudad = 'San luis de tipal' where id_ciudades=4;
--insert  Aeropuertos
INSERT INTO Aeropuertos (id_aeropuerto,nombre,id_ciudades,longitud,latitud,abreviatura_aeropuerto) VALUES (1,'Bogota El Dorado International Airport',16,'89.36074','3.72194','BOG / SKBO');
INSERT INTO Aeropuertos (id_aeropuerto,nombre,id_ciudades,longitud,latitud,abreviatura_aeropuerto) VALUES (2,'Medellin Jose Maria Cordova International Airport',1,'89.36074','3.72194','MDE/SKRG');
INSERT INTO Aeropuertos (id_aeropuerto,nombre,id_ciudades,longitud,latitud,abreviatura_aeropuerto) VALUES (3,'Cali Alfonso Bonilla Aragon International Airport',2,'-73.33696','-23.22709','CLO / SKCL');
INSERT INTO Aeropuertos (id_aeropuerto,nombre,id_ciudades,longitud,latitud,abreviatura_aeropuerto) VALUES (4,'Cartagena Rafael Nunez International Airport',3,'-157.13658','24.65761','CTG / SKCG');
INSERT INTO Aeropuertos (id_aeropuerto,nombre,id_ciudades,longitud,latitud,abreviatura_aeropuerto) VALUES (5,'Lima Jorge Chavez International Airport',5,'59.22591','-17.11493','LIM / SPJC');
INSERT INTO Aeropuertos (id_aeropuerto,nombre,id_ciudades,longitud,latitud,abreviatura_aeropuerto) VALUES (6,'San Salvador International Airport',4,'29.84196','9.61549','SAL / MSLP');
INSERT INTO Aeropuertos (id_aeropuerto,nombre,id_ciudades,longitud,latitud,abreviatura_aeropuerto) VALUES (7,'Madrid Barajas Airport',6,'5.97211','85.31284','MAD / LEMD');
INSERT INTO Aeropuertos (id_aeropuerto,nombre,id_ciudades,longitud,latitud,abreviatura_aeropuerto) VALUES (8,'Miami International Airport',7,'145.03556','-55.15572','MIA / KMIA');
INSERT INTO Aeropuertos (id_aeropuerto,nombre,id_ciudades,longitud,latitud,abreviatura_aeropuerto) VALUES (9,'New York John F. Kennedy International Airport',8,'36.71771','28.83056','JFK / KJFK');

--insertar rutas
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (200,4,1,74578,243);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (201,5,4,52754,119);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (202,2,7,2859,273);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (203,9,2,66136,155);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (204,8,6,2596,113);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (205,8,1,14510,72);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (206,4,2,79045,253);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (207,9,7,3732,278);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (208,1,8,60741,250);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (209,4,6,32366,66);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (210,6,5,11644,297);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (211,1,9,42787,187);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (212,9,7,61296,103);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (213,4,6,25304,297);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (214,5,5,71716,177);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (215,2,4,45109,26);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (216,4,9,63890,209);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (217,4,3,19465,246);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (218,4,1,51175,273);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (219,3,1,34989,256);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (220,3,5,22036,164);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (221,6,9,23360,292);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (222,7,1,48275,150);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (223,6,4,72078,110);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (224,3,1,24143,300);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (225,9,4,30779,202);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (226,3,2,63817,236);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (227,1,1,62090,33);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (228,5,7,47360,110);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (229,5,4,46456,289);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (230,8,1,4062,215);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (231,2,2,70773,80);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (232,6,8,51361,237);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (233,5,8,26564,236);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (234,3,4,31561,151);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (235,1,9,41976,106);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (236,1,1,15792,185);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (237,9,5,46261,163);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (238,8,1,9072,56);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (239,7,4,32160,55);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (240,5,2,27642,47);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (241,2,8,62075,102);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (242,6,7,28427,261);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (243,2,3,34736,217);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (244,9,8,1339,227);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (245,8,2,38545,91);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (246,3,7,53736,39);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (247,9,9,40386,252);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (248,6,9,56242,217);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (249,5,5,10882,178);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (250,6,1,66991,139);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (251,3,2,6919,196);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (252,6,1,23373,181);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (253,9,8,28702,212);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (254,7,2,61765,88);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (255,6,3,14566,96);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (256,6,8,70051,23);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (257,6,9,22482,128);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (258,1,4,47812,79);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (259,6,5,52919,197);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (260,3,4,23314,293);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (261,5,8,56546,220);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (262,1,9,75452,60);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (263,8,4,60732,190);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (264,7,1,34686,236);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (265,9,8,21548,61);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (266,4,9,9945,157);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (267,3,9,5479,234);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (268,1,1,62616,148);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (269,8,9,4336,181);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (270,3,5,51219,254);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (271,8,7,42580,44);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (272,9,6,69763,217);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (273,9,7,77045,94);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (274,3,2,79569,247);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (275,4,4,64030,200);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (276,9,9,11912,288);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (277,2,2,45925,182);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (278,4,1,64985,47);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (279,3,2,30540,248);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (280,1,5,39961,241);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (281,1,4,61597,40);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (282,5,2,31454,101);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (283,9,3,44163,94);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (284,2,6,40019,224);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (285,4,6,16744,291);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (286,3,6,40919,300);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (287,7,6,19194,47);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (288,9,6,51397,20);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (289,4,3,49798,202);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (290,5,8,6442,162);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (291,3,3,50214,116);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (292,6,7,51631,125);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (293,9,4,54307,87);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (294,3,5,29415,284);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (295,9,9,75130,75);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (296,9,4,20491,74);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (297,8,3,77390,275);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (298,9,5,30174,101);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (299,6,1,60709,93);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (300,8,6,73065,250);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (301,1,8,65220,246);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (302,9,6,26586,135);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (303,6,3,24610,150);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (304,3,4,40918,287);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (305,2,3,58291,206);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (306,2,4,77076,184);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (307,1,9,17787,193);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (308,1,6,33543,42);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (309,1,1,51200,293);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (310,5,8,33987,275);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (311,3,1,18563,195);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (312,5,2,26909,223);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (313,4,9,36986,95);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (314,8,6,31167,89);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (315,1,5,67499,237);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (316,1,1,30478,143);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (317,5,1,47919,154);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (318,8,5,42838,103);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (319,9,5,25963,134);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (320,7,9,1587,244);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (321,8,1,58600,53);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (322,9,2,31956,92);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (323,8,9,78735,199);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (324,8,1,56067,214);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (325,5,3,16588,251);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (326,9,3,46406,104);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (327,7,5,77351,215);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (328,9,1,15543,107);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (329,3,7,15415,174);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (330,4,1,18279,96);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (331,8,7,50213,249);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (332,5,2,76372,173);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (333,1,6,71801,199);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (334,6,9,3402,291);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (335,4,7,41123,238);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (336,4,1,48744,298);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (337,3,8,2465,91);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (338,2,9,32264,30);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (339,8,2,74114,51);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (340,9,2,38025,100);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (341,8,9,69816,244);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (342,3,6,30659,273);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (343,9,9,66043,85);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (344,9,2,49479,131);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (345,1,5,16354,198);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (346,2,8,46975,55);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (347,2,1,45214,78);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (348,2,6,14810,161);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (349,3,8,8889,34);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (350,8,8,70533,173);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (351,2,8,37193,164);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (352,7,9,22259,195);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (353,6,4,66489,102);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (354,8,1,56108,230);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (355,2,1,33721,80);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (356,8,6,11546,228);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (357,1,1,347,21);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (358,7,5,29119,55);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (359,2,2,63845,99);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (360,3,2,56707,280);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (361,4,4,30283,136);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (362,6,5,9300,157);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (363,4,5,67670,136);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (364,2,6,17697,228);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (365,4,1,60762,298);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (366,2,6,60134,132);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (367,5,1,53391,220);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (368,9,6,24484,278);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (369,3,3,66123,27);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (370,7,4,50870,58);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (371,2,5,72174,248);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (372,7,4,29720,49);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (373,8,7,41313,297);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (374,8,4,62669,133);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (375,7,4,16274,150);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (376,1,1,8110,142);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (377,4,5,46185,77);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (378,1,3,54216,126);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (379,3,4,76968,193);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (380,7,8,6871,205);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (381,1,4,44369,24);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (382,5,5,20093,184);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (383,5,9,2629,139);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (384,6,2,59682,299);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (385,6,1,10401,52);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (386,3,3,66990,149);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (387,3,5,68506,233);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (388,1,6,10945,31);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (389,2,1,59233,24);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (390,5,9,1577,158);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (391,9,4,18197,202);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (392,5,5,48893,74);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (393,4,2,29557,197);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (394,5,5,10927,219);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (395,4,2,17901,60);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (396,1,6,65552,261);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (397,5,5,49997,211);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (398,5,2,12137,222);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (399,7,9,70648,81);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (400,3,9,6475,277);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (401,9,4,25157,169);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (402,1,2,6153,135);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (403,7,6,69561,228);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (404,1,8,13077,232);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (405,1,4,32545,182);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (406,2,1,18348,47);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (407,3,2,34502,90);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (408,6,5,33743,112);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (409,3,3,37455,186);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (410,5,9,57264,22);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (411,5,5,40813,155);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (412,6,1,40403,54);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (413,9,8,11906,186);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (414,7,9,54184,241);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (415,6,1,42912,227);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (416,1,9,46189,232);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (417,6,4,16492,176);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (418,3,6,29680,124);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (419,4,3,5137,30);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (420,6,3,263,268);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (421,6,3,15212,251);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (422,4,5,29459,282);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (423,3,9,73284,226);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (424,9,5,4688,137);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (425,5,7,73076,266);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (426,4,8,6108,129);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (427,7,7,67964,37);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (428,6,9,18484,87);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (429,8,1,31393,38);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (430,3,6,78375,170);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (431,8,5,79468,253);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (432,8,9,77333,277);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (433,4,7,67106,42);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (434,4,2,68053,281);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (435,3,3,54865,50);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (436,1,8,63559,176);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (437,1,9,28793,107);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (438,1,7,64159,95);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (439,2,8,61696,204);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (440,1,8,62645,39);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (441,5,1,19805,273);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (442,9,7,41107,146);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (443,4,8,24020,96);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (444,4,9,27591,251);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (445,5,3,79633,231);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (446,3,3,45215,210);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (447,9,8,46881,68);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (448,5,3,44527,49);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (449,1,6,74094,55);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (450,1,3,32559,104);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (451,6,8,45354,174);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (452,5,7,71959,134);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (453,4,7,11806,78);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (454,1,6,28754,244);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (455,5,6,45996,251);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (456,1,5,1340,120);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (457,8,7,59878,237);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (458,3,6,1842,254);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (459,9,9,19201,118);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (460,5,7,78924,76);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (461,5,7,79669,111);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (462,6,7,61076,94);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (463,8,3,50871,277);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (464,3,2,35967,113);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (465,4,4,78180,63);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (466,8,4,30658,111);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (467,2,5,19222,246);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (468,5,8,66828,46);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (469,6,7,61086,165);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (470,2,1,29821,259);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (471,3,5,18670,78);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (472,5,1,38713,144);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (473,5,2,13740,62);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (474,5,4,19564,25);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (475,7,7,48177,141);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (476,7,2,37419,162);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (477,2,5,15574,269);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (478,7,5,78999,253);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (479,3,2,62911,267);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (480,6,4,28815,285);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (481,6,7,33229,205);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (482,5,7,46794,98);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (483,4,7,26191,60);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (484,6,4,37586,140);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (485,5,3,74081,193);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (486,6,1,14835,117);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (487,3,7,71930,178);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (488,8,3,28682,44);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (489,3,4,25319,265);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (490,5,2,62800,270);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (491,9,7,26381,277);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (492,2,4,13692,56);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (493,1,7,14031,71);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (494,7,2,62784,268);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (495,9,3,549,290);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (496,3,6,16451,214);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (497,9,3,9989,40);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (498,4,7,57786,88);
INSERT INTO rutas (id_ruta,id_aeropuerto_origen,id_aeropuerto_destino,distancia_kilometro,cantidad_promedio) VALUES (499,3,6,50552,240);

--insert aviones
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (1,'N764AV','7887','Airbus A320-251N','Brand new',12,138,'vuelo',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (2,'N765AV','7928','Airbus A320-251N','Brand new',12,138,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (3,'N766AV','8096','Airbus A320-251N','Brand new',12,138,'reparacion',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (4,'PR-OBD','7175','Airbus A320-251N','1 year',12,138,'reparacion',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (5,'PR-OBF','7323','Airbus A320-251N','1 year',12,138,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (6,'PR-OBH','7484','Airbus A320-251N','1 year',12,138,'mantenimiento',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (7,'PR-OBI','7514','Airbus A320-251N','1 year',12,138,'vuelo',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (8,'PR-OBJ','7698','Airbus A320-251N','Brand new',12,138,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (9,'PR-OBK','7799','Airbus A320-251N','Brand new',12,138,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (10,'PR-OBL','7854','Airbus A320-251N','Brand new',12,138,'vuelo',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (11,'PR-OBM','7856','Airbus A320-251N','Brand new',12,138,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (12,'PR-OBO','7995','Airbus A320-251N','Brand new',12,138,'mantenimiento',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (13,'N759AV','7770','Airbus A321-253N','Brand new',12,182,'tierra',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (14,'N761AV','7847','Airbus A321-253N','Brand new',12,182,'vuelo',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (15,'N589AV','2575','12 years','Airbus A318-111',12,88,'vuelo',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (16,'N590EL','2328','13 years','Airbus A318-111',12,88,'vuelo',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (17,'N591EL','2333','13 years','Airbus A318-111',12,88,'tierra',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (18,'N592EL','2358','13 years','Airbus A318-111',12,88,'tierra',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (19,'N593EL','2367','13 years','Airbus A318-111',12,88,'mantenimiento',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (20,'N594EL','2377','13 years','Airbus A318-111',12,88,'tierra',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (21,'N595EL','2394','13 years','Airbus A318-111',12,88,'reparacion',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (22,'N596EL','2523','12 years','Airbus A318-111',12,88,'mantenimiento',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (23,'N597EL','2544','12 years','Airbus A318-111',12,88,'tierra',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (24,'N598EL','2552','12 years','Airbus A318-111',12,88,'vuelo',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (25,'PR-AVJ','3030','10 years','Airbus A318-122',12,88,'reparacion',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (26,'PR-AVL','3214','10 years','Airbus A318-122',12,88,'tierra',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (27,'PR-ONC','3371','10 years','Airbus A318-122',12,88,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (28,'PR-OND','3390','10 years','Airbus A318-122',12,88,'reparacion',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (29,'PR-ONI','3509','9 years','Airbus A318-122',12,88,'tierra',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (30,'PR-ONO','3602','9 years','Airbus A318-122',12,88,'mantenimiento',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (31,'PR-ONR','3642','9 years','Airbus A318-122',12,88,'tierra',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (32,'HC-CKN','1882','15 years','Airbus A319-112',12,108,'vuelo',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (33,'HC-CLF','2078','14 years','Airbus A319-112',12,108,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (34,'HC-CSA','3518','9 years','Airbus A319-115',12,108,'mantenimiento',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (35,'HC-CSB','3467','9 years','Airbus A319-115',12,108,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (36,'N422AV','4200','8 years','Airbus A319-115',12,108,'tierra',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (37,'N478TA','2339','13 years','Airbus A319-132',12,108,'tierra',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (38,'N479TA','2444','12 years','Airbus A319-132',12,108,'tierra',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (39,'N480TA','3057','11 years','Airbus A319-132',12,108,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (40,'N519AV','5119','5 years','Airbus A319-115',12,108,'tierra',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (41,'N520TA','3248','10 years','Airbus A319-132',12,108,'tierra',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (42,'N521TA','3276','10 years','Airbus A319-132',12,108,'reparacion',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (43,'N522TA','5219','5 years','Airbus A319-132',12,108,'vuelo',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (44,'N524TA','5280','5 years','Airbus A319-112',12,108,'vuelo',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (45,'N557AV','5057','6 years','Airbus A319-115',12,108,'vuelo',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (46,'N647AV','3647','9 years','Airbus A319-115',12,108,'mantenimiento',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (47,'N690AV','5944','4 years','Airbus A319-132',12,108,'tierra',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (48,'N691AV','3691','9 years','Airbus A319-115',12,108,'reparacion',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (49,'N694AV','6068','3 years','Airbus A319-132',12,108,'tierra',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (50,'N695AV','6099','3 years','Airbus A319-132',12,108,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (51,'N703AV','5406','5 years','Airbus A319-132',12,108,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (52,'N723AV','6167','3 years','Airbus A319-115',12,108,'reparacion',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (53,'N726AV','6174','3 years','Airbus A319-115',12,108,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (54,'N730AV','6132','3 years','Airbus A319-132',12,108,'vuelo',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (55,'N741AV','6617','2 years','Airbus A319-115',12,108,'vuelo',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (56,'N751AV','7284','1 year','Airbus A319-115',12,108,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (57,'N753AV','7318','1 year','Airbus A319-115',12,108,'reparacion',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (58,'PR-AVB','4222','8 years','Airbus A319-115',12,108,'reparacion',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (59,'PR-AVC','4287','7 years','Airbus A319-115',12,108,'mantenimiento',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (60,'PR-AVD','4336','7 years','Airbus A319-115',12,108,'tierra',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (61,'PR-ONJ','5193','5 years','Airbus A319-115',12,108,'mantenimiento',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (62,'HC-CJM','4379','7 years','Airbus A320-214',12,138,'tierra',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (63,'HC-CJV','4547','7 years','Airbus A320-214',12,138,'mantenimiento',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (64,'HC-CJW','4487','7 years','Airbus A320-214',12,138,'reparacion',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (65,'HC-CRU','3408','10 years','Airbus A320-214',12,138,'reparacion',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (66,'HC-CSF','4100','8 years','Airbus A320-214',12,138,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (67,'HC-CTR','4599','7 years','Airbus A320-214',12,138,'mantenimiento',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (68,'N195AV','5195','5 years','Airbus A320-214',12,138,'tierra',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (69,'N281AV','4281','7 years','Airbus A320-214',12,138,'vuelo',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (70,'N284AV','4284','7 years','Airbus A320-214',12,138,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (71,'N345AV','4345','7 years','Airbus A320-214',12,138,'tierra',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (72,'N398AV','3988','8 years','Airbus A320-214',12,138,'tierra',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (73,'N401AV','4001','8 years','Airbus A320-214',12,138,'mantenimiento',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (74,'N411AV','4011','8 years','Airbus A320-214',12,138,'reparacion',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (75,'N416AV','4167','8 years','Airbus A320-214',12,138,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (76,'N426AV','4026','8 years','Airbus A320-214',12,138,'reparacion',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (77,'N446AV','4046','8 years','Airbus A320-214',12,138,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (78,'N451AV','4051','8 years','Airbus A320-214',12,138,'tierra',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (79,'N454AV','5454','5 years','Airbus A320-214',12,138,'reparacion',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (80,'N477AV','5477','5 years','Airbus A320-214',12,138,'vuelo',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (81,'N481AV','4381','7 years','Airbus A320-214',12,138,'vuelo',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (82,'N490TA','2282','13 years','Airbus A320-233',12,138,'mantenimiento',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (83,'N491TA','2301','13 years','Airbus A320-233',12,138,'mantenimiento',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (84,'N492TA','2434','12 years','Airbus A320-233',12,138,'reparacion',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (85,'N493TA','2917','11 years','Airbus A320-233',12,138,'vuelo',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (86,'N494TA','3042','11 years','Airbus A320-233',12,138,'mantenimiento',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (87,'N495TA','3103','10 years','Airbus A320-233',12,138,'vuelo',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (88,'N496TA','3113','10 years','Airbus A320-233',12,138,'reparacion',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (89,'N497TA','3378','10 years','Airbus A320-233',12,138,'reparacion',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (90,'N498TA','3418','10 years','Airbus A320-233',12,138,'mantenimiento',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (91,'N499TA','3510','9 years','Airbus A320-233',12,138,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (92,'N536AV','5360','5 years','Airbus A320-214',12,138,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (93,'N538AV','5398','5 years','Airbus A320-214',12,138,'tierra',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (94,'N562AV','5622','4 years','Airbus A320-214',12,138,'vuelo',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (95,'N567AV','4567','7 years','Airbus A320-214',12,138,'mantenimiento',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (96,'N603AV','5840','4 years','Airbus A320-233',12,138,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (97,'N632AV','5632','4 years','Airbus A320-214',12,138,'reparacion',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (98,'N664AV','3664','9 years','Airbus A320-214',12,138,'tierra',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (99,'N680TA','3538','9 years','Airbus A320-233',12,138,'mantenimiento',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (100,'N683TA','4906','6 years','Airbus A320-233',12,138,'reparacion',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (101,'N684TA','4944','6 years','Airbus A320-233',12,138,'reparacion',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (102,'N685TA','5068','6 years','Airbus A320-233',12,138,'tierra',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (103,'N686TA','5238','5 years','Airbus A320-214',12,138,'reparacion',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (104,'N687TA','1334','17 years','Airbus A320-233',12,138,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (105,'N688TA','5243','5 years','Airbus A320-214',12,138,'vuelo',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (106,'N689TA','5333','5 years','Airbus A320-214',12,138,'vuelo',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (107,'N724AV','6153','3 years','Airbus A320-214',12,138,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (108,'N728AV','6209','3 years','Airbus A320-214',12,138,'tierra',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (109,'N740AV','6411','3 years','Airbus A320-214',12,138,'reparacion',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (110,'N742AV','6692','2 years','Airbus A320-214',12,138,'vuelo',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (111,'N743AV','6739','2 years','Airbus A320-214',12,138,'vuelo',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (112,'N745AV','6746','2 years','Airbus A320-214',12,138,'mantenimiento',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (113,'N748AV','6862','2 years','Airbus A320-214',12,138,'vuelo',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (114,'N750AV','7120','1 year','Airbus A320-214',12,138,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (115,'N755AV','7437','1 year','Airbus A320-214',12,138,'mantenimiento',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (116,'N763AV','4763','6 years','Airbus A320-214',12,138,'vuelo',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (117,'N789AV','4789','6 years','Airbus A320-214',12,138,'reparacion',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (118,'N821AV','4821','6 years','Airbus A320-214',12,138,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (119,'N862AV','4862','6 years','Airbus A320-214',12,138,'reparacion',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (120,'N939AV','4939','6 years','Airbus A320-214',12,138,'tierra',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (121,'N961AV','3961','8 years','Airbus A320-214',12,138,'vuelo',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (122,'N980AV','3980','8 years','Airbus A320-214',12,138,'mantenimiento',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (123,'N992AV','3992','8 years','Airbus A320-214',12,138,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (124,'PR-AVP','4891','6 years','Airbus A320-214',12,138,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (125,'PR-AVQ','4913','6 years','Airbus A320-214',12,138,'mantenimiento',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (126,'PR-AVR','4941','6 years','Airbus A320-214',12,138,'tierra',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (127,'PR-AVU','4942','6 years','Airbus A320-214',12,138,'vuelo',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (128,'PR-OBB','6876','2 years','Airbus A320-214',12,138,'mantenimiento',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (129,'PR-OCA','6125','3 years','Airbus A320-214',12,138,'reparacion',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (130,'PR-OCB','6139','3 years','Airbus A320-214',12,138,'reparacion',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (131,'PR-OCD','6173','3 years','Airbus A320-214',12,138,'tierra',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (132,'PR-OCH','6528','3 years','Airbus A320-214',12,138,'mantenimiento',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (133,'PR-OCI','6536','2 years','Airbus A320-214',12,138,'reparacion',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (134,'PR-OCM','6561','2 years','Airbus A320-214',12,138,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (135,'PR-OCN','6598','2 years','Airbus A320-214',12,138,'tierra',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (136,'PR-OCO','6634','2 years','Airbus A320-214',12,138,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (137,'PR-OCP','6651','2 years','Airbus A320-214',12,138,'mantenimiento',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (138,'PR-OCQ','6689','2 years','Airbus A320-214',12,138,'mantenimiento',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (139,'PR-OCR','1450','2 years','Airbus A320-214',12,138,'reparacion',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (140,'PR-OCT','6800','2 years','Airbus A320-214',12,138,'tierra',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (141,'PR-OCV','6806','2 years','Airbus A320-214',12,138,'reparacion',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (142,'PR-OCW','6813','2 years','Airbus A320-214',12,138,'reparacion',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (143,'PR-OCY','6871','2 years','Airbus A320-214',12,138,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (144,'PR-ONK','5278','5 years','Airbus A320-214',12,138,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (145,'PR-ONL','5299','5 years','Airbus A320-214',12,138,'mantenimiento',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (146,'PR-ONS','5754','4 years','Airbus A320-214',12,138,'mantenimiento',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (147,'PR-ONT','5841','4 years','Airbus A320-214',12,138,'tierra',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (148,'PR-ONW','6050','3 years','Airbus A320-214',12,138,'tierra',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (149,'PR-ONX','6057','3 years','Airbus A320-214',12,138,'mantenimiento',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (150,'PR-ONY','6103','3 years','Airbus A320-214',12,138,'mantenimiento',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (151,'PR-ONZ','6110','3 years','Airbus A320-214',12,138,'mantenimiento',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (152,'N568TA','2687','12 years','Airbus A321-231',12,182,'vuelo',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (153,'N570TA','3869','8 years','Airbus A321-231',12,182,'tierra',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (154,'N692AV','5936','4 years','Airbus A321-231',12,182,'mantenimiento',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (155,'N693AV','6002','4 years','Airbus A321-231',12,182,'mantenimiento',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (156,'N696AV','6128','3 years','Airbus A321-231',12,182,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (157,'N697AV','6190','3 years','Airbus A321-231',12,182,'vuelo',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (158,'N725AV','6219','3 years','Airbus A321-231',12,182,'tierra',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (159,'N729AV','6399','3 years','Airbus A321-231',12,182,'tierra',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (160,'N744AV','6767','2 years','Airbus A321-211',12,182,'tierra',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (161,'N746AV','6511','2 years','Airbus A321-211',12,182,'tierra',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (162,'N747AV','6861','2 years','Airbus A321-231',12,182,'reparacion',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (163,'N805AV','6009','4 years','Airbus A321-231',12,182,'tierra',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (164,'N810AV','6294','3 years','Airbus A321-231',12,182,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (165,'N279AV','1279','6 years','Airbus A330-243',30,222,'vuelo',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (166,'N280AV','1400','5 years','Airbus A330-243',30,222,'mantenimiento',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (167,'N342AV','1342','5 years','Airbus A330-243',30,222,'reparacion',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (168,'N968AV','1009','8 years','Airbus A330-243',30,222,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (169,'N969AV','1016','8 years','Airbus A330-243',30,222,'reparacion',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (170,'N973AV','1073','8 years','Airbus A330-243',30,222,'mantenimiento',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (171,'N974AV','1208','7 years','Airbus A330-243',30,222,'mantenimiento',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (172,'N975AV','1224','6 years','Airbus A330-243',30,222,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (173,'PR-OCG','1608','2 years','Airbus A330-243',30,222,'reparacion',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (174,'PR-OCJ','1492','3 years','Airbus A330-243',30,222,'tierra',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (175,'PR-OCK','1508','3 years','Airbus A330-243',30,222,'mantenimiento',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (176,'PR-OCX','1657','2 years','Airbus A330-243',30,222,'mantenimiento',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (177,'N803AV','1357','5 years','Airbus A330-343',30,222,'tierra',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (178,'N804AV','1378','5 years','Airbus A330-343',30,222,'reparacion',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (179,'N279AV','1279','6 years','Airbus A330-243',30,222,'mantenimiento',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (180,'N280AV','1400','5 years','Airbus A330-243',30,222,'mantenimiento',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (181,'N342AV','1342','5 years','Airbus A330-243',30,222,'tierra',1);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (182,'N968AV','1009','8 years','Airbus A330-243',30,222,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (183,'N969AV','1016','8 years','Airbus A330-243',30,222,'tierra',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (184,'N973AV','1073','8 years','Airbus A330-243',30,222,'tierra',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (185,'N974AV','1208','7 years','Airbus A330-243',30,222,'tierra',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (186,'N975AV','1224','6 years','Airbus A330-243',30,222,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (187,'PR-OCG','1608','2 years','Airbus A330-243',30,222,'tierra',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (188,'PR-OCJ','1492','3 years','Airbus A330-243',30,222,'vuelo',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (189,'PR-OCK','1508','3 years','Airbus A330-243',30,222,'mantenimiento',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (190,'PR-OCX','1657','2 years','Airbus A330-243',30,222,'vuelo',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (191,'N974AV','1208','7 years','Airbus A330-243',30,222,'mantenimiento',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (192,'N975AV','1224','6 years','Airbus A330-243',30,222,'mantenimiento',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (193,'PR-OCG','1608','2 years','Airbus A330-243',30,222,'reparacion',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (194,'PR-OCJ','1492','3 years','Airbus A330-243',30,222,'reparacion',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (195,'PR-OCK','1508','3 years','Airbus A330-243',30,222,'vuelo',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (196,'PR-OCX','1657','2 years','Airbus A330-243',30,222,'vuelo',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (197,'N780AV','37502','3 years','Boeing 787-8 Dreamliner',28,222,'reparacion',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (198,'N781AV','37503','3 years','Boeing 787-8 Dreamliner',28,222,'vuelo',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (199,'N782AV','37504','3 years','Boeing 787-8 Dreamliner',28,222,'reparacion',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (200,'N783AV','37505','3 years','Boeing 787-8 Dreamliner',28,222,'vuelo',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (201,'N784AV','37506','2 years','Boeing 787-8 Dreamliner',28,222,'tierra',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (202,'N785AV','37507','2 years','Boeing 787-8 Dreamliner',28,222,'mantenimiento',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (203,'N786AV','37508','2 years','Boeing 787-8 Dreamliner',28,222,'tierra',3);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (204,'N791AV','37509','1 year','Boeing 787-8 Dreamliner',28,222,'vuelo',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (205,'N792AV','37510','1 year','Boeing 787-8 Dreamliner',28,222,'reparacion',6);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (206,'N793AV','37511','1 year','Boeing 787-8 Dreamliner',28,222,'vuelo',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (207,'N794AV','39406','1 year','Boeing 787-8 Dreamliner',28,222,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (208,'N795AV','39407','Brand new','Boeing 787-8 Dreamliner',28,222,'mantenimiento',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (209,'N935TA','19000205','9 years','Embraer ERJ-190AR',8,88,'vuelo',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (210,'N936TA','19000215','9 years','Embraer ERJ-190AR',8,88,'vuelo',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (211,'N937TA','19000221','9 years','Embraer ERJ-190AR',8,88,'vuelo',5);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (212,'N938TA','19000228','9 years','Embraer ERJ-190AR',8,88,'vuelo',4);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (213,'N982TA','19000259','9 years','Embraer ERJ-190AR',8,88,'reparacion',2);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (214,'N983TA','19000265','9 years','Embraer ERJ-190AR',8,88,'reparacion',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (215,'N987TA','19000393','8 years','Embraer ERJ-190AR',8,88,'reparacion',8);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (216,'N988TA','19000399','8 years','Embraer ERJ-190AR',8,88,'vuelo',9);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (217,'N989TA','19000482','7 years','Embraer ERJ-190AR',8,88,'mantenimiento',7);
INSERT INTO aviones (id_avion,registration,serial_number,age,aircraft_type,bussiness_seats,economy_seats,estado,id_aeropuerto) VALUES (218,'TI-BCG','19000215','10 years','Embraer ERJ-190AR',8,88,'reparacion',3);


--insert pasajeros
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (1,'Colette','Puckett',5475240,3120055008,'sem.egestas.blandit@Donectempuslorem.com',6);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (2,'Brian','Caldwell',3479992,3026414796,'non.enim@perinceptos.ca',3);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (3,'Hiram','Williamson',4925659,3156122238,'a@quisaccumsanconvallis.org',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (4,'Mercedes','Craig',3965514,3070080939,'vel.nisl@elit.co.uk',1);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (5,'John','Parrish',4952819,3094460278,'risus@Fuscefermentum.org',15);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (6,'Kameko','Compton',4904836,3070602273,'leo.Morbi@iaculisodio.org',11);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (7,'Nevada','Knight',5221424,3099649375,'interdum.enim.non@aliquetProin.ca',6);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (8,'Plato','Estrada',5023153,3124911025,'iaculis.odio@metusfacilisislorem.org',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (9,'Walker','Hoffman',4220026,3047348241,'mi.Aliquam.gravida@diamDuismi.com',6);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (10,'Mara','House',3688478,3160750912,'consequat@vitaerisusDuis.ca',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (11,'Joel','Jordan',3205055,3148395945,'Nullam@lectus.net',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (12,'Colette','Rich',3444737,3174596434,'arcu.Sed.eu@egestas.org',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (13,'Liberty','Hester',4025666,3044270082,'aliquet.Proin@Sedet.co.uk',1);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (14,'Renee','Maynard',5008584,3203188461,'molestie.tellus.Aenean@malesuada.ca',8);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (15,'Mannix','Wells',4796834,3027187250,'elit@nequetellusimperdiet.co.uk',5);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (16,'Regina','Chaney',5212177,3076443040,'sit.amet.risus@eu.ca',14);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (17,'Madeson','Pickett',4921445,3106400367,'Donec.egestas@diamnunc.ca',8);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (18,'Haley','Alvarado',5166522,3107574866,'Integer.vitae@orcisemeget.edu',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (19,'Jolene','Shields',5631527,3170874315,'facilisis.non.bibendum@liberolacusvarius.co.uk',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (20,'Brenden','Roy',2815290,3139080983,'libero.Proin@dictumplacerat.org',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (21,'Latifah','Stewart',5498979,3205608345,'Pellentesque.habitant@imperdieterat.edu',13);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (22,'Leslie','Hogan',5425069,3022100129,'commodo.tincidunt.nibh@est.net',1);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (23,'Ariana','Holcomb',2623948,3202524644,'consequat.purus.Maecenas@erat.net',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (24,'Quemby','Manning',5233422,3120660431,'Pellentesque.ut.ipsum@tristiqueneque.org',8);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (25,'Melissa','Kerr',2514223,3163674758,'justo.nec@elit.net',5);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (26,'Lucian','Steele',3705508,3190775271,'turpis.vitae@Aliquam.co.uk',5);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (27,'Merrill','Schroeder',5480300,3068394605,'Nunc.pulvinar@tempor.org',5);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (28,'Velma','Gonzales',4846901,3095986693,'Suspendisse.tristique.neque@eu.co.uk',11);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (29,'Dylan','Vasquez',4741427,3136168108,'metus@arcuVestibulumut.com',3);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (30,'Rebecca','Beasley',3623786,3122912000,'dolor@utipsum.ca',8);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (31,'Daniel','Barnett',3630094,3092338267,'in@magnaPhasellusdolor.com',13);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (32,'Lisandra','Manning',3486923,3201202810,'eu.ligula.Aenean@vitaeorci.org',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (33,'Hollee','Aguirre',4095638,3024062225,'erat.volutpat.Nulla@feugiatSednec.org',11);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (34,'Idona','Stanley',2960808,3081338308,'eget.volutpat.ornare@interdumfeugiatSed.co.uk',4);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (35,'Hilary','Mccray',2940729,3168210603,'ac@in.co.uk',14);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (36,'Tanisha','Hammond',4965996,3075922934,'mollis@amet.co.uk',14);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (37,'Timothy','Colon',4689883,3178844600,'Integer.aliquam@insodaleselit.co.uk',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (38,'Zeph','Salinas',5704444,3051468130,'Nullam@Donec.edu',8);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (39,'Drew','Nielsen',5658803,3005086152,'euismod@imperdietullamcorperDuis.com',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (40,'Hedy','Manning',5506475,3155446854,'magna@ornareplacerat.edu',3);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (41,'Mari','Saunders',3107379,3075531254,'Integer.sem.elit@posuerevulputate.co.uk',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (42,'Quentin','Rose',2532602,3015094797,'ipsum.dolor.sit@massaVestibulumaccumsan.org',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (43,'Reese','Mcleod',3711136,3189533480,'facilisis@consequatauctor.co.uk',14);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (44,'Damian','Vaughn',4060238,3197860973,'imperdiet.dictum.magna@tellus.net',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (45,'Len','Hatfield',3098315,3093321673,'eu.elit@est.edu',2);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (46,'Jane','Rosa',5678620,3088001561,'nulla.Integer.vulputate@Aenean.net',1);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (47,'Gregory','Jimenez',4654639,3094706427,'sed.dui@vel.co.uk',6);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (48,'Leilani','Stafford',4480003,3074050691,'ipsum.Curabitur@a.org',2);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (49,'Halee','Hyde',4196143,3058864810,'egestas.Aliquam@quisdiam.co.uk',11);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (50,'Elvis','Obrien',5022756,3205336232,'sagittis@eu.edu',1);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (51,'Winter','Kline',5078022,3045012731,'ac.ipsum@eleifend.co.uk',12);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (52,'Amery','Knight',5565254,3077039809,'Proin@quis.org',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (53,'Tasha','Herman',2944543,3066248963,'orci.lacus@sem.com',6);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (54,'Hayes','Salas',2690875,3208281065,'pede.Praesent.eu@elita.edu',12);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (55,'Yetta','Bird',2936758,3034524133,'cursus.Nunc@magna.net',6);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (56,'Quin','Woodard',4240978,3051242712,'imperdiet.erat.nonummy@nonnisi.edu',12);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (57,'Dexter','Galloway',5663558,3078532751,'aliquam.eros@enim.co.uk',4);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (58,'Cadman','Shepherd',2518740,3198346647,'id.sapien.Cras@lobortisauguescelerisque.com',4);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (59,'Samson','Sheppard',3847252,3209347091,'adipiscing.ligula.Aenean@dolor.ca',7);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (60,'Ryan','Gray',3264715,3026705196,'placerat.Cras@egetipsumDonec.co.uk',12);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (61,'Aline','Ramsey',2970450,3071475897,'sagittis.lobortis.mauris@Nuncsollicitudin.org',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (62,'Keane','Mckee',5323069,3159468060,'sapien.imperdiet.ornare@ametfaucibus.com',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (63,'Bree','Skinner',2890092,3023554771,'taciti@fringillaornareplacerat.net',6);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (64,'Luke','Garcia',4581830,3124717523,'non@Aeneansed.com',3);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (65,'Julian','Burt',2817239,3176733787,'mi.Duis@euodio.co.uk',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (66,'Kyle','Hobbs',4057527,3062036830,'natoque@porttitortellus.ca',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (67,'Hyacinth','Hanson',5654082,3042598599,'lectus@arcuimperdiet.ca',4);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (68,'Honorato','Mccall',5664908,3013250749,'mus.Donec.dignissim@Vivamusnisi.co.uk',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (69,'Tara','Shepherd',4508232,3097825833,'tincidunt@ipsum.edu',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (70,'Kane','Diaz',3996629,3048978112,'turpis.nec@porttitor.com',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (71,'Vance','Phelps',3576977,3146603027,'dolor@nonarcuVivamus.co.uk',13);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (72,'Jade','Long',5855990,3141039461,'tellus.Nunc@senectusetnetus.org',11);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (73,'Rylee','Bright',5614195,3185150762,'molestie.in@quispede.ca',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (74,'Prescott','Christian',2676509,3005181303,'aliquam.enim@lectus.net',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (75,'Dacey','Bridges',3853860,3115092706,'orci@sedestNunc.org',7);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (76,'Kay','Benjamin',4531438,3120756302,'aliquet.Phasellus@ridiculusmus.edu',15);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (77,'Jana','Carrillo',5044673,3029704290,'facilisis.vitae@Aliquamadipiscing.edu',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (78,'Fay','Collins',5513723,3075530895,'adipiscing.elit.Curabitur@Vestibulum.ca',15);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (79,'Phillip','Gould',3745948,3084710052,'sodales.Mauris@Proinegetodio.edu',5);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (80,'Avram','Church',4611232,3115486393,'nec@iaculisenim.edu',2);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (81,'Ezra','Durham',3264984,3156136242,'interdum.Sed.auctor@turpisIn.co.uk',3);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (82,'Zenaida','Myers',4229450,3093825363,'convallis.convallis@In.net',3);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (83,'Fletcher','Mccarthy',3076109,3121796939,'est.Nunc@Phasellus.ca',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (84,'Miriam','Potter',2928459,3152412552,'pharetra.felis.eget@vestibulumMaurismagna.co.uk',4);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (85,'Allistair','Caldwell',3656891,3096752295,'Morbi.accumsan.laoreet@eratVivamusnisi.edu',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (86,'Shad','Santana',5361998,3006249627,'Sed.eu.eros@nectempus.ca',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (87,'Cheryl','Reeves',4164537,3141807175,'sem@duiquis.com',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (88,'Uma','Parks',4480796,3166080355,'vestibulum@atiaculis.org',4);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (89,'Rudyard','Fields',3128292,3182247486,'semper@sagittis.org',10);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (90,'Amir','Logan',5601846,3132212557,'aliquam@venenatisvelfaucibus.ca',4);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (91,'Kimberly','Cleveland',4006845,3030318650,'eu.enim.Etiam@mollisDuissit.edu',3);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (92,'Anika','Blake',4375717,3059623567,'sodales.elit.erat@interdum.co.uk',12);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (93,'Erin','Reilly',3406246,3106726478,'pharetra@metusInnec.edu',6);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (94,'Hedley','Johnson',4197498,3075975136,'adipiscing.Mauris@necanteblandit.org',6);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (95,'Fletcher','Goodwin',3081170,3122957409,'egestas@dictum.org',16);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (96,'Lavinia','Abbott',3168487,3180594107,'euismod@Aenean.co.uk',15);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (97,'Velma','Mckay',4239017,3080983983,'amet.luctus.vulputate@faucibusorciluctus.net',2);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (98,'Brenda','Pittman',4363049,3188696038,'molestie.in.tempus@non.org',9);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (99,'Mallory','Wolf',5290673,3191967459,'sit.amet.luctus@CuraePhasellusornare.edu',4);
INSERT INTO pasajeros (id_pasajeros,nombre,apellidos,telefono,celular,email,id_ciudades) VALUES (100,'Kiona','Erickson',4647119,3049952066,'Curabitur.egestas@laciniavitae.net',2);

--insert vuelos
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (1,530,572,'retrasado',5,'AU751',45,163,162,'13:00:40','07:18:05','14:05:54','17:51:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (2,556,307,'abordando',3,'AU214',72,123,41,'20:45:56','13:38:23','13:20:11','11:28:20');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (3,370,467,'retrasado',4,'AU822',141,172,107,'21:57:40','21:55:43','07:33:31','05:27:49');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (4,488,349,'confirmado',2,'AO278',57,56,211,'16:41:29','04:12:09','15:26:59','08:28:00');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (5,542,469,'confirmado',1,'AA369',8,158,218,'20:31:38','02:40:35','09:07:22','16:41:20');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (6,466,567,'en vuelo',4,'AE066',122,65,181,'02:21:31','04:46:03','09:14:58','15:54:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (7,536,393,'programado',5,'AO222',119,52,64,'00:06:45','23:28:05','11:10:55','08:46:04');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (8,450,354,'en vuelo',1,'AO510',116,111,170,'17:47:58','11:55:38','15:57:40','14:45:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (9,541,383,'cancelado',7,'AU942',177,72,141,'08:30:32','09:42:45','07:13:39','06:52:19');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (10,550,509,'en vuelo',4,'AA181',71,68,99,'09:06:04','13:04:35','02:21:23','12:22:48');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (11,401,516,'en vuelo',7,'AA922',70,14,120,'09:17:03','12:08:16','07:22:36','23:54:48');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (12,434,339,'retrasado',7,'AI389',9,143,95,'12:28:22','20:51:04','00:56:39','11:47:28');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (13,432,331,'cancelado',3,'AA962',149,81,185,'05:28:31','00:08:03','22:37:38','02:44:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (14,482,547,'retrasado',7,'AU408',69,124,185,'16:19:45','00:26:14','03:31:37','18:31:44');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (15,411,329,'cancelado',8,'AA093',105,182,208,'17:10:14','01:49:49','10:49:22','09:18:56');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (16,531,578,'programado',6,'AE268',175,105,84,'22:59:37','08:48:22','04:36:57','19:50:26');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (17,566,462,'retrasado',3,'AO170',9,143,52,'20:26:08','15:26:06','17:51:59','18:41:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (18,488,306,'retrasado',1,'AE351',5,59,146,'16:52:16','10:53:41','10:49:46','20:07:43');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (19,306,326,'cancelado',3,'AE138',43,158,81,'11:03:46','16:21:25','16:49:51','03:24:42');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (20,489,345,'retrasado',3,'AO318',25,31,15,'12:39:29','02:15:46','05:15:04','16:27:24');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (21,569,421,'programado',5,'AE921',27,77,161,'19:39:40','06:03:55','07:12:08','07:56:56');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (22,325,308,'retrasado',4,'AE810',140,75,53,'00:26:25','13:44:24','00:30:26','16:18:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (23,485,345,'abordando',7,'AE425',184,187,6,'16:06:31','09:59:33','09:59:31','11:48:58');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (24,451,431,'cancelado',1,'AU042',36,145,8,'17:43:43','14:55:37','12:56:01','22:05:48');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (25,533,450,'cancelado',4,'AA089',115,7,35,'01:51:12','03:16:09','07:50:59','17:16:41');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (26,578,455,'retrasado',8,'AA504',74,13,182,'07:53:03','21:52:38','20:10:59','04:45:34');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (27,385,454,'retrasado',4,'AO035',141,138,64,'07:26:04','23:23:42','18:08:27','06:17:34');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (28,453,335,'abordando',3,'AU091',107,16,152,'06:28:27','05:05:04','03:37:23','02:26:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (29,595,550,'programado',3,'AE173',169,125,72,'09:08:16','20:40:47','12:44:10','13:11:59');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (30,369,545,'confirmado',7,'AO883',166,195,71,'03:34:15','07:44:54','03:56:40','04:11:32');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (31,475,449,'cancelado',5,'AU794',127,75,46,'07:59:14','05:04:08','08:59:04','02:12:57');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (32,493,588,'cancelado',3,'AI510',100,178,52,'11:40:33','16:37:04','10:19:06','16:24:25');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (33,545,341,'confirmado',4,'AO587',189,32,197,'05:15:21','03:30:04','16:56:06','05:00:12');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (34,545,525,'confirmado',1,'AI784',4,157,182,'20:57:42','21:51:31','13:56:59','09:12:28');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (35,539,513,'en vuelo',6,'AI369',40,70,128,'20:06:41','14:57:16','16:35:54','09:57:24');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (36,393,583,'confirmado',8,'AE380',146,136,53,'04:34:54','23:33:03','22:49:09','03:35:11');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (37,358,371,'cancelado',8,'AI064',113,17,53,'19:02:55','08:31:18','02:56:43','23:28:37');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (38,456,444,'programado',5,'AO157',199,176,51,'18:08:34','05:19:56','02:14:11','21:12:31');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (39,577,318,'en vuelo',4,'AU410',153,65,7,'11:30:24','14:26:37','11:29:55','07:14:20');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (40,453,522,'cancelado',2,'AI983',134,9,10,'06:51:19','02:10:03','13:38:48','06:56:13');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (41,535,480,'programado',6,'AE460',149,24,63,'16:30:02','18:49:41','01:38:47','19:57:11');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (42,504,526,'abordando',3,'AI953',193,71,143,'10:48:26','12:11:37','05:36:12','12:24:21');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (43,572,508,'confirmado',7,'AU508',138,72,69,'15:16:58','13:06:35','10:40:02','20:40:51');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (44,558,416,'confirmado',6,'AA412',143,188,125,'15:48:12','06:07:17','23:28:04','11:17:33');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (45,457,329,'retrasado',6,'AO789',82,160,213,'01:59:05','01:10:20','23:27:20','17:14:54');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (46,364,450,'abordando',4,'AE721',108,3,155,'13:33:03','06:17:11','10:55:12','21:16:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (47,310,311,'en vuelo',5,'AU542',178,68,54,'02:54:08','22:11:15','08:43:52','11:07:13');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (48,313,385,'programado',4,'AI333',32,110,169,'15:26:00','11:56:37','05:49:30','10:06:30');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (49,541,442,'cancelado',8,'AI609',84,17,157,'02:24:47','13:24:30','17:18:43','21:08:08');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (50,482,546,'cancelado',4,'AE682',41,112,15,'11:42:37','21:52:08','05:04:42','08:08:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (51,447,530,'abordando',6,'AI397',116,121,118,'20:05:50','19:47:04','19:29:58','13:35:36');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (52,318,478,'programado',6,'AA965',62,199,183,'10:21:07','12:54:35','21:14:38','05:20:26');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (53,571,433,'cancelado',3,'AO613',88,39,53,'19:54:31','13:24:48','08:34:55','12:27:38');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (54,341,389,'en vuelo',6,'AI835',8,144,93,'11:49:05','03:50:09','04:11:25','05:12:03');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (55,577,551,'confirmado',5,'AU104',163,45,181,'01:31:36','06:08:08','11:28:12','21:20:34');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (56,310,466,'en vuelo',1,'AA568',183,166,55,'04:50:52','03:29:36','14:13:57','13:16:08');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (57,422,530,'retrasado',2,'AI375',48,152,157,'17:46:34','16:09:46','14:06:49','14:22:04');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (58,311,476,'confirmado',5,'AU651',9,137,211,'07:41:01','01:22:56','11:42:58','16:02:19');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (59,486,469,'programado',5,'AU975',82,70,50,'15:27:10','20:03:57','10:22:02','14:17:39');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (60,415,316,'retrasado',7,'AU177',32,85,84,'18:22:52','20:07:50','00:35:54','09:42:54');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (61,417,384,'cancelado',8,'AI564',14,117,106,'07:27:26','12:09:44','15:19:03','21:20:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (62,451,539,'cancelado',8,'AU291',68,50,142,'08:10:13','02:06:47','12:18:58','08:51:20');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (63,416,411,'confirmado',2,'AU412',105,187,96,'10:47:17','16:53:54','17:40:41','05:25:18');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (64,337,397,'en vuelo',4,'AE576',75,43,111,'04:20:45','01:35:05','20:38:22','00:30:34');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (65,573,521,'abordando',6,'AA182',47,108,206,'19:32:55','06:42:07','00:50:48','08:06:45');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (66,492,334,'en vuelo',3,'AA782',56,190,47,'08:17:21','12:49:59','16:01:42','21:24:02');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (67,315,439,'cancelado',6,'AU904',39,151,70,'21:19:45','04:37:50','09:03:43','08:00:02');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (68,508,324,'confirmado',4,'AO766',126,90,102,'11:57:43','07:25:37','01:10:53','12:50:54');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (69,335,355,'programado',2,'AU719',11,176,3,'22:59:31','07:00:46','21:16:59','07:04:20');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (70,379,499,'cancelado',7,'AI895',100,123,84,'11:15:14','01:00:39','20:51:26','16:13:43');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (71,387,380,'abordando',8,'AO116',154,186,7,'07:36:27','12:38:36','18:15:48','08:13:46');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (72,516,488,'cancelado',7,'AO334',137,98,86,'11:16:05','09:10:13','10:21:14','17:03:29');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (73,567,451,'confirmado',4,'AA538',28,89,134,'20:43:07','07:16:07','20:43:55','10:21:19');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (74,308,447,'en vuelo',1,'AO211',168,39,157,'13:37:36','01:57:16','17:01:29','01:14:32');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (75,367,544,'en vuelo',1,'AU379',148,175,194,'19:29:37','05:41:52','07:03:34','11:24:43');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (76,536,554,'retrasado',1,'AU491',192,166,173,'02:07:04','10:42:20','19:30:24','22:49:12');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (77,361,587,'retrasado',4,'AA943',141,180,48,'21:21:37','08:04:45','02:00:25','02:43:18');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (78,425,347,'cancelado',8,'AE422',80,192,128,'06:03:50','00:42:42','02:58:23','03:52:30');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (79,524,499,'confirmado',6,'AO138',2,89,121,'06:09:17','10:05:04','16:47:30','12:21:16');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (80,342,509,'cancelado',2,'AI007',6,153,79,'02:48:11','17:17:19','08:22:49','01:25:13');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (81,319,544,'en vuelo',2,'AI163',163,99,125,'18:49:07','16:46:59','04:43:13','09:06:08');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (82,335,491,'abordando',2,'AE905',42,146,106,'19:48:11','18:23:14','15:01:29','13:30:03');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (83,372,488,'abordando',8,'AA682',118,69,87,'14:37:22','19:27:37','20:38:35','07:21:41');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (84,405,503,'programado',2,'AO085',8,127,195,'09:39:09','15:20:30','19:06:05','02:51:02');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (85,426,471,'cancelado',5,'AU669',133,91,122,'14:18:11','05:19:28','17:48:08','06:01:28');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (86,306,392,'programado',5,'AO768',199,73,94,'14:56:29','13:47:36','14:00:39','16:42:05');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (87,357,485,'retrasado',1,'AE988',77,138,203,'03:43:07','14:53:40','05:32:08','02:54:52');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (88,495,546,'programado',4,'AO608',130,88,134,'01:00:08','15:24:45','11:56:40','04:55:09');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (89,334,403,'programado',5,'AU214',105,75,72,'03:50:27','08:02:56','23:05:15','15:22:49');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (90,442,396,'en vuelo',4,'AU838',71,185,175,'19:13:04','14:39:07','01:58:43','11:35:50');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (91,331,553,'en vuelo',6,'AE105',183,36,147,'00:05:48','03:14:52','00:08:36','12:33:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (92,444,577,'retrasado',5,'AU204',32,33,171,'05:18:28','10:43:24','01:40:24','08:27:16');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (93,392,362,'confirmado',4,'AE726',181,174,206,'05:50:43','13:09:10','18:04:21','02:32:40');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (94,359,308,'programado',6,'AI345',16,144,169,'01:09:00','19:24:35','17:41:16','09:33:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (95,351,408,'confirmado',3,'AA953',169,197,197,'06:43:58','05:57:13','05:00:40','09:56:09');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (96,542,593,'programado',4,'AA837',81,115,195,'02:17:37','16:32:56','22:21:21','17:33:52');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (97,562,546,'cancelado',1,'AE037',185,172,154,'10:11:39','17:53:32','19:25:52','17:20:45');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (98,526,357,'retrasado',8,'AO747',77,61,93,'10:42:50','10:21:06','22:20:15','20:15:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (99,463,426,'cancelado',4,'AE358',38,55,159,'08:53:53','12:10:38','09:40:38','01:50:34');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (100,466,598,'programado',7,'AO913',2,92,105,'08:40:10','13:32:05','20:45:34','07:05:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (101,322,598,'programado',2,'AE299',2,189,52,'14:24:47','20:03:12','05:40:21','06:11:25');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (102,538,323,'cancelado',4,'AU245',5,187,108,'07:15:28','07:17:41','04:06:47','22:25:53');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (103,509,496,'programado',8,'AO668',199,116,69,'14:26:05','02:51:40','10:19:20','01:59:14');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (104,370,585,'en vuelo',7,'AO987',95,9,192,'05:40:53','17:02:45','06:01:18','21:54:42');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (105,403,331,'en vuelo',3,'AE931',191,137,104,'11:27:04','06:25:00','00:03:39','20:14:59');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (106,590,595,'retrasado',1,'AA633',142,200,185,'11:21:45','21:13:11','10:44:00','07:06:08');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (107,342,566,'abordando',1,'AI565',83,180,9,'00:42:56','09:24:16','02:45:24','01:18:21');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (108,508,359,'retrasado',3,'AE953',184,9,65,'19:00:38','07:16:03','11:15:15','22:44:51');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (109,355,306,'programado',6,'AE963',106,174,113,'04:44:49','20:11:18','02:06:08','04:10:30');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (110,546,389,'confirmado',2,'AI081',59,19,138,'23:04:18','04:21:35','03:19:07','19:49:42');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (111,356,394,'retrasado',8,'AI281',15,118,193,'09:57:42','08:00:10','02:05:52','16:33:39');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (112,389,458,'cancelado',8,'AU051',151,49,54,'21:04:52','13:41:49','09:28:48','14:56:32');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (113,507,531,'en vuelo',6,'AI495',140,197,145,'05:06:39','12:37:18','08:46:41','11:03:53');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (114,595,358,'retrasado',1,'AO563',82,173,8,'13:41:00','02:13:17','18:47:24','12:31:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (115,329,307,'retrasado',3,'AU376',8,71,68,'18:16:39','22:25:26','02:26:15','20:54:05');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (116,574,468,'retrasado',1,'AE865',167,101,151,'03:33:34','09:54:18','10:14:33','19:06:01');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (117,336,367,'en vuelo',4,'AI492',144,115,187,'14:55:34','12:53:23','20:56:26','10:01:05');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (118,347,477,'retrasado',4,'AO962',28,180,114,'02:08:28','14:18:30','03:03:22','08:22:24');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (119,545,460,'programado',4,'AU010',191,97,183,'19:07:08','11:13:22','05:35:11','09:02:21');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (120,596,404,'cancelado',2,'AO040',154,135,89,'13:12:24','20:24:01','20:51:00','20:00:05');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (121,538,511,'abordando',8,'AU900',87,33,178,'04:51:26','15:47:39','07:42:13','05:11:11');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (122,581,368,'abordando',4,'AI585',82,74,180,'04:16:46','08:41:20','09:41:47','14:15:33');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (123,591,376,'en vuelo',2,'AO442',101,74,148,'05:18:25','15:28:01','14:08:51','03:58:38');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (124,550,438,'abordando',1,'AU997',141,77,134,'05:48:37','07:03:11','06:15:57','06:16:40');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (125,415,308,'programado',6,'AA848',125,110,124,'13:25:16','18:36:21','19:57:43','14:47:01');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (126,582,447,'retrasado',5,'AO494',130,167,13,'09:53:24','00:34:29','12:21:07','02:48:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (127,515,435,'abordando',4,'AI770',199,140,214,'13:47:33','03:26:10','13:36:46','13:59:42');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (128,357,502,'cancelado',4,'AU430',21,65,152,'03:51:57','10:00:41','14:10:48','18:10:23');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (129,441,467,'confirmado',4,'AO207',180,159,63,'00:46:11','14:13:25','08:29:31','11:28:41');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (130,533,431,'cancelado',8,'AU432',5,141,26,'19:29:23','22:41:26','19:28:08','13:22:44');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (131,364,548,'en vuelo',7,'AU604',125,59,52,'13:59:29','22:38:34','16:07:31','02:36:53');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (132,411,591,'programado',4,'AE176',157,69,207,'03:48:11','12:10:22','08:13:10','02:02:34');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (133,542,479,'retrasado',4,'AE303',8,17,123,'11:37:44','08:07:16','20:52:40','02:07:44');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (134,567,541,'cancelado',3,'AA306',7,117,47,'12:18:31','04:25:11','09:38:37','12:26:31');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (135,379,509,'confirmado',5,'AA397',60,60,150,'04:06:28','10:53:17','03:21:55','05:52:45');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (136,547,355,'abordando',6,'AO199',67,142,37,'19:11:03','01:17:56','12:30:22','11:17:35');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (137,373,590,'confirmado',6,'AA070',134,36,76,'08:42:12','18:59:09','04:03:01','19:11:08');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (138,559,476,'confirmado',8,'AO103',103,15,5,'22:38:58','13:04:16','22:09:13','09:00:00');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (139,303,458,'abordando',4,'AA618',19,1,127,'00:50:32','13:46:23','00:46:48','14:06:09');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (140,435,483,'confirmado',6,'AE859',45,66,151,'06:12:44','16:31:40','21:00:18','08:10:58');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (141,512,537,'cancelado',4,'AU108',33,135,62,'22:22:09','15:40:26','21:36:45','15:09:28');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (142,470,465,'en vuelo',2,'AI213',56,111,132,'00:27:27','20:26:03','18:35:43','15:41:14');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (143,453,360,'programado',1,'AA682',43,136,81,'01:23:00','00:44:07','15:54:55','10:11:39');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (144,429,523,'confirmado',1,'AI469',65,35,20,'02:02:04','18:01:22','01:40:36','04:20:09');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (145,473,352,'programado',1,'AO030',36,101,8,'14:51:06','18:19:35','06:42:59','00:10:00');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (146,375,373,'abordando',7,'AU432',197,128,33,'21:51:25','18:52:19','13:39:08','22:26:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (147,493,433,'retrasado',5,'AO121',180,68,104,'12:59:18','21:37:24','18:06:18','12:15:39');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (148,479,374,'cancelado',5,'AE267',57,6,87,'01:23:21','14:15:05','18:10:06','22:43:38');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (149,374,477,'cancelado',6,'AA259',110,123,42,'16:03:13','21:51:01','17:03:50','16:39:19');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (150,423,357,'retrasado',3,'AE045',79,133,179,'18:57:44','01:41:08','17:42:43','18:45:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (151,427,566,'en vuelo',1,'AE378',161,28,108,'21:26:08','05:18:02','22:13:06','09:14:12');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (152,554,365,'retrasado',7,'AA523',38,116,158,'20:37:25','21:50:55','10:10:11','22:39:13');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (153,339,379,'programado',1,'AU253',8,12,16,'04:45:52','11:09:17','14:21:04','18:16:51');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (154,483,568,'en vuelo',1,'AA807',40,81,216,'08:00:43','23:27:23','17:36:08','12:23:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (155,460,384,'abordando',4,'AI509',67,19,149,'20:36:05','17:36:17','04:37:47','17:03:36');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (156,468,342,'retrasado',7,'AE755',68,25,119,'14:26:45','22:06:08','18:51:47','07:28:44');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (157,548,569,'en vuelo',7,'AE129',164,27,208,'12:41:26','10:43:23','06:16:07','08:18:28');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (158,486,522,'confirmado',1,'AA928',3,161,68,'12:11:32','10:15:17','12:06:04','04:41:54');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (159,391,404,'en vuelo',6,'AE457',84,59,38,'12:03:57','16:35:43','10:47:45','21:34:03');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (160,512,311,'en vuelo',8,'AE975',122,156,22,'17:38:49','12:43:22','21:11:04','05:48:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (161,398,399,'en vuelo',8,'AO116',46,104,83,'21:14:56','08:40:13','02:35:33','00:44:00');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (162,317,473,'cancelado',2,'AU155',166,25,76,'10:42:36','11:26:39','16:01:45','07:31:21');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (163,578,575,'retrasado',7,'AI774',146,44,182,'15:08:28','18:16:18','10:44:18','22:05:20');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (164,374,571,'cancelado',2,'AU790',76,78,183,'16:24:43','21:04:16','20:39:21','13:13:42');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (165,345,530,'confirmado',6,'AE198',144,110,87,'15:47:34','16:15:51','13:26:19','01:57:40');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (166,496,303,'en vuelo',8,'AU837',15,126,148,'07:32:43','04:45:31','12:03:03','22:41:33');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (167,482,572,'en vuelo',1,'AO188',114,136,179,'17:23:53','01:48:14','21:54:25','16:46:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (168,481,551,'en vuelo',3,'AE458',153,144,17,'02:21:57','15:04:20','22:15:08','10:53:28');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (169,356,418,'en vuelo',5,'AA315',136,160,4,'20:19:34','23:59:07','07:51:36','10:59:04');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (170,303,462,'en vuelo',6,'AU565',178,153,70,'10:35:42','05:35:12','03:15:45','23:24:30');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (171,378,510,'retrasado',6,'AU419',162,174,197,'15:27:16','12:17:27','17:33:11','03:42:32');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (172,416,328,'confirmado',3,'AE091',13,157,180,'19:30:59','16:05:17','01:17:25','05:40:09');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (173,551,474,'retrasado',7,'AI020',170,7,114,'14:42:38','14:19:09','11:40:06','05:58:04');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (174,520,590,'abordando',4,'AO268',23,118,115,'07:46:48','02:34:40','06:36:51','15:04:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (175,395,597,'programado',8,'AA262',122,6,145,'05:02:17','03:36:57','03:26:51','02:20:50');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (176,348,575,'en vuelo',1,'AU752',131,107,63,'09:04:08','18:14:38','03:18:27','20:44:39');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (177,544,553,'retrasado',5,'AI974',108,31,217,'10:28:35','16:15:12','12:49:49','09:04:45');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (178,475,567,'cancelado',5,'AA646',24,150,127,'03:07:13','18:46:27','03:02:47','07:32:06');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (179,440,432,'abordando',2,'AI003',82,150,115,'11:32:26','19:40:31','21:34:37','13:13:16');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (180,599,593,'abordando',8,'AI074',40,197,34,'17:27:42','03:21:37','04:58:28','05:21:31');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (181,384,432,'abordando',1,'AI562',174,72,185,'01:13:05','00:19:06','05:07:20','02:15:07');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (182,451,480,'abordando',6,'AO360',18,35,83,'04:57:06','13:35:47','11:48:30','03:42:00');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (183,588,591,'abordando',5,'AA980',119,56,57,'07:20:21','16:25:07','16:48:20','15:32:32');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (184,582,304,'abordando',5,'AO392',126,70,47,'14:27:34','08:15:46','05:52:33','00:36:56');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (185,586,303,'en vuelo',6,'AU754',119,196,189,'01:29:06','11:52:52','00:28:42','07:00:36');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (186,575,521,'abordando',5,'AO790',145,108,217,'06:46:10','19:24:35','18:02:41','10:35:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (187,449,418,'cancelado',1,'AE687',38,72,111,'14:41:38','12:04:52','06:09:08','00:41:42');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (188,412,421,'abordando',8,'AA517',189,36,105,'14:14:49','05:58:28','11:25:55','14:51:29');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (189,422,524,'cancelado',4,'AI354',58,176,166,'01:08:40','16:49:16','17:00:56','17:32:19');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (190,479,349,'en vuelo',3,'AE048',194,137,159,'21:05:57','09:34:25','16:57:09','22:32:54');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (191,551,323,'programado',2,'AI769',170,164,102,'01:48:53','19:25:10','12:09:55','09:49:31');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (192,313,336,'en vuelo',4,'AI979',110,189,135,'15:23:58','05:00:11','01:23:23','23:01:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (193,402,483,'confirmado',2,'AA212',21,170,179,'09:59:49','06:25:10','20:50:48','17:47:15');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (194,304,408,'confirmado',8,'AA126',143,168,205,'08:58:42','10:26:08','08:12:12','16:43:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (195,369,528,'retrasado',7,'AA645',76,151,143,'18:19:18','08:45:36','23:36:18','06:05:34');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (196,544,335,'abordando',3,'AE186',188,191,64,'21:03:06','13:55:03','10:45:10','17:57:58');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (197,407,562,'en vuelo',2,'AI275',161,158,85,'11:19:21','03:55:09','03:04:21','05:46:24');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (198,339,416,'programado',6,'AA096',53,47,84,'20:18:24','17:52:27','20:27:10','10:54:06');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (199,396,566,'en vuelo',6,'AU107',126,94,115,'16:32:59','21:33:53','16:28:26','19:44:49');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (200,345,413,'confirmado',2,'AE153',93,62,218,'08:26:41','11:41:30','04:31:43','03:06:16');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (201,456,332,'abordando',2,'AU023',75,131,168,'09:36:43','04:47:57','11:53:28','19:38:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (202,439,403,'programado',3,'AE998',144,6,209,'11:41:23','20:24:44','03:46:56','01:00:34');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (203,324,315,'cancelado',6,'AU783',149,100,122,'18:52:05','15:08:44','19:06:14','11:53:39');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (204,561,325,'retrasado',4,'AI499',93,175,215,'11:57:21','15:52:38','08:37:24','09:12:20');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (205,468,585,'retrasado',5,'AU972',148,21,168,'19:03:44','06:38:09','01:24:12','22:15:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (206,552,433,'retrasado',2,'AE866',2,120,21,'08:19:18','23:34:01','22:32:13','17:59:26');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (207,557,323,'retrasado',8,'AU285',150,43,156,'08:09:57','16:05:24','14:03:17','13:27:39');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (208,354,359,'retrasado',5,'AI002',108,130,8,'07:33:48','22:26:25','07:02:28','15:26:55');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (209,431,365,'retrasado',6,'AA748',92,52,203,'01:18:47','21:16:56','11:02:19','00:07:40');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (210,407,502,'abordando',6,'AO218',115,138,48,'07:35:30','13:54:49','19:18:52','00:50:09');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (211,333,379,'abordando',3,'AA857',58,16,13,'14:12:54','06:09:02','05:23:27','17:31:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (212,391,355,'confirmado',3,'AI145',104,174,5,'05:39:36','10:31:35','03:59:31','09:25:57');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (213,521,322,'cancelado',5,'AE600',168,91,152,'21:13:25','05:42:57','07:38:08','08:48:26');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (214,342,433,'programado',6,'AA648',78,145,27,'17:51:16','08:04:34','05:02:59','02:23:42');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (215,353,496,'retrasado',2,'AI105',186,167,215,'20:11:26','15:55:03','02:41:05','23:53:58');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (216,343,491,'cancelado',7,'AE897',110,57,46,'05:11:51','17:03:30','21:53:37','06:46:52');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (217,339,357,'programado',7,'AU209',198,33,114,'00:30:58','16:20:10','10:36:03','21:52:43');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (218,342,406,'confirmado',7,'AI042',74,58,173,'22:55:03','19:32:01','11:10:32','10:23:36');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (219,311,472,'abordando',5,'AA732',179,98,48,'15:18:17','23:11:32','02:04:05','18:57:44');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (220,586,502,'retrasado',8,'AU994',79,103,193,'06:40:53','19:15:19','03:42:34','20:47:34');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (221,507,548,'retrasado',6,'AE690',36,112,99,'07:30:54','20:28:19','02:08:26','15:39:59');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (222,471,510,'programado',7,'AU374',156,193,181,'12:25:12','17:28:56','08:48:58','12:08:18');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (223,371,354,'programado',4,'AA132',153,60,63,'07:16:13','18:21:55','15:12:13','01:14:58');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (224,399,565,'en vuelo',2,'AU339',80,146,163,'15:43:24','23:25:06','13:03:33','17:10:33');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (225,550,343,'en vuelo',8,'AO069',184,135,113,'02:58:23','03:18:33','13:35:56','21:05:44');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (226,466,584,'retrasado',1,'AI006',23,21,203,'02:41:13','16:38:32','08:25:43','03:42:14');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (227,578,300,'confirmado',7,'AU271',103,123,212,'20:55:53','05:29:15','01:59:59','21:07:36');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (228,309,359,'retrasado',4,'AI556',95,90,158,'09:03:33','09:15:59','23:18:08','22:11:01');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (229,494,475,'confirmado',5,'AA388',34,85,117,'14:51:59','11:18:58','04:42:04','09:27:45');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (230,389,507,'confirmado',6,'AO811',7,29,161,'13:13:55','22:27:51','04:46:48','14:04:28');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (231,448,349,'en vuelo',5,'AU053',138,15,13,'19:45:54','20:46:14','00:23:19','05:05:29');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (232,521,436,'retrasado',4,'AA921',110,25,117,'03:36:38','14:41:41','05:40:59','17:38:05');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (233,531,440,'en vuelo',5,'AI984',169,185,15,'18:03:23','22:01:45','17:25:42','00:45:01');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (234,414,593,'retrasado',7,'AE876',188,3,89,'07:16:06','01:28:14','23:30:00','00:38:48');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (235,462,468,'retrasado',8,'AU916',72,180,177,'00:51:23','13:18:53','06:34:06','18:14:54');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (236,332,320,'confirmado',1,'AU083',54,122,141,'06:19:17','18:14:34','16:15:35','09:29:05');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (237,502,353,'retrasado',5,'AA208',40,168,168,'14:04:39','05:49:30','03:42:59','23:54:16');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (238,444,547,'programado',2,'AA116',85,147,28,'18:40:22','18:55:48','06:38:49','02:00:37');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (239,349,464,'confirmado',8,'AA332',148,156,16,'16:23:12','22:23:43','12:38:51','08:36:31');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (240,368,431,'confirmado',6,'AO398',109,43,84,'20:38:02','23:53:35','21:47:48','02:26:31');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (241,585,462,'cancelado',4,'AO007',30,189,158,'02:31:01','21:47:24','08:55:04','15:18:50');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (242,392,489,'cancelado',6,'AU216',165,179,181,'11:45:53','08:56:29','22:03:45','10:31:49');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (243,381,341,'en vuelo',5,'AO934',119,61,188,'15:02:09','18:10:18','03:34:29','22:10:20');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (244,572,393,'confirmado',7,'AU612',32,199,167,'02:51:10','12:18:01','22:12:55','14:14:14');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (245,342,516,'retrasado',6,'AI995',153,139,175,'03:07:03','07:50:59','07:20:08','19:33:32');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (246,565,338,'programado',1,'AE014',145,55,192,'09:08:25','06:20:12','19:03:12','09:06:32');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (247,417,375,'programado',6,'AI298',16,93,170,'12:44:44','21:02:18','15:24:01','09:09:32');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (248,463,324,'abordando',1,'AI866',160,27,52,'03:51:37','02:45:15','22:21:40','06:16:54');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (249,542,545,'abordando',6,'AA896',181,78,1,'09:41:10','17:34:20','15:12:06','15:30:25');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (250,576,571,'cancelado',2,'AU928',100,31,55,'02:26:36','06:35:33','09:03:04','12:16:31');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (251,423,342,'retrasado',6,'AI918',12,26,1,'05:03:59','06:37:13','15:47:24','02:46:17');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (252,580,363,'cancelado',6,'AO609',37,156,32,'12:22:30','13:45:15','05:18:18','22:07:16');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (253,359,406,'cancelado',4,'AI585',127,164,131,'12:50:59','03:31:26','19:16:00','00:33:07');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (254,369,567,'confirmado',7,'AO865',27,186,110,'03:35:41','23:47:08','22:52:53','09:32:30');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (255,423,351,'programado',8,'AI739',197,140,11,'19:59:31','13:10:29','21:00:40','02:43:57');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (256,476,385,'abordando',7,'AI596',91,69,173,'10:19:57','05:16:10','21:40:21','17:35:03');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (257,577,507,'en vuelo',8,'AA267',164,115,132,'06:21:42','20:16:47','18:18:03','15:51:20');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (258,421,501,'cancelado',2,'AU804',81,120,193,'16:24:55','21:21:23','02:36:16','22:49:05');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (259,371,436,'programado',8,'AA879',173,43,140,'21:07:32','11:21:01','20:38:04','17:20:36');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (260,545,537,'en vuelo',2,'AA944',163,152,109,'20:47:35','04:10:13','00:04:42','23:10:17');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (261,598,473,'programado',1,'AI453',25,149,84,'09:58:51','13:35:15','13:40:59','02:34:08');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (262,424,372,'en vuelo',6,'AA854',25,36,180,'08:20:55','21:11:28','02:55:35','16:32:05');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (263,344,510,'confirmado',2,'AA322',109,105,165,'03:27:33','16:31:14','13:36:27','14:16:50');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (264,438,324,'programado',8,'AI349',118,28,5,'14:21:49','14:37:20','03:48:20','11:36:05');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (265,323,333,'abordando',1,'AO304',103,150,159,'00:42:21','14:24:27','01:29:24','11:14:27');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (266,521,345,'en vuelo',8,'AA026',130,10,36,'18:07:46','10:04:00','17:06:47','23:32:40');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (267,331,575,'cancelado',1,'AU705',19,121,45,'09:04:03','03:03:59','02:53:31','18:30:03');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (268,506,529,'programado',8,'AU380',145,78,117,'22:52:22','01:28:57','03:43:02','00:46:11');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (269,507,570,'abordando',4,'AA655',116,6,86,'03:49:11','19:59:02','23:01:58','17:55:01');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (270,510,402,'cancelado',4,'AI716',62,52,133,'06:41:56','17:40:15','20:26:10','19:14:44');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (271,436,524,'programado',2,'AI798',147,51,208,'09:40:27','07:45:11','22:00:20','07:03:47');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (272,448,392,'programado',7,'AI693',27,135,146,'16:55:33','12:34:35','22:52:34','20:48:30');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (273,320,396,'programado',5,'AU562',180,49,204,'13:00:47','06:48:34','11:10:54','19:39:54');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (274,401,326,'en vuelo',6,'AA123',63,120,125,'03:00:30','00:41:57','08:43:11','07:33:12');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (275,430,560,'abordando',7,'AO941',134,54,155,'15:21:22','09:15:26','19:23:35','17:10:54');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (276,497,538,'retrasado',1,'AO018',19,180,65,'10:50:50','08:07:05','09:36:38','13:41:53');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (277,330,418,'programado',5,'AA067',51,124,101,'02:31:37','22:12:11','02:11:23','17:07:01');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (278,458,420,'programado',2,'AE344',25,189,45,'00:53:23','04:20:02','18:49:21','06:46:45');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (279,583,573,'retrasado',5,'AE650',38,26,37,'16:25:18','21:41:25','22:07:25','16:35:14');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (280,528,541,'en vuelo',8,'AE055',35,53,111,'21:40:06','05:58:59','20:39:49','05:47:48');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (281,390,565,'cancelado',7,'AU773',87,39,13,'21:37:23','17:03:58','00:19:11','08:28:42');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (282,549,409,'confirmado',4,'AA269',176,93,68,'19:55:31','12:09:12','13:25:06','22:04:57');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (283,393,310,'en vuelo',8,'AU966',159,55,140,'17:52:58','06:37:04','03:05:48','07:37:52');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (284,477,518,'programado',4,'AE212',176,141,147,'07:31:37','02:21:19','17:32:44','05:27:49');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (285,413,471,'en vuelo',6,'AA406',31,138,189,'04:58:50','16:58:01','10:16:27','18:40:59');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (286,318,518,'programado',7,'AU849',46,75,65,'10:46:00','13:28:54','23:26:45','02:19:41');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (287,357,455,'confirmado',6,'AO353',38,41,40,'22:30:06','17:41:11','17:09:20','18:23:08');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (288,567,373,'confirmado',2,'AO935',137,151,170,'17:42:54','03:00:39','14:11:16','12:40:35');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (289,543,534,'abordando',4,'AO289',93,65,163,'08:32:35','22:27:17','14:20:57','05:56:37');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (290,426,560,'confirmado',5,'AO370',47,26,161,'20:35:14','00:12:27','06:06:27','12:23:24');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (291,338,390,'en vuelo',8,'AU219',71,165,15,'22:00:02','22:26:00','16:27:29','01:48:41');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (292,339,519,'confirmado',1,'AI294',59,120,32,'03:40:58','04:47:39','06:11:40','05:27:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (293,427,452,'programado',3,'AU600',165,8,172,'07:31:05','10:50:26','00:15:34','20:17:08');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (294,444,403,'en vuelo',5,'AI027',45,145,82,'05:30:20','09:32:03','14:54:20','18:49:03');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (295,566,305,'en vuelo',1,'AU499',132,166,210,'20:39:35','13:22:37','22:14:41','01:35:42');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (296,518,491,'en vuelo',2,'AA826',14,55,41,'19:48:16','08:15:46','09:49:41','07:50:08');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (297,552,519,'confirmado',8,'AU995',65,15,65,'20:58:57','18:25:23','14:47:02','03:51:36');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (298,479,357,'confirmado',4,'AE612',151,86,46,'14:53:03','07:44:03','22:13:44','01:59:48');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (299,513,320,'cancelado',5,'AO576',30,23,108,'14:28:45','21:50:24','19:39:52','22:29:22');
INSERT INTO vuelos (id_vuelo,id_piloto,id_copiloto,estado,frecuencia_semanal,aeronave_asignada,cantidad_pasajeros_ejecutiva,cantidad_pasajeros_economica,id_avion,hora_estimada_salida,hora_estimada_llegada,hora_real_salida,hora_real_llegada) VALUES (300,365,376,'confirmado',7,'AU512',191,91,85,'10:30:37','08:33:00','05:30:53','02:44:18');

--insert log vuelo

--Fila 1
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (1,'1520741793','2018-03-11T04:16:33Z','AVA120','4.700993,-74.141899','0','2','258',252);
--Fila 2
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (2,'1520741838','2018-03-11T04:17:18Z','AVA120','4.701089,-74.141624','0','2','295',224);
--Fila 3
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (3,'1520741917','2018-03-11T04:18:37Z','AVA120','4.701055,-74.141487','0','2','300',117);
--Fila 4
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (4,'1520741969','2018-03-11T04:19:29Z','AVA120','4.701279,-74.141716','0','2','315',259);
--Fila 5
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (5,'1520742193','2018-03-11T04:23:13Z','AVA120','4.701636,-74.142181','0','18','317',44);
--Fila 6
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (6,'1520742284','2018-03-11T04:24:44Z','AVA120','4.704071,-74.14325','0','21','25',247);
--Fila 7
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (7,'1520742291','2018-03-11T04:24:51Z','AVA120','4.70438,-74.143402','0','21','331',148);
--Fila 8
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (8,'1520742299','2018-03-11T04:24:59Z','AVA120','4.704581,-74.1437','0','22','312',84);
--Fila 9
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (9,'1520742311','2018-03-11T04:25:11Z','AVA120','4.704872,-74.144112','0','23','312',87);
--Fila 10
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (10,'1520742317','2018-03-11T04:25:17Z','AVA120','4.705032,-74.144318','0','24','312',47);
--Fila 11
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (11,'1520742324','2018-03-11T04:25:24Z','AVA120','4.705204,-74.144539','0','25','312',124);
--Fila 12
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (12,'1520742332','2018-03-11T04:25:32Z','AVA120','4.705477,-74.14489','0','26','312',300);
--Fila 13
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (13,'1520742338','2018-03-11T04:25:38Z','AVA120','4.705651,-74.145142','0','27','312',113);
--Fila 14
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (14,'1520742344','2018-03-11T04:25:44Z','AVA120','4.705856,-74.145401','0','28','312',236);
--Fila 15
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (15,'1520742351','2018-03-11T04:25:51Z','AVA120','4.706024,-74.14563','0','29','312',269);
--Fila 16
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (16,'1520742359','2018-03-11T04:25:59Z','AVA120','4.706396,-74.146111','0','31','312',52);
--Fila 17
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (17,'1520742365','2018-03-11T04:26:05Z','AVA120','4.706559,-74.146339','0','31','312',104);
--Fila 18
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (18,'1520742371','2018-03-11T04:26:11Z','AVA120','4.706852,-74.146706','0','33','315',98);
--Fila 19
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (19,'1520742380','2018-03-11T04:26:20Z','AVA120','4.707188,-74.147163','0','34','312',27);
--Fila 20
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (20,'1520742387','2018-03-11T04:26:27Z','AVA120','4.707481,-74.147545','0','15','312',114);
--Fila 21
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (21,'1520742393','2018-03-11T04:26:33Z','AVA120','4.707723,-74.147881','0','15','312',18);
--Fila 22
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (22,'1520742399','2018-03-11T04:26:39Z','AVA120','4.708003,-74.148247','0','16','312',65);
--Fila 23
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (23,'1520742411','2018-03-11T04:26:51Z','AVA120','4.708569,-74.148987','0','17','312',211);
--Fila 24
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (24,'1520742417','2018-03-11T04:26:57Z','AVA120','4.708866,-74.149391','0','17','312',208);
--Fila 25
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (25,'1520742423','2018-03-11T04:27:03Z','AVA120','4.709166,-74.14978','0','17','312',192);
--Fila 26
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (26,'1520742435','2018-03-11T04:27:15Z','AVA120','4.709702,-74.15049','0','18','312',212);
--Fila 27
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (27,'1520742441','2018-03-11T04:27:21Z','AVA120','4.710039,-74.15094','0','15','312',249);
--Fila 28
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (28,'1520742447','2018-03-11T04:27:27Z','AVA120','4.710239,-74.151207','0','34','312',295);
--Fila 29
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (29,'1520742456','2018-03-11T04:27:36Z','AVA120','4.710575,-74.151665','0','25','312',62);
--Fila 30
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (30,'1520742471','2018-03-11T04:27:51Z','AVA120','4.710865,-74.152031','0','18','315',228);
--Fila 31
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (31,'1520742489','2018-03-11T04:28:09Z','AVA120','4.711424,-74.152176','0','20','350',259);
--Fila 32
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (32,'1520742555','2018-03-11T04:29:15Z','AVA120','4.711853,-74.152199','0','10','2',72);
--Fila 33
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (33,'1520742574','2018-03-11T04:29:34Z','AVA120','4.712227,-74.152237','0','15','357',159);
--Fila 34
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (34,'1520742592','2018-03-11T04:29:52Z','AVA120','4.712814,-74.152283','0','20','5',3);
--Fila 35
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (35,'1520742601','2018-03-11T04:30:01Z','AVA120','4.713112,-74.152107','0','23','42',83);
--Fila 36
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (36,'1520742607','2018-03-11T04:30:07Z','AVA120','4.71317,-74.151894','0','25','75',111);
--Fila 37
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (37,'1520742619','2018-03-11T04:30:19Z','AVA120','4.712751,-74.151192','0','19','132',78);
--Fila 38
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (38,'1520742625','2018-03-11T04:30:25Z','AVA120','4.712297,-74.150597','0','39','132',175);
--Fila 39
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (39,'1520742634','2018-03-11T04:30:34Z','AVA120','4.710551,-74.148293','0','80','132',247);
--Fila 40
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (40,'1520742743','2018-03-11T04:32:23Z','AVA120','4.702288,-74.075363','10575','215','13',169);
--Fila 41
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (41,'1520742756','2018-03-11T04:32:36Z','AVA120','4.714299,-74.072998','10975','218','11',272);
--Fila 42
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (42,'1520742768','2018-03-11T04:32:48Z','AVA120','4.726402,-74.070389','11125','230','12',107);
--Fila 43
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (43,'1520742779','2018-03-11T04:32:59Z','AVA120','4.739731,-74.067497','11300','244','12',279);
--Fila 44
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (44,'1520742791','2018-03-11T04:33:11Z','AVA120','4.753235,-74.064705','11475','257','11',243);
--Fila 45
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (45,'1520742803','2018-03-11T04:33:23Z','AVA120','4.767746,-74.061676','11650','271','12',28);
--Fila 46
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (46,'1520742815','2018-03-11T04:33:35Z','AVA120','4.783218,-74.058281','11875','284','12',258);
--Fila 47
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (47,'1520742830','2018-03-11T04:33:50Z','AVA120','4.803268,-74.053902','12175','300','12',146);
--Fila 48
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (48,'1520742864','2018-03-11T04:34:24Z','AVA120','4.849672,-74.043304','13325','313','14',245);
--Fila 49
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (49,'1520742897','2018-03-11T04:34:57Z','AVA120','4.896194,-74.028069','14350','318','19',113);
--Fila 50
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (50,'1520742930','2018-03-11T04:35:30Z','AVA120','4.943527,-74.012009','15275','326','19',280);
--Fallo de inserción en las filas  51  mediante  100 
--ORA-01400: no se puede realizar una inserción NULL en ("AVIANCA"."LOGS_VUELO"."ID_LOG_VUELO")
--Fila 51
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (51,'1520742963','2018-03-11T04:36:03Z','AVA120','4.991043,-73.995712','16325','332','18',26);
--Fila 52
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (52,'1520742996','2018-03-11T04:36:36Z','AVA120','5.041933,-73.980652','17375','338','14',221);
--Fila 53
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (53,'1520743029','2018-03-11T04:37:09Z','AVA120','5.092941,-73.968201','18175','351','14',262);
--Fila 54
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (54,'1520743090','2018-03-11T04:38:10Z','AVA120','5.194107,-73.942879','19100','389','14',125);
--Fila 55
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (55,'1520743153','2018-03-11T04:39:13Z','AVA120','5.311249,-73.913551','20025','428','14',130);
--Fila 56
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (56,'1520743214','2018-03-11T04:40:14Z','AVA120','5.425781,-73.885056','21950','412','13',58);
--Fila 57
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (57,'1520743277','2018-03-11T04:41:17Z','AVA120','5.546746,-73.855499','22775','423','13',171);
--Fila 58
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (58,'1520743338','2018-03-11T04:42:18Z','AVA120','5.665009,-73.831245','23950','429','11',33);
--Fila 59
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (59,'1520743401','2018-03-11T04:43:21Z','AVA120','5.790354,-73.805534','25375','440','11',223);
--Fila 60
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (60,'1520743462','2018-03-11T04:44:22Z','AVA120','5.911715,-73.776604','26700','455','21',223);
--Fila 61
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (61,'1520743468','2018-03-11T04:44:28Z','AVA120','5.922363,-73.771843','26800','458','25',43);
--Fila 62
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (62,'1520743474','2018-03-11T04:44:34Z','AVA120','5.934586,-73.765793','26950','459','26',89);
--Fila 63
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (63,'1520743480','2018-03-11T04:44:40Z','AVA120','5.94635,-73.759598','27075','461','27',297);
--Fila 64
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (64,'1520743486','2018-03-11T04:44:46Z','AVA120','5.958069,-73.753319','27200','462','28',198);
--Fila 65
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (65,'1520743552','2018-03-11T04:45:52Z','AVA120','6.083954,-73.68251','28450','474','32',204);
--Fila 66
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (66,'1520743613','2018-03-11T04:46:53Z','AVA120','6.198011,-73.610718','29600','480','31',32);
--Fila 67
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (67,'1520743646','2018-03-11T04:47:26Z','AVA120','6.261795,-73.571251','30000','487','31',6);
--Fila 68
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (68,'1520743740','2018-03-11T04:49:00Z','AVA120','6.445669,-73.457291','29975','523','31',222);
--Fila 69
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (69,'1520743773','2018-03-11T04:49:33Z','AVA120','6.516129,-73.406036','29975','529','41',74);
--Fila 70
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (70,'1520743837','2018-03-11T04:50:37Z','AVA120','6.631668,-73.302734','29975','514','41',90);
--Fila 71
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (71,'1520743859','2018-03-11T04:50:59Z','AVA120','6.666792,-73.27597','30000','514','34',265);
--Fila 72
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (72,'1520743948','2018-03-11T04:52:28Z','AVA120','6.87395,-73.26252','30000','500','349',244);
--Fila 73
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (73,'1520744010','2018-03-11T04:53:30Z','AVA120','7.015515,-73.289558','30000','495','348',152);
--Fila 74
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (74,'1520744072','2018-03-11T04:54:32Z','AVA120','7.153381,-73.325081','30000','496','344',41);
--Fila 75
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (75,'1520744118','2018-03-11T04:55:18Z','AVA120','7.25647,-73.349106','30000','502','354',104);
--Fila 76
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (76,'1520744124','2018-03-11T04:55:24Z','AVA120','7.270981,-73.349846','30000','504','358',132);
--Fila 77
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (77,'1520744149','2018-03-11T04:55:49Z','AVA120','7.329071,-73.343796','29975','511','11',53);
--Fila 78
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (78,'1520744155','2018-03-11T04:55:55Z','AVA120','7.343857,-73.339935','29975','513','15',84);
--Fila 79
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (79,'1520744168','2018-03-11T04:56:08Z','AVA120','7.372013,-73.329811','30000','516','21',128);
--Fila 80
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (80,'1520744176','2018-03-11T04:56:16Z','AVA120','7.39189,-73.321236','30000','518','23',273);
--Fila 81
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (81,'1520744182','2018-03-11T04:56:22Z','AVA120','7.405701,-73.31498','30000','518','24',114);
--Fila 82
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (82,'1520744244','2018-03-11T04:57:24Z','AVA120','7.54216,-73.252182','30625','522','24',274);
--Fila 83
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (83,'1520744300','2018-03-11T04:58:20Z','AVA120','7.66571,-73.202332','31625','512','14',134);
--Fila 84
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (84,'1520744306','2018-03-11T04:58:26Z','AVA120','7.680862,-73.199486','31775','509','9',153);
--Fila 85
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (85,'1520744316','2018-03-11T04:58:36Z','AVA120','7.702377,-73.197159','31925','506','4',287);
--Fila 86
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (86,'1520744322','2018-03-11T04:58:42Z','AVA120','7.716888,-73.196693','32050','504','1',133);
--Fila 87
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (87,'1520744343','2018-03-11T04:59:03Z','AVA120','7.765411,-73.201767','32375','498','349',193);
--Fila 88
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (88,'1520744349','2018-03-11T04:59:09Z','AVA120','7.779624,-73.204796','32475','497','347',13);
--Fila 89
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (89,'1520744371','2018-03-11T04:59:31Z','AVA120','7.827107,-73.219429','32825','493','339',70);
--Fila 90
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (90,'1520744377','2018-03-11T04:59:37Z','AVA120','7.840805,-73.225136','32925','492','336',204);
--Fila 91
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (91,'1520744383','2018-03-11T04:59:43Z','AVA120','7.853037,-73.230789','33000','490','334',87);
--Fila 92
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (92,'1520744389','2018-03-11T04:59:49Z','AVA120','7.865433,-73.237099','33100','490','332',97);
--Fila 93
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (93,'1520744395','2018-03-11T04:59:55Z','AVA120','7.877942,-73.244095','33175','489','330',20);
--Fila 94
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (94,'1520744460','2018-03-11T05:01:00Z','AVA120','8.003723,-73.322006','33475','503','328',63);
--Fila 95
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (95,'1520744521','2018-03-11T05:02:01Z','AVA120','8.127731,-73.398636','34125','510','328',221);
--Fila 96
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (96,'1520744582','2018-03-11T05:03:02Z','AVA120','8.24887,-73.473488','35300','503','328',174);
--Fila 97
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (97,'1520744643','2018-03-11T05:04:03Z','AVA120','8.37228,-73.549774','35975','505','328',211);
--Fila 98
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (98,'1520744705','2018-03-11T05:05:05Z','AVA120','8.49472,-73.62558','36000','505','328',252);
--Fila 99
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (99,'1520744767','2018-03-11T05:06:07Z','AVA120','8.615795,-73.7006','36000','503','328',178);
--Fila 100
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (100,'1520744806','2018-03-11T05:06:46Z','AVA120','8.697401,-73.746674','35975','507','338',279);
--Fallo de inserción en las filas  101  mediante  150 
--ORA-01400: no se puede realizar una inserción NULL en ("AVIANCA"."LOGS_VUELO"."ID_LOG_VUELO")
--Fila 101
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (101,'1520744812','2018-03-11T05:06:52Z','AVA120','8.711181,-73.751503','36000','508','342',123);
--Fila 102
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (102,'1520744818','2018-03-11T05:06:58Z','AVA120','8.724914,-73.755249','35975','509','346',138);
--Fila 103
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (103,'1520744824','2018-03-11T05:07:04Z','AVA120','8.739532,-73.758247','36000','510','349',232);
--Fila 104
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (104,'1520744830','2018-03-11T05:07:10Z','AVA120','8.754181,-73.760109','35975','512','353',135);
--Fila 105
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (105,'1520744837','2018-03-11T05:07:17Z','AVA120','8.76796,-73.760994','36000','513','357',54);
--Fila 106
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (106,'1520744861','2018-03-11T05:07:41Z','AVA120','8.827332,-73.754105','35975','517','14',83);
--Fila 107
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (107,'1520744868','2018-03-11T05:07:48Z','AVA120','8.840456,-73.750229','36000','518','16',78);
--Fila 108
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (108,'1520744931','2018-03-11T05:08:51Z','AVA120','8.987747,-73.70462','36000','517','17',182);
--Fila 109
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (109,'1520744993','2018-03-11T05:09:53Z','AVA120','9.128941,-73.659592','36000','517','20',232);
--Fila 110
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (110,'1520745054','2018-03-11T05:10:54Z','AVA120','9.263523,-73.598976','36175','520','25',201);
--Fila 111
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (111,'1520745115','2018-03-11T05:11:55Z','AVA120','9.395684,-73.534996','37000','513','25',273);
--Fila 112
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (112,'1520745176','2018-03-11T05:12:56Z','AVA120','9.527435,-73.470787','36975','515','25',104);
--Fila 113
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (113,'1520745237','2018-03-11T05:13:57Z','AVA120','9.658264,-73.407196','37000','517','25',6);
--Fila 114
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (114,'1520745299','2018-03-11T05:14:59Z','AVA120','9.791146,-73.342407','37000','520','25',199);
--Fila 115
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (115,'1520745360','2018-03-11T05:16:00Z','AVA120','9.924425,-73.277344','37000','519','25',165);
--Fila 116
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (116,'1520745421','2018-03-11T05:17:01Z','AVA120','10.057434,-73.212517','36975','518','25',7);
--Fila 117
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (117,'1520745483','2018-03-11T05:18:03Z','AVA120','10.189866,-73.147781','37025','521','25',235);
--Fila 118
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (118,'1520745538','2018-03-11T05:18:58Z','AVA120','10.301405,-73.093224','37000','522','25',262);
--Fila 119
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (119,'1520745624','2018-03-11T05:20:24Z','AVA120','10.498672,-72.99662','37000','523','25',219);
--Fila 120
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (120,'1520745685','2018-03-11T05:21:25Z','AVA120','10.633118,-72.930847','37000','521','25',119);
--Fila 121
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (121,'1520745746','2018-03-11T05:22:26Z','AVA120','10.766144,-72.865494','37000','523','25',22);
--Fila 122
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (122,'1520745807','2018-03-11T05:23:27Z','AVA120','10.899353,-72.800148','36975','525','25',260);
--Fila 123
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (123,'1520745869','2018-03-11T05:24:29Z','AVA120','11.035309,-72.73333','36975','526','25',23);
--Fila 124
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (124,'1520745933','2018-03-11T05:25:33Z','AVA120','11.176071,-72.664047','36975','527','25',193);
--Fila 125
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (125,'1520745994','2018-03-11T05:26:34Z','AVA120','11.309967,-72.598038','36975','528','25',153);
--Fila 126
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (126,'1520746055','2018-03-11T05:27:35Z','AVA120','11.444775,-72.531548','37000','528','25',239);
--Fila 127
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (127,'1520746116','2018-03-11T05:28:36Z','AVA120','11.57931,-72.465004','36975','528','25',246);
--Fila 128
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (128,'1520746178','2018-03-11T05:29:38Z','AVA120','11.715848,-72.3974','36975','528','26',118);
--Fila 129
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (129,'1520746239','2018-03-11T05:30:39Z','AVA120','11.850896,-72.330566','36975','530','25',91);
--Fila 130
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (130,'1520746260','2018-03-11T05:31:00Z','AVA120','11.896729,-72.307892','36975','530','25',70);
--Fila 131
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (131,'1520746350','2018-03-11T05:32:30Z','AVA120','12.098088,-72.207932','36975','531','25',267);
--Fila 132
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (132,'1520746412','2018-03-11T05:33:32Z','AVA120','12.234695,-72.140022','36975','533','26',50);
--Fila 133
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (133,'1520746473','2018-03-11T05:34:33Z','AVA120','12.369644,-72.072868','37000','532','26',81);
--Fila 134
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (134,'1520746534','2018-03-11T05:35:34Z','AVA120','12.506678,-72.00473','37000','533','25',76);
--Fila 135
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (135,'1520746596','2018-03-11T05:36:36Z','AVA120','12.643029,-71.936691','37000','532','26',113);
--Fila 136
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (136,'1520746659','2018-03-11T05:37:39Z','AVA120','12.780624,-71.86631','36975','533','28',151);
--Fila 137
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (137,'1520746668','2018-03-11T05:37:48Z','AVA120','12.801167,-71.851746','36975','534','36',106);
--Fila 138
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (138,'1520746674','2018-03-11T05:37:54Z','AVA120','12.811967,-71.842827','36975','534','39',160);
--Fila 139
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (139,'1520746680','2018-03-11T05:38:00Z','AVA120','12.823975,-71.831833','36975','535','42',21);
--Fila 140
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (140,'1520746687','2018-03-11T05:38:07Z','AVA120','12.834684,-71.8209','37000','535','45',102);
--Fila 141
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (141,'1520746693','2018-03-11T05:38:13Z','AVA120','12.845252,-71.808762','37025','535','49',191);
--Fila 142
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (142,'1520746700','2018-03-11T05:38:20Z','AVA120','12.855447,-71.795654','37000','535','52',281);
--Fila 143
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (143,'1520746708','2018-03-11T05:38:28Z','AVA120','12.867643,-71.778404','36975','536','54',29);
--Fila 144
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (144,'1520746714','2018-03-11T05:38:34Z','AVA120','12.87735,-71.764587','37000','536','54',25);
--Fila 145
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (145,'1520746739','2018-03-11T05:38:59Z','AVA120','12.91246,-71.71534','37000','536','54',279);
--Fila 146
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (146,'1520746836','2018-03-11T05:40:36Z','AVA120','13.053909,-71.515884','36975','537','54',287);
--Fila 147
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (147,'1520746897','2018-03-11T05:41:37Z','AVA120','13.144089,-71.388687','36975','538','54',216);
--Fila 148
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (148,'1520746958','2018-03-11T05:42:38Z','AVA120','13.233948,-71.261681','37000','539','54',239);
--Fila 149
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (149,'1520747021','2018-03-11T05:43:41Z','AVA120','13.32427,-71.133873','37000','534','54',250);
--Fila 150
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (150,'1520747086','2018-03-11T05:44:46Z','AVA120','13.41966,-70.998657','37800','531','54',126);

--ORA-01400: no se puede realizar una inserción NULL en ("AVIANCA"."LOGS_VUELO"."ID_LOG_VUELO")
--Fila 151
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (151,'1520747151','2018-03-11T05:45:51Z','AVA120','13.51481,-70.863548','38775','530','54',273);
--Fila 152
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (152,'1520747216','2018-03-11T05:46:56Z','AVA120','13.60871,-70.72979','39000','530','54',262);
--Fila 153
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (153,'1520747281','2018-03-11T05:48:01Z','AVA120','13.70068,-70.598846','38975','527','55',102);
--Fila 154
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (154,'1520747346','2018-03-11T05:49:06Z','AVA120','13.79571,-70.46347','39000','529','54',255);
--Fila 155
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (155,'1520747411','2018-03-11T05:50:11Z','AVA120','13.88933,-70.32975','38975','530','55',173);
--Fila 156
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (156,'1520747476','2018-03-11T05:51:16Z','AVA120','13.98178,-70.197243','38975','530','55',185);
--Fila 157
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (157,'1520747541','2018-03-11T05:52:21Z','AVA120','14.07665,-70.061546','38975','532','55',201);
--Fila 158
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (158,'1520747606','2018-03-11T05:53:26Z','AVA120','14.17191,-69.924622','39000','532','55',29);
--Fila 159
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (159,'1520747671','2018-03-11T05:54:31Z','AVA120','14.26447,-69.791496','39000','531','55',41);
--Fila 160
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (160,'1520747736','2018-03-11T05:55:36Z','AVA120','14.35936,-69.654716','39025','535','54',66);
--Fila 161
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (161,'1520747801','2018-03-11T05:56:41Z','AVA120','14.45261,-69.520248','38975','531','55',97);
--Fila 162
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (162,'1520747866','2018-03-11T05:57:46Z','AVA120','14.54697,-69.38401','38975','533','55',85);
--Fila 163
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (163,'1520747931','2018-03-11T05:58:51Z','AVA120','14.63942,-69.250053','39000','537','54',92);
--Fila 164
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (164,'1520747996','2018-03-11T05:59:56Z','AVA120','14.73262,-69.114853','38975','536','54',155);
--Fila 165
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (165,'1520748062','2018-03-11T06:01:02Z','AVA120','14.82596,-68.979317','39000','535','54',46);
--Fila 166
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (166,'1520748126','2018-03-11T06:02:06Z','AVA120','14.92083,-68.841263','39000','533','54',257);
--Fila 167
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (167,'1520748191','2018-03-11T06:03:11Z','AVA120','15.01268,-68.70742','38975','534','54',227);
--Fila 168
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (168,'1520748256','2018-03-11T06:04:16Z','AVA120','15.10437,-68.573532','38975','535','54',103);
--Fila 169
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (169,'1520748321','2018-03-11T06:05:21Z','AVA120','15.19591,-68.439583','38975','534','54',220);
--Fila 170
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (170,'1520748361','2018-03-11T06:06:01Z','AVA120','15.24902,-68.361847','39000','533','54',136);
--Fila 171
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (171,'1520748445','2018-03-11T06:07:25Z','AVA120','15.357211,-68.195274','39000','530','57',44);
--Fila 172
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (172,'1520748520','2018-03-11T06:08:40Z','AVA120','15.431131,-68.080063','39000','530','55',297);
--Fila 173
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (173,'1520748581','2018-03-11T06:09:41Z','AVA120','15.510069,-67.959702','39000','530','55',239);
--Fila 174
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (174,'1520748672','2018-03-11T06:11:12Z','AVA120','15.696442,-67.703247','38975','534','55',255);
--Fila 175
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (175,'1520748699','2018-03-11T06:11:39Z','AVA120','15.733887,-67.647881','39000','534','55',39);
--Fila 176
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (176,'1520748811','2018-03-11T06:13:31Z','AVA120','15.874952,-67.428505','39000','530','55',44);
--Fila 177
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (177,'1520748874','2018-03-11T06:14:34Z','AVA120','15.957036,-67.296959','39000','530','56',83);
--Fila 178
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (178,'1520748935','2018-03-11T06:15:35Z','AVA120','16.059359,-67.145203','38975','535','56',19);
--Fila 179
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (179,'1520748996','2018-03-11T06:16:36Z','AVA120','16.143631,-67.012215','38975','538','56',38);
--Fila 180
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (180,'1520749057','2018-03-11T06:17:37Z','AVA120','16.227692,-66.87957','38975','542','56',183);
--Fila 181
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (181,'1520749097','2018-03-11T06:18:17Z','AVA120','16.280731,-66.79567','38975','542','56',74);
--Fila 182
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (182,'1520749186','2018-03-11T06:19:46Z','AVA120','16.404419,-66.599602','38975','544','57',92);
--Fila 183
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (183,'1520749247','2018-03-11T06:20:47Z','AVA120','16.487137,-66.468155','38975','544','56',8);
--Fila 184
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (184,'1520749310','2018-03-11T06:21:50Z','AVA120','16.576218,-66.32634','39000','545','56',249);
--Fila 185
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (185,'1520749368','2018-03-11T06:22:48Z','AVA120','16.652939,-66.204002','38975','542','56',190);
--Fila 186
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (186,'1520749459','2018-03-11T06:24:19Z','AVA120','16.780453,-66.000168','38975','542','56',106);
--Fila 187
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (187,'1520749520','2018-03-11T06:25:20Z','AVA120','16.863373,-65.86718','38975','540','57',209);
--Fila 188
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (188,'1520749581','2018-03-11T06:26:21Z','AVA120','16.9459,-65.734436','38975','537','57',251);
--Fila 189
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (189,'1520749644','2018-03-11T06:27:24Z','AVA120','17.031368,-65.596962','38975','537','57',238);
--Fila 190
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (190,'1520749705','2018-03-11T06:28:25Z','AVA120','17.114185,-65.463753','39000','537','57',63);
--Fila 191
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (191,'1520749766','2018-03-11T06:29:26Z','AVA120','17.196442,-65.330971','38975','537','57',106);
--Fila 192
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (192,'1520749827','2018-03-11T06:30:27Z','AVA120','17.278931,-65.19735','39000','541','57',128);
--Fila 193
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (193,'1520749888','2018-03-11T06:31:28Z','AVA120','17.361832,-65.062767','39000','540','57',163);
--Fila 194
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (194,'1520749949','2018-03-11T06:32:29Z','AVA120','17.444046,-64.92939','39000','539','57',232);
--Fila 195
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (195,'1520750012','2018-03-11T06:33:32Z','AVA120','17.529694,-64.789993','38975','541','57',68);
--Fila 196
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (196,'1520750073','2018-03-11T06:34:33Z','AVA120','17.612387,-64.65493','39000','542','57',115);
--Fila 197
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (197,'1520750134','2018-03-11T06:35:34Z','AVA120','17.694738,-64.520256','38975','542','57',263);
--Fila 198
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (198,'1520750195','2018-03-11T06:36:35Z','AVA120','17.776703,-64.385902','39000','542','57',260);
--Fila 199
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (199,'1520750256','2018-03-11T06:37:36Z','AVA120','17.858974,-64.250893','38975','542','57',55);
--Fila 200
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (200,'1520750320','2018-03-11T06:38:40Z','AVA120','17.944817,-64.109642','39000','543','57',167);
--Fallo de inserción en las filas  201  mediante  250 
--ORA-01400: no se puede realizar una inserción NULL en ("AVIANCA"."LOGS_VUELO"."ID_LOG_VUELO")
--Fila 201
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (201,'1520750383','2018-03-11T06:39:43Z','AVA120','18.030716,-63.967945','38975','542','57',144);
--Fila 202
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (202,'1520750445','2018-03-11T06:40:45Z','AVA120','18.113243,-63.831646','38975','542','57',103);
--Fila 203
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (203,'1520750508','2018-03-11T06:41:48Z','AVA120','18.199318,-63.689194','39000','542','57',39);
--Fila 204
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (204,'1520750569','2018-03-11T06:42:49Z','AVA120','18.280226,-63.554859','38975','543','57',181);
--Fila 205
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (205,'1520750630','2018-03-11T06:43:50Z','AVA120','18.362995,-63.417179','38975','544','57',112);
--Fila 206
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (206,'1520750691','2018-03-11T06:44:51Z','AVA120','18.444229,-63.281898','38975','541','57',106);
--Fila 207
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (207,'1520750752','2018-03-11T06:45:52Z','AVA120','18.52533,-63.146374','39000','543','57',45);
--Fila 208
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (208,'1520750813','2018-03-11T06:46:53Z','AVA120','18.60672,-63.010174','38975','543','58',293);
--Fila 209
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (209,'1520750874','2018-03-11T06:47:54Z','AVA120','18.688614,-62.872746','39000','544','58',195);
--Fila 210
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (210,'1520750937','2018-03-11T06:48:57Z','AVA120','18.773958,-62.729435','38975','545','58',267);
--Fila 211
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (211,'1520750998','2018-03-11T06:49:58Z','AVA120','18.856018,-62.591221','38975','545','58',21);
--Fila 212
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (212,'1520751047','2018-03-11T06:50:47Z','AVA120','18.920551,-62.482243','39000','545','58',83);
--Fila 213
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (213,'1520751135','2018-03-11T06:52:15Z','AVA120','19.03791,-62.28389','39000','546','58',286);
--Fila 214
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (214,'1520751196','2018-03-11T06:53:16Z','AVA120','19.12001,-62.144409','39000','546','58',220);
--Fila 215
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (215,'1520751257','2018-03-11T06:54:17Z','AVA120','19.201542,-62.005688','38975','546','58',89);
--Fila 216
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (216,'1520751318','2018-03-11T06:55:18Z','AVA120','19.28334,-61.866417','38975','548','58',105);
--Fila 217
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (217,'1520751379','2018-03-11T06:56:19Z','AVA120','19.357498,-61.723251','38975','554','66',291);
--Fila 218
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (218,'1520751441','2018-03-11T06:57:21Z','AVA120','19.416321,-61.569','38975','552','68',274);
--Fila 219
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (219,'1520751503','2018-03-11T06:58:23Z','AVA120','19.475361,-61.412376','39000','551','68',197);
--Fila 220
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (220,'1520751516','2018-03-11T06:58:36Z','AVA120','19.486633,-61.382526','39000','551','68',238);
--Fila 221
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (221,'1520751570','2018-03-11T06:59:30Z','AVA120','19.537043,-61.248428','39000','551','68',188);
--Fila 222
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (222,'1520751650','2018-03-11T07:00:50Z','AVA120','19.592958,-61.092804','39000','556','66',216);
--Fila 223
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (223,'1520752079','2018-03-11T07:07:59Z','AVA120','19.995407,-60.011318','39000','561','130',85);
--Fila 224
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (224,'1520752217','2018-03-11T07:10:17Z','AVA120','20.180849,-59.679356','39000','562','53',195);
--Fila 225
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (225,'1520752799','2018-03-11T07:19:59Z','AVA120','21.022758,-58.355595','39000','565','120',74);
--Fila 226
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (226,'1520753363','2018-03-11T07:29:23Z','AVA120','21.886786,-57.036564','39000','567','100',177);
--Fila 227
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (227,'1520753954','2018-03-11T07:39:14Z','AVA120','22.738001,-55.680325','39000','569','124',160);
--Fila 228
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (228,'1520754517','2018-03-11T07:48:37Z','AVA120','23.565166,-54.311554','39000','572','105',124);
--Fila 229
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (229,'1520755100','2018-03-11T07:58:20Z','AVA120','24.388018,-52.887096','39000','572','120',121);
--Fila 230
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (230,'1520755668','2018-03-11T08:07:48Z','AVA120','25.199556,-51.457451','39000','574','113',200);
--Fila 231
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (231,'1520756250','2018-03-11T08:17:30Z','AVA120','26.003971,-50.000546','39000','566','120',28);
--Fila 232
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (232,'1520756273','2018-03-11T08:17:53Z','AVA120','26.018661,-49.970455','39000','566','172',167);
--Fila 233
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (233,'1520756835','2018-03-11T08:27:15Z','AVA120','26.887695,-48.628487','39000','564','73',265);
--Fila 234
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (234,'1520756977','2018-03-11T08:29:37Z','AVA120','27.132244,-48.275105','39200','564','52',158);
--Fila 235
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (235,'1520757054','2018-03-11T08:30:54Z','AVA120','27.252253,-48.102009','39800','564','53',280);
--Fila 236
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (236,'1520757404','2018-03-11T08:36:44Z','AVA120','27.8009,-47.25322','40000','566','54',87);
--Fila 237
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (237,'1520757987','2018-03-11T08:46:27Z','AVA120','28.686796,-45.834522','40000','566','116',220);
--Fila 238
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (238,'1520758554','2018-03-11T08:55:54Z','AVA120','29.536245,-44.407745','40000','565','107',31);
--Fila 239
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (239,'1520759140','2018-03-11T09:05:40Z','AVA120','30.387949,-42.949448','40000','566','113',232);
--Fila 240
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (240,'1520759703','2018-03-11T09:15:03Z','AVA120','31.216167,-41.463406','40000','572','104',15);
--Fila 241
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (241,'1520763165','2018-03-11T10:12:45Z','AVA120','36.539364,-32.71302','40000','552','55',83);
--Fila 242
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (242,'1520763239','2018-03-11T10:13:59Z','AVA120','36.646133,-32.52182','39975','550','55',157);
--Fila 243
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (243,'1520763302','2018-03-11T10:15:02Z','AVA120','36.737072,-32.35836','40000','545','55',249);
--Fila 244
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (244,'1520763356','2018-03-11T10:15:56Z','AVA120','36.815464,-32.216763','39975','543','55',45);
--Fila 245
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (245,'1520763388','2018-03-11T10:16:28Z','AVA120','36.841999,-32.1689','40000','543','55',190);
--Fila 246
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (246,'1520763477','2018-03-11T10:17:57Z','AVA120','36.98645,-31.90555','40000','545','55',102);
--Fila 247
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (247,'1520763540','2018-03-11T10:19:00Z','AVA120','37.075424,-31.742891','39975','549','55',19);
--Fila 248
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (248,'1520763603','2018-03-11T10:20:03Z','AVA120','37.16684,-31.574648','39975','553','55',176);
--Fila 249
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (249,'1520763667','2018-03-11T10:21:07Z','AVA120','37.256424,-31.408392','40000','548','56',272);
--Fila 250
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (250,'1520763729','2018-03-11T10:22:09Z','AVA120','37.345928,-31.24255','39975','548','55',9);
--Fallo de inserción en las filas  251  mediante  300 
--ORA-01400: no se puede realizar una inserción NULL en ("AVIANCA"."LOGS_VUELO"."ID_LOG_VUELO")
--Fila 251
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (251,'1520763792','2018-03-11T10:23:12Z','AVA120','37.43391,-31.077576','39975','547','56',70);
--Fila 252
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (252,'1520763855','2018-03-11T10:24:15Z','AVA120','37.522339,-30.911787','40000','547','56',126);
--Fila 253
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (253,'1520763917','2018-03-11T10:25:17Z','AVA120','37.6096,-30.74703','40000','548','56',6);
--Fila 254
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (254,'1520763979','2018-03-11T10:26:19Z','AVA120','37.696884,-30.581638','40000','548','56',282);
--Fila 255
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (255,'1520764041','2018-03-11T10:27:21Z','AVA120','37.782822,-30.41762','40000','547','56',249);
--Fila 256
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (256,'1520764103','2018-03-11T10:28:23Z','AVA120','37.869324,-30.251965','40000','545','56',119);
--Fila 257
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (257,'1520764166','2018-03-11T10:29:26Z','AVA120','37.956253,-30.084833','39975','545','56',82);
--Fila 258
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (258,'1520764228','2018-03-11T10:30:28Z','AVA120','38.054489,-29.933653','39975','536','43',69);
--Fila 259
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (259,'1520764290','2018-03-11T10:31:30Z','AVA120','38.164967,-29.799519','40000','531','43',69);
--Fila 260
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (260,'1520764353','2018-03-11T10:32:33Z','AVA120','38.275772,-29.663788','40000','527','44',125);
--Fila 261
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (261,'1520764415','2018-03-11T10:33:35Z','AVA120','38.384182,-29.530653','40000','526','44',154);
--Fila 262
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (262,'1520764476','2018-03-11T10:34:36Z','AVA120','38.492508,-29.396973','40000','526','44',167);
--Fila 263
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (263,'1520764538','2018-03-11T10:35:38Z','AVA120','38.599533,-29.264404','40000','530','44',136);
--Fila 264
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (264,'1520764599','2018-03-11T10:36:39Z','AVA120','38.706604,-29.130859','40000','528','44',23);
--Fila 265
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (265,'1520764660','2018-03-11T10:37:40Z','AVA120','38.814331,-28.996443','40000','529','44',259);
--Fila 266
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (266,'1520764722','2018-03-11T10:38:42Z','AVA120','38.92149,-28.861816','39975','530','44',179);
--Fila 267
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (267,'1520764784','2018-03-11T10:39:44Z','AVA120','39.030258,-28.724531','39975','533','44',49);
--Fila 268
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (268,'1520764846','2018-03-11T10:40:46Z','AVA120','39.135303,-28.591492','40000','531','44',133);
--Fila 269
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (269,'1520764909','2018-03-11T10:41:49Z','AVA120','39.244354,-28.45262','40000','528','44',91);
--Fila 270
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (270,'1520764971','2018-03-11T10:42:51Z','AVA120','39.354675,-28.311529','40000','526','44',73);
--Fila 271
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (271,'1520765032','2018-03-11T10:43:52Z','AVA120','39.461494,-28.174316','40000','531','45',279);
--Fila 272
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (272,'1520765097','2018-03-11T10:44:57Z','AVA120','39.574944,-28.027954','39975','534','44',294);
--Fila 273
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (273,'1520765168','2018-03-11T10:46:08Z','AVA120','39.699329,-27.866333','40000','534','44',63);
--Fila 274
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (274,'1520765229','2018-03-11T10:47:09Z','AVA120','39.805893,-27.727402','40000','533','44',144);
--Fila 275
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (275,'1520765248','2018-03-11T10:47:28Z','AVA120','39.836792,-27.68692','39975','533','45',89);
--Fila 276
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (276,'1520765277','2018-03-11T10:47:57Z','AVA120','39.887878,-27.619987','40000','533','31',59);
--Fila 277
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (277,'1520765297','2018-03-11T10:48:17Z','AVA120','39.924637,-27.571716','39975','533','45',150);
--Fila 278
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (278,'1520765391','2018-03-11T10:49:51Z','AVA120','40.082886,-27.363159','39975','535','29',9);
--Fila 279
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (279,'1520765453','2018-03-11T10:50:53Z','AVA120','40.19241,-27.217754','40000','533','45',1);
--Fila 280
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (280,'1520765514','2018-03-11T10:51:54Z','AVA120','40.298363,-27.076616','39975','532','45',276);
--Fila 281
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (281,'1520765580','2018-03-11T10:53:00Z','AVA120','40.404968,-26.933716','40000','531','45',232);
--Fila 282
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (282,'1520765630','2018-03-11T10:53:50Z','AVA120','40.498444,-26.807983','40000','529','45',158);
--Fila 283
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (283,'1520765726','2018-03-11T10:55:26Z','AVA120','40.662357,-26.586227','39975','529','45',58);
--Fila 284
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (284,'1520765790','2018-03-11T10:56:30Z','AVA120','40.767982,-26.442282','40000','525','46',140);
--Fila 285
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (285,'1520765855','2018-03-11T10:57:35Z','AVA120','40.879196,-26.290033','39975','524','46',93);
--Fila 286
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (286,'1520765930','2018-03-11T10:58:50Z','AVA120','41.00354,-26.118958','40000','526','46',244);
--Fila 287
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (287,'1520765993','2018-03-11T10:59:53Z','AVA120','41.11042,-25.970993','40000','526','46',158);
--Fila 288
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (288,'1520766057','2018-03-11T11:00:57Z','AVA120','41.217636,-25.821838','40000','522','46',254);
--Fila 289
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (289,'1520771314','2018-03-11T12:28:34Z','AVA120','48.930916,-11.692345','41000','518','68',167);
--Fila 290
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (290,'1520771378','2018-03-11T12:29:38Z','AVA120','48.982773,-11.479656','41000','519','70',184);
--Fila 291
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (291,'1520771441','2018-03-11T12:30:41Z','AVA120','49.033985,-11.263949','41000','517','70',70);
--Fila 292
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (292,'1520771504','2018-03-11T12:31:44Z','AVA120','49.085144,-11.04603','41000','515','70',83);
--Fila 293
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (293,'1520771567','2018-03-11T12:32:47Z','AVA120','49.135281,-10.830351','40975','517','70',99);
--Fila 294
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (294,'1520771630','2018-03-11T12:33:50Z','AVA120','49.185184,-10.613227','41000','515','70',158);
--Fila 295
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (295,'1520771691','2018-03-11T12:34:51Z','AVA120','49.232204,-10.406727','40975','515','70',150);
--Fila 296
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (296,'1520771754','2018-03-11T12:35:54Z','AVA120','49.281132,-10.189603','41000','514','71',19);
--Fila 297
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (297,'1520771817','2018-03-11T12:36:57Z','AVA120','49.329544,-9.972839','40975','513','71',182);
--Fila 298
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (298,'1520771881','2018-03-11T12:38:01Z','AVA120','49.377686,-9.754732','41000','513','71',102);
--Fila 299
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (299,'1520771943','2018-03-11T12:39:03Z','AVA120','49.42535,-9.536711','41000','517','71',284);
--Fila 300
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (300,'1520772006','2018-03-11T12:40:06Z','AVA120','49.472645,-9.317742','41000','519','71',140);
--Fallo de inserción en las filas  301  mediante  350 
--ORA-01400: no se puede realizar una inserción NULL en ("AVIANCA"."LOGS_VUELO"."ID_LOG_VUELO")
--Fila 301
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (301,'1520772069','2018-03-11T12:41:09Z','AVA120','49.519913,-9.096246','41000','516','72',111);
--Fila 302
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (302,'1520772130','2018-03-11T12:42:10Z','AVA120','49.563747,-8.889201','41000','513','71',151);
--Fila 303
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (303,'1520772193','2018-03-11T12:43:13Z','AVA120','49.609772,-8.669514','40975','514','72',154);
--Fila 304
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (304,'1520772256','2018-03-11T12:44:16Z','AVA120','49.655178,-8.450417','40975','515','72',281);
--Fila 305
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (305,'1520772317','2018-03-11T12:45:17Z','AVA120','49.698658,-8.238187','40975','518','72',24);
--Fila 306
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (306,'1520772379','2018-03-11T12:46:19Z','AVA120','49.74353,-8.016116','41000','517','72',230);
--Fila 307
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (307,'1520772442','2018-03-11T12:47:22Z','AVA120','49.787338,-7.792128','40975','519','73',294);
--Fila 308
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (308,'1520772506','2018-03-11T12:48:26Z','AVA120','49.830818,-7.568541','40975','519','73',218);
--Fila 309
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (309,'1520772569','2018-03-11T12:49:29Z','AVA120','49.874111,-7.343544','41000','521','73',76);
--Fila 310
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (310,'1520772630','2018-03-11T12:50:30Z','AVA120','49.915077,-7.127974','40975','523','73',110);
--Fila 311
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (311,'1520772692','2018-03-11T12:51:32Z','AVA120','49.957535,-6.902088','41000','523','73',163);
--Fila 312
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (312,'1520772753','2018-03-11T12:52:33Z','AVA120','49.998093,-6.68388','41000','520','74',65);
--Fila 313
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (313,'1520772815','2018-03-11T12:53:35Z','AVA120','50.039513,-6.457957','41000','519','74',93);
--Fila 314
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (314,'1520772876','2018-03-11T12:54:36Z','AVA120','50.078659,-6.241825','40975','519','74',196);
--Fila 315
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (315,'1520772937','2018-03-11T12:55:37Z','AVA120','50.117069,-6.027337','40975','520','74',167);
--Fila 316
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (316,'1520772999','2018-03-11T12:56:39Z','AVA120','50.157524,-5.798777','41000','520','74',16);
--Fila 317
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (317,'1520773062','2018-03-11T12:57:42Z','AVA120','50.197586,-5.569345','40975','520','74',218);
--Fila 318
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (318,'1520773129','2018-03-11T12:58:49Z','AVA120','50.237869,-5.335163','41000','520','75',232);
--Fila 319
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (319,'1520773192','2018-03-11T12:59:52Z','AVA120','50.277603,-5.101849','41000','521','75',93);
--Fila 320
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (320,'1520773255','2018-03-11T13:00:55Z','AVA120','50.316101,-4.87222','41000','517','75',157);
--Fila 321
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (321,'1520773318','2018-03-11T13:01:58Z','AVA120','50.352158,-4.654046','40975','516','75',57);
--Fila 322
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (322,'1520773379','2018-03-11T13:02:59Z','AVA120','50.389938,-4.422503','40975','517','75',128);
--Fila 323
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (323,'1520773442','2018-03-11T13:04:02Z','AVA120','50.425896,-4.199895','41000','519','75',76);
--Fila 324
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (324,'1520773504','2018-03-11T13:05:04Z','AVA120','50.461578,-3.975605','41000','519','76',230);
--Fila 325
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (325,'1520773568','2018-03-11T13:06:08Z','AVA120','50.497787,-3.743953','40825','521','76',96);
--Fila 326
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (326,'1520773631','2018-03-11T13:07:11Z','AVA120','50.534637,-3.505867','38200','515','76',119);
--Fila 327
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (327,'1520773692','2018-03-11T13:08:12Z','AVA120','50.568394,-3.285209','35500','515','76',150);
--Fila 328
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (328,'1520773755','2018-03-11T13:09:15Z','AVA120','50.602562,-3.0565','32425','504','77',290);
--Fila 329
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (329,'1520773819','2018-03-11T13:10:19Z','AVA120','50.635242,-2.835735','30075','482','76',285);
--Fila 330
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (330,'1520773882','2018-03-11T13:11:22Z','AVA120','50.666153,-2.623347','28025','470','77',105);
--Fila 331
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (331,'1520773945','2018-03-11T13:12:25Z','AVA120','50.677883,-2.417374','26400','440','93',12);
--Fila 332
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (332,'1520774008','2018-03-11T13:13:28Z','AVA120','50.669411,-2.21768','25175','424','93',111);
--Fila 333
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (333,'1520774071','2018-03-11T13:14:31Z','AVA120','50.662445,-2.036229','24000','363','91',147);
--Fila 334
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (334,'1520774136','2018-03-11T13:15:36Z','AVA120','50.662769,-1.87534','23025','348','89',231);
--Fila 335
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (335,'1520774199','2018-03-11T13:16:39Z','AVA120','50.664379,-1.7158','22025','344','89',198);
--Fila 336
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (336,'1520774262','2018-03-11T13:17:42Z','AVA120','50.670437,-1.559316','21050','343','78',24);
--Fila 337
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (337,'1520774268','2018-03-11T13:17:48Z','AVA120','50.673275,-1.540909','20900','342','75',247);
--Fila 338
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (338,'1520774274','2018-03-11T13:17:54Z','AVA120','50.67588,-1.526489','20750','342','73',278);
--Fila 339
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (339,'1520774283','2018-03-11T13:18:03Z','AVA120','50.680435,-1.505498','20550','343','69',275);
--Fila 340
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (340,'1520774292','2018-03-11T13:18:12Z','AVA120','50.685425,-1.486124','20325','343','66',76);
--Fila 341
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (341,'1520774298','2018-03-11T13:18:18Z','AVA120','50.688961,-1.474075','20200','343','64',237);
--Fila 342
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (342,'1520774304','2018-03-11T13:18:24Z','AVA120','50.693665,-1.459029','20025','343','63',184);
--Fila 343
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (343,'1520774371','2018-03-11T13:19:31Z','AVA120','50.7388,-1.312495','18400','336','64',97);
--Fila 344
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (344,'1520774398','2018-03-11T13:19:58Z','AVA120','50.760406,-1.256895','17725','343','52',31);
--Fila 345
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (345,'1520774404','2018-03-11T13:20:04Z','AVA120','50.768196,-1.242065','17550','343','49',62);
--Fila 346
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (346,'1520774410','2018-03-11T13:20:10Z','AVA120','50.774826,-1.230914','17400','343','46',289);
--Fila 347
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (347,'1520774419','2018-03-11T13:20:19Z','AVA120','50.785091,-1.215668','17175','343','44',91);
--Fila 348
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (348,'1520774428','2018-03-11T13:20:28Z','AVA120','50.796112,-1.201667','16950','343','37',29);
--Fila 349
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (349,'1520774439','2018-03-11T13:20:39Z','AVA120','50.811081,-1.185558','16650','343','32',162);
--Fila 350
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (350,'1520774446','2018-03-11T13:20:46Z','AVA120','50.820465,-1.176205','16475','343','32',219);
--Fallo de inserción en las filas  351  mediante  400 
--ORA-01400: no se puede realizar una inserción NULL en ("AVIANCA"."LOGS_VUELO"."ID_LOG_VUELO")
--Fila 351
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (351,'1520774483','2018-03-11T13:21:23Z','AVA120','50.868511,-1.12656','15575','332','33',271);
--Fila 352
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (352,'1520774514','2018-03-11T13:21:54Z','AVA120','50.90918,-1.084232','14800','334','33',210);
--Fila 353
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (353,'1520774549','2018-03-11T13:22:29Z','AVA120','50.955334,-1.036377','13950','323','33',189);
--Fila 354
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (354,'1520774583','2018-03-11T13:23:03Z','AVA120','50.995193,-0.992481','13175','315','38',28);
--Fila 355
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (355,'1520774616','2018-03-11T13:23:36Z','AVA120','51.029572,-0.941187','12975','311','47',251);
--Fila 356
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (356,'1520774648','2018-03-11T13:24:08Z','AVA120','51.06152,-0.884323','13000','311','48',260);
--Fila 357
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (357,'1520774679','2018-03-11T13:24:39Z','AVA120','51.090271,-0.833254','12950','310','48',295);
--Fila 358
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (358,'1520774712','2018-03-11T13:25:12Z','AVA120','51.121574,-0.777283','12125','308','48',237);
--Fila 359
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (359,'1520774745','2018-03-11T13:25:45Z','AVA120','51.151932,-0.722871','11450','303','48',276);
--Fila 360
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (360,'1520774757','2018-03-11T13:25:57Z','AVA120','51.159943,-0.708544','11225','303','48',277);
--Fila 361
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (361,'1520774769','2018-03-11T13:26:09Z','AVA120','51.174774,-0.681895','10875','301','48',76);
--Fila 362
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (362,'1520774781','2018-03-11T13:26:21Z','AVA120','51.185806,-0.662075','10600','299','48',59);
--Fila 363
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (363,'1520774793','2018-03-11T13:26:33Z','AVA120','51.19725,-0.641735','10275','299','48',22);
--Fila 364
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (364,'1520774805','2018-03-11T13:26:45Z','AVA120','51.208282,-0.621989','10100','298','48',266);
--Fila 365
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (365,'1520774817','2018-03-11T13:26:57Z','AVA120','51.219425,-0.601959','9975','297','48',202);
--Fila 366
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (366,'1520774832','2018-03-11T13:27:12Z','AVA120','51.232693,-0.578003','10000','282','48',139);
--Fila 367
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (367,'1520774844','2018-03-11T13:27:24Z','AVA120','51.242935,-0.55954','10025','278','48',86);
--Fila 368
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (368,'1520774856','2018-03-11T13:27:36Z','AVA120','51.253269,-0.540771','9975','282','48',41);
--Fila 369
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (369,'1520774868','2018-03-11T13:27:48Z','AVA120','51.262905,-0.5233','9975','282','48',206);
--Fila 370
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (370,'1520774880','2018-03-11T13:28:00Z','AVA120','51.273891,-0.503387','10000','280','48',104);
--Fila 371
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (371,'1520774896','2018-03-11T13:28:16Z','AVA120','51.286739,-0.480194','10000','281','48',62);
--Fila 372
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (372,'1520774910','2018-03-11T13:28:30Z','AVA120','51.299011,-0.457937','10000','279','48',72);
--Fila 373
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (373,'1520774922','2018-03-11T13:28:42Z','AVA120','51.309906,-0.438265','9975','274','48',137);
--Fila 374
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (374,'1520774934','2018-03-11T13:28:54Z','AVA120','51.319794,-0.420301','10025','272','49',221);
--Fila 375
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (375,'1520774946','2018-03-11T13:29:06Z','AVA120','51.329708,-0.401993','9975','275','51',4);
--Fila 376
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (376,'1520774955','2018-03-11T13:29:15Z','AVA120','51.335201,-0.38765','9975','270','64',33);
--Fila 377
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (377,'1520774962','2018-03-11T13:29:22Z','AVA120','51.337856,-0.374908','9975','269','69',70);
--Fila 378
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (378,'1520774970','2018-03-11T13:29:30Z','AVA120','51.338837,-0.361584','10000','261','86',85);
--Fila 379
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (379,'1520774991','2018-03-11T13:29:51Z','AVA120','51.33321,-0.32618','10000','247','117',180);
--Fila 380
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (380,'1520774999','2018-03-11T13:29:59Z','AVA120','51.329086,-0.316673','10000','244','127',207);
--Fila 381
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (381,'1520775008','2018-03-11T13:30:08Z','AVA120','51.318695,-0.302421','10000','237','145',159);
--Fila 382
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (382,'1520775014','2018-03-11T13:30:14Z','AVA120','51.312515,-0.296334','9975','237','148',72);
--Fila 383
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (383,'1520775024','2018-03-11T13:30:24Z','AVA120','51.304688,-0.288465','10000','238','147',53);
--Fila 384
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (384,'1520775043','2018-03-11T13:30:43Z','AVA120','51.28418,-0.267903','9975','240','148',205);
--Fila 385
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (385,'1520775054','2018-03-11T13:30:54Z','AVA120','51.275101,-0.259171','9975','242','149',145);
--Fila 386
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (386,'1520775065','2018-03-11T13:31:05Z','AVA120','51.263168,-0.25224','9975','231','165',121);
--Fila 387
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (387,'1520775071','2018-03-11T13:31:11Z','AVA120','51.25882,-0.25135','10000','229','174',31);
--Fila 388
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (388,'1520775080','2018-03-11T13:31:20Z','AVA120','51.24728,-0.25239','10000','227','190',69);
--Fila 389
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (389,'1520775086','2018-03-11T13:31:26Z','AVA120','51.242199,-0.25439','10000','236','194',141);
--Fila 390
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (390,'1520775095','2018-03-11T13:31:35Z','AVA120','51.232361,-0.26174','9975','236','208',215);
--Fila 391
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (391,'1520775106','2018-03-11T13:31:46Z','AVA120','51.225239,-0.27084','10000','231','218',293);
--Fila 392
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (392,'1520775115','2018-03-11T13:31:55Z','AVA120','51.218399,-0.28505','9975','239','240',252);
--Fila 393
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (393,'1520775126','2018-03-11T13:32:06Z','AVA120','51.213558,-0.30556','9975','248','259',273);
--Fila 394
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (394,'1520775135','2018-03-11T13:32:15Z','AVA120','51.21286,-0.32333','9975','255','273',178);
--Fila 395
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (395,'1520775143','2018-03-11T13:32:23Z','AVA120','51.215237,-0.341187','10000','260','287',250);
--Fila 396
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (396,'1520775150','2018-03-11T13:32:30Z','AVA120','51.218216,-0.351488','9975','263','297',191);
--Fila 397
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (397,'1520775159','2018-03-11T13:32:39Z','AVA120','51.225246,-0.366287','9875','268','314',238);
--Fila 398
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (398,'1520775172','2018-03-11T13:32:52Z','AVA120','51.237164,-0.380096','9650','273','328',179);
--Fila 399
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (399,'1520775180','2018-03-11T13:33:00Z','AVA120','51.24678,-0.389347','9475','273','328',141);
--Fila 400
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (400,'1520775186','2018-03-11T13:33:06Z','AVA120','51.253315,-0.395889','9375','273','327',49);
--Fallo de inserción en las filas  401  mediante  450 
--ORA-01400: no se puede realizar una inserción NULL en ("AVIANCA"."LOGS_VUELO"."ID_LOG_VUELO")
--Fila 401
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (401,'1520775198','2018-03-11T13:33:18Z','AVA120','51.266327,-0.408795','9150','274','328',261);
--Fila 402
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (402,'1520775214','2018-03-11T13:33:34Z','AVA120','51.281799,-0.424087','9025','272','328',276);
--Fila 403
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (403,'1520775228','2018-03-11T13:33:48Z','AVA120','51.297539,-0.439682','8975','271','328',61);
--Fila 404
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (404,'1520775237','2018-03-11T13:33:57Z','AVA120','51.308533,-0.44799','9000','272','338',273);
--Fila 405
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (405,'1520775243','2018-03-11T13:34:03Z','AVA120','51.315948,-0.452147','9000','274','341',172);
--Fila 406
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (406,'1520775251','2018-03-11T13:34:11Z','AVA120','51.325333,-0.456696','8975','275','343',109);
--Fila 407
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (407,'1520775259','2018-03-11T13:34:19Z','AVA120','51.336132,-0.461655','8975','276','344',133);
--Fila 408
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (408,'1520775272','2018-03-11T13:34:32Z','AVA120','51.351425,-0.468552','8975','274','344',46);
--Fila 409
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (409,'1520775284','2018-03-11T13:34:44Z','AVA120','51.365555,-0.474701','9000','269','344',251);
--Fila 410
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (410,'1520775295','2018-03-11T13:34:55Z','AVA120','51.379807,-0.483844','8975','271','330',272);
--Fila 411
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (411,'1520775306','2018-03-11T13:35:06Z','AVA120','51.388779,-0.495276','8975','272','328',34);
--Fila 412
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (412,'1520775318','2018-03-11T13:35:18Z','AVA120','51.396557,-0.515213','9000','253','292',46);
--Fila 413
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (413,'1520775327','2018-03-11T13:35:27Z','AVA120','51.398621,-0.531575','9000','247','274',98);
--Fila 414
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (414,'1520775347','2018-03-11T13:35:47Z','AVA120','51.393398,-0.56164','8975','231','239',150);
--Fila 415
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (415,'1520775363','2018-03-11T13:36:03Z','AVA120','51.379799,-0.584412','9000','230','222',38);
--Fila 416
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (416,'1520775375','2018-03-11T13:36:15Z','AVA120','51.369827,-0.598681','8975','231','221',208);
--Fila 417
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (417,'1520775387','2018-03-11T13:36:27Z','AVA120','51.36058,-0.611894','8925','229','221',108);
--Fila 418
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (418,'1520775399','2018-03-11T13:36:39Z','AVA120','51.351959,-0.62706','8725','231','228',16);
--Fila 419
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (419,'1520775406','2018-03-11T13:36:46Z','AVA120','51.348793,-0.636978','8600','237','247',277);
--Fila 420
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (420,'1520775415','2018-03-11T13:36:55Z','AVA120','51.34684,-0.652771','8425','240','253',104);
--Fila 421
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (421,'1520775435','2018-03-11T13:37:15Z','AVA120','51.349178,-0.68071','8175','196','278',224);
--Fila 422
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (422,'1520775444','2018-03-11T13:37:24Z','AVA120','51.35252,-0.7032','7950','251','281',14);
--Fila 423
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (423,'1520775459','2018-03-11T13:37:39Z','AVA120','51.356609,-0.73128','7625','249','281',232);
--Fila 424
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (424,'1520775473','2018-03-11T13:37:53Z','AVA120','51.36034,-0.7576','7500','248','282',96);
--Fila 425
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (425,'1520775488','2018-03-11T13:38:08Z','AVA120','51.364151,-0.78508','7225','251','280',164);
--Fila 426
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (426,'1520775499','2018-03-11T13:38:19Z','AVA120','51.36726,-0.80304','7050','254','288',26);
--Fila 427
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (427,'1520775508','2018-03-11T13:38:28Z','AVA120','51.371799,-0.82071','6925','249','292',51);
--Fila 428
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (428,'1520775518','2018-03-11T13:38:38Z','AVA120','51.376789,-0.83719','6850','240','294',129);
--Fila 429
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (429,'1520775539','2018-03-11T13:38:59Z','AVA120','51.386921,-0.868','6550','228','296',27);
--Fila 430
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (430,'1520775553','2018-03-11T13:39:13Z','AVA120','51.39423,-0.88928','6350','215','297',41);
--Fila 431
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (431,'1520775563','2018-03-11T13:39:23Z','AVA120','51.399769,-0.90236','6250','210','307',158);
--Fila 432
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (432,'1520775574','2018-03-11T13:39:34Z','AVA120','51.40773,-0.91232','6150','218','331',278);
--Fila 433
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (433,'1520775583','2018-03-11T13:39:43Z','AVA120','51.416569,-0.91675','6075','210','349',224);
--Fila 434
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (434,'1520775594','2018-03-11T13:39:54Z','AVA120','51.427368,-0.91835','5975','210','356',95);
--Fila 435
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (435,'1520775618','2018-03-11T13:40:18Z','AVA120','51.45071,-0.90823','5775','203','43',76);
--Fila 436
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (436,'1520775628','2018-03-11T13:40:28Z','AVA120','51.456989,-0.89628','5675','202','54',39);
--Fila 437
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (437,'1520775644','2018-03-11T13:40:44Z','AVA120','51.465221,-0.87784','5500','200','56',197);
--Fila 438
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (438,'1520775658','2018-03-11T13:40:58Z','AVA120','51.473011,-0.85923','5350','196','65',57);
--Fila 439
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (439,'1520775668','2018-03-11T13:41:08Z','AVA120','51.475368,-0.8448','5250','194','84',18);
--Fila 440
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (440,'1520775678','2018-03-11T13:41:18Z','AVA120','51.475971,-0.83069','5100','195','90',231);
--Fila 441
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (441,'1520775704','2018-03-11T13:41:44Z','AVA120','51.476109,-0.80505','4750','198','90',187);
--Fila 442
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (442,'1520775712','2018-03-11T13:41:52Z','AVA120','51.47617,-0.78174','4425','197','89',152);
--Fila 443
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (443,'1520775718','2018-03-11T13:41:58Z','AVA120','51.47617,-0.77216','4325','195','89',87);
--Fila 444
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (444,'1520775728','2018-03-11T13:42:08Z','AVA120','51.47625,-0.75798','4150','193','89',131);
--Fila 445
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (445,'1520775734','2018-03-11T13:42:14Z','AVA120','51.47625,-0.75058','4050','191','89',47);
--Fila 446
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (446,'1520775743','2018-03-11T13:42:23Z','AVA120','51.476349,-0.73662','3850','187','89',68);
--Fila 447
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (447,'1520775754','2018-03-11T13:42:34Z','AVA120','51.47644,-0.72324','3675','179','89',176);
--Fila 448
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (448,'1520775760','2018-03-11T13:42:40Z','AVA120','51.47649,-0.71545','3575','173','89',229);
--Fila 449
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (449,'1520775770','2018-03-11T13:42:50Z','AVA120','51.476528,-0.7029','3475','168','89',169);
--Fila 450
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (450,'1520775779','2018-03-11T13:42:59Z','AVA120','51.476631,-0.69199','3325','166','89',111);
--Fallo de inserción en las filas  451  mediante  472 
--ORA-01400: no se puede realizar una inserción NULL en ("AVIANCA"."LOGS_VUELO"."ID_LOG_VUELO")
--Fila 451
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (451,'1520775790','2018-03-11T13:43:10Z','AVA120','51.476669,-0.67833','3150','163','89',74);
--Fila 452
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (452,'1520775799','2018-03-11T13:43:19Z','AVA120','51.476761,-0.66638','3000','159','89',120);
--Fila 453
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (453,'1520775810','2018-03-11T13:43:30Z','AVA120','51.476768,-0.65941','2925','158','89',74);
--Fila 454
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (454,'1520775826','2018-03-11T13:43:46Z','AVA120','51.47691,-0.6369','2650','155','89',212);
--Fila 455
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (455,'1520775835','2018-03-11T13:43:55Z','AVA120','51.476952,-0.62637','2525','154','89',109);
--Fila 456
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (456,'1520775844','2018-03-11T13:44:04Z','AVA120','51.47699,-0.61323','2350','154','89',136);
--Fila 457
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (457,'1520775855','2018-03-11T13:44:15Z','AVA120','51.477039,-0.60239','2225','153','89',51);
--Fila 458
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (458,'1520775865','2018-03-11T13:44:25Z','AVA120','51.477081,-0.59163','2075','150','89',192);
--Fila 459
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (459,'1520775881','2018-03-11T13:44:41Z','AVA120','51.477139,-0.58174','1950','149','89',248);
--Fila 460
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (460,'1520775894','2018-03-11T13:44:54Z','AVA120','51.477139,-0.5764','1900','142','89',134);
--Fila 461
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (461,'1520775959','2018-03-11T13:45:59Z','AVA120','51.477402,-0.52141','1225','131','89',253);
--Fila 462
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (462,'1520776168','2018-03-11T13:49:28Z','AVA120','51.475983,-0.45005','0','28','90',276);
--Fila 463
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (463,'1520776183','2018-03-11T13:49:43Z','AVA120','51.475983,-0.448565','0','33','92',191);
--Fila 464
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (464,'1520776198','2018-03-11T13:49:58Z','AVA120','51.475998,-0.447025','0','15','90',167);
--Fila 465
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (465,'1520776204','2018-03-11T13:50:04Z','AVA120','51.475998,-0.446472','0','33','90',155);
--Fila 466
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (466,'1520776224','2018-03-11T13:50:24Z','AVA120','51.475998,-0.444546','0','29','90',99);
--Fila 467
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (467,'1520776235','2018-03-11T13:50:35Z','AVA120','51.475998,-0.44342','0','25','92',143);
--Fila 468
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (468,'1520776251','2018-03-11T13:50:51Z','AVA120','51.475937,-0.442274','0','26','95',279);
--Fila 469
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (469,'1520776265','2018-03-11T13:51:05Z','AVA120','51.475929,-0.441322','0','22','92',16);
--Fila 470
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (470,'1520776276','2018-03-11T13:51:16Z','AVA120','51.475895,-0.440903','0','19','101',282);
--Fila 471
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (471,'1520776284','2018-03-11T13:51:24Z','AVA120','51.475456,-0.440622','0','21','168',160);
--Fila 472
INSERT INTO LOGS_VUELO (ID_LOG_VUELO, LOG_TIMESTAMP, HORAUTC, CALLSIGN, POSITION, ALTITUD, VELOCIDAD, DIRECCION, ID_VUELO) VALUES (472,'1520776299','2018-03-11T13:51:39Z','AVA120','51.474895,-0.440604','0','21','180',21);


--insert checkin
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (500,110,'Pasaporte','F3D 019',2,'Duns','Etiam.ligula@nullaInteger.edu',4593654,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (501,48,'Pasaporte','D2G 071',27,'La Magdeleine','Sed@sociisnatoque.org',3982319,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (502,155,'Cédula','M8C 770',27,'Montauban','Fusce@rutrumurna.org',5543278,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (503,18,'Cédula Extranjería','L1P 859',71,'Wunstorf','Aenean.egestas.hendrerit@semsempererat.net',2871769,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (504,104,'DNI','V2X 028',68,'Pitt Meadows','mauris.Suspendisse@a.edu',2613197,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (505,49,'Cédula','T8L 209',79,'Jhelum','vitae@fermentum.com',2913535,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (506,67,'Cédula Extranjería','N7P 538',21,'Brugge Bruges','volutpat.ornare@tinciduntdui.org',3633027,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (507,8,'Cédula','A4C 770',79,'Freiburg','mus.Proin@natoquepenatibus.co.uk',3484684,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (508,212,'Pasaporte','P0I 362',72,'Söderhamn','euismod.ac.fermentum@augueut.net',2892377,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (509,188,'Pasaporte','N2S 924',23,'Koningshooikt','id.risus@justofaucibus.ca',4494830,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (510,121,'Cédula','Z7D 969',38,'Brindisi','erat.neque@Donecegestas.net',3597789,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (511,173,'DNI','Z5P 762',98,'Leffinge','dolor.sit.amet@nibhvulputate.org',5303243,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (512,132,'Cédula','U4X 952',70,'Minneapolis','Nulla.eu@mi.com',3151540,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (513,112,'Cédula Extranjería','L9V 794',79,'S?upsk','enim.Suspendisse.aliquet@quis.ca',4177082,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (514,177,'Cédula Extranjería','Y2T 771',99,'Vilna','Curabitur.vel@Sed.co.uk',2805009,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (515,249,'Cédula','Z3Z 148',32,'Frigento','Sed@ornaretortor.co.uk',3196518,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (516,202,'Cédula','H3Z 575',26,'Santa Bárbara','per.inceptos.hymenaeos@eget.org',2819950,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (517,218,'Cédula Extranjería','W7C 320',65,'Rocca d''Arazzo','luctus.ipsum.leo@interdumliberodui.ca',4640004,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (518,45,'DNI','I5M 391',54,'Dietzenbach','in.dolor.Fusce@Aeneaneget.net',5259054,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (519,188,'Cédula Extranjería','M0E 421',62,'Kessenich','dui.in@nonante.ca',5485286,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (520,48,'Cédula','W8O 776',2,'Créteil','ligula.Nullam@fringillacursus.co.uk',3379899,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (521,275,'DNI','V7S 268',45,'O''Higgins','Donec.egestas.Duis@Suspendissecommodo.ca',4666156,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (522,186,'Cédula','O7L 848',31,'Phoenix','erat.Vivamus.nisi@et.edu',4519926,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (523,283,'Cédula','S9K 181',43,'Bolzano Vicentino','massa@tincidunt.ca',4265656,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (524,241,'DNI','E4F 416',67,'Waarloos','blandit@imperdietornare.co.uk',3493466,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (525,232,'Cédula Extranjería','K6M 107',1,'Tirupati','metus.Aliquam@ametrisusDonec.edu',2665742,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (526,80,'Cédula Extranjería','K6L 983',78,'Villenave-d''Ornon','Suspendisse@duiSuspendisse.org',4333159,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (527,280,'Cédula','U6I 257',90,'Avellino','dapibus@laoreet.ca',2792465,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (528,244,'Cédula','I0Z 774',38,'Gijzegem','magna.Suspendisse.tristique@nullaDonec.com',3711401,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (529,146,'Cédula','O8E 496',61,'Bhatinda','sapien.Nunc.pulvinar@at.net',3434239,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (530,70,'Cédula Extranjería','H5R 165',7,'Ananindeua','pede@Proinsedturpis.edu',4968645,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (531,107,'Cédula','R5P 908',78,'HavrŽ','faucibus.orci@consectetueripsumnunc.ca',5319249,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (532,93,'Cédula Extranjería','K5V 183',61,'Barry','vulputate@aliquam.net',2783984,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (533,10,'Cédula Extranjería','E1I 124',34,'Arsoli','In.mi@laoreetlibero.org',4032298,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (534,155,'Cédula','L9H 284',13,'Nelson','dolor@elitsed.net',4386358,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (535,131,'Cédula','Z7N 933',38,'Colico','Proin.mi.Aliquam@nuncinterdumfeugiat.org',2852796,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (536,172,'DNI','U9Y 396',34,'Minitonas','in.magna@famesacturpis.net',4598278,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (537,251,'DNI','Y0S 134',24,'Kahramanmara?','volutpat@molestie.com',4833260,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (538,290,'Pasaporte','N4F 889',71,'Heule','nulla.Cras.eu@enimdiamvel.ca',5031058,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (539,254,'Cédula Extranjería','U3O 517',82,'Regina','magna.Nam@adipiscing.edu',3854871,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (540,286,'Cédula Extranjería','U6E 265',34,'Verdun','volutpat@urnasuscipit.com',2909141,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (541,182,'Pasaporte','B4V 704',76,'Rochester','non.enim@porttitorinterdum.org',4498462,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (542,281,'Cédula','I6Y 421',20,'Tranent','eget.magna@cursusdiamat.com',4692870,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (543,168,'Cédula Extranjería','I8E 240',3,'Ammanford','id.enim.Curabitur@purusMaecenaslibero.com',3845449,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (544,271,'Cédula','Y6N 547',71,'Amelia','Proin@risusodio.net',4602769,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (545,188,'Cédula Extranjería','I6G 919',21,'Prato Carnico','ipsum@lacusvarius.co.uk',3552328,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (546,242,'Cédula Extranjería','K4T 438',64,'Ostra Vetere','vitae.sodales.nisi@sem.edu',4898273,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (547,300,'Pasaporte','D5D 706',56,'Narcao','venenatis.a@diam.org',4958432,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (548,63,'Cédula Extranjería','T3Y 238',56,'Hassan','lacus@necluctusfelis.edu',3718704,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (549,122,'Cédula','E2W 659',44,'Alajuela','erat@pede.edu',2853990,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (550,300,'Cédula','Z8F 175',53,'Jackson','ornare.elit.elit@Mauris.ca',3350355,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (551,47,'Cédula Extranjería','G4K 812',76,'Turrialba','Fusce.mollis@vel.net',4290685,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (552,223,'Cédula Extranjería','R2F 628',76,'Minna','nec.euismod.in@etipsumcursus.ca',3555803,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (553,273,'Pasaporte','W0N 831',69,'Montjovet','mauris@eudui.ca',4389163,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (554,43,'Pasaporte','A5Z 781',63,'Leamington','dolor.sit@atrisusNunc.org',5470864,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (555,160,'Pasaporte','E9E 953',42,'Nodebais','eu@cubilia.org',4765998,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (556,76,'Cédula','F3W 517',45,'Burg','amet.nulla@neque.net',5273370,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (557,69,'Cédula','Q0V 252',26,'Sainte-Marie-sur-Semois','dui.Suspendisse@Phasellus.org',3389931,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (558,285,'Pasaporte','T3O 648',67,'Launceston','a.felis@Sedidrisus.org',3868524,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (559,208,'Pasaporte','O8I 515',85,'Episcopia','quis.lectus.Nullam@rutrumjusto.edu',4426559,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (560,47,'Cédula Extranjería','L0E 107',17,'Hay River','luctus@liberoDonecconsectetuer.net',2782394,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (561,34,'DNI','I2P 915',20,'Port Hope','tempor.bibendum.Donec@infelisNulla.com',4540029,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (562,261,'DNI','L3O 089',10,'Bologna','Curabitur@molestiesodalesMauris.ca',5268026,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (563,54,'Cédula Extranjería','E3K 509',95,'Deschambault','augue@leoCrasvehicula.net',4758738,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (564,230,'DNI','N8E 100',59,'Francofonte','sed.libero@ametrisusDonec.edu',3154013,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (565,228,'Pasaporte','E0F 207',64,'Molfetta','rutrum@nisia.edu',2646765,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (566,70,'DNI','V3N 148',51,'Romeral','Phasellus.libero@pharetraNamac.org',4751160,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (567,83,'Pasaporte','O0Y 687',28,'Virton','aliquet@etipsumcursus.org',4974357,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (568,55,'DNI','Z9O 275',17,'Limelette','nulla.Cras.eu@adipiscing.edu',2631397,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (569,137,'Cédula','O4L 896',6,'Shipshaw','felis.Nulla@urna.edu',2763661,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (570,154,'DNI','R0W 291',2,'Galbiate','vitae.orci@ipsumSuspendissenon.com',3204947,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (571,30,'Cédula','L8R 916',80,'Zeebrugge','Nulla.tempor.augue@aliquet.ca',3723381,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (572,299,'Cédula','Z7V 964',96,'Carahue','elementum.purus@elit.ca',2738235,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (573,101,'Cédula Extranjería','V2B 180',66,'Pontypridd','molestie.dapibus.ligula@interdumNuncsollicitudin.co.uk',5422695,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (574,295,'DNI','R7K 317',27,'Limena','eros.Proin.ultrices@auctorquistristique.ca',3734913,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (575,33,'DNI','B3G 300',28,'Hartlepool','enim.Mauris.quis@nulla.net',5194856,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (576,41,'DNI','G5Z 759',62,'Weyburn','nec@iaculis.co.uk',3275480,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (577,61,'Pasaporte','D8L 903',18,'Grand-Manil','amet.ante.Vivamus@cursusvestibulum.org',5301123,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (578,191,'DNI','Y9X 792',62,'Kitimat','facilisis@mauris.ca',4688162,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (579,33,'Cédula','V9B 575',27,'Ingelheim','mauris.eu.elit@placeratCrasdictum.co.uk',4703277,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (580,112,'Pasaporte','I3A 177',48,'Neuville','non@elitNulla.org',3924826,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (581,294,'Pasaporte','L6H 594',99,'Moircy','sagittis@diamlorem.net',3332634,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (582,246,'Cédula','S1T 819',11,'Linton','nibh.Donec@luctuslobortis.org',4790239,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (583,170,'Pasaporte','N1E 818',86,'Thurso','ipsum.nunc@lacus.com',5208943,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (584,284,'Cédula','A6U 099',80,'Argyle','dignissim@leoelementum.com',4044048,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (585,12,'Cédula','Z0U 191',69,'Linton','gravida.sit@Fuscealiquam.edu',5297108,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (586,132,'Cédula','N0M 710',52,'Ceyhan','orci.luctus.et@Aliquamnecenim.net',3101157,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (587,81,'Cédula Extranjería','W8G 528',58,'Gontrode','sapien.gravida@Integerin.com',3090163,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (588,52,'Cédula Extranjería','V4Q 371',55,'Cuxhaven','at.arcu@purusmaurisa.org',5338774,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (589,71,'Cédula Extranjería','K7O 342',83,'Reading','pede.Nunc@lectuspedeet.net',3801351,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (590,54,'Cédula','G7J 420',33,'Sanzeno','odio@Maecenas.co.uk',3458915,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (591,88,'Cédula','R6S 941',97,'Elen','malesuada.fringilla@facilisisloremtristique.ca',3126219,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (592,91,'Cédula Extranjería','H0I 928',13,'Tarzo','penatibus.et@acsem.com',3177176,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (593,195,'DNI','E9R 936',33,'Río Hurtado','fermentum.metus.Aenean@id.co.uk',4978281,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (594,159,'Cédula','X0K 591',97,'Buren','mauris.sit.amet@sem.edu',5559627,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (595,147,'Cédula Extranjería','U9I 853',6,'Anchorage','ac.facilisis.facilisis@arcuet.ca',5126432,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (596,185,'Cédula','Z2U 419',61,'Mobile','massa.non.ante@erosNamconsequat.net',3518788,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (597,173,'Pasaporte','O9V 334',86,'Pforzheim','facilisis.facilisis.magna@Nulla.ca',4810401,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (598,145,'Cédula','L7G 877',35,'Campochiaro','elementum.purus.accumsan@odio.com',2929550,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (599,167,'Cédula Extranjería','C5Q 680',63,'St. Albans','Nunc@neceuismodin.org',5218900,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (600,21,'Pasaporte','S9O 706',47,'Lüneburg','vestibulum.massa.rutrum@Namnullamagna.net',4490448,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (601,105,'Cédula Extranjería','E1T 367',93,'Grumo Appula','Vivamus.non.lorem@in.net',3470815,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (602,259,'Cédula Extranjería','W5W 939',38,'Leffinge','tempus.eu.ligula@tellusNunc.co.uk',3358200,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (603,87,'Cédula','E3J 947',12,'Oldenburg','magna@nonlobortis.ca',3509695,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (604,294,'DNI','D2Z 162',32,'Cincinnati','amet.metus.Aliquam@luctusaliquetodio.co.uk',4781050,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (605,151,'Pasaporte','A5P 252',52,'Varna/Vahrn','sociosqu@ultricies.com',2701182,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (606,256,'Cédula','N8P 070',55,'Quellón','est.arcu.ac@dolor.co.uk',4160193,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (607,74,'Cédula Extranjería','W0D 851',89,'Molino dei Torti','tincidunt@etnuncQuisque.com',2905424,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (608,92,'Cédula Extranjería','D7D 673',72,'Santa Flavia','ornare@congue.com',3558620,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (609,140,'Cédula Extranjería','M9I 774',50,'Canmore','dui.lectus@atvelitCras.co.uk',3132688,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (610,278,'Cédula Extranjería','K5W 149',19,'Lathuy','egestas@turpis.ca',3120521,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (611,98,'Pasaporte','Z1W 726',47,'Iquique','lobortis.quam@nostraper.edu',2862635,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (612,105,'Cédula','U0I 485',85,'Dar?ca','neque.Sed@risusNunc.ca',4569968,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (613,122,'Pasaporte','K9H 909',59,'Redlands','sit@auctornon.co.uk',5352199,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (614,106,'Pasaporte','Q0A 333',44,'Paal','Nullam@Aliquamfringillacursus.co.uk',4013130,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (615,115,'Cédula','J9S 895',52,'Siculiana','neque.Nullam@noncursus.org',4159260,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (616,75,'DNI','O5E 951',46,'Abaetetuba','et.lacinia@etarcu.com',4571301,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (617,129,'Cédula','X1F 368',55,'Jodoigne-Souveraine','In.ornare.sagittis@magna.ca',4679570,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (618,43,'Cédula Extranjería','H5H 524',65,'Münster','odio.Aliquam.vulputate@egestas.edu',4979783,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (619,264,'Cédula','X7G 458',21,'Woodstock','parturient@mauris.co.uk',4129907,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (620,194,'DNI','P9N 991',53,'New Haven','vestibulum.lorem@velit.net',3779875,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (621,247,'Cédula Extranjería','D6D 719',68,'Gelsenkirchen','cursus.et@augueacipsum.net',2819635,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (622,172,'DNI','T8P 301',4,'Sandy','egestas.hendrerit@lorem.net',5215634,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (623,89,'Cédula','S8W 807',91,'Albisola Superiore','scelerisque@mi.net',3750974,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (624,290,'Cédula','Y0C 265',5,'Navsari','pellentesque@nibhlaciniaorci.org',2619692,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (625,298,'DNI','C2R 580',84,'Drongen','metus@odio.org',3033114,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (626,275,'Pasaporte','F1I 051',53,'Independencia','facilisis.Suspendisse.commodo@odio.ca',2907719,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (627,298,'Pasaporte','H6M 951',65,'Río Ibáñez','Curabitur.ut.odio@vitae.com',4686095,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (628,104,'Cédula','J8C 537',66,'Mantova','bibendum.ullamcorper.Duis@est.org',3280593,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (629,256,'DNI','K5R 057',35,'Melsbroek','dictum.Phasellus.in@inmolestie.net',4295441,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (630,139,'Cédula','S2I 887',70,'Weyburn','eu.odio@Nullamvitae.co.uk',3896640,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (631,25,'Cédula','H3O 879',91,'Duque de Caxias','lorem@Donectempuslorem.edu',4353654,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (632,231,'Cédula Extranjería','Q4V 402',6,'Marburg','lectus.justo.eu@etarcu.co.uk',3417795,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (633,85,'DNI','P2P 935',11,'Pincher Creek','Aliquam.nec@etnunc.org',5326650,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (634,10,'DNI','W2P 523',91,'Bad Nauheim','interdum.Sed.auctor@Utsagittislobortis.net',5257015,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (635,83,'Pasaporte','H3T 787',6,'Che?m','ut.dolor.dapibus@lectus.org',3974053,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (636,183,'Cédula Extranjería','Y5R 616',1,'Haddington','varius@senectuset.org',3677572,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (637,204,'DNI','Q3P 876',64,'Hattem','egestas.nunc@aliquet.com',2955094,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (638,273,'Pasaporte','N7V 789',48,'Punta Arenas','egestas@ultricies.com',4996476,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (639,36,'Pasaporte','Q4U 451',2,'Barrie','cursus.non@Donectincidunt.co.uk',3094781,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (640,249,'DNI','N3A 985',12,'Bismil','mauris@molestie.co.uk',3816957,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (641,173,'Pasaporte','W8B 864',84,'Recanati','fringilla.cursus@utlacusNulla.edu',4582285,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (642,230,'Cédula Extranjería','Q6A 509',15,'Evansville','Aenean.massa.Integer@justonecante.com',3061678,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (643,57,'Cédula Extranjería','H8N 909',29,'Beigem','eu@semper.ca',5005544,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (644,40,'Cédula','B8F 997',40,'Rivière-du-Loup','metus.eu.erat@tempuseu.net',4737979,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (645,16,'DNI','E8P 079',86,'Tula','dictum.Phasellus.in@consectetuereuismod.com',5430920,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (646,15,'DNI','C4A 134',81,'Sacramento','eu.dolor.egestas@lacusCrasinterdum.edu',5452315,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (647,139,'Cédula Extranjería','T1Z 545',24,'Genk','dolor.egestas.rhoncus@suscipitestac.com',3796070,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (648,36,'Cédula Extranjería','K3P 512',90,'Niel-bij-As','at.sem@Pellentesque.com',3052110,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (649,32,'Pasaporte','F2A 443',2,'Alken','non.dui@non.ca',3113390,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (650,138,'Pasaporte','Z2B 729',50,'Vernole','mollis@arcu.ca',3256459,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (651,130,'Pasaporte','G8C 510',94,'Comox','mauris.Morbi.non@ultricesDuisvolutpat.co.uk',4474346,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (652,63,'Cédula Extranjería','K9G 382',7,'Monguelfo-Tesido/Welsberg-Taisten','leo.in.lobortis@lorem.com',2916362,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (653,219,'DNI','L6O 113',92,'Lloydminster','pede@nullaInteger.net',4484300,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (654,229,'Cédula Extranjería','Z8S 832',23,'Picture Butte','torquent.per@accumsanlaoreetipsum.ca',4495587,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (655,25,'Cédula Extranjería','M8C 118',12,'Civitacampomarano','turpis.vitae.purus@lorem.net',5159473,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (656,137,'Pasaporte','A8W 144',98,'Flensburg','et@acnulla.com',3553671,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (657,300,'Cédula Extranjería','G8B 720',23,'Melle','ac.arcu.Nunc@loremauctor.ca',3666517,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (658,141,'DNI','H7G 561',76,'Merrickville-Wolford','elit.pharetra.ut@Praesentinterdumligula.co.uk',4942285,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (659,191,'Cédula','K3G 588',68,'Roselies','lorem.luctus.ut@dis.ca',4868500,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (660,160,'DNI','Z8A 357',81,'Lanark County','mi.lacinia.mattis@rutrumFusce.co.uk',3870079,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (661,239,'DNI','V0R 373',28,'Camrose','orci@mattisvelitjusto.ca',3112999,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (662,94,'Cédula','C6M 164',75,'Werder','non.vestibulum@adipiscing.org',3285643,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (663,146,'Pasaporte','M5J 292',92,'Castelluccio Inferiore','fringilla.cursus.purus@tellus.org',4907636,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (664,22,'Cédula Extranjería','B0P 008',95,'Reinbek','Mauris.blandit@nec.co.uk',3072218,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (665,144,'Cédula','Y4P 852',62,'Riksingen','Mauris@eu.com',5233680,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (666,294,'DNI','O3Y 867',65,'South Portland','libero.Morbi.accumsan@dolor.com',3875400,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (667,78,'DNI','B5P 871',18,'Lustin','nonummy@mollis.edu',3410281,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (668,81,'Cédula Extranjería','Z9L 535',81,'Erode','In.mi@ligulaeu.com',4943862,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (669,61,'Pasaporte','S1A 571',55,'Nueva Imperial','eu.nibh.vulputate@ami.org',2772415,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (670,23,'Cédula Extranjería','W0X 535',9,'Casperia','Aliquam.ultrices.iaculis@tinciduntnibhPhasellus.com',4075538,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (671,265,'Cédula Extranjería','J2W 382',65,'Dibrugarh','nisl.Quisque.fringilla@porttitor.com',5435562,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (672,91,'Cédula','L3P 733',7,'Spy','aliquet.lobortis.nisi@odiovel.co.uk',5158286,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (673,187,'Cédula','M6L 170',80,'Rossignol','nascetur@sapienmolestieorci.edu',2762721,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (674,88,'Cédula Extranjería','I3Z 494',86,'Mansfield-et-Pontefract','Cum.sociis.natoque@Nullamvelit.ca',5457236,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (675,67,'Pasaporte','P1G 560',1,'Castiglione di Sicilia','nec.enim.Nunc@euultricessit.co.uk',3860387,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (676,51,'Cédula Extranjería','S9B 013',24,'Bottrop','purus@lectusCum.net',2874293,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (677,209,'Cédula','G6Z 210',58,'Olsztyn','lobortis@dolor.ca',5455572,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (678,50,'DNI','B4N 860',76,'Marchtrenk','mollis@Phasellusornare.org',2841461,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (679,180,'Cédula Extranjería','U3N 766',70,'Dera Ghazi Khan','et.pede@massaQuisque.net',3677055,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (680,116,'Cédula','Q7K 497',33,'Jonesboro','vehicula.et.rutrum@cursuset.edu',2847362,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (681,241,'Cédula','O7L 816',58,'Homburg','urna.et@velitinaliquet.net',4343735,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (682,138,'DNI','L6F 022',53,'Alcobendas','dolor@consectetuermauris.org',3223827,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (683,300,'DNI','Q7N 990',70,'Autelbas','commodo.at@ac.org',3845263,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (684,68,'Pasaporte','E2V 645',36,'Castiglione di Garfagnana','commodo@habitantmorbi.org',3174973,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (685,125,'Cédula Extranjería','T9P 494',94,'Anápolis','ipsum@dolorsit.com',4652243,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (686,252,'Cédula Extranjería','Y9S 116',73,'Vallenar','aliquet@sollicitudin.com',3331082,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (687,298,'Cédula','F0E 365',48,'Drumheller','Aenean@ametornare.ca',4449218,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (688,6,'Cédula','N2K 977',10,'Seraing','eros.Proin@nec.co.uk',4971190,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (689,284,'Pasaporte','W1T 510',38,'Jonqui?re','neque@adipiscingelitAliquam.net',4237723,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (690,225,'Cédula Extranjería','N6M 498',63,'Colli a Volturno','aliquet.nec@faucibusut.co.uk',5367335,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (691,275,'Cédula Extranjería','C8F 580',79,'Wanganui','euismod.et@suscipitnonummy.com',3364499,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (692,206,'DNI','X3W 270',49,'Gbongan','ac@nonantebibendum.com',4743832,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (693,18,'Cédula Extranjería','A9R 311',80,'Amersfoort','a.aliquet.vel@elementumategestas.net',2872868,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (694,167,'DNI','D4Z 076',89,'Castelseprio','ultrices.sit.amet@lacus.com',3509599,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (695,282,'Cédula Extranjería','L1U 386',45,'Deurne','Nullam@sitametrisus.edu',4690409,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (696,162,'Cédula Extranjería','C1W 123',97,'Whitewater Region Township','ornare.Fusce.mollis@famesacturpis.org',3983634,'ejecutiva');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (697,219,'DNI','Y1Q 453',94,'Grafton','Donec.est.mauris@quis.co.uk',4613653,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (698,215,'Cédula','P4U 167',6,'Yaxley','sociis.natoque.penatibus@uteratSed.com',3290135,'economia');
    INSERT INTO checkin (id_checkin,numero_vuelo,tipo_de_identificacion,numero_confirmacion_checkin,contacto_emergencia,ciudad_emergencia,correo_emergencia,numero_telefono_emergencia,tipo_silla) VALUES (699,126,'Pasaporte','U9M 035',22,'Fontanigorda','Duis.sit@magna.co.uk',3105323,'ejecutiva');
    
    --insert tripvuelo
    
    INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (243,132);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (281,285);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (179,235);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (42,10);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (29,282);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (155,94);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (195,52);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (210,82);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (72,18);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (150,253);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (206,144);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (234,253);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (42,33);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (227,33);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (76,97);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (287,144);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (113,255);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (29,94);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (248,166);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (130,254);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (260,172);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (253,245);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (3,114);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (127,104);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (55,252);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (272,264);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (66,283);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (220,24);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (26,117);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (91,38);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (194,293);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (52,126);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (20,191);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (280,298);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (60,105);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (89,102);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (194,230);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (3,82);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (213,172);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (190,157);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (66,94);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (199,47);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (260,73);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (121,14);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (251,159);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (128,132);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (41,194);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (118,248);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (123,230);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (99,145);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (145,202);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (92,251);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (155,50);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (220,240);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (191,99);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (223,141);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (293,100);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (173,139);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (90,219);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (142,93);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (7,31);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (17,246);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (56,271);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (125,65);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (174,295);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (112,232);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (115,228);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (1,8);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (79,110);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (26,210);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (145,134);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (133,198);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (173,78);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (46,227);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (285,185);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (97,172);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (30,237);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (117,106);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (124,120);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (44,216);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (163,273);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (120,140);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (260,52);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (286,144);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (245,58);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (78,246);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (185,299);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (283,53);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (49,95);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (71,18);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (203,36);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (15,35);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (44,74);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (11,194);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (90,30);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (18,234);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (10,131);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (78,154);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (223,263);
INSERT INTO tripuvuelo (id_tripulaciones,id_vuelo) VALUES (30,262);



--insert itinerario
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (600,413,17,158,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (601,367,153,66,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (602,342,175,164,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (603,240,16,199,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (604,274,67,122,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (605,312,264,28,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (606,294,188,216,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (607,386,292,66,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (608,374,283,185,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (609,348,21,84,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (610,435,133,197,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (611,455,197,155,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (612,449,279,73,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (613,208,288,206,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (614,493,296,74,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (615,459,161,36,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (616,295,193,133,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (617,282,239,88,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (618,295,132,148,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (619,336,163,205,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (620,209,167,10,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (621,427,79,208,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (622,467,175,98,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (623,203,10,186,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (624,229,22,179,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (625,231,287,53,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (626,429,122,47,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (627,463,187,63,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (628,272,102,147,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (629,273,192,38,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (630,289,169,62,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (631,342,247,213,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (632,339,30,139,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (633,346,185,59,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (634,271,122,150,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (635,445,44,179,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (636,384,171,65,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (637,215,199,81,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (638,424,92,15,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (639,396,111,174,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (640,352,190,10,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (641,401,239,68,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (642,400,103,215,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (643,247,272,84,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (644,384,171,149,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (645,241,208,67,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (646,355,53,78,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (647,267,166,153,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (648,474,145,20,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (649,311,39,111,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (650,379,123,146,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (651,313,251,191,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (652,317,173,12,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (653,338,261,36,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (654,416,173,94,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (655,235,95,164,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (656,425,161,55,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (657,470,212,45,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (658,390,188,97,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (659,274,74,7,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (660,222,218,3,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (661,231,262,16,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (662,444,191,216,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (663,299,168,97,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (664,406,82,107,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (665,413,133,215,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (666,221,245,18,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (667,295,183,35,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (668,315,10,34,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (669,287,253,205,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (670,224,240,199,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (671,440,80,160,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (672,430,241,182,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (673,445,263,78,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (674,409,164,88,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (675,331,271,195,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (676,463,20,24,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (677,357,30,167,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (678,207,192,189,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (679,226,273,142,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (680,264,180,11,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (681,207,59,6,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (682,282,279,213,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (683,316,23,13,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (684,294,97,25,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (685,398,193,175,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (686,234,249,36,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (687,303,43,29,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (688,251,86,100,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (689,345,70,7,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (690,227,216,186,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (691,381,193,4,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (692,468,254,194,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (693,249,36,56,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (694,346,33,194,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (695,365,200,1,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (696,432,176,202,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (697,343,271,32,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (698,272,121,52,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (699,463,108,18,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (700,401,191,218,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (701,379,143,202,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (702,206,246,17,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (703,451,106,211,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (704,441,201,56,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (705,486,213,26,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (706,241,210,184,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (707,491,1,189,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (708,401,22,131,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (709,327,81,44,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (710,386,127,53,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (711,348,88,165,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (712,410,140,55,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (713,403,70,127,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (714,387,38,86,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (715,484,43,128,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (716,362,199,213,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (717,279,242,109,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (718,434,119,166,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (719,318,179,199,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (720,485,235,187,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (721,235,148,120,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (722,427,166,65,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (723,461,148,198,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (724,342,283,19,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (725,271,181,33,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (726,243,292,103,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (727,353,291,26,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (728,490,159,212,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (729,482,13,152,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (730,400,231,181,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (731,261,254,15,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (732,482,87,51,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (733,355,180,135,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (734,216,60,73,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (735,403,84,55,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (736,336,128,111,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (737,493,292,77,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (738,477,164,205,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (739,202,82,179,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (740,200,4,1,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (741,407,174,166,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (742,244,111,120,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (743,219,122,134,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (744,346,44,156,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (745,326,203,125,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (746,326,81,152,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (747,336,226,172,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (748,301,292,58,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (749,223,174,164,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (750,249,268,197,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (751,241,127,46,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (752,306,276,132,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (753,226,2,128,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (754,274,255,148,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (755,244,259,197,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (756,285,257,141,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (757,240,256,137,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (758,397,91,83,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (759,389,92,55,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (760,321,109,215,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (761,273,24,99,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (762,297,130,87,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (763,247,191,127,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (764,377,241,51,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (765,316,274,12,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (766,370,190,59,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (767,438,106,198,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (768,343,196,128,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (769,215,127,37,6);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (770,226,116,60,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (771,380,22,211,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (772,306,198,8,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (773,218,110,51,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (774,337,25,111,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (775,411,120,15,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (776,358,243,167,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (777,208,284,153,7);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (778,412,153,155,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (779,478,172,110,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (780,299,101,143,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (781,396,225,67,3);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (782,229,176,196,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (783,408,42,147,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (784,438,151,53,8);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (785,312,111,218,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (786,252,119,179,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (787,359,184,192,4);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (788,358,65,4,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (789,366,62,5,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (790,235,181,183,2);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (791,480,293,102,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (792,302,137,174,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (793,333,46,174,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (794,264,206,32,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (795,395,109,148,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (796,498,242,116,9);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (797,483,188,46,5);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (798,348,188,155,1);
INSERT INTO itinerarios (id_itinerario,id_ruta,id_vuelo,id_avion,id_aeropuerto) VALUES (799,419,162,105,5);
