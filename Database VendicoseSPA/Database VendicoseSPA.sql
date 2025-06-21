create database vendicosespa;  -- QUELLO UFFICIALE
use vendicosespa;
CREATE TABLE Categoria (
CategoriaID INT AUTO_INCREMENT PRIMARY KEY,
NomeCategoria VARCHAR (50) NOT NULL,
Sogliarestock int);

CREATE TABLE Prodotto (
ProdottoID INT AUTO_INCREMENT PRIMARY KEY,
NomeProdotto VARCHAR (50) NOT NULL,
Price DECIMAL (10,2),
CategoriaID INT,
FOREIGN KEY (CategoriaID) REFERENCES Categoria(CategoriaID));

CREATE TABLE Magazzino (
MagazzinoID INT AUTO_INCREMENT PRIMARY KEY,
NomeMagazzino VARCHAR (50),
Città VARCHAR (50),
Indirizzo VARCHAR (100));

CREATE TABLE Negozio (
NegozioID INT AUTO_INCREMENT PRIMARY KEY,
NomeNegozio VARCHAR (50),
Telefono varchar(50),
Città VARCHAR (50),
Indirizzo VARCHAR(100),
MagazzinoID INT,
FOREIGN KEY (MagazzinoID) REFERENCES Magazzino(MagazzinoID));

CREATE TABLE Giacenza (
ProdottoID INT,
MagazzinoID INT,
Quantità_magazzino INT,
PRIMARY KEY (ProdottoID, MagazzinoID),
FOREIGN KEY (ProdottoID) REFERENCES Prodotto(ProdottoID),
FOREIGN KEY (MagazzinoID) REFERENCES Magazzino(MagazzinoID));

CREATE TABLE Vendite (
TransazioneID INT AUTO_INCREMENT PRIMARY KEY,
Data_Vendita DATETIME unique,
NegozioID INT,
FOREIGN KEY (NegozioID) REFERENCES Negozio(NegozioID));

CREATE TABLE Dettaglio_Vendite (
Dettaglio_VenditeID INT AUTO_INCREMENT PRIMARY KEY,
TransazioneID INT,
ProdottoID INT,
Quantità INT,
FOREIGN KEY (TransazioneID) REFERENCES Vendite(TransazioneID),
FOREIGN KEY (ProdottoID) REFERENCES Prodotto(ProdottoID));

-- Categoria
INSERT INTO Categoria (NomeCategoria, Sogliarestock) VALUES
('Action Figures', 50),
('Puzzle', 30),
('Giochi Educativi', 40),
('Bambole', 60),
('Costruzioni', 70);

-- Prodotto
INSERT INTO Prodotto (NomeProdotto, Price, CategoriaID) VALUES
('Super Robot X', 29.99, 1),
('Puzzle Mondo 1000 Pezzi', 14.50, 2),
('Abaco Colorato', 9.99, 3),
('Bambola Anna con Accessori', 24.90, 4),
('Blocchi Costruzioni Maxi', 39.99, 5),
('Puzzle Animali della Fattoria', 12.00, 2),
('Kit Esperimenti Base', 18.75, 3),
('Action Hero Blaze', 22.50, 1),
('Mattoncini Creativi 500 pezzi', 44.99, 5);

-- Magazzino
INSERT INTO Magazzino (NomeMagazzino, Città, Indirizzo) VALUES
('Magazzino Nord', 'Milano', 'Via Lombardia 45'),
('Magazzino Sud', 'Napoli', 'Via Vesuvio 12'),
('Magazzino Centro', 'Firenze', 'Via del Mercato 101');

-- Negozio
INSERT INTO Negozio (NomeNegozio, Telefono, Città, Indirizzo, MagazzinoID) VALUES
('GiocaGiò Milano', '02-1234567', 'Milano', 'Corso Buenos Aires 33', 1),
('Bimbi Felici Napoli', '081-9876543', 'Napoli', 'Via Partenope 10', 2),
('Giochi&Cose Firenze', '055-334455', 'Firenze', 'Piazza della Libertà 88', 3);

-- Giacenza 
INSERT INTO Giacenza (ProdottoID, MagazzinoID, Quantità_magazzino) VALUES
(1, 1, 200),
(2, 1, 80),
(3, 2, 120),
(4, 2, 40),
(5, 3, 160),
(6, 1, 60),
(7, 3, 100),
(8, 2, 180),
(9, 3, 240);




