-- =========================================
-- SQL ШПАРГАЛКА ПО POSTGRESQL
-- БАЗА ДЛЯ АНАЛИТИКА
-- =========================================


-- =========================================
-- 🔢 ЧИСЛА
-- =========================================
ABS(x)              -- модуль числа
-- пример: ABS(-5) = 5

ROUND(x, n)         -- округлить до n знаков
-- пример: ROUND(10.567, 2) = 10.57

CEIL(x)             -- округлить вверх
-- пример: CEIL(10.1) = 11

FLOOR(x)            -- округлить вниз
-- пример: FLOOR(10.9) = 10


-- =========================================
-- 🔤 СТРОКИ
-- =========================================
LOWER(text)         -- нижний регистр
-- пример: LOWER('ABC') = 'abc'

UPPER(text)         -- верхний регистр
-- пример: UPPER('abc') = 'ABC'

LENGTH(text)        -- длина строки
-- пример: LENGTH('hello') = 5

SUBSTRING(text, a, b)   -- взять часть строки
-- a = с какой позиции
-- b = сколько символов взять
-- пример: SUBSTRING('abcdef', 1, 3) = 'abc'

CONCAT(a, b)        -- склеить строки
-- пример: CONCAT('sql', '123') = 'sql123'

TRIM(text)          -- убрать пробелы по краям
-- пример: TRIM('  hello  ') = 'hello'


-- =========================================
-- 📅 ДАТЫ И ВРЕМЯ
-- =========================================
NOW()               -- текущая дата и время

CURRENT_DATE        -- текущая дата без времени

-- =========================================
-- 🔍 DATE_PART → достать часть даты/времени
-- =========================================

DATE_PART('year', created_at)
-- пример: 2024-05-10 12:30:00 → 2024

DATE_PART('month', created_at)
-- пример: 2024-05-10 12:30:00 → 5

DATE_PART('day', created_at)
-- пример: 2024-05-10 12:30:00 → 10

DATE_PART('hour', created_at)
-- пример: 2024-05-10 12:30:00 → 12

DATE_PART('minute', created_at)
-- пример: 2024-05-10 12:30:00 → 30

DATE_PART('second', created_at)
-- пример: 2024-05-10 12:30:45 → 45

-- День недели (0 = воскресенье, 6 = суббота)
DATE_PART('dow', created_at)
-- пример: 2024-05-11 (суббота) → 6

-- День недели ISO (1 = понедельник, 7 = воскресенье)
DATE_PART('isodow', created_at)
-- пример: 2024-05-12 (воскресенье) → 7

-- День года (1–365/366)
DATE_PART('doy', created_at)
-- пример: 2024-01-01 → 1

-- Неделя года
DATE_PART('week', created_at)
-- пример: 2024-05-10 → 19

-- ISO-неделя
DATE_PART('isoweek', created_at)
-- пример: 2024-05-10 → 19

-- Квартал
DATE_PART('quarter', created_at)
-- пример: 2024-05-10 → 2

-- Десятилетие
DATE_PART('decade', created_at)
-- пример: 2024 → 202

-- Век
DATE_PART('century', created_at)
-- пример: 2024 → 21

-- Тысячелетие
DATE_PART('millennium', created_at)
-- пример: 2024 → 3

-- Эпоха (секунды с 1970 года)
DATE_PART('epoch', created_at)
-- пример: 2024-05-10 → 1715299200

-- =========================================
-- ✂️ DATE_TRUNC → обрезать дату до точности
-- =========================================

DATE_TRUNC('year', created_at)
-- пример: 2024-05-10 → 2024-01-01 00:00:00

DATE_TRUNC('month', created_at)
-- пример: 2024-05-10 → 2024-05-01 00:00:00

DATE_TRUNC('day', created_at)
-- пример: 2024-05-10 12:30 → 2024-05-10 00:00:00

DATE_TRUNC('hour', created_at)
-- пример: 2024-05-10 12:30 → 2024-05-10 12:00:00

DATE_TRUNC('minute', created_at)
-- пример: 2024-05-10 12:30:45 → 2024-05-10 12:30:00

DATE_TRUNC('second', created_at)
-- пример: 2024-05-10 12:30:45 → 2024-05-10 12:30:45

-- Неделя (начало недели — понедельник)
DATE_TRUNC('week', created_at)
-- пример: 2024-05-10 → 2024-05-06 00:00:00

-- Квартал
DATE_TRUNC('quarter', created_at)
-- пример: 2024-05-10 → 2024-04-01 00:00:00

-- =========================================
-- 💡 ЧАСТО ИСПОЛЬЗУЕТСЯ
-- =========================================

-- группировка по дням
DATE_TRUNC('day', created_at)

-- группировка по месяцам
DATE_TRUNC('month', created_at)

-- день недели
DATE_PART('dow', created_at)

-- час активности
DATE_PART('hour', created_at)

-- часто в задачах: группировка по месяцам
-- пример:
-- SELECT
--   DATE_TRUNC('month', created_at) AS month_start,
--   COUNT(*) AS orders_cnt
-- FROM orders
-- GROUP BY month_start
-- ORDER BY month_start;


-- =========================================
-- 🧠 ЛОГИКА
-- =========================================
CASE
  WHEN условие THEN значение
  ELSE значение
END

-- пример:
-- CASE
--   WHEN price > 1000 THEN 'дорого'
--   ELSE 'дёшево'
-- END


-- =========================================
-- 🧩 NULL
-- =========================================
COALESCE(a, b)      -- если a = NULL, взять b
-- пример: COALESCE(city, 'неизвестно')

