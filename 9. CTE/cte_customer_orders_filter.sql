-- Найти всех пользователей из СПБ и МСК
-- зарегистрировавшихся после 1 марта 2024 года у которых:
-- больше 5 доставленных заказов
-- средняя стоимость заказа превышает 20000
-- вывести таких пользователей и информацию про них
--
--
WITH delivered_orders AS (
SELECT
o.customer_id,
COUNT(o.order_id) AS total_orders,
SUM(oi.price) AS total_price,
SUM(oi.price)::numeric / COUNT(o.order_id) AS avg_order_price
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.customer_id)

SELECT
c.customer_id,
c.customer_city,
c.created_at,
d.total_orders,
d.avg_order_price
FROM 
customers c INNER JOIN delivered_orders d
ON c.customer_id = d.customer_id
WHERE c.customer_city IN ('Санкт-Петербург', 'Москва') AND d.total_orders > 5 AND d.avg_order_price > 20000 AND c.created_at > '2024-03-01'
ORDER BY d.total_orders DESC