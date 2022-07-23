CREATE TABLE Customer (
    Customer_ID         NUMERIC(6) PRIMARY KEY,
    Customer_Name       VARCHAR(35) NOT NULL,
    Customer_Address    VARCHAR(100) NULL,
    Customer_State      CHAR(2) NOT NULL,
    Customer_Zip        INT NOT NULL CHECK (5 <= Customer_Zip && Customer_Zip <= 6)
);

CREATE TABLE Products (
    Product_ID         NUMERIC(6)  PRIMARY KEY,
    Product_Name       VARCHAR(30) UNIQUE,
    Product_Price      FLOAT,
    Product_Line_ID    SMALLINT CHECK (10 <= Product_Line_ID && Product_Line_ID <= 100)
);

CREATE TABLE Sales_Order (
    Order_ID       NUMERIC(6)    PRIMARY KEY,
    Order_Date     DATE,
    Customer_ID    NUMERIC(6),

    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);

CREATE TABLE Order_Line (
    Order_ID      NUMERIC(6),
    Product_ID    NUMERIC(6) NOT NULL,
    PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY (Order_ID) REFERENCES Sales_Order(Order_ID) ON DELETE CASCADE,
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

----------------------------------------------------------

SELECT ProductID, ProductPrice, ProductPrice * 1.4 AS Increased_Product_Price FROM Product;

SELECT ProductID, ProductPrice, ProductName
FROM Product
WHERE ProductName > 100;

SELECT ProductID, ProductName, VendorID, CategoryID, ProductPrice
FROM Product
WHERE ProductPrice <= 200 AND CategoryID = 'FW';

SELECT VendorID
FROM Product
GROUP BY VendorID;

SELECT AVG(ProductPrice) AS ProductPriceAverage FROM Product;
SELECT COUNT(ProductID) AS TheNumberOfProducts FROM Product;

SELECT COUNT(ProductID), AVG(ProductPrice), MIN(ProductPrice), MAX(ProductPrice)
FROM Product
WHERE CategoryID = 'CP';

SELECT ProductID, ProductName, CategoryID, ProductPrice
FROM Product
WHERE CategoryID = 'FW'
ORDER BY ProductPrice DESC;

SELECT ProductID, SUM(NoOfItems) AS Total_Sold
FROM SaldVia
GROUP BY ProductID;

SELECT VendorID, COUNT(ProductID), AVG(ProductPrice) FROM Product GROUP BY VendorID;

SELECT *
FROM Products
WHERE ProductName LIKE 'Tiny%';

SELECT ProductID, ProductName, ProductPrice
FROM Product
WHERE CategoryID = 'CP'
ORDER BY ProductID;

SELECT TID, NoOfItems AS Total_Items_Sold
FROM SoldVia
WHERE NoOfItems > 5;

SELECT RegionID, COUNT(StoreID)
FROM Store
GROUP BY RegionID;

----------------------------------------------------------

SELECT salestransaction.tid,
       customer.customername,
       salestransaction.tdate
FROM salestransaction,
     customer,
     soldvia,
     product
WHERE soldvia.productid = product.productid
    AND salestransaction.tid = soldvia.tid
    AND salestransaction.customerid = customer.customerid
    AND product.productname = 'Dura Boot';

SELECT productid,
       productname
FROM product
WHERE productprice =
        (SELECT min(productprice)
         FROM product);

SELECT product.productid,
       product.productname,
       vendor.vendorname
FROM product,
     vendor
WHERE product.vendorid = vendor.vendorid
    AND product.productprice <
        (SELECT avg(productprice)
         FROM product);

SELECT customer.customername,
       avg(product.productprice)
FROM salestransaction,
     soldvia,
     customer,
     product
WHERE customer.customerid = salestransaction.customerid
    AND salestransaction.tid = soldvia.tid
    AND salestransaction.customerid = customer.customerid
    AND soldvia.productid = product.productid
GROUP BY customer.customername;

----------------------------------------------------------

SELECT SalesTransaction.TID, Customer.CustomerName, SalesTransaction.TDate
FROM SalesTransaction INNER JOIN Customer ON SalesTransaction.CustomerID = Customer.CustomerID INNER JOIN SoldVia ON SalesTransaction.TID = SoldVia.TID INNER JOIN Product ON SoldVia.ProductID = Product.ProductID
WHERE Product.ProductName = 'Dura Boot';

SELECT SalesTransaction.TID, Customer.CustomerName, SalesTransaction.TDate
FROM SalesTransaction NATURAL JOIN Customer NATURAL JOIN SoldVia NATURAL JOIN Product
WHERE Product.ProductName = 'Dura Boot';

SELECT SalesTransaction.TID, Customer.CustomerName, SalesTransaction.TDate
FROM SalesTransaction CROSS JOIN Customer CROSS JOIN SoldVia CROSS JOIN Product
WHERE SalesTransaction.CustomerID = Customer.CustomerID
      AND SalesTransaction.TID = SoldVia.TID
      AND SoldVia.ProductID = Product.ProductID
      AND Product.ProductName = 'Dura Boot';

SELECT Region.RegionName, Store.StoreID
FROM Region LEFT JOIN Store ON Region.RegionID = Store.RegionID;

SELECT Region.RegionName, Store.StoreID
FROM Region INNER JOIN Store ON Region.RegionID = Store.RegionID;

SELECT Region.RegionName, Store.StoreID
FROM Region RIGHT JOIN Store ON Region.RegionID = Store.RegionID;

SELECT Product.ProductID, Product.ProductName
FROM Product LEFT JOIN SoldVia ON Product.ProductID = SoldVia.ProductID
WHERE SoldVia.TID IS NULL;

SELECT CorpClient.CCID, CorpClient.CCName, Apartment.AptNo, Apartment.BuildingID
FROM CorpClient FULL JOIN Apartment ON CorpClient.CCID = Apartment.CCID;