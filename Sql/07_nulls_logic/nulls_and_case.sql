-- =============================================================
-- ТЕМА: NULL и условная логика — IS NULL, COALESCE, CASE WHEN
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Средний | Тема: CASE WHEN, LIKE
-- Добавить категорию бренда по ключевым словам в названии.
-- Приоритет: Фото → Техно → Энерго → Другое.
-- Поля: product_id, product_brand (в нижнем регистре), category
-- -------------------------------------------------------------

SELECT
    product_id,
    LOWER(product_brand) AS product_brand,
    CASE
        WHEN LOWER(product_brand) LIKE '%фото%'                             THEN 'Фото'
        WHEN LOWER(product_brand) LIKE '%квант%'
          OR LOWER(product_brand) LIKE '%техно%'                            THEN 'Техно'
        WHEN LOWER(product_brand) LIKE '%энерго%'                           THEN 'Энерго'
        ELSE 'Другое'
    END AS category
FROM products;


-- -------------------------------------------------------------
-- Задача 2 | Уровень: Базовый | Тема: IS NULL
-- Найти клиентов без указанного города.
-- Поля: customer_id
-- -------------------------------------------------------------

SELECT customer_id
FROM customers
-- = NULL не работает — используем IS NULL
WHERE customer_city IS NULL;


-- -------------------------------------------------------------
-- Задача 3 | Уровень: Средний | Тема: COALESCE, CAST
-- Поле destination = city, если заполнен, иначе zip_code.
-- ZIP-код нужно привести к VARCHAR для совместимости типов.
-- Поля: customer_id, customer_zip_code, customer_city, destination
-- -------------------------------------------------------------

SELECT
    customer_id,
    customer_zip_code,
    customer_city,
    -- COALESCE берёт первое ненулевое значение слева направо
    COALESCE(customer_city, customer_zip_code::VARCHAR) AS destination
FROM customers;


-- -------------------------------------------------------------
-- Задача 4 | Уровень: Средний | Тема: CASE WHEN, COALESCE, BETWEEN
-- Статус доставки заказов за период 15.01–03.03.2024.
-- Если дата доставки NULL — подставить '2050-01-01'.
-- Поля: order_id, status_order, order_delivered_customer_time
-- -------------------------------------------------------------

SELECT
    order_id,
    CASE
        -- доставили вовремя или раньше
        WHEN order_delivered_customer_time <= order_estimated_delivery_time THEN 'вовремя'
        -- доставили позже срока
        WHEN order_delivered_customer_time >  order_estimated_delivery_time THEN 'опоздал'
        ELSE 'остальные случаи'
    END AS status_order,
    -- заполняем пустую дату заглушкой
    COALESCE(order_delivered_customer_time, '2050-01-01') AS order_delivered_customer_time
FROM orders
-- BETWEEN включает левую границу, НЕ включает '2024-03-03' (строка без времени = '2024-03-03 00:00:00')
WHERE order_created_time BETWEEN '2024-01-15' AND '2024-03-03';


-- -------------------------------------------------------------
-- Задача 5 | Уровень: Средний | Тема: CASE WHEN, UPPER, IN
-- Разбить клиентов на группы «Столица» и «Другие»,
-- добавить город в верхнем регистре.
-- Поля: customer_id, city_upper, region_group
-- -------------------------------------------------------------

SELECT
    customer_id,
    UPPER(customer_city) AS city_upper,
    CASE
        WHEN customer_city IN ('Москва', 'Санкт-Петербург') THEN 'Столица'
        ELSE 'Другие'
    END AS region_group
FROM customers;
