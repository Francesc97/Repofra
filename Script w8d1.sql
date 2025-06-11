/*È necessario implementare uno schema che consenta di gestire le anagrafiche degli store di un'ipotetica azienda.
Uno store è collocato in una precisa area geografica.
In un'area geografica possono essere collocati store diversi.
*/
#1. Crea una tabella Store per la gestione degli store ID, nome, data apertura, ecc.) 

create table Region (
RegionID INT auto_increment primary key,
Città Varchar(50),
Regionname varchar(50),
Area varchar(50)
);

#2. Crea una tabella Region per la gestione delle aree geografiche ID, città, regione, area geografica, …) 

create table Store (
StoreID int,
Nome varchar(50),
DataApertura date,
Indirizzo varchar(100),
RegionID INT,
constraint FOREIGN key (RegionID) REFERENCES Region (RegionID)
);

#3. Popola le tabelle con pochi record esemplificativi 

INSERT INTO Region (Città, Regionname, Area) VALUES
('Milano', 'Lombardia', 'Nord'),
('Torino', 'Piemonte', 'Nord'),
('Napoli', 'Campania', 'Sud'),
('Bari', 'Puglia', 'Sud'),
('Firenze', 'Toscana', 'Centro');

select * from region;

INSERT INTO Store (StoreID, Nome, DataApertura, Indirizzo, RegionID) VALUES
(1, 'TechWorld Milano', '2020-03-15', 'Via Dante 12', 1),
(2, 'Libreria Piemonte', '2019-10-05', 'Corso Regina Margherita 45', 2),
(3, 'Gadget Point', '2021-06-20', 'Via Toledo 89', 3),
(4, 'Casa Digitale', '2018-09-10', 'Via Sparano 20', 4),
(5, 'Emporio Toscana', '2022-01-25', 'Via Roma 33', 5),
(6, 'TechWorld Torino', '2023-04-01', 'Via Po 101', 2),
(7, 'Libri e Caffè', '2020-11-11', 'Via Carducci 14', 5),
(8, 'Fashion Milano', '2021-08-08', 'Via Montenapoleone 3', 1),
(9, 'Store Sud', '2017-07-07', 'Via Mazzini 9', 3),
(10, 'Bari Market', '2016-05-05', 'Corso Cavour 11', 4);

select * from store;

#4. Esegui operazioni di aggiornamento, modifica ed eliminazione record

SET SQL_SAFE_UPDATES = 0;  #Disabilitare temporaneamente la modalità safe SQL per la sessione corrente (con 1 la si riattiva)

update store 
set indirizzo = 'C.so Garibaldi 92'
where storeID = 1;

update store
set dataapertura = date_sub(dataapertura, interval 4 day)
where storeid = 3;

set autocommit = 0;

start transaction;

insert into Store (StoreID, Nome, DataApertura, Indirizzo, RegionID) values (11, 'MarketPlace', '2014-09-13', 'Largo Ciaia 10', 7);



select * from store;
commit;
insert into Region (RegionID, Città, Regionname, Area) values (6, 'Palermo', 'Sicilia', 'Isole');
select * from region;

start transaction;

insert into Region (Città, Regionname, Area) values ('Lecce', 'Puglia', 'Sud');


select s.storeid, s.nome, r.Città
from store s 
join region r on s.regionid = r.regionid
where s.storeid = 2;
select * from region;
rollback;

start transaction;
INSERT INTO Store (StoreID, Nome, DataApertura, Indirizzo, RegionID) VALUES 
(13, 'Mongolfiera', '2024-05-08', 'Via del Mare 14/c', 9);
update region
set Città = 'Arezzo'
where RegionID = 5;
select * from store;
select * from region;
commit;

begin;
delete from Store 
where StoreID = 9;
SELECT * from store;
rollback;

begin;
delete from store
where Nome like '%caffè';
select * from store;
commit;

begin;
delete from store
where Nome like 'Libreria%' or storeid = 3;
select * from store;
rollback;

begin;
delete from store
where Nome like 'Libreria%' or storeid = 3;
select * from store;
commit;