NULLIF(a, b)        -- если a = b, вернуть NULL
-- пример: NULLIF(0, 0) = NULL


-- =========================================
-- 🔍 ФИЛЬТРАЦИЯ
-- =========================================
 WHERE → отфильтровать строки

-- пример:
-- WHERE price > 1000

-- пример:
-- WHERE customer_city = 'Москва'

-- пример:
-- WHERE created_at >= '2024-01-01'

-- пример:
-- WHERE name LIKE '%иван%'
-- % ... любые символы до/после

-- пример:
-- WHERE customer_city IS NULL

-- пример:
-- WHERE customer_city IS NOT NULL


-- =========================================
-- 📊 АГРЕГАЦИИ
-- =========================================
COUNT(*)            -- количество строк
-- пример: COUNT(*) = 125

COUNT(column)       -- количество НЕ NULL значений
-- пример: COUNT(customer_city)

SUM(x)              -- сумма
-- пример: SUM(price)

AVG(x)              -- среднее
-- пример: AVG(price)

MIN(x)              -- минимум
-- пример: MIN(price)

MAX(x)              -- максимум
-- пример: MAX(price)


-- =========================================
-- 📦 ГРУППИРОВКА
-- =========================================
GROUP BY column     -- группировка по столбцу

-- пример:
-- SELECT
--   customer_city,
--   COUNT(*) AS orders_cnt
-- FROM orders
-- GROUP BY customer_city

HAVING              -- фильтр после GROUP BY

-- пример:
-- SELECT
--   customer_city,
--   COUNT(*) AS orders_cnt
-- FROM orders
-- GROUP BY customer_city
-- HAVING COUNT(*) > 10


-- =========================================
-- 📈 СОРТИРОВКА
-- =========================================
ORDER BY column ASC     -- по возрастанию
-- пример: ORDER BY price ASC

ORDER BY column DESC    -- по убыванию
-- пример: ORDER BY price DESC

-- сортировка по нескольким полям
-- пример:
-- ORDER BY price DESC, order_id ASC


-- =========================================
-- 🔗 JOIN
-- =========================================
INNER JOIN          -- только совпадения
-- пример:
-- SELECT *
-- FROM customers c
-- INNER JOIN orders o
--   ON c.customer_id = o.customer_id

LEFT JOIN           -- всё из левой таблицы + совпадения справа
-- если совпадения нет, справа будет NULL
-- пример:
-- SELECT *
-- FROM customers c
-- LEFT JOIN orders o
--   ON c.customer_id = o.customer_id


-- =========================================
-- 🏷 ПСЕВДОНИМЫ
-- =========================================
AS                  -- переименовать столбец или таблицу

-- пример:
-- SELECT price AS total_price
-- FROM orders

-- пример:
-- FROM orders AS o


-- =========================================
-- 🔄 ПРИВЕДЕНИЕ ТИПОВ
-- =========================================
::type              -- привести к типу

-- пример:
-- customer_zip_code::varchar

-- пример:
-- price::numeric

CAST(x AS type)     -- то же самое через CAST
-- пример:
-- CAST(customer_zip_code AS varchar)


-- =========================================
-- 🔥 ЧАСТО ИСПОЛЬЗУЕМЫЕ КОНСТРУКЦИИ
-- =========================================

-- выбрать все столбцы
-- SELECT * FROM orders

-- выбрать нужные столбцы
-- SELECT order_id, price FROM orders

-- ограничить количество строк
LIMIT 10
-- пример:
-- SELECT * FROM orders LIMIT 10

-- убрать дубликаты
DISTINCT
-- пример:
-- SELECT DISTINCT customer_city FROM orders


-- =========================================
-- ✅ МИНИ-ПРИМЕРЫ
-- =========================================

-- 1. Категория цены
-- SELECT
--   order_id,
--   price,
--   CASE
--     WHEN price > 1000 THEN 'дорого'
--     ELSE 'дёшево'
--   END AS price_category
-- FROM orders;


-- 2. Подставить значение вместо NULL
-- SELECT
--   order_id,
--   customer_city,
--   COALESCE(customer_city, 'неизвестно') AS city_final
-- FROM orders;


-- 3. Достать месяц из даты
-- SELECT
--   order_id,
--   created_at,
--   DATE_PART('month', created_at) AS order_month
-- FROM orders;


-- 4. Обрезать дату до начала месяца
-- SELECT
--   order_id,
--   created_at,
--   DATE_TRUNC('month', created_at) AS month_start
-- FROM orders;


-- 5. Посчитать количество заказов по месяцам
-- SELECT
--   DATE_TRUNC('month', created_at) AS month_start,
--   COUNT(*) AS orders_cnt
-- FROM orders
-- GROUP BY month_start
-- ORDER BY month_start;


-- =========================================
-- 🧠 ТОП-10 ДЛЯ ЗАПОМИНАНИЯ
-- =========================================
-- DATE_PART   → достать часть даты
-- DATE_TRUNC  → обрезать дату
-- COALESCE    → заменить NULL
-- CASE        → логика
-- COUNT       → посчитать количество
-- AVG         → среднее
-- GROUP BY    → сгруппировать
-- ORDER BY    → отсортировать
-- WHERE       → отфильтровать
-- JOIN        → объединить таблицы


-- =========================================
-- КАК ЗАПОМНИТЬ
-- =========================================
-- WHERE      → фильтрует строки до группировки
-- GROUP BY   → собирает строки в группы
-- HAVING     → фильтрует уже группы
-- ORDER BY   → сортирует результат
-- LIMIT      → ограничивает количество строк


-- =========================================