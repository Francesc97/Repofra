select * from dimproduct;
# esponi in output i campi ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag. Assegnare un alias se necessario
select ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag as FGF from dimproduct;
#esponi in output i soli prodotti finiti cioè quelli per cui il campo FinishedGoodsFlag è uguale a 1
select ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag as FGF from dimproduct where FinishedGoodsFlag=1;
#esponi in output i prodotti il cui PAK comincia on FR o BK
select Productkey, productalternatekey as model, englishproductname, standardcost, listprice from dimproduct where Productalternatekey like 'FR%' or productalternatekey like 'BK%';
#arricchire output precedente con Markup applicato dallazienda (listprice - standardcost)
select Productkey, productalternatekey as model, englishproductname, standardcost, listprice, listprice - standardcost as Markup from dimproduct where Productalternatekey like 'FR%' or productalternatekey like 'BK%';
#esporre lʼelenco dei prodotti finiti il cui prezzo di listino è compreso tra 1000 e 2000
select Productkey, productalternatekey as model, englishproductname, standardcost, listprice from dimproduct where (FinishedGoodsFlag = 1) and (listprice>1000 and listprice<2000) and (productalternatekey like 'fr%' or productalternatekey like 'bk%');
#esplora la tabella dimemployee
select* from dimemployee;
#esponi l'elenco dei soli agenti con salespersonflag =1
select * from dimemployee where salespersonflag = 1;
#interroga la tabella delle vendite 
select * from factresellersales;
#Esponi in output lʼelenco delle transazioni registrate a partire dal 1 gennaio 2020 dei soli codici prodotto: 597, 598, 477, 214
select * from factresellersales where (orderdate > '2020-01-01') and productkey in (597, 598, 477, 214);
#Calcola per ciascuna transazione il profitto SalesAmount - TotalProductCost
select salesordernumber, orderdate, productkey, orderquantity, unitprice, totalproductcost, salesamount, salesamount - totalproductcost as Markup from factresellersales where (orderdate > '2020-01-01') and productkey in (597, 598, 477, 214);