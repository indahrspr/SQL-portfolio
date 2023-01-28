USE 3_odds;

-- function to determine the amount of bonus that each sales representative gets

SELECT
	CONCAT(firstName, ' ', lastName) employeeName,
	SUM(quantityOrdered*priceEach) total_sales
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders USING (customerNumber)
JOIN orderdetails USING (orderNumber)
WHERE status = 'Shipped'
GROUP BY 1
ORDER BY total_sales DESC;

WITH sales_report AS(
	SELECT
		employeeNumber,
		CONCAT(firstName, ' ', lastName) employeeName,
		SUM(quantityOrdered*priceEach) total_sales
	FROM employees e
	JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
	JOIN orders USING (customerNumber)
	JOIN orderdetails USING (orderNumber)
    WHERE status = 'Shipped'
	GROUP BY 1
)
SELECT employeeNumber, employeeName, total_sales,
	CASE
		WHEN total_sales > 400000 THEN 15000
        WHEN total_sales >= 200001 THEN 10000
        WHEN total_sales >= 100000 THEN 5000
        ELSE 0
	END bonus
FROM sales_report;

DELIMITER $$
CREATE FUNCTION total_bonus(
	total_sales DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE jumlah INT;
	CASE
		WHEN total_sales > 400000 THEN RETURN 15000;
        WHEN total_sales >= 200001 THEN RETURN 10000;
        WHEN total_sales >= 100000 THEN RETURN 5000;
        ELSE SET jumlah = 0;
	END CASE;
END $$
DELIMITER ;

WITH sales_report AS(
	SELECT
		employeeNumber,
		CONCAT(firstName, ' ', lastName) employeeName,
		SUM(quantityOrdered*priceEach) total_sales
	FROM employees e
	JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
	JOIN orders USING (customerNumber)
	JOIN orderdetails USING (orderNumber)
    WHERE status = 'Shipped'
	GROUP BY 1
)
SELECT
	employeeNumber, employeeName, total_sales,
	total_bonus(total_sales) AS bonus
FROM sales_report;
