select* from dimproduct;
describe dimreseller;
describe dimsalesterritory;
describe dimproduct;
describe factresellersales;
describe dimproductcategory;
describe dimproductsubcategory;
#esporre anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria
select *
from dimproduct p
join dimproductsubcategory s on p.ProductSubcategoryKey = s.ProductSubcategoryKey;
#esporre angrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria
select p.productkey, p.EnglishProductName, s.EnglishProductSubcategoryName, c.EnglishProductCategoryName
from dimproduct p
left join dimproductsubcategory s on p.ProductSubcategoryKey = s.ProductSubcategoryKey
left join dimproductcategory c on s.productcategorykey = c.productcategorykey;
#esponi l'elenco dei soli prodotti venduti 
select *
from dimproduct p 
join factresellersales s on p.productkey = s.productkey;
#esponi l'elenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il campo fgf = 1)
select p.productkey, p.EnglishProductName, s.orderdate
from dimproduct p 
left join factresellersales s on p.productkey = s.productkey
where s.productkey is null
and p.FinishedGoodsFlag=1;
#SUGGERIMENTO DI DANILO: [si può anche annidare una query (subquery)]
select distinct p.productkey, p.EnglishProductName, p.FinishedGoodsFlag
from dimproduct p 
where p.FinishedGoodsFlag = 1 and p.productkey not in (select distinct productkey from factresellersales);

#esponi l'elenco delle transazione di vendita indicando anche il nome del prodotto venduto
select s.productkey, p.englishproductname, s.SalesOrderNumber, s.OrderDate, s.OrderQuantity, s.unitprice, s.totalproductcost, s.salesamount
from factresellersales s 
join dimproduct p on s.productkey = p.productkey;
#esporre l'elenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto
select s.productkey, p.englishproductname, c.EnglishProductCategoryName, s.SalesOrderNumber, s.OrderDate, s.OrderQuantity, s.unitprice, s.totalproductcost, s.salesamount
from factresellersales s 
join dimproduct p on s.productkey = p.productkey
join dimproductsubcategory b on p.ProductSubcategoryKey = b.ProductSubcategoryKey
join dimproductcategory c on b.productcategorykey = c.productcategorykey;
#esplora la tabella dimseller
select * from dimreseller;
select * from dimgeography;
#esponi in output l'elenco dei reseller indicando, per ciascun reseller, anche la sua area geografica
select r.resellerkey, r.resellername, r.geographykey, g.city, g.stateprovincename, g.countryregioncode, g.englishcountryregionname
from dimreseller r 
left join dimgeography g on r.geographykey = g.geographykey;
/*Esponi lʼelenco delle transazioni di vendita. Il result set deve esporre i campi: 
SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost. 
Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e lʼarea geografica
*/
select s.SalesOrderNumber, s.SalesOrderLineNumber, s.OrderDate, s.OrderQuantity, s.unitprice, s.totalproductcost, p.englishproductname, c.EnglishProductCategoryName, r.resellername, g.englishcountryregionname
from factresellersales s 
left join dimproduct p on s.productkey = p.productkey
left join dimproductsubcategory b on p.ProductSubcategoryKey = b.ProductSubcategoryKey
left join dimproductcategory c on b.productcategorykey = c.productcategorykey
left join dimreseller r on s.resellerkey = r.resellerkey
left join dimgeography g on r.geographykey = g.geographykey;