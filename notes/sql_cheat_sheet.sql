-- =========================================
-- 1. БАЗОВЫЙ СИНТАКСИС
-- =========================================

-- выбрать все столбцы
SELECT *
FROM orders;

-- выбрать нужные столбцы
SELECT
  order_id,
  customer_id,
  price
FROM orders;

-- убрать дубликаты
SELECT DISTINCT customer_city
FROM orders;

-- ограничить количество строк
SELECT *
FROM orders
LIMIT 10;


-- =========================================
-- 2. ПСЕВДОНИМЫ (ALIASES)
-- =========================================

-- переименовать столбец
SELECT
  price AS total_price
FROM orders;

-- короткое имя таблицы
SELECT
  o.order_id,
  o.price
FROM orders AS o;

-- алиасы таблиц часто используют в JOIN
SELECT
  o.order_id,
  c.customer_id
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;


-- =========================================
-- 3. СОРТИРОВКА
-- =========================================

-- по возрастанию
SELECT
  order_id,
  price
FROM orders
ORDER BY price ASC;

-- по убыванию
SELECT
  order_id,
  price
FROM orders
ORDER BY price DESC;

-- по нескольким полям
SELECT
  order_id,
  customer_id,
  price
FROM orders
ORDER BY price DESC, order_id ASC;


-- =========================================
-- 4. ФИЛЬТРАЦИЯ: WHERE
-- =========================================

-- простое условие
SELECT *
FROM orders
WHERE price > 1000;

-- строка
SELECT *
FROM customers
WHERE customer_city = 'Москва';

-- дата
SELECT *
FROM orders
WHERE created_at >= '2024-01-01';

-- несколько условий
SELECT *
FROM orders
WHERE order_status = 'paid'
  AND price > 1000;

SELECT *
FROM customers
WHERE customer_city = 'Москва'
   OR customer_city = 'Казань';

SELECT *
FROM orders
WHERE order_status <> 'canceled';


-- =========================================
-- 5. УСЛОВИЯ В WHERE
-- =========================================

-- входит в список
SELECT *
FROM customers
WHERE customer_city IN ('Москва', 'Казань');

-- диапазон
SELECT *
FROM orders
WHERE price BETWEEN 100 AND 500;

-- поиск по шаблону
SELECT *
FROM customers
WHERE name LIKE 'A%';

SELECT *
FROM customers
WHERE name LIKE '%abc%';

-- поиск по шаблону без учета регистра (PostgreSQL)
SELECT *
FROM customers
WHERE name ILIKE '%иван%';


-- =========================================
-- 6. NULL
-- =========================================

-- значение отсутствует
SELECT *
FROM customers
WHERE customer_city IS NULL;

-- значение заполнено
SELECT *
FROM customers
WHERE customer_city IS NOT NULL;

-- если значение NULL, подставить другое
SELECT
  customer_id,
  COALESCE(customer_city, 'неизвестно') AS city_final
FROM customers;

-- пример:
-- customer_city: NULL, 'Москва'
-- result: 'неизвестно', 'Москва'

-- если два значения равны, вернуть NULL
SELECT
  NULLIF(a, b)
FROM some_table;

-- пример:
-- a,b: 0,0
-- result: NULL

-- важно:
-- NULL нельзя сравнивать через = NULL
-- правильно: IS NULL / IS NOT NULL


-- =========================================
-- 7. ЛОГИКА: CASE WHEN
-- =========================================

CASE
  WHEN условие THEN значение
  WHEN условие THEN значение
  ELSE значение
END

-- пример: разбить цену на категории
SELECT
  order_id,
  price,
  CASE
    WHEN price > 1000 THEN 'дорого'
    ELSE 'дёшево'
  END AS price_category
FROM orders;

-- пример:
-- price: 1500, 700
-- result: 'дорого', 'дёшево'


-- =========================================
-- 8. ЧИСЛА
-- =========================================

ABS(x)              -- модуль числа
-- пример:
-- ABS(-5) = 5

ROUND(x, n)         -- округлить до n знаков
-- пример:
-- ROUND(10.567, 2) = 10.57

CEIL(x)             -- округлить вверх
-- пример:
-- CEIL(10.1) = 11

FLOOR(x)            -- округлить вниз
-- пример:
-- FLOOR(10.9) = 10


-- =========================================
-- 9. СТРОКИ
-- =========================================

LOWER(text)             -- нижний регистр
-- пример:
-- LOWER('ABC') = 'abc'

UPPER(text)             -- верхний регистр
-- пример:
-- UPPER('abc') = 'ABC'

