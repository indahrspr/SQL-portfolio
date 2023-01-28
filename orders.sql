USE 3_odds;
SHOW TABLES;

-- What products have been ordered and how many
SELECT * FROM orderdetails;
SELECT
  p.productCode,
  p.productName,
  SUM(o.quantityOrdered) totalquantityOrdered
FROM products p
LEFT JOIN orderdetails o USING(productCode)
GROUP BY productName;

-- What are the products whose status is still in the processing stage, and how much is the income from each of these products
SELECT * FROM orderdetails;
SELECT
  p.productCode,
  p.productName,
  od.quantityOrdered,
  o.status,
  (od.priceEach*od.quantityOrdered) total_pendapatan
FROM products p
LEFT JOIN orderdetails od USING(productCode)
LEFT JOIN orders o USING(orderNumber)
WHERE o.status = 'In Process'
GROUP BY p.productName;

-- The remaining stock of products that have been ordered and the percentage of products sold to the total stock (assume total stock = quantityOrdered + quantitystock)
SELECT * FROM products;
SELECT
  p.productName,
  p.quantityInStock,
  SUM(od.quantityOrdered) total_quantity_ordered,
  (p.quantityInStock+SUM(od.quantityOrdered)) AS total_stock,
  SUM(od.quantityOrdered)/(p.quantityInStock+SUM(od.quantityOrdered))*100 AS percentage
FROM products p
LEFT JOIN orderdetails od USING(productCode)
GROUP BY p.productName;

-- Any product whose selling price is 20 percent below the vendor's recommended price
SELECT
  DISTINCT(p.productName),
  od.priceEach,
  p.MSRP
FROM products p
LEFT JOIN orderdetails od USING(productCode)
WHERE od.priceEach < 0.8*p.MSRP
GROUP BY p.productName;

-- Information about the customer who has placed an order along with the name and number of products ordered
SELECT
  c.customerNumber,
  c.customerName,
  p.productName,
  od.quantityOrdered
FROM customers c
LEFT JOIN orders o USING(customerNumber)
LEFT JOIN orderdetails od USING(orderNumber)
LEFT JOIN products p USING(productCode)
;
