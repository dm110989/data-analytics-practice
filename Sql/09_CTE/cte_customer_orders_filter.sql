-- =============================================================
-- ТЕМА: CTE (Common Table Expressions) — WITH
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Сложный | Тема: CTE, JOIN, агрегаты, фильтрация
--
-- Найти клиентов из Москвы и Санкт-Петербурга,
-- зарегистрированных после 1 марта 2024 года,
-- у которых: > 5 доставленных заказов И средний чек > 20 000 руб.
--
-- Поля: customer_id, customer_city, created_at,
--        total_orders, avg_order_price
-- Сортировка: по убыванию total_orders
-- -------------------------------------------------------------

-- Шаг 1: считаем агрегаты только по доставленным заказам
WITH delivered_orders AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id)                              AS total_orders,
        SUM(oi.price)                                           AS total_price,
        -- средний чек: total / кол-во заказов
        -- ::numeric нужен чтобы результат был дробным, а не целым
        SUM(oi.price)::NUMERIC / COUNT(DISTINCT o.order_id)    AS avg_order_price
    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
)

-- Шаг 2: фильтруем клиентов по условиям задачи
SELECT
    c.customer_id,
    c.customer_city,
    c.created_at,
    d.total_orders,
    d.avg_order_price
FROM customers c
INNER JOIN delivered_orders d ON c.customer_id = d.customer_id
WHERE c.customer_city IN ('Санкт-Петербург', 'Москва')
  AND d.total_orders     > 5
  AND d.avg_order_price  > 20000
  AND c.created_at       > '2024-03-01'
ORDER BY d.total_orders DESC;