LENGTH(text)            -- длина строки
-- пример:
-- LENGTH('hello') = 5

SUBSTRING(text, a, b)   -- взять часть строки
-- a = с какой позиции
-- b = сколько символов взять
-- пример:
-- SUBSTRING('abcdef', 1, 3) = 'abc'

CONCAT(a, b)            -- склеить строки
-- пример:
-- CONCAT('sql', '123') = 'sql123'

TRIM(text)              -- убрать пробелы по краям
-- пример:
-- TRIM('  hello  ') = 'hello'


-- =========================================
-- 10. ДАТЫ И ВРЕМЯ
-- =========================================

NOW()               -- текущая дата и время
-- пример:
-- NOW() = 2026-04-07 15:30:00

CURRENT_DATE        -- текущая дата без времени
-- пример:
-- CURRENT_DATE = 2026-04-07


-- =========================================
-- 11. DATE_PART → ДОСТАТЬ ЧАСТЬ ДАТЫ/ВРЕМЕНИ
-- =========================================

DATE_PART('year', created_at)
-- пример:
-- 2024-05-10 12:30:00 → 2024

DATE_PART('month', created_at)
-- пример:
-- 2024-05-10 12:30:00 → 5

DATE_PART('day', created_at)
-- пример:
-- 2024-05-10 12:30:00 → 10

DATE_PART('hour', created_at)
-- пример:
-- 2024-05-10 12:30:00 → 12

DATE_PART('minute', created_at)
-- пример:
-- 2024-05-10 12:30:00 → 30

-- секунды (могут быть с дробной частью)
DATE_PART('second', created_at)
-- пример:
-- 2024-05-10 12:30:45 → 45

-- день недели: 0 = воскресенье, 6 = суббота
DATE_PART('dow', created_at)
-- пример:
-- 2024-05-12 → 0

-- день недели ISO: 1 = понедельник, 7 = воскресенье
DATE_PART('isodow', created_at)
-- пример:
-- 2024-05-12 → 7

-- день года
DATE_PART('doy', created_at)
-- пример:
-- 2024-05-10 → 131

-- неделя года
DATE_PART('week', created_at)
-- пример:
-- 2024-05-10 → 19

-- квартал
DATE_PART('quarter', created_at)
-- пример:
-- 2024-05-10 → 2

-- эпоха: секунды с 1970 года
DATE_PART('epoch', created_at)
-- пример:
-- 1970-01-01 00:01:00 → 60


-- =========================================
-- 12. DATE_TRUNC → ОБРЕЗАТЬ ДАТУ ДО НУЖНОЙ ТОЧНОСТИ
-- =========================================

DATE_TRUNC('year', created_at)
DATE_TRUNC('month', created_at)
DATE_TRUNC('day', created_at)
DATE_TRUNC('hour', created_at)
DATE_TRUNC('minute', created_at)
DATE_TRUNC('second', created_at)
DATE_TRUNC('week', created_at)
DATE_TRUNC('quarter', created_at)

-- пример:
-- 2024-05-10 12:34:56
-- DATE_TRUNC('month', ...) = 2024-05-01 00:00:00

-- частые примеры:
-- группировка по дням
SELECT
  DATE_TRUNC('day', created_at) AS day_start,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY day_start
ORDER BY day_start;

-- группировка по месяцам
SELECT
  DATE_TRUNC('month', created_at) AS month_start,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY month_start
ORDER BY month_start;


-- =========================================
-- 13. ПРИВЕДЕНИЕ ТИПОВ
-- =========================================

::type
-- пример:
SELECT
  customer_zip_code::varchar
FROM customers;

CAST(x AS type)
-- пример:
SELECT
  CAST(price AS numeric)
FROM orders;


-- =========================================
-- 14. АГРЕГАЦИИ
-- =========================================

COUNT(*)                -- количество строк
COUNT(column)           -- считает только НЕ NULL значения
COUNT(DISTINCT column)  -- количество уникальных НЕ NULL значений
SUM(x)                  -- сумма
AVG(x)                  -- среднее
MIN(x)                  -- минимум
MAX(x)                  -- максимум

-- важно:
-- агрегатные функции схлопывают строки

-- пример:
SELECT
  COUNT(*) AS orders_cnt,
  COUNT(DISTINCT customer_id) AS customers_cnt,
  SUM(price) AS total_sum,
  AVG(price) AS avg_price,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM orders;

-- пример:
-- price: 100, 200, 300
-- SUM = 600
-- AVG = 200
-- MIN = 100
-- MAX = 300


-- =========================================
-- 15. FILTER В АГРЕГАТАХ (POSTGRESQL)
-- =========================================

