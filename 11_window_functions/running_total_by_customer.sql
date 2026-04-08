Для каждого клиента рассчитайте нарастающую сумму его трат от заказа к заказу cumulative_spend.
Для начала нужно посчитать общую стоимость каждого заказа order_total_price, так как в одном заказе может быть несколько товаров.
Результирующую таблицу отсортируйте по возрастанию customer_id и order_created_time.
Поля в результирующей таблице: customer_id, order_id, order_created_time, order_total_price, cumulative_spend

WITH order_total_price AS (
SELECT
order_id,
SUM(price) AS order_total_price
FROM order_items
GROUP BY order_id)

SELECT
c.customer_id,
o.order_id,
o.order_created_time,
ot.order_total_price,
SUM(ot.order_total_price) OVER (PARTITION BY c.customer_id ORDER BY o.order_id) AS cumulative_spend
FROM customers c

JOIN orders o USING(customer_id)

JOIN order_total_price ot ON ot.order_id = o.order_id

ORDER BY c.customer_id, o.order_created_time