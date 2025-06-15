#Task 2: creazione del database e successivamente delle tabelle

create database ToysGroup;
create table Category (
CategoryID int auto_increment primary key,
CategoryName varchar(50) not null
);
create table Region (
RegionID int auto_increment primary key,
RegionName varchar(50) not null
);
create table Product (
ProductID INT AUTO_INCREMENT primary key,
ProductName varchar(50) not null,
CategoryID INT not null, 
FOREIGN KEY (CategoryID) references Category(CategoryID)
);
create table Country (
CountryID int auto_increment primary key,
CountryName varchar(50) not null,
RegionID int not null,
foreign key (RegionID) REFERENCES Region(RegionID)
);
create table Sales (
SONumber int auto_increment primary key,
DateOrder date not null,
DateShip date not null,
UnitSold decimal(10,2) not null,
UnitCost decimal(10,2) not null,
TotalProductCost decimal(10,2) not null,
SalesAmount decimal(10,2) not null,
ProductID int not null,
CountryID INT not null,
foreign key (ProductID) REFERENCES Product(ProductID),
Foreign key (CountryID) references Country(CountryID)
);

#Task 3: Inserimento dei dati nelle tabelle

INSERT INTO Category (CategoryName) VALUES
('Costruzioni'),
('Bambole'),
('Veicoli'),
('Puzzle'),
('Educativi');
INSERT INTO Region (RegionName) VALUES
('NorthEurope'),
('SouthEurope'),
('WestEurope');
INSERT INTO Country (CountryName, RegionID) VALUES
('Germany', 3),     
('France', 3),
('Italy', 2),       
('Spain', 2),
('Norway', 1),      
('Sweden', 1);
INSERT INTO Product (ProductName, CategoryID) VALUES
('Lego Classic 11005', 1),
('Barbie Fashionista', 2),
('Hot Wheels Mega Garage', 3),
('Puzzle Mappamondo 1000pz', 4),
('Set Didattico STEM Junior', 5),
('Lego Technic Bugatti', 1),
('Bambola Frozen Elsa', 2),
('Treno Elettrico Express', 3);
INSERT INTO Sales (DateOrder, DateShip, UnitSold, UnitCost, TotalProductCost, SalesAmount, ProductID, CountryID) VALUES
('2024-01-15', '2024-01-17', 10, 15.00, 150.00, 250.00, 1, 3), 
('2024-02-10', '2024-02-12', 5, 22.00, 110.00, 200.00, 2, 3),  
('2024-03-01', '2024-03-03', 12, 12.00, 144.00, 240.00, 3, 4), 
('2024-01-25', '2024-01-27', 3, 18.00, 54.00, 90.00, 4, 1),    
('2023-12-15', '2023-12-17', 6, 20.00, 120.00, 180.00, 5, 2),  
('2024-04-10', '2024-04-12', 8, 35.00, 280.00, 480.00, 6, 5),  
('2024-05-01', '2024-05-02', 4, 25.00, 100.00, 180.00, 7, 6),  
('2024-05-20', '2024-05-22', 7, 30.00, 210.00, 350.00, 8, 1);


#Task 4
#4.1 Verificare che i campi definiti come PK siano univoci. 
#In altre parole, scrivi una query per determinare l’univocità dei valori di ciascuna PK (una query per tabella implementata)

SELECT ProductID, COUNT(*) FROM Product GROUP BY ProductID HAVING COUNT(*) > 1;
SELECT CategoryID, COUNT(*) FROM Category GROUP BY CategoryID HAVING COUNT(*) > 1;
SELECT Sonumber, COUNT(*) FROM Sales GROUP BY sonumber HAVING COUNT(*) > 1;
SELECT RegionID, COUNT(*) FROM REGION GROUP BY REGIONID HAVING COUNT(*) > 1;
SELECT cOUNTRYID, COUNT(*) FROM COUNTRY GROUP BY Countryid HAVING COUNT(*) > 1;   #se i resultset sono vuoti, vuol dire che le chiavi sono univoche 


/*4.2 Esporre l’elenco delle transazioni indicando nel result set il codice documento, la data, 
#il nome del prodotto, la categoria del prodotto, il nome dello stato, il nome della regione di vendita 
#e un campo booleano valorizzato in base alla condizione 
che siano passati più di 180 giorni dalla data vendita o meno (>180 -> True, <= 180 -> False) */