FILTER (WHERE условие)

-- пример: посчитать все и доставленные заказы
SELECT
  COUNT(*) AS total_orders,
  COUNT(*) FILTER (WHERE order_status = 'Delivered') AS delivered_orders
FROM orders;

-- пример: сумма только по доставленным
SELECT
  SUM(price) FILTER (WHERE order_status = 'Delivered') AS delivered_sum
FROM orders;

-- пример:
-- status: Delivered, Pending, Delivered
-- result delivered_orders: 2


-- =========================================
-- 16. GROUP BY
-- =========================================

-- сгруппировать по столбцу
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city;

-- сгруппировать по нескольким столбцам
SELECT
  customer_city,
  order_status,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city, order_status;

-- пример:
-- city: Москва, Москва, Казань
-- result:
-- Москва = 2
-- Казань = 1


-- =========================================
-- 17. HAVING
-- =========================================

-- HAVING фильтрует уже готовые группы
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city
HAVING COUNT(*) > 10;

-- пример: города со средней ценой выше 1000
SELECT
  customer_city,
  AVG(price) AS avg_price
FROM orders
GROUP BY customer_city
HAVING AVG(price) > 1000;

-- пример:
-- city avg: Москва=1200, Казань=800
-- result: Москва


-- =========================================
-- 18. ПОРЯДОК ВЫПОЛНЕНИЯ SQL
-- =========================================

-- FROM      → выбрать основную таблицу
-- JOIN      → присоединить вторую таблицу
-- ON        → указать условие соединения
-- WHERE     → отфильтровать строки
-- GROUP BY  → сгруппировать строки
-- HAVING    → отфильтровать группы
-- WINDOW    → посчитать оконные функции
-- SELECT    → выбрать итоговые столбцы
-- ORDER BY  → отсортировать результат
-- LIMIT     → ограничить количество строк


-- =========================================
-- 19. ВИДЫ JOIN
-- =========================================

-- INNER JOIN → только совпадения
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id,
  o.price
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id;

-- LEFT JOIN → всё из левой таблицы + совпадения справа
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id;

-- RIGHT JOIN → всё из правой таблицы + совпадения слева
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id
FROM customers c
RIGHT JOIN orders o
  ON c.customer_id = o.customer_id;

-- FULL OUTER JOIN → все строки из обеих таблиц
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id
FROM customers c
FULL OUTER JOIN orders o
  ON c.customer_id = o.customer_id;


-- =========================================
-- 20. JOIN НА ПРАКТИКЕ
-- =========================================

-- FROM = основная таблица
-- JOIN = что присоединяем
-- ON   = по какому ключу соединяем

-- пример:
SELECT
  o.order_id,
  o.price,
  c.customer_name,
  c.customer_city
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;

-- если нужна информация из нескольких таблиц
SELECT
  o.order_id,
  c.customer_name,
  p.product_brand,
  oi.price AS item_price
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
JOIN products p
  ON oi.product_id = p.product_id;

-- важно про гранулярность:
-- orders      → 1 строка = 1 заказ
-- order_items → 1 строка = 1 товар в заказе

-- пример:
-- order_id 10 имеет 3 товара
-- после JOIN orders + order_items
-- order_id 10 появится 3 раза

-- если нужен итог на уровне заказа,
-- сначала агрегируй order_items, потом JOIN


-- =========================================
-- 21. ПОДЗАПРОСЫ (SUBQUERIES)
-- =========================================

-- Подзапрос = SELECT внутри другого запроса
--
-- Он может стоять:
-- 1) в WHERE
-- 2) в SELECT
-- 3) в FROM
-- 4) в JOIN
--
-- Главное:
-- подзапрос в SELECT должен вернуть одно значение на строку
-- подзапрос в FROM / JOIN возвращает таблицу
-- подзапрос в WHERE часто возвращает одно значение или список


-- =========================================
-- 22. ПОДЗАПРОС В WHERE: ОДНО ЗНАЧЕНИЕ
-- =========================================

-- найти заказы дороже средней цены
SELECT
  order_id,
  price
FROM orders
WHERE price > (
  SELECT AVG(price)
  FROM orders
);

-- сначала выполняется внутренний запрос:
-- SELECT AVG(price) FROM orders
-- потом внешний запрос сравнивает каждую строку с этим значением

-- пример:
-- avg(price) = 500
-- price: 300, 700
-- result: 700


-- =========================================
-- 23. ПОДЗАПРОС В WHERE: СПИСОК ЗНАЧЕНИЙ ЧЕРЕЗ IN
-- =========================================