#1) Ogni qual volta un prodotto viene venduto in un negozio, qual è la query da eseguire per aggiornare le tabelle di riferimento?
set sql_safe_updates = 0;  
set autocommit = 0;
UPDATE Giacenza g
JOIN (
    SELECT 
        dv.ProdottoID,
        n.MagazzinoID,
        dv.Quantità AS QuantitàVenduta
    FROM Dettaglio_Vendite dv
    JOIN Vendite v ON dv.TransazioneID = v.TransazioneID
    JOIN Negozio n ON v.NegozioID = n.NegozioID
    WHERE dv.TransazioneID = (select transazioneid from vendite order by transazioneid desc limit 1)  -- subquery
) AS sub
ON g.ProdottoID = sub.ProdottoID AND g.MagazzinoID = sub.MagazzinoID
SET g.Quantità_magazzino = g.Quantità_magazzino - sub.QuantitàVenduta;
create view ID AS (SELECT 
        dv.ProdottoID,
        n.MagazzinoID,
        dv.Quantità AS QuantitàVenduta
    FROM Dettaglio_Vendite dv
    JOIN Vendite v ON dv.TransazioneID = v.TransazioneID
    JOIN Negozio n ON v.NegozioID = n.NegozioID
    WHERE dv.TransazioneID = (select transazioneid from vendite order by transazioneid desc limit 1));
    select * from id;
    select transazioneid from vendite order by transazioneid desc limit 1;
UPDATE GIACENZA G
		JOIN (SELECT * FROM ID) AS SUB
		ON g.ProdottoID = sub.ProdottoID AND g.MagazzinoID = sub.MagazzinoID
SET g.Quantità_magazzino = g.Quantità_magazzino - sub.QuantitàVenduta;   -- utilizare in una trnsazione dopo l'inserimento di un una vendita con dettaglio trnsazione afferente
   
START TRANSACTION;

INSERT INTO Vendite (Data_Vendita, NegozioID) VALUES
('2025-06-16 11:11:00', 2);
INSERT INTO Dettaglio_Vendite (TransazioneID, ProdottoID, Quantità) VALUES
(1, 4, 6),
(1, 3, 2);

UPDATE GIACENZA G
		JOIN (SELECT * FROM ID) AS SUB
		ON g.ProdottoID = sub.ProdottoID AND g.MagazzinoID = sub.MagazzinoID
SET g.Quantità_magazzino = g.Quantità_magazzino - sub.QuantitàVenduta;
SELECT * FROM giacenza;
SELECT * FROM vendite;
ROLLBACK;
START TRANSACTION;
INSERT INTO Vendite (Data_Vendita, NegozioID) VALUES
('2025-06-16 11:10:00', 3);
INSERT INTO Dettaglio_Vendite (TransazioneID, ProdottoID, Quantità) VALUES
((select transazioneid from vendite order by transazioneid desc limit 1), 5, 4),
((select transazioneid from vendite order by transazioneid desc limit 1), 7, 2);


UPDATE GIACENZA G
		JOIN (SELECT * FROM ID) AS SUB
		ON g.ProdottoID = sub.ProdottoID AND g.MagazzinoID = sub.MagazzinoID
SET g.Quantità_magazzino = g.Quantità_magazzino - sub.QuantitàVenduta;

SELECT * FROM giacenza;
rollback;
commit;

#2) Quali sono le query da eseguire per verificare quante unità di un prodotto ci sono un dato magazzino? 
create view Anagrafica_prodotto as (select g.prodottoid, p.nomeprodotto, g.quantità_magazzino as Giacenza_prodotto, g.magazzinoid, m.nomemagazzino
from giacenza g
join prodotto p on g.prodottoid = p.prodottoid
join magazzino m on g.magazzinoid = m.magazzinoid order by prodottoid asc);

-- vogliamo vedere nel magazzino 2 la giacenza del prodotto con p_id 8
select * from anagrafica_prodotto where prodottoid = 9;

#3) e per monitorare le soglie di restock? 
create view Restock as (select g.prodottoid, p.nomeprodotto, c.nomecategoria, g.magazzinoid,  m.nomemagazzino, g.quantità_magazzino, c.sogliarestock, IF ((g.quantità_magazzino - c.sogliarestock) > 0, 'OK', 'RESTOCK') AS Alert_Restock
from giacenza g
join prodotto p on g.prodottoid = p.prodottoid          
join magazzino m on g.magazzinoid = m.magazzinoid
join categoria c on p.categoriaid = c.categoriaid
order by Alert_Restock desc); 

select * from restock;



