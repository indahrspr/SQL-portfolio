-- product sales level obtained from the total sales of each product in 2005

USE 3_odds;

SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM products;

WITH product_sales AS (SELECT
	productCode,
    productName,
    SUM(quantityOrdered*priceEach) sales
FROM orderdetails
LEFT JOIN products USING(productCode)
LEFT JOIN orders USING(orderNumber)
WHERE YEAR(orderDate) = 2005
GROUP BY 1
)
SELECT productCode, productName, sales,
    CASE
		WHEN sales > 20000 THEN 'higher selling product'
        WHEN sales > 10000 THEN 'average selling product'
        ELSE 'lower selling product'
	END productSales
FROM product_sales;

DELIMITER $$
CREATE PROCEDURE product_sales_categories()
BEGIN
	WITH product_sales AS (SELECT
		productCode,
		productName,
		SUM(quantityOrdered*priceEach) sales
	FROM orderdetails
	LEFT JOIN products USING(productCode)
	LEFT JOIN orders USING(orderNumber)
	WHERE YEAR(orderDate) = 2005
	GROUP BY 1
	)
	SELECT productCode, productName, sales,
		CASE
			WHEN sales > 20000 THEN 'higher selling product'
			WHEN sales > 10000 THEN 'average selling product'
			ELSE 'lower selling product'
		END productSales
	FROM product_sales;
END $$
DELIMITER ;

CALL product_sales_categories();