-- найти клиентов, у которых есть заказы
SELECT *
FROM customers
WHERE customer_id IN (
  SELECT customer_id
  FROM orders
);

-- IN проверяет, входит ли значение в список,
-- который вернул подзапрос

-- пример:
-- список: 1, 2, 5
-- customer_id = 2 → подходит


-- =========================================
-- 24. EXISTS
-- =========================================

-- EXISTS проверяет:
-- есть ли хотя бы одна строка в подзапросе
--
-- внутри обычно пишут SELECT 1
-- число 1 тут не важно

-- найти клиентов, у которых есть заказы
SELECT *
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- найти товары, которые покупались
SELECT *
FROM products p
WHERE EXISTS (
  SELECT 1
  FROM order_items oi
  WHERE oi.product_id = p.product_id
);

-- с условием по городу
SELECT
  p.product_id,
  p.product_brand,
  oi.price
FROM products p
JOIN order_items oi
  ON p.product_id = oi.product_id
WHERE EXISTS (
  SELECT 1
  FROM orders o
  JOIN customers c
    ON o.customer_id = c.customer_id
  WHERE o.order_id = oi.order_id
    AND c.customer_city = 'Самара'
);

-- пример:
-- подзапрос нашёл хотя бы 1 строку
-- result: TRUE

-- важно:
-- ❌ нельзя так:
-- EXISTS (p.product_id = oi.product_id)
--
-- ✔ правильно только с SELECT:
-- EXISTS (
--   SELECT 1
--   FROM ...
--   WHERE ...
-- )


-- =========================================
-- 25. NOT EXISTS
-- =========================================

-- найти клиентов без заказов
SELECT *
FROM customers c
WHERE NOT EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- пример:
-- заказов нет
-- result: TRUE


-- =========================================
-- 26. EXISTS vs IN
-- =========================================

-- IN:
-- проверяет, есть ли значение в списке
SELECT *
FROM order_items oi
WHERE oi.order_id IN (
  SELECT o.order_id
  FROM orders o
);

-- EXISTS:
-- проверяет, есть ли хотя бы одна строка
SELECT *
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- удобно запомнить:
-- IN     → список значений
-- EXISTS → факт наличия строки


-- =========================================
-- 27. ПОДЗАПРОС В SELECT
-- =========================================

-- для каждого клиента показать количество его заказов
SELECT
  c.customer_id,
  c.customer_name,
  (
    SELECT COUNT(*)
    FROM orders o
    WHERE o.customer_id = c.customer_id
  ) AS orders_cnt
FROM customers c;

-- такой подзапрос зависит от строки внешнего запроса
-- это коррелированный подзапрос

-- важно:
-- подзапрос в SELECT должен вернуть одно значение
-- если он вернет несколько строк → будет ошибка

-- такой подзапрос удобен и нагляден,
-- но иногда JOIN + GROUP BY читается лучше

-- пример:
-- customer_id = 10
-- orders_cnt = 3


-- =========================================
-- 28. ПОДЗАПРОС В FROM
-- =========================================

-- сначала считаем заказы по городам,
-- потом работаем с этим результатом как с таблицей
SELECT
  city_stats.customer_city,
  city_stats.orders_cnt
FROM (
  SELECT
    customer_city,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_city
) AS city_stats
WHERE city_stats.orders_cnt > 10;

-- подзапрос в FROM создает временный набор строк
-- у него обязательно должен быть псевдоним


-- =========================================
-- 29. ПОДЗАПРОС В JOIN
-- =========================================

-- присоединить к клиентам количество их заказов
SELECT
  c.customer_id,
  c.customer_name,
  s.orders_cnt
FROM customers c
LEFT JOIN (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_id
) AS s
  ON c.customer_id = s.customer_id;

-- это очень частый шаблон:
-- 1) внутри считаем агрегат
-- 2) снаружи присоединяем через JOIN


-- =========================================
-- 30. КОГДА ЛУЧШЕ ПОДЗАПРОС, А КОГДА JOIN
-- =========================================

-- подзапрос в SELECT:
-- удобно, когда надо получить одно значение на строку

-- JOIN + агрегат:
-- удобно, когда нужно присоединить заранее посчитанную таблицу

-- EXISTS:
-- удобно, когда надо проверить наличие строк

-- IN:
-- удобно, когда надо проверить значение по списку

-- CTE:
-- удобно, когда запрос лучше разбить на шаги


-- =========================================
-- 31. WITH (CTE)
-- =========================================

-- CTE = временная именованная таблица внутри запроса
-- часто это более читаемая альтернатива подзапросу в FROM

