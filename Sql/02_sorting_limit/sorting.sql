-- =============================================================
-- ТЕМА: Сортировка — ORDER BY, LIMIT
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Базовый | Тема: ORDER BY
-- Вывести все столбцы таблицы products,
-- отсортировав по возрастанию product_id и убыванию product_brand.
-- -------------------------------------------------------------

SELECT *
FROM products
ORDER BY
    product_id ASC,
    product_brand DESC;


-- -------------------------------------------------------------
-- Задача 2 | Уровень: Базовый | Тема: ORDER BY + LIMIT
-- Найти топ-10 самых тяжёлых продуктов.
-- Поля: product_id, product_weight_g, product_category_name
-- -------------------------------------------------------------

SELECT
    product_id,
    product_weight_g,
    product_category_name
FROM products
ORDER BY product_weight_g DESC
LIMIT 10;


-- -------------------------------------------------------------
-- Задача 3 | Уровень: Средний | Тема: LOWER, LENGTH, ORDER BY
-- Вывести ID продукта, название бренда в нижнем регистре
-- и длину названия бренда. Топ-10 по длине (по возрастанию).
-- Поля: product_id, product_brand_lower, length_brand
-- -------------------------------------------------------------

SELECT
    product_id,
    LOWER(product_brand)    AS product_brand_lower,
    LENGTH(product_brand)   AS length_brand
FROM products
ORDER BY LENGTH(product_brand) ASC
LIMIT 10;


-- -------------------------------------------------------------
-- Задача 4 | Уровень: Средний | Тема: FLOOR, арифметика
-- Рассчитать цену товара со скидкой 5% и скидкой 100 руб.
-- Цены округлить вниз (FLOOR).
-- Сортировка: по убыванию product_id, затем price.
-- Поля: product_id, price, price_5_perc_discount, price_100_rub_discount
-- -------------------------------------------------------------

SELECT
    product_id,
    price,
    FLOOR(price * 0.95)     AS price_5_perc_discount,   -- цена минус 5%
    FLOOR(price - 100)      AS price_100_rub_discount    -- цена минус 100 руб
FROM order_items
ORDER BY
    product_id DESC,
    price DESC;