select s.sonumber as Codicedocumento, s.dateorder, p.productname, cat.categoryname, c.countryname, r.regionname, DATEDIFF(S.dateship, S.DateOrder) > 180 AS TorF
from sales s 
join product p on s.productid = p.productid
join country c on s.countryid = c.countryid
join region r on c.regionid = r.regionid
join category cat on p.categoryid = cat.categoryid;     #con datediff >180 stabilisco se saranno veri(1), alrimenti falsi(0)
select * from sales;
set autocommit = 0;    #disattivo l'autocommit di mysql
start transaction;
update sales 
set dateship = '2024-08-19' 
where sonumber = 2;
update sales 
set dateship = '2024-06-19'
where sonumber = 3;
update sales
set dateship = '2024-08-19'
where sonumber = 1;
select * from sales;
commit;    #Ho modificato dei campi di dateship poiché per i dati che avevo inserito, nessuno era vero  (nesssuna diff era maggiore di 180 giorni)


/*4.3 Esporre l’elenco dei prodotti che hanno venduto, in totale,
una quantità maggiore della media delle vendite realizzate nell’ultimo anno censito. 
(ogni valore della condizione deve risultare da una query e non deve essere inserito a mano). 
Nel result set devono comparire solo il codice prodotto e il totale venduto. */

SELECT productID, SUM(UnitSold) AS Totalepezzivenduto
FROM SALES
WHERE YEAR(Dateorder) = (SELECT MAX(YEAR(DateOrder)) FROM Sales)
GROUP BY ProductID
HAVING SUM(UnitSold) > (SELECT AVG(SommaVendite)
FROM (SELECT SUM(UNITSOLD) AS SommaVendite
FROM Sales
WHERE YEAR(DateOrder) = (
SELECT MAX(YEAR(DateOrder)) FROM Sales)
GROUP BY ProductID) AS SubVendite);


#4.4 Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno. 
Select p.productname, sum(s.Salesamount) as fatturato, year(dateorder) as Anno
from sales s
join product p on s.productid = p.productid
where dateorder is not null
group by p.productname, year(dateorder)
order by anno desc;


#4.5 Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.

Select year(DATEORDER) as Anno, sum(SALESAMOUNT) as Fatturato, countryname
from Sales s
join COUNTRY C ON S.COUNTRYID = C.COUNTRYID
group by countryname, year(dateorder)
ORDER BY year(dateorder), fatturato DESC;


#4.6 Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?
select cat.categoryname, sum(s.unitsold) as Pezzivenduti
from sales s 
join product p on s.productid = p.productid
join category cat on p.categoryid = cat.categoryid
group by cat.categoryname
order by pezzivenduti desc
limit 1;     #ordinando in desc e limitando il result set alla prima riga, ottengo la categoria con più unita vendute


#4.7 Rispondere alla seguente domanda: quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.
SELECT p.ProductID, p.ProductName
FROM Product p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.ProductID IS NULL;       #con left join escludo dal result set i record di sales in cui non appaiono i produtti non venduti (nella tabella sales ci sono solo prod. venduti)

SELECT productID, productname
FROM PRODUCT
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM Sales);     #con questa subquery ottengo un result set con prodotti non presenti nelle vendite
INSERT INTO Product (ProductName, CategoryID)
VALUES 
  ('Puzzle Torre Eiffel 3000pz', 4),     
  ('Camion dei Pompieri PlaySet', 3);      #ho dovuto inserire due prodotti per fare in modo che i due result set delle query precedenti non fossero vuoti (avevo immesso dati che mi davano solo prodotti venduti)
  
  
 #4.8 Creare una vista sui prodotti in modo tale da esporre una “versione denormalizzata” delle informazioni utili (codice prodotto, nome prodotto, nome categoria)
 
 create view Versionedenormalizzata as (select productid as CodiceProdotto, productname as NomeProdotto, (select categoryname from category cat where p.categoryid = cat.categoryid) as NomeCategoria
 from product p);
 select * from versionedenormalizzata;     #view creata utilizzando una subquery 
 
 
 #4.9 Creare una vista per le informazioni geografiche
 
 create view InfoGeografiche as (select C.CountryID AS CodiceStato, c.Countryname as Stato, r.Regionname as Regione
 from country c 
 join region r on c.regionid = r.regionid);
 select * from infogeografiche;       #view creata utilizzando inner join