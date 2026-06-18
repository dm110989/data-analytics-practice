-- =============================================================
-- ТЕМА: Оконные функции — SUM OVER, AVG OVER, ROW_NUMBER,
--        RANK, DENSE_RANK, LAG, LEAD, ROWS BETWEEN
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Средний | Тема: SUM OVER, CTE
--
-- Нарастающая сумма трат каждого клиента от заказа к заказу.
-- Сначала считаем стоимость каждого заказа (в заказе может быть
-- несколько товаров), затем накапливаем по клиенту.
--
-- Поля: customer_id, order_id, order_created_time,
--        order_total_price, cumulative_spend
-- Сортировка: customer_id ASC, order_created_time ASC
-- -------------------------------------------------------------

WITH order_total_price AS (
    -- суммируем позиции внутри каждого заказа
    SELECT
        order_id,
        SUM(price) AS order_total_price
    FROM order_items
    GROUP BY order_id
)

SELECT
    c.customer_id,
    o.order_id,
    o.order_created_time,
    ot.order_total_price,
    -- нарастающая сумма внутри каждого клиента по порядку заказов
    SUM(ot.order_total_price) OVER (
        PARTITION BY c.customer_id
        ORDER BY o.order_id
    ) AS cumulative_spend
FROM customers c
JOIN orders o           USING (customer_id)
JOIN order_total_price ot ON ot.order_id = o.order_id
ORDER BY c.customer_id, o.order_created_time;


-- -------------------------------------------------------------
-- Задача 2 | Уровень: Базовый | Тема: AVG OVER, PARTITION BY
--
-- Для каждого проданного товара показать его цену
-- и среднюю цену по категории рядом.
--
-- Поля: price, product_category_name, avg_category_price
-- Сортировка: price ASC
-- -------------------------------------------------------------

SELECT
    oi.price,
    p.product_category_name,
    -- среднее считается отдельно для каждой категории, строки не схлопываются
    AVG(oi.price) OVER (
        PARTITION BY p.product_category_name
    ) AS avg_category_price
FROM order_items oi
JOIN products p USING (product_id)
ORDER BY oi.price;


-- -------------------------------------------------------------
-- Задача 3 | Уровень: Сложный | Тема: ROW_NUMBER, RANK, DENSE_RANK, CTE
--
-- Топ-5 самых высоких товаров в каждой категории.
-- Добавить все три функции ранжирования чтобы видеть разницу.
--
-- Поля: product_category_name, product_id, product_height_cm,
--        row_num, rank_num, dense_rank_num
-- Сортировка: row_num DESC, product_id ASC
-- -------------------------------------------------------------

WITH ranked AS (
    SELECT
        product_category_name,
        product_id,
        product_height_cm,
        -- всегда уникальный номер строки
        ROW_NUMBER()  OVER (PARTITION BY product_category_name ORDER BY product_height_cm DESC) AS row_num,
        -- одинаковые значения = одинаковый ранг, следующий ранг пропускается (1,2,2,4)
        RANK()        OVER (PARTITION BY product_category_name ORDER BY product_height_cm DESC) AS rank_num,
        -- одинаковые значения = одинаковый ранг, без пропуска (1,2,2,3)
        DENSE_RANK()  OVER (PARTITION BY product_category_name ORDER BY product_height_cm DESC) AS dense_rank_num
    FROM products
)

SELECT
    product_category_name,
    product_id,
    product_height_cm,
    row_num,
    rank_num,
    dense_rank_num
FROM ranked
-- фильтруем через DENSE_RANK чтобы не терять товары с одинаковой высотой
WHERE dense_rank_num <= 5
ORDER BY row_num DESC, product_id ASC;


-- -------------------------------------------------------------
-- Задача 4 | Уровень: Сложный | Тема: AVG OVER, ROWS BETWEEN
--
-- Скользящее среднее выручки за 3 дня (текущий + 2 предыдущих).
--
-- Поля: order_date, daily_revenue, moving_avg_3d_revenue
-- Сортировка: order_date ASC
-- -------------------------------------------------------------

