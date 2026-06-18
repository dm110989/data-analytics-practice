-- =============================================================
-- ТЕМА: Строковые функции — CONCAT, UPPER, LOWER, LENGTH,
--        SUBSTRING, SPLIT_PART, LIKE
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Средний | Тема: CONCAT, UPPER, LENGTH
-- Сформировать полное название товара и артикул.
-- Формат названия: "brand - category" (пр.: SAMSUNG - ЭЛЕКТРОНИКА)
-- Формат артикула: BRAND + длина категории (пр.: SAMSUNG12)
-- Поля: product_id, product_full_name, product_number
-- -------------------------------------------------------------

SELECT
    product_id,
    CONCAT(product_brand, ' - ', product_category_name)        AS product_full_name,
    -- артикул: бренд в верхнем регистре + длина названия категории
    CONCAT(UPPER(product_brand), LENGTH(product_category_name)) AS product_number
FROM products;


-- -------------------------------------------------------------
-- Задача 2 | Уровень: Средний | Тема: SUBSTRING, SPLIT_PART, CONCAT
-- Сформировать название, артикул (первые 3 символа бренда + длина категории)
-- и основную категорию (первое слово из product_category_name).
-- Поля: product_id, product_full_name_clean, product_number, main_category
-- -------------------------------------------------------------

SELECT
    product_id,
    CONCAT(product_brand, ' - ', product_category_name)            AS product_full_name_clean,
    -- первые 3 символа бренда + длина категории: пр. "Мир15"
    CONCAT(SUBSTRING(product_brand, 1, 3), LENGTH(product_category_name)) AS product_number,
    -- берём первое слово до пробела
    SPLIT_PART(product_category_name, ' ', 1)                      AS main_category
FROM products;


-- -------------------------------------------------------------
-- Задача 3 | Уровень: Базовый | Тема: LOWER, LIKE
-- Найти все продукты, в названии бренда которых есть слово «фото»
-- (без учёта регистра). Вернуть бренд в нижнем регистре.
-- Поля: product_id, product_brand
-- -------------------------------------------------------------

SELECT
    product_id,
    LOWER(product_brand) AS product_brand
FROM products
-- LOWER перед LIKE чтобы поиск не зависел от регистра
WHERE LOWER(product_brand) LIKE '%фото%';