WITH city_stats AS (
  SELECT
    customer_city,
    COUNT(*) AS cnt
  FROM orders
  GROUP BY customer_city
)
SELECT
  customer_city,
  cnt
FROM city_stats;

-- пример: несколько шагов через CTE
WITH orders_per_customer AS (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt,
    AVG(price) AS avg_price
  FROM orders
  GROUP BY customer_id
)
SELECT
  customer_id,
  orders_cnt,
  avg_price
FROM orders_per_customer
WHERE orders_cnt >= 3;

-- пример:
-- шаг 1: считаем по клиенту
-- шаг 2: фильтруем готовый результат


-- =========================================
-- 32. UNION / UNION ALL / INTERSECT / EXCEPT
-- =========================================

-- UNION → объединить результаты без дублей
SELECT customer_id
FROM customer_actions
UNION
SELECT customer_id
FROM customers;

-- UNION ALL → объединить результаты с дублями
SELECT customer_id
FROM customer_actions
UNION ALL
SELECT customer_id
FROM customers;

-- INTERSECT → оставить только общие строки
SELECT customer_id
FROM customer_actions
INTERSECT
SELECT customer_id
FROM customers;

-- EXCEPT → строки из первого SELECT, которых нет во втором
SELECT customer_id
FROM customer_actions
EXCEPT
SELECT customer_id
FROM customers;

-- важно:
-- количество столбцов должно совпадать
-- порядок столбцов должен совпадать
-- типы данных должны быть совместимы

-- пример:
-- A: 1,2,3
-- B: 3,4
-- UNION = 1,2,3,4
-- INTERSECT = 3
-- EXCEPT = 1,2


-- =========================================
-- 33. WINDOW FUNCTIONS
-- =========================================

-- Оконные функции НЕ схлопывают строки
-- и добавляют результат как новый столбец

-- когда использовать оконные функции:
-- - если нужно посчитать что-то по группе, но не потерять строки
-- - если нужен топ-N внутри группы
-- - если нужен накопительный итог
-- - если нужно сравнить строку с предыдущей или следующей

-- Всегда используются с OVER()

-- =========================================
-- СИНТАКСИС
-- =========================================

-- function() OVER (
--   PARTITION BY ...
--   ORDER BY ...
--   ROWS BETWEEN ...
-- )

-- =========================================
-- 1. АГРЕГАТНЫЕ ФУНКЦИИ
-- =========================================

-- SUM — сумма
SUM(price) OVER ()

-- AVG — среднее
AVG(price) OVER (PARTITION BY customer_id)

-- COUNT — количество
COUNT(*) OVER (PARTITION BY customer_id)

-- MIN / MAX — минимум / максимум
MIN(price) OVER ()
MAX(price) OVER ()

-- пример:
-- prices: 100, 200, 300
-- SUM OVER () = 600 в каждой строке


-- =========================================
-- 2. РАНЖИРОВАНИЕ (Ranking functions)
-- =========================================

-- Все функции ранжирования:
-- - не уменьшают количество строк
-- - работают по окну (OVER)
-- - требуют ORDER BY для корректного результата

-- ROW_NUMBER() → когда нужен жёсткий топ-N
-- RANK()       → одинаковые значения делят место, но будут пропуски
-- DENSE_RANK() → одинаковые значения делят место, без пропусков

-- -----------------------------------------
-- ROW_NUMBER — уникальный номер строки
-- -----------------------------------------
-- Каждая строка получает уникальный номер (1,2,3...)
-- Даже при одинаковых значениях порядок сохраняется

ROW_NUMBER() OVER (
  ORDER BY price DESC
)

-- пример:
-- price: 100, 90, 90, 80
-- result: 1, 2, 3, 4


-- -----------------------------------------
-- RANK — ранг с пропусками
-- -----------------------------------------
-- Одинаковые значения получают одинаковый ранг
-- Следующие значения "перепрыгивают" номера

RANK() OVER (
  ORDER BY price DESC
)

-- пример:
-- price: 100, 90, 90, 80
-- result: 1, 2, 2, 4


-- -----------------------------------------
-- DENSE_RANK — ранг без пропусков
-- -----------------------------------------
-- Одинаковые значения → одинаковый ранг
-- Нумерация идёт без пропусков

DENSE_RANK() OVER (
  ORDER BY price DESC
)

-- пример:
-- price: 100, 90, 90, 80
-- result: 1, 2, 2, 3


-- -----------------------------------------
-- NTILE(n) — деление на группы
-- -----------------------------------------
-- Делит строки на n групп (пример: квартиль, дециль)

