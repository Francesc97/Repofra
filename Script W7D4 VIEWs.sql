#Implementa una vista denominata Product al fine di creare unʼanagrafica (dimensione) prodotto completa. 
#La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome prodotto, il nome della sottocategoria associata e il nome della categoria associata.
create view product as (SELECT
	p.Englishproductname as NomeProdotto,
    sub.EnglishProductSubcategoryName as SottocategoriaProdotto,
    c.EnglishProductCategoryName as CategoriaProdotto
    from dimproduct p
	join dimproductsubcategory sub on p.productsubcategorykey = sub.productsubcategorykey
	join dimproductcategory c on sub.ProductCategoryKey = c.ProductCategoryKey);
    CREATE OR REPLACE VIEW product AS
(SELECT
	p.productkey,
	p.Englishproductname as NomeProdotto,
    sub.EnglishProductSubcategoryName as SottocategoriaProdotto,
    c.EnglishProductCategoryName as CategoriaProdotto
    from dimproduct p
	join dimproductsubcategory sub on p.productsubcategorykey = sub.productsubcategorykey
	join dimproductcategory c on sub.ProductCategoryKey = c.ProductCategoryKey);
    SELECT * FROM PRODUCT;


    
    #Implementa una vista denominata Reseller al fine di creare unʼanagrafica (dimensione) reseller completa. 
    #La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome del reseller, il nome della città e il nome della regione
    
    create view Reseller as (
    select 
    r.resellername as NomeReseller,
    g.city as Città,
    g.stateprovincename as Regione
	from dimreseller r 
	join dimgeography g on r.geographykey = g.geographykey
    );
    SELECT * FROM RESELLER;
    
    create or replace view Reseller as (
    SELECT 
    r.resellerkey,
    r.resellername as NomeReseller,
    g.city as Città,
    g.stateprovincename as Regione
	from dimreseller r 
	join dimgeography g on r.geographykey = g.geographykey
    );
    SELECT * FROM RESELLER;

#Crea una vista denominata Sales che deve restituire la data dellʼordine, il codice documento, la riga di corpo del documento, 
#la quantità venduta, lʼimporto totale e il profitto.

create view Sales as (
select
f.productkey,
f.resellerkey,
 orderdate as DataOrdine,
 salesordernumber as CodiceDocumento,
 salesorderlinenumber as Rigadicorpodeldocumento,
 orderquantity as QuantitàVenduta,
salesamount as ImportoTotale,
TotalProductCost,
(SalesAmount - TotalProductCost) as Profitto
from factresellersales f 
join dimproduct p on f.productkey = p.productkey
join dimreseller r on f.ResellerKey = r.resellerkey
);

create or replace view Saeles as (select
f.productkey,
f.resellerkey,
 orderdate as DataOrdine,
 salesordernumber as CodiceDocumento,
 salesorderlinenumber as Rigadicorpodeldocumento,
 orderquantity as QuantitàVenduta,
salesamount as ImportoTotale,
(SalesAmount - TotalProductCost) as Profitto
from factresellersales f 
join dimproduct p on f.productkey = p.productkey
join dimreseller r on f.ResellerKey = r.resellerkey
);


select *
from product p 
join sales f on p.productkey = f.productkey
join reseller r on f.ResellerKey = r.resellerkey;

