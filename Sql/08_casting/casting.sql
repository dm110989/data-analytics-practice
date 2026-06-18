-- =============================================================
-- ТЕМА: Приведение типов — CAST, ::
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Базовый | Тема: CAST, ::
-- Вывести клиентов, приведя zip_code к INTEGER, дату — к VARCHAR.
-- Поля: customer_id, customer_zip_code (INTEGER), created_at (VARCHAR)
-- Сортировка: по возрастанию zip_code.
-- -------------------------------------------------------------

SELECT
    customer_id,
    customer_zip_code::INTEGER,     -- оператор :: — синтаксис PostgreSQL
    created_at::VARCHAR             -- эквивалент CAST(created_at AS VARCHAR)
FROM customers
ORDER BY customer_zip_code ASC;


-- =============================================================
-- СПРАВКА: два способа приведения типов в PostgreSQL
-- =============================================================
--
--  PostgreSQL-синтаксис:   value::type
--  Стандартный SQL:        CAST(value AS type)
--
--  Пример:
--  customer_zip_code::INTEGER  =  CAST(customer_zip_code AS INTEGER)
--  created_at::VARCHAR         =  CAST(created_at AS VARCHAR)
--
--  Типы данных:
--  INTEGER / INT   — целое число
--  NUMERIC         — дробное число
--  VARCHAR / TEXT  — строка
--  DATE            — дата без времени
--  TIMESTAMP       — дата со временем
--  BOOLEAN         — true / false
-- =============================================================