NTILE(4) OVER (
  ORDER BY price
)

-- пример:
-- 8 строк
-- result: 1,1,2,2,3,3,4,4


-- =========================================
-- 3. СМЕЩЕНИЕ И ЗНАЧЕНИЯ В ОКНЕ
-- =========================================

-- -----------------------------------------
-- LAG — предыдущее значение
-- -----------------------------------------
-- Позволяет получить значение из предыдущей строки

LAG(price) OVER (
  ORDER BY created_at
)

-- используется для:
-- - сравнения с предыдущим значением
-- - расчёта роста/падения

-- пример:
-- price: 100, 120, 90
-- LAG:   NULL,100,120


-- -----------------------------------------
-- LEAD — следующее значение
-- -----------------------------------------
-- Возвращает значение из следующей строки

LEAD(price) OVER (
  ORDER BY created_at
)

-- пример:
-- price: 100, 120, 90
-- LEAD:  120,90,NULL


-- =========================================
-- ФУНКЦИИ ЗНАЧЕНИЙ (Value functions)
-- =========================================

-- ВАЖНО:
-- Эти функции зависят от "оконного фрейма" (ROWS BETWEEN ...)

-- если есть ORDER BY, а фрейм не указан явно,
-- поведение зависит от СУБД,
-- но часто окно считается от начала до текущей строки

-- -----------------------------------------
-- FIRST_VALUE — первое значение в окне
-- -----------------------------------------
-- Возвращает первое значение в пределах окна

FIRST_VALUE(price) OVER (
  PARTITION BY customer_id
  ORDER BY price
)

-- пример:
-- price: 50, 100, 200
-- result: 50, 50, 50


-- -----------------------------------------
-- LAST_VALUE — последнее значение в окне
-- -----------------------------------------
-- ⚠️ ВАЖНО: по умолчанию возвращает НЕ последнее значение,
-- а значение текущей строки (из-за фрейма)

LAST_VALUE(price) OVER (
  PARTITION BY customer_id
  ORDER BY price
)

-- чтобы получить реальное "последнее значение",
-- нужно расширить фрейм:

LAST_VALUE(price) OVER (
  PARTITION BY customer_id
  ORDER BY price
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)

-- пример:
-- price: 50, 100, 200
-- result: 200, 200, 200


-- -----------------------------------------
-- NTH_VALUE — n-ое значение в окне
-- -----------------------------------------
-- Возвращает n-ое значение внутри окна

NTH_VALUE(price, 2) OVER (
  PARTITION BY customer_id
  ORDER BY price
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)

-- пример:
-- price: 50, 100, 200
-- result: 100, 100, 100


-- -----------------------------------------
-- Пример использования
-- -----------------------------------------

