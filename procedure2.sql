USE 3_odds;

-- procedures that can provide information on the top 10 best selling items sold in 2004
-- barang_terjual = sold items
-- barang_terlaris = best selling items

SELECT
	productCode,
    productName,
    SUM(quantityOrdered) barang_terjual
FROM orderdetails
JOIN products USING(productCode)
JOIN orders USING(orderNumber)
WHERE YEAR(orderDate) = 2004
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

DELIMITER $$
CREATE PROCEDURE barang_terlaris()
BEGIN
	SELECT
		productCode,
		productName,
		SUM(quantityOrdered) barang_terjual
	FROM orderdetails
	JOIN products USING(productCode)
	JOIN orders USING(orderNumber)
	WHERE YEAR(orderDate) = 2004
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 10;
END $$
DELIMITER ;

CALL barang_terlaris();
