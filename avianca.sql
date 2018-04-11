/*2. Create 2 Tablespaces a.first one with 2 Gb and 1 datafile, tablespace should be named " avianca "*/
create tablespace Avianca
datafile 'avianca.dbf' size 2G;
/*b.Undo tablespace with 25Mb of space and 1 datafile and 3. */ 
create undo tablespace undoavianca_01
datafile 'undoavianca.dbf'
size 25M autoextend on;
/*4. Create a DBA user (with the role DBA) and assign it to the tablespace called " avianca ", this user has
unlimited space on the tablespace (The user should have permission to connect)*/
create user avianca
identified by avianca
default tablespace Avianca
quota UNLIMITED on Avianca

grant DBA, connect to AVIANCA


/*8. Create tables with its columns according to your normalization (0.125) .
i. If you are using Oracle 11g: Create sequences for every primary key.
ii. If you are using Oracle 12c: Use identity columns.
b. Create primary and foreign keys.*/
create table Tripulacion
(
    id_empleados number(20) not null primary key,
    id_azafatas number(20),
    nombres varchar2(255),
    apellidos varchar2(255),
    fecha_de_nacimiento date,
    antiguedad varchar(100),
    fecha_ultimo_entrenamiento_recibido date,
    correo varchar2(255),
    celular number(13),
    horas_descanso_ultimo_vuelo integer,
    estado varchar(255) not null check(estado in ('en vuelo','activo','inactivo','jubilado','suspendido','despedido','entrenamiento','licencia','vacaciones')),
    ubicacion_actual varchar(255)
);

create table Pilotos
(
    id_piloto number(20) not null primary key,
    nivel_ingles varchar(255) not null check(nivel_ingles in ('1_pre-elementary','2_elementary','3_pre-operational','4_operational','5_extended','6_expert')),
    cantidad_horas_vuelo integer,
    tipo_licencia varchar(255) not null check(tipo_licencia in ('CPL','IFR','ME','ATPL')),
    cargo varchar(255) not null check(cargo in ('comandante','primer oficial')),
    id_empleado number(20)  
);

create table Aeropuertos
(
    id_aeropuerto integer not null primary key,
    nombre varchar2(255),
    ciudad varchar2(255),
    pais varchar2(255),
    longitud integer,
    latitud integer,
    abreviatura_aeropuerto varchar2(255)
);
  
create table Rutas
(
    id_ruta integer not null primary key,
    id_aeropuerto_origen integer not null,
    id_aeropuerto_destino integer not null,
    distancia_kilometro integer,
    numero_vuelo integer,
    frecuencia_semanal integer,
    aeronave_requerida varchar2(255),
    cantidad_promedio integer,
    tripulante_requerido integer
);

create table log_vuelo
(
    id_log_vuelo integer not null primary key,
    log_timestamp timestamp,
    horaUTC varchar(255),
    position varchar2(255),
    altitud varchar(255),
    velocidad varchar(255),
    direccion varchar(255),
    id_vuelo integer not null  
);
 

create table Vuelo
(
    id_vuelo integer not null primary key,
    id_piloto number(20) not null,
    id_copiloto number(20) not null,
    id_auxiliares number(20) not null,
    hora_estimada_salida varchar(255),
    hora_estimada_llegada varchar(255),
    hora_real_salida varchar(255),
    hora_real_llegada varchar(255),
    duracion_real integer,
    aeronave_asignada varchar(255),
    cantidad_pasajeros integer,
    id_avion integer not null
);

create table checkin
(
    id_checkin integer not null primary key,
    numero_vuelo integer not null,
    tipo_de_identificacion varchar(255)not null check(tipo_de_identificacion in('Cédula','Pasaporte','DNI','Cédula Extranjería')),
    numero_confirmacion_checkin varchar2(255)not null,
    contacto_emergencia varchar2(255),
    ciudad_emergencia varchar2(255),
    correo_emergencia varchar2(255),
    numero_telefono_emergencia integer
);


create table programacion
(
    id_programacion integer not null primary key,
    id_ruta integer not null,
    id_vuelo integer not null,
    id_avion integer not null,
    hora varchar2(255),
    pais varchar2(255),
    id_aeropuerto integer not null
);

create table avion 
(
    id_avion integer not null primary key,
    registration varchar(50),
    serial_number varchar(45),
    age varchar(255),
    aircraft_type varchar(255),
    bussiness_seats integer,
    economy_seats integer
    
);

ALTER TABLE Pilotos
ADD CONSTRAINT FK_Pilotos_Tripulacion
  FOREIGN KEY (id_empleado)
  REFERENCES Tripulacion(id_empleados);
  
  ALTER TABLE Rutas
ADD CONSTRAINT FK_ruta_id_aeropuerto_origen
  FOREIGN KEY (id_aeropuerto_origen)
  REFERENCES Aeropuertos(id_aeropuerto);
  
  ALTER TABLE Rutas
ADD CONSTRAINT FK_ruta_id_aeropuerto_destino
  FOREIGN KEY (id_aeropuerto_destino)
  REFERENCES Aeropuertos(id_aeropuerto);
  
ALTER TABLE log_vuelo
ADD CONSTRAINT FK_log_vuelo_id_vuelo
  FOREIGN KEY (id_vuelo)
  REFERENCES Vuelo(id_vuelo);

ALTER TABLE Vuelo
ADD CONSTRAINT FK_vuelo_id_piloto
  FOREIGN KEY (id_piloto)
  REFERENCES Pilotos(id_piloto);
  
  ALTER TABLE Vuelo
ADD CONSTRAINT FK_vuelo_id_copiloto
  FOREIGN KEY (id_copiloto)
  REFERENCES Pilotos(id_piloto);
  
  ALTER TABLE Vuelo
ADD CONSTRAINT FK_vuelo_id_copiloto
  FOREIGN KEY (id_copiloto)
  REFERENCES Pilotos(id_piloto);
  
  ALTER TABLE Vuelo
ADD CONSTRAINT FK_vuelo_id_avion
  FOREIGN KEY (id_avion)
  REFERENCES avion(id_avion);
  
    ALTER TABLE checkin
ADD CONSTRAINT FK_checkin_id_vuelo
  FOREIGN KEY (numero_vuelo)
  REFERENCES Vuelo(id_vuelo);
  
  
  ALTER TABLE programacion
ADD CONSTRAINT FK_programacion_id_ruta
  FOREIGN KEY (id_ruta)
  REFERENCES Rutas(id_ruta);
  
  ALTER TABLE programacion
ADD CONSTRAINT FK_programacion_id_vuelo
  FOREIGN KEY (id_vuelo)
  REFERENCES Vuelo(id_vuelo);
  
   ALTER TABLE programacion
ADD CONSTRAINT FK_programacion_id_avion
  FOREIGN KEY (id_avion)
  REFERENCES avion(id_avion);
  
  ALTER TABLE programacion
ADD CONSTRAINT FK_programacion_id_aeropuerto
  FOREIGN KEY (id_aeropuerto)
  REFERENCES Aeropuertos(id_aeropuerto);
  
  
select * from dba_tablespaces;
select * from dba_data_files;