SELECT
  customer_id,
  price,
  NTH_VALUE(price, 2) OVER (
    PARTITION BY customer_id
    ORDER BY price
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS second_price
FROM orders;


-- =========================================
-- ВАЖНО ПРО ОКОННЫЙ ФРЕЙМ
-- =========================================

-- Это означает:
-- - окно начинается с первой строки
-- - заканчивается на текущей строке

-- Поэтому:
-- - SUM → даёт накопительный эффект
-- - LAST_VALUE → "ломается"
-- - NTH_VALUE → может вести себя неожиданно

-- Если нужно использовать ВСЕ строки:
-- используем

ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING


-- =========================================
-- 4. СТАТИСТИКА
-- =========================================

-- PERCENT_RANK — относительный ранг (0–1)
PERCENT_RANK() OVER (ORDER BY price)
-- пример:
-- 4 строки
-- result: 0, 0.33, 0.66, 1

-- CUME_DIST — доля строк <= текущей
CUME_DIST() OVER (ORDER BY price)
-- пример:
-- 4 строки
-- result: 0.25, 0.5, 0.75, 1


-- =========================================
-- 5. НАСТРОЙКА ОКНА
-- =========================================

-- PARTITION BY — делит на группы
OVER (PARTITION BY customer_id)

-- пример:
-- customer_id: 1,1,2,2
-- result: 2 отдельные группы

-- ORDER BY — задаёт порядок
OVER (ORDER BY created_at)

-- пример:
-- date: 2024-01-01, 2024-01-02, 2024-01-03
-- result: расчёт идёт сверху вниз


-- =========================================
-- ROWS BETWEEN (ГРАНИЦЫ ПО СТРОКАМ)
-- =========================================

-- ROWS BETWEEN задаёт, какие строки участвуют в расчёте

-- от первой строки до текущей
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- N строк ДО текущей
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW

-- только текущая строка
ROWS BETWEEN CURRENT ROW AND CURRENT ROW

-- предыдущая + текущая + следующая строка
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING

-- N строк ПОСЛЕ текущей
ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING

-- от текущей строки до последней
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

-- вся таблица
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

-- пример:
-- rows: 10,20,30,40
-- 1 PRECEDING AND CURRENT ROW
-- result windows: (10), (10,20), (20,30), (30,40)


-- =========================================
-- RANGE BETWEEN (ГРАНИЦЫ ПО ЗНАЧЕНИЮ)
-- =========================================

-- RANGE работает по значению ORDER BY, а не по позиции строки

-- от первой строки до текущего значения
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- от текущего значения до конца
RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

-- вся таблица
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

-- ROWS = по строкам
-- RANGE = по значениям

-- пример:
-- price: 100,100,200
-- RANGE CURRENT ROW объединит две строки со 100


-- =========================================
-- ВАЖНО ПРО ФРЕЙМ ПО УМОЛЧАНИЮ
-- =========================================

-- если есть ORDER BY, но не указан ROWS / RANGE,
-- то по умолчанию обычно используется окно
-- от начала до текущей строки

-- поэтому LAST_VALUE() и NTH_VALUE() без явного ROWS BETWEEN
-- часто работают не так, как ожидают

-- RANGE объединяет строки с одинаковым значением ORDER BY
-- поэтому результат может отличаться от ROWS


-- =========================================
-- БАЗОВЫЕ ПАТТЕРНЫ
-- =========================================

-- накопительная сумма
SUM(price) OVER (
  ORDER BY created_at
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)

-- пример:
-- price: 100, 200, 50
-- result: 100, 300, 350

-- топ-1 в группе
ROW_NUMBER() OVER (
  PARTITION BY customer_id
  ORDER BY price DESC
)

-- пример:
-- prices in group: 500, 300, 100
-- result: 1, 2, 3

-- разница с предыдущим
price - LAG(price) OVER (ORDER BY created_at)

-- пример:
-- price: 100, 120, 90
-- result: NULL, 20, -30


-- =========================================
-- 33.1 ФИЛЬТРАЦИЯ ПО ОКОННЫМ ФУНКЦИЯМ
-- =========================================

-- нельзя писать так:
-- WHERE ROW_NUMBER() OVER (...) = 1

-- сначала считаем оконную функцию,
-- потом фильтруем снаружи

SELECT *
FROM (
  SELECT
    customer_id,
    order_id,
    price,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY price DESC
    ) AS rn
  FROM orders
) t
WHERE rn = 1;

-- пример:
-- взять самый дорогой заказ каждого клиента


-- =========================================
-- 33.2 ТОП-N ВНУТРИ ГРУППЫ
-- =========================================

SELECT *
FROM (
  SELECT
    product_category_name,
    product_id,
    product_height_cm,
    ROW_NUMBER() OVER (
      PARTITION BY product_category_name
      ORDER BY product_height_cm DESC
    ) AS rn
  FROM products
) t
WHERE rn <= 5;

-- пример:
-- взять топ-5 товаров по высоте в каждой категории


-- =========================================
-- GROUP BY vs WINDOW FUNCTIONS
-- =========================================

-- GROUP BY:
-- схлопывает строки

-- пример:
-- 3 заказа клиента → 1 строка на клиента

-- WINDOW FUNCTIONS:
-- не схлопывают строки

-- пример:
-- 3 заказа клиента → остаются 3 строки,
-- но можно добавить avg / sum / rank


-- =========================================
-- 34. МИНИ-ПРИМЕРЫ
-- =========================================

-- 1. Просто выбрать нужные столбцы
SELECT
  order_id,
  price
FROM orders;

-- 2. Отфильтровать дорогие заказы
SELECT
  order_id,
  price
FROM orders
WHERE price > 1000;

-- 3. Отсортировать дорогие заказы
SELECT
  order_id,
  price
FROM orders
WHERE price > 1000
ORDER BY price DESC;

-- 4. Подставить значение вместо NULL
SELECT
  order_id,
  customer_city,
  COALESCE(customer_city, 'неизвестно') AS city_final
FROM orders;

-- 5. Сделать категорию через CASE
SELECT
  order_id,
  price,
  CASE
    WHEN price > 1000 THEN 'дорого'
    ELSE 'дёшево'
  END AS price_category
FROM orders;

-- 6. Достать месяц из даты
SELECT
  order_id,
  created_at,
  DATE_PART('month', created_at) AS order_month
FROM orders;

-- 7. Посчитать количество заказов по городам
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city;