SELECT
    o.order_created_time::DATE                  AS order_date,
    SUM(oi.price)                               AS daily_revenue,
    -- AVG вложен в OVER — сначала GROUP BY схлопывает строки,
    -- потом оконная функция работает по уже агрегированным дням
    AVG(SUM(oi.price)) OVER (
        ORDER BY o.order_created_time::DATE
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW  -- окно: текущий день + 2 предыдущих
    )                                           AS moving_avg_3d_revenue
FROM orders o
JOIN order_items oi USING (order_id)
GROUP BY o.order_created_time::DATE
ORDER BY order_date;


-- -------------------------------------------------------------
-- Задача 5 | Уровень: Сложный | Тема: SUM OVER, ROWS BETWEEN, COALESCE, CTE
--
-- Для каждой категории и каждого месяца: выручка за месяц
-- и суммарная выручка за все предыдущие месяцы.
--
-- Поля: category_month, product_category_name,
--        monthly_revenue, total_revenue_before_this_month
-- Сортировка: product_category_name ASC, category_month ASC
-- -------------------------------------------------------------

WITH monthly_by_category AS (
    SELECT
        DATE_TRUNC('month', o.order_created_time)::DATE AS category_month,
        p.product_category_name,
        SUM(oi.price)                                   AS monthly_revenue
    FROM orders o
    JOIN order_items oi USING (order_id)
    JOIN products p     ON p.product_id = oi.product_id
    GROUP BY category_month, p.product_category_name
)

SELECT
    category_month,
    product_category_name,
    monthly_revenue,
    -- сумма всех строк ДО текущей (не включая текущую)
    COALESCE(
        SUM(monthly_revenue) OVER (
            PARTITION BY product_category_name
            ORDER BY category_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ),
        0  -- если предыдущих месяцев нет — подставляем 0
    ) AS total_revenue_before_this_month
FROM monthly_by_category
ORDER BY product_category_name, category_month;


-- -------------------------------------------------------------
-- Задача 6 | Уровень: Сложный | Тема: ROW_NUMBER, LEAD, CTE
--
-- Среднее время между 1-м и 2-м заказом для клиентов,
-- сделавших более одного заказа.
--
-- Поля: avg_time_between_1st_and_2nd_order
-- -------------------------------------------------------------

WITH ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        order_created_time,
        -- нумеруем заказы клиента по дате (1 = самый ранний)
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_created_time
        ) AS order_rank,
        -- для каждой строки — дата следующего заказа того же клиента
        LEAD(order_created_time) OVER (
            PARTITION BY customer_id
            ORDER BY order_created_time
        ) AS second_order_time
    FROM orders
)

SELECT
    AVG(second_order_time - order_created_time) AS avg_time_between_1st_and_2nd_order
FROM ranked_orders
-- берём только первые заказы у которых есть второй
WHERE order_rank = 1
  AND second_order_time IS NOT NULL;


-- -------------------------------------------------------------
-- Задача 7 | Уровень: Сложный | Тема: DENSE_RANK, CTE, DISTINCT
--
-- Найти клиентов, чей ПЕРВЫЙ заказ был в категории «Автомобили».
--
-- Поля: customer_id
-- Сортировка: customer_id DESC
-- -------------------------------------------------------------

WITH first_orders AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_created_time,
        p.product_category_name,
        -- ранжируем по дате, DENSE_RANK чтобы не терять одновременные заказы
        DENSE_RANK() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_created_time
        ) AS order_rank
    FROM orders o
    JOIN order_items oi USING (order_id)
    JOIN products p     ON oi.product_id = p.product_id
)

SELECT DISTINCT customer_id
FROM first_orders
WHERE product_category_name = 'Автомобили'
  AND order_rank = 1
ORDER BY customer_id DESC;


-- -------------------------------------------------------------
-- Задача 8 | Уровень: Сложный | Тема: DENSE_RANK, CTE
--
-- Три самых дорогих товара в каждой категории.
-- При одинаковой цене — одинаковый ранг (DENSE_RANK).
--
-- Поля: product_category_name, product_id, price, price_rank
-- Сортировка: product_category_name ASC, price_rank ASC
-- -------------------------------------------------------------

WITH ranked_prices AS (
    SELECT
        p.product_category_name,
        p.product_id,
        oi.price,
        DENSE_RANK() OVER (
            PARTITION BY p.product_category_name
            ORDER BY oi.price DESC
        ) AS price_rank
    FROM products p
    JOIN order_items oi USING (product_id)
)

