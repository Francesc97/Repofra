-- 1. Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. Quali considerazioni/ragionamenti è necessario che tu faccia? 
SELECT COUNT(*) AS totale, COUNT(DISTINCT ProductKey) AS distinti
FROM dimproduct;      -- con questa query dovrei riuscire a stabilire che productkey è una pk poiché un requisito per esserlo è l'univocità delle istanze (tot=distinti)

-- 2. Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.
describe factresellersales;
SELECT 
  COUNT(*) AS totale_righe,
  COUNT(SalesOrderNumber),
  COUNT(SalesOrderLineNumber)
FROM factresellersales; 

-- 3. Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.
select * from factresellersales;
SELECT 
  OrderDate,
  COUNT(SalesOrderLineNumber) AS NumeroTransazioni
FROM factresellersales
WHERE OrderDate >= '2020-01-01'
GROUP BY OrderDate
ORDER BY OrderDate;

# 4. Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (factResellerSales.OrderQuantity)
#e il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct) a partire dal 1 Gennaio 2020. 
#Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. 
#I campi in output devono essere parlanti! 
 select 
	p.englishproductname as nome_del_prodotto,
	sum(f.salesamount) as fatturato_totale,
	sum(f.orderquantity) as quantità_totale_venduta,
    round(avg(f.unitprice),2) as prezzo_medio_di_vendita
	from factresellersales f
    join dimproduct p on f.productkey = p.productkey
    where f.orderdate >= '2020-01-01'
    group by f.productkey
    order by fatturato_totale desc;
    
#1.2 Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) per Categoria prodotto (DimProductCategory). 
#Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta.
#I campi in output devono essere parlanti!
Select c.EnglishProductCategoryName as nome_categoria_prodotto,
	sum(f.salesamount) as fatturato_totale,
	sum(f.orderquantity) as quantità_totale_venduta
from factresellersales f
join dimproduct p on f.productkey = p.productkey
join dimproductsubcategory sub on p.productsubcategorykey = sub.productsubcategorykey
join dimproductcategory c on sub.ProductCategoryKey = c.ProductCategoryKey
group by c.EnglishProductCategoryName
order by fatturato_totale desc;

#2.2 Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. 
#Il result set deve esporre lʼelenco delle città con fatturato realizzato superiore a 60K
select 
	g.city,
	sum(f.salesamount) as fatturato_totale
    from factresellersales f 
    join dimreseller r on f.resellerkey = r.resellerkey
	join dimgeography g on r.geographykey = g.geographykey
    where orderdate >= '2020-01-01'
    group by city 
    having fatturato_totale > 60000
    order by fatturato_totale desc;