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
  
 
  