-- =============================================================
-- ТЕМА: Числовые функции — ROUND, CEIL, FLOOR, ABS
-- =============================================================


-- -------------------------------------------------------------
-- Задача 1 | Уровень: Базовый | Тема: AS, арифметика
-- Для каждого товара вывести размеры и объём в кубических метрах.
-- Поля: product_id, length_cm, width_cm, height_cm, volume_m3
-- -------------------------------------------------------------

SELECT
    product_id,
    product_length_cm                                               AS length_cm,
    product_width_cm                                                AS width_cm,
    product_height_cm                                               AS height_cm,
    -- делим на 1000000.0 (не на 1000000) чтобы получить дробный результат
    product_length_cm * product_width_cm * product_height_cm
        / 1000000.0                                                 AS volume_m3
FROM products;


-- -------------------------------------------------------------
-- Задача 2 | Уровень: Базовый | Тема: ROUND, CEIL
-- Добавить объём, округлённый до 1 знака, и вес в кг (округлить вверх).
-- Поля: product_id, length_cm, width_cm, height_cm, round_volume_m3, product_weight_kg
-- -------------------------------------------------------------

SELECT
    product_id,
    product_length_cm                                               AS length_cm,
    product_width_cm                                                AS width_cm,
    product_height_cm                                               AS height_cm,
    ROUND(
        product_length_cm * product_width_cm * product_height_cm
            / 1000000.0, 1
    )                                                               AS round_volume_m3,
    CEIL(product_weight_g / 1000.0)                                 AS product_weight_kg
FROM products;


-- -------------------------------------------------------------
-- Задача 3 | Уровень: Средний | Тема: ROUND, ABS
-- Добавить модуль разницы между длиной и шириной в метрах (abs_diff).
-- Показывает «вытянутость» товара.
-- Поля: product_id, length_cm, width_cm, height_cm, round_volume_m3, product_weight_kg, abs_diff
-- -------------------------------------------------------------

SELECT
    product_id,
    product_length_cm                                               AS length_cm,
    product_width_cm                                                AS width_cm,
    product_height_cm                                               AS height_cm,
    ROUND(
        product_length_cm * product_width_cm * product_height_cm
            / 1000000.0, 1
    )                                                               AS round_volume_m3,
    CEIL(product_weight_g / 1000.0)                                 AS product_weight_kg,
    -- ABS чтобы разница была всегда положительной, / 100.0 чтобы перевести в метры
    ABS((product_length_cm - product_width_cm) / 100.0)            AS abs_diff
FROM products;
