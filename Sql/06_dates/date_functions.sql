-- =============================================================
-- ТЕМА: Функции дат — DATE_PART, CAST, арифметика с датами
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Средний | Тема: DATE_PART, NOW()
-- Выгрузка клиентов с разбивкой даты регистрации на части
-- и количеством дней с момента регистрации.
-- Поля: customer_id, customer_city, day_created_at,
--       month_created_at, year_created_at, register_days_ago
-- -------------------------------------------------------------

SELECT
    customer_id,
    customer_city,
    DATE_PART('day',   created_at)          AS day_created_at,
    DATE_PART('month', created_at)          AS month_created_at,
    DATE_PART('year',  created_at)          AS year_created_at,
    -- вычитаем дату регистрации из текущего момента, берём дни
    DATE_PART('day', NOW() - created_at)    AS register_days_ago
FROM customers;


-- -------------------------------------------------------------
-- Задача 2 | Уровень: Средний | Тема: CAST, DATE_PART, разность дат
-- Для каждого заказа вывести даты без времени и задержку доставки.
-- Положительное значение delivery_delay_days = опередил,
-- отрицательное = опоздал.
-- Поля: order_id, order_created_day, order_delivered_customer_day,
--       order_estimated_delivery_day, delivery_delay_days
-- Сортировка: по возрастанию задержки, затем order_id.
-- -------------------------------------------------------------

SELECT
    order_id,
    CAST(order_created_time           AS DATE) AS order_created_day,
    CAST(order_delivered_customer_time AS DATE) AS order_delivered_customer_day,
    CAST(order_estimated_delivery_time AS DATE) AS order_estimated_delivery_day,
    -- ожидаемая - фактическая: положительное = доставили раньше срока
    DATE_PART(
        'day',
        order_estimated_delivery_time - order_delivered_customer_time
    )                                           AS delivery_delay_days
FROM orders
ORDER BY
    delivery_delay_days ASC,
    order_id ASC;
