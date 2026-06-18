-- =============================================================
-- ТЕМА: Фильтрация — WHERE, IN, BETWEEN, LIKE, IS NULL, INTERVAL
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Базовый | Тема: WHERE, LIKE
-- Вывести продукты из категории «Одежда», отсортировав по весу.
-- Поля: product_id, product_brand, product_category_name,
--       product_height_cm, product_length_cm, product_width_cm, product_weight_g
-- -------------------------------------------------------------

SELECT
    product_id,
    product_brand,
    product_category_name,
    product_height_cm,
    product_length_cm,
    product_width_cm,
    product_weight_g
FROM products
-- LOWER + LIKE чтобы найти «Одежда», «одежда», «ОДЕЖДА» и т.д.
WHERE LOWER(product_category_name) LIKE '%одежда%'
ORDER BY product_weight_g DESC;


-- -------------------------------------------------------------
-- Задача 2 | Уровень: Базовый | Тема: WHERE, дата
-- Вывести клиентов, зарегистрировавшихся с 1 февраля 2024 включительно.
-- Поля: customer_id, customer_zip_code, customer_city, created_at
-- -------------------------------------------------------------

SELECT
    customer_id,
    customer_zip_code,
    customer_city,
    created_at
FROM customers
WHERE created_at >= '2024-02-01';


-- -------------------------------------------------------------
-- Задача 3 | Уровень: Средний | Тема: WHERE, IN, DATE_PART
-- Клиенты из Москвы или Санкт-Петербурга, зарегистрированные в январе.
-- Поля: customer_id
-- -------------------------------------------------------------

SELECT customer_id
FROM customers
WHERE customer_city IN ('Санкт-Петербург', 'Москва')
  AND DATE_PART('month', created_at) = 1;


-- -------------------------------------------------------------
-- Задача 4 | Уровень: Базовый | Тема: WHERE, IN
-- Продукты из категорий «Электроника», «Одежда» и «Сад».
-- Поля: product_id, product_brand, product_category_name
-- -------------------------------------------------------------

SELECT
    product_id,
    product_brand,
    product_category_name
FROM products
WHERE product_category_name IN ('Электроника', 'Одежда', 'Сад');


-- -------------------------------------------------------------
-- Задача 5 | Уровень: Базовый | Тема: WHERE, точечный запрос
-- Найти город клиента с ID = 229.
-- Поля: customer_city
-- -------------------------------------------------------------

SELECT customer_city
FROM customers
WHERE customer_id = 229;


-- -------------------------------------------------------------
-- Задача 6 | Уровень: Сложный | Тема: WHERE, INTERVAL, IS NOT NULL
-- Заказы после 4 января 2024 (не включительно), статус ≠ Returned,
-- ожидаемая доставка через 5–10 дней от создания,
-- фактическая дата доставки не NULL.
-- Сортировка: по убыванию даты создания.
-- -------------------------------------------------------------

SELECT
    order_id,
    order_status,
    order_created_time
FROM orders
WHERE order_created_time > '2024-01-04'
  AND order_status <> 'Returned'
  -- BETWEEN включает оба края
  AND order_estimated_delivery_time BETWEEN
        order_created_time + INTERVAL '5 days'
    AND order_created_time + INTERVAL '10 days'
  AND order_delivered_customer_time IS NOT NULL
ORDER BY order_created_time DESC;


-- -------------------------------------------------------------
-- Задача 7 | Уровень: Средний | Тема: WHERE, LIKE, AND
-- Продукты с «фото» в бренде (любой регистр) и весом > 500 г.
-- Поля: product_id, product_brand, product_category_name
-- -------------------------------------------------------------

SELECT
    product_id,
    product_brand,
    product_category_name
FROM products
WHERE LOWER(product_brand) LIKE '%фото%'
  AND product_weight_g > 500;
