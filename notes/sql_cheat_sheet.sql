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
WHERE status = 'paid'
  AND price > 1000;

SELECT *
FROM customers
WHERE city = 'Москва'
   OR city = 'Казань';

SELECT *
FROM orders
WHERE NOT status = 'canceled';


-- =========================================
-- 5. УСЛОВИЯ В WHERE
-- =========================================

-- входит в список
SELECT *
FROM customers
WHERE city IN ('Москва', 'Казань');

-- диапазон
SELECT *
FROM orders
WHERE price BETWEEN 100 AND 500;

-- поиск по шаблону с учетом регистра
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

-- если a = NULL, взять b
COALESCE(a, b)
-- пример: COALESCE(city, 'неизвестно')

-- если a = b, вернуть NULL
NULLIF(a, b)
-- пример: NULLIF(0, 0)


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


-- =========================================
-- 8. ЧИСЛА
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
-- 9. СТРОКИ
-- =========================================

LOWER(text)             -- нижний регистр
-- пример: LOWER('ABC') = 'abc'

UPPER(text)             -- верхний регистр
-- пример: UPPER('abc') = 'ABC'

LENGTH(text)            -- длина строки
-- пример: LENGTH('hello') = 5

SUBSTRING(text, a, b)   -- взять часть строки
-- a = с какой позиции
-- b = сколько символов взять
-- пример: SUBSTRING('abcdef', 1, 3) = 'abc'

CONCAT(a, b)            -- склеить строки
-- пример: CONCAT('sql', '123') = 'sql123'

TRIM(text)              -- убрать пробелы по краям
-- пример: TRIM('  hello  ') = 'hello'


-- =========================================
-- 10. ДАТЫ И ВРЕМЯ
-- =========================================

NOW()               -- текущая дата и время
CURRENT_DATE        -- текущая дата без времени


-- =========================================
-- 11. DATE_PART → ДОСТАТЬ ЧАСТЬ ДАТЫ/ВРЕМЕНИ
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

-- день недели: 0 = воскресенье, 6 = суббота
DATE_PART('dow', created_at)

-- день недели ISO: 1 = понедельник, 7 = воскресенье
DATE_PART('isodow', created_at)

-- день года
DATE_PART('doy', created_at)

-- неделя года
DATE_PART('week', created_at)

-- квартал
DATE_PART('quarter', created_at)

-- эпоха: секунды с 1970 года
DATE_PART('epoch', created_at)


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
COUNT(column)           -- количество НЕ NULL значений
COUNT(DISTINCT column)  -- количество уникальных НЕ NULL значений
SUM(x)                  -- сумма
AVG(x)                  -- среднее
MIN(x)                  -- минимум
MAX(x)                  -- максимум

-- пример:
SELECT
  COUNT(*) AS orders_cnt,
  COUNT(DISTINCT customer_id) AS customers_cnt,
  SUM(price) AS total_sum,
  AVG(price) AS avg_price,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM orders;


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
  status,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city, status;


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


-- =========================================
-- 18. ПОРЯДОК ВЫПОЛНЕНИЯ SQL
-- =========================================

-- FROM      → выбрать основную таблицу
-- JOIN      → присоединить вторую таблицу
-- ON        → указать условие соединения
-- WHERE     → отфильтровать строки
-- GROUP BY  → сгруппировать строки
-- HAVING    → отфильтровать группы
-- SELECT    → выбрать итоговые столбцы
-- ORDER BY  → отсортировать результат
-- LIMIT     → ограничить количество строк


-- =========================================
-- 19. JOIN
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
-- 20. JOIN: КАК ДУМАТЬ
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

-- если нужна информация из 3 таблиц
SELECT
  o.order_id,
  c.customer_name,
  p.product_brand,
  oi.price
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
JOIN products p
  ON oi.product_id = p.product_id;


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
--
-- JOIN + агрегат:
-- удобно, когда нужно присоединить заранее посчитанную таблицу
--
-- EXISTS:
-- удобно, когда надо проверить наличие строк
--
-- IN:
-- удобно, когда надо проверить значение по списку


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


-- =========================================
-- 33. WINDOW FUNCTIONS (БАЗА)
-- =========================================

-- window functions не схлопывают строки,
-- в отличие от GROUP BY

-- нумерация строк
SELECT
  customer_id,
  price,
  ROW_NUMBER() OVER (ORDER BY price DESC) AS rn
FROM orders;

-- ранг с пропусками
SELECT
  customer_id,
  price,
  RANK() OVER (ORDER BY price DESC) AS price_rank
FROM orders;

-- общая сумма по всем строкам
SELECT
  customer_id,
  price,
  SUM(price) OVER () AS total_sum
FROM orders;

-- нумерация внутри группы
SELECT
  customer_id,
  price,
  ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY price DESC
  ) AS rn
FROM orders;


-- =========================================
-- 34. МИНИ-ПРИМЕРЫ: ОТ ПРОСТОГО К СЛОЖНОМУ
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


-- =========================================
-- КОНЕЦ ШПАРГАЛКИ
-- =========================================
