-- =============================================================
-- ТЕМА: Подзапросы — Scalar Subquery, CASE WHEN
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Сложный | Тема: Scalar Subquery, CASE WHEN
--
-- Для товаров категории «Одежда» определить размер скидки
-- на основе сравнения цены со средней ценой по категории:
--   > средней → Скидка 15%
--   = средней → Скидка 10%
--   < средней → Скидка 5%
--
-- Поля: product_id, product_category_name, price, discount_status
-- Сортировка: по product_id, затем по price ASC
-- -------------------------------------------------------------

SELECT
    p.product_id,
    p.product_category_name,
    oi.price,
    CASE
        -- скалярный подзапрос: считает AVG один раз и сравнивает с каждой строкой
        WHEN oi.price > (
            SELECT AVG(oi2.price)
            FROM order_items oi2
            JOIN products p2 USING (product_id)
            WHERE p2.product_category_name = 'Одежда'
        ) THEN 'Скидка 15%'

        WHEN oi.price = (
            SELECT AVG(oi2.price)
            FROM order_items oi2
            JOIN products p2 USING (product_id)
            WHERE p2.product_category_name = 'Одежда'
        ) THEN 'Скидка 10%'

        ELSE 'Скидка 5%'
    END AS discount_status

FROM products p
JOIN order_items oi USING (product_id)
WHERE p.product_category_name = 'Одежда'
ORDER BY p.product_id, oi.price;


-- =============================================================
-- ЗАМЕТКА: оптимизация через CTE
-- Два одинаковых подзапроса выше можно вынести в CTE,
-- чтобы AVG считался один раз:
-- =============================================================
--
-- WITH avg_price AS (
--     SELECT AVG(oi2.price) AS val
--     FROM order_items oi2
--     JOIN products p2 USING (product_id)
--     WHERE p2.product_category_name = 'Одежда'
-- )
-- SELECT
--     p.product_id,
--     p.product_category_name,
--     oi.price,
--     CASE
--         WHEN oi.price > (SELECT val FROM avg_price) THEN 'Скидка 15%'
--         WHEN oi.price = (SELECT val FROM avg_price) THEN 'Скидка 10%'
--         ELSE 'Скидка 5%'
--     END AS discount_status
-- FROM products p
-- JOIN order_items oi USING (product_id)
-- WHERE p.product_category_name = 'Одежда'
-- ORDER BY p.product_id, oi.price;