SELECT
    product_category_name,
    product_id,
    price,
    price_rank
FROM ranked_prices
WHERE price_rank <= 3
ORDER BY product_category_name, price_rank;


-- -------------------------------------------------------------
-- Задача 9 | Уровень: Сложный | Тема: AVG OVER, PARTITION BY, DISTINCT
--
-- Для каждого товара: отклонение цены от средней по категории
-- и от средней по бренду.
--
-- Поля: product_id, product_category_name, product_brand, price,
--        avg_category_price, avg_brand_price,
--        category_price_delta, brand_price_delta
-- -------------------------------------------------------------

SELECT DISTINCT
    oi.product_id,
    p.product_category_name,
    p.product_brand,
    oi.price,
    AVG(oi.price) OVER (PARTITION BY p.product_category_name) AS avg_category_price,
    AVG(oi.price) OVER (PARTITION BY p.product_brand)         AS avg_brand_price,
    -- положительное = товар дороже среднего, отрицательное = дешевле
    oi.price - AVG(oi.price) OVER (PARTITION BY p.product_category_name) AS category_price_delta,
    oi.price - AVG(oi.price) OVER (PARTITION BY p.product_brand)         AS brand_price_delta
FROM order_items oi
JOIN products p USING (product_id)
ORDER BY oi.product_id, p.product_category_name, oi.price, category_price_delta;


-- -------------------------------------------------------------
-- Задача 10 | Уровень: Средний | Тема: DENSE_RANK, подзапрос, COUNT DISTINCT
--
-- Ранжировать клиентов по количеству уникальных категорий покупок.
-- «Исследователи» (много категорий) vs «Специалисты» (мало).
--
-- Поля: customer_id, distinct_categories_count, diversity_rank
-- Сортировка: diversity_rank ASC, customer_id ASC
-- -------------------------------------------------------------

SELECT
    t1.customer_id,
    t1.distinct_categories_count,
    DENSE_RANK() OVER (
        ORDER BY t1.distinct_categories_count DESC
    ) AS diversity_rank
FROM (
    SELECT
        o.customer_id,
        COUNT(DISTINCT p.product_category_name) AS distinct_categories_count
    FROM orders o
    JOIN order_items oi USING (order_id)
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY o.customer_id
) t1
ORDER BY diversity_rank ASC, t1.customer_id ASC;


-- -------------------------------------------------------------
-- Задача 11 | Уровень: Сложный | Тема: LAG, SUM OVER, CTE
--
-- Разбивка событий клиентов на сессии.
-- Логика: новая сессия если пауза между событиями > 30 минут.
-- Сессия идентифицируется как "customer_id_session_num".
--
-- Поля: customer_id, event_timestamp, session_id
-- -------------------------------------------------------------

-- Шаг 1: для каждого события получаем время предыдущего события
WITH events_with_lag AS (
    SELECT
        customer_id,
        event_timestamp,
        LAG(event_timestamp) OVER (
            PARTITION BY customer_id
            ORDER BY event_timestamp
        ) AS prev_event_time
    FROM customer_actions
),

-- Шаг 2: ставим флаг 1 = начало новой сессии, 0 = продолжение
session_boundaries AS (
    SELECT
        customer_id,
        event_timestamp,
        CASE
            WHEN prev_event_time IS NULL                                    THEN 1  -- первое событие клиента
            WHEN (event_timestamp - prev_event_time) > INTERVAL '30 minutes' THEN 1  -- долгая пауза
            ELSE 0
        END AS is_new_session
    FROM events_with_lag
),

-- Шаг 3: нумеруем сессии накопительной суммой флагов
-- пример: флаги 1,0,0,1,0 → номера 1,1,1,2,2
sessions AS (
    SELECT
        customer_id,
        event_timestamp,
        SUM(is_new_session) OVER (
            PARTITION BY customer_id
            ORDER BY event_timestamp
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS session_num
    FROM session_boundaries
)

SELECT
    customer_id,
    event_timestamp,
    -- формируем читаемый ID сессии: "customer_id_session_num"
    CONCAT(customer_id, '_', session_num) AS session_id
FROM sessions
ORDER BY customer_id, event_timestamp;