-- 8. Оставить только города, где заказов больше 10
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city
HAVING COUNT(*) > 10;

-- 9. Присоединить клиентов к заказам
SELECT
  o.order_id,
  o.price,
  c.customer_name
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;

-- 10. Найти клиентов, у которых есть заказы
SELECT *
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- 11. Для каждого клиента показать число заказов
SELECT
  c.customer_id,
  c.customer_name,
  (
    SELECT COUNT(*)
    FROM orders o
    WHERE o.customer_id = c.customer_id
  ) AS orders_cnt
FROM customers c;

-- 12. Присоединить заранее посчитанное количество заказов
SELECT
  c.customer_id,
  c.customer_name,
  s.orders_cnt
FROM customers c
LEFT JOIN (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_id
) AS s
  ON c.customer_id = s.customer_id;

-- 13. То же самое, но через CTE
WITH orders_per_customer AS (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_id
)
SELECT
  c.customer_id,
  c.customer_name,
  opc.orders_cnt
FROM customers c
LEFT JOIN orders_per_customer opc
  ON c.customer_id = opc.customer_id;

-- 14. Ранг заказов по цене внутри клиента
SELECT
  customer_id,
  order_id,
  price,
  ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY price DESC
  ) AS rn
FROM orders;

-- 15. Предыдущее значение через LAG
SELECT
  customer_id,
  order_id,
  created_at,
  price,
  LAG(price) OVER (
    PARTITION BY customer_id
    ORDER BY created_at
  ) AS prev_price
FROM orders;


-- =========================================
-- 35. КОРОТКАЯ ПАМЯТКА ПО ПОДЗАПРОСАМ
-- =========================================

-- ПОДЗАПРОС В SELECT
-- должен вернуть одно значение на одну строку

-- ПОДЗАПРОС В WHERE
-- может вернуть:
-- 1) одно значение
-- 2) список значений
-- 3) использоваться через EXISTS

-- ПОДЗАПРОС В FROM
-- возвращает временную таблицу

-- ПОДЗАПРОС В JOIN
-- обычно нужен, чтобы присоединить уже посчитанный агрегат


-- =========================================
-- 36. ЧТО ЧАЩЕ ВСЕГО ПУТАЮТ НОВИЧКИ
-- =========================================

-- 1) WHERE и HAVING
-- WHERE  → фильтр строк до группировки
-- HAVING → фильтр групп после GROUP BY

-- 2) COUNT(*) и COUNT(column)
-- COUNT(*)      → считает все строки
-- COUNT(column) → не считает NULL

-- 3) LEFT JOIN и INNER JOIN
-- INNER JOIN → только совпадения
-- LEFT JOIN  → все строки слева + совпадения справа

-- 4) IN и EXISTS
-- IN     → проверка по списку значений
-- EXISTS → проверка факта наличия строки

-- 5) подзапрос в SELECT и подзапрос в JOIN
-- SELECT-подзапрос → одно значение на строку
-- JOIN-подзапрос   → таблица с данными

-- 6) GROUP BY и оконные функции
-- GROUP BY → уменьшает количество строк
-- WINDOW   → оставляет строки и считает поверх них

-- 7) JOIN и "дубли"
-- дубли часто появляются не из-за ошибки,
-- а из-за разной гранулярности таблиц

-- 8) ROW_NUMBER, RANK, DENSE_RANK
-- ROW_NUMBER → всегда уникальный номер
-- RANK       → одинаковые значения делят место, с пропусками
-- DENSE_RANK → одинаковые значения делят место, без пропусков


-- =========================================
-- 37. КАК РЕШАТЬ ЗАДАЧИ НА ПРАКТИКЕ
-- =========================================

-- если нужна просто выборка
-- SELECT ... FROM ... WHERE ...

-- если нужно посчитать
-- SELECT ..., COUNT/SUM/AVG ...
-- FROM ...
-- GROUP BY ...

-- если нужно отфильтровать агрегат
-- HAVING ...

-- если нужно объединить таблицы
-- JOIN ...

-- если нужно сравнить с агрегатом
-- WHERE x > (SELECT AVG(...) ...)

-- если нужно проверить наличие связанных строк
-- EXISTS (...)

-- если нужно получить промежуточную таблицу
-- подзапрос в FROM или CTE

-- если нужно посчитать что-то поверх каждой строки,
-- но не потерять сами строки
-- window functions

-- если нужно взять топ-N внутри группы
-- ROW_NUMBER / RANK / DENSE_RANK + подзапрос или CTE

-- если появились "дубли" после JOIN
-- проверь гранулярность таблиц