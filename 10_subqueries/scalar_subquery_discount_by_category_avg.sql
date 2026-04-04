-- Тема: Scalar Subquery + CASE
-- Уровень: Medium
-- Идея: сравнение значения строки с агрегатом (AVG)

-- Задача:
-- Для товаров категории "Одежда" определить размер скидки
-- в зависимости от того, как цена товара соотносится
-- со средней ценой по этой категории

SELECT
    p.product_id,                  -- id товара
    p.product_category_name,       -- категория товара
    oi.price,                      -- цена товара из заказа

    -- Определяем размер скидки через CASE
    CASE 
        -- Если цена выше средней по категории "Одежда"
        WHEN oi.price > (
            SELECT AVG(oi2.price)
            FROM order_items oi2
            JOIN products p2 USING (product_id)
            WHERE p2.product_category_name = 'Одежда'
        ) THEN 'Скидка 15%'

        -- Если цена равна средней
        WHEN oi.price = (
            SELECT AVG(oi2.price)
            FROM order_items oi2
            JOIN products p2 USING (product_id)
            WHERE p2.product_category_name = 'Одежда'
        ) THEN 'Скидка 10%'

        -- Если цена ниже средней
        ELSE 'Скидка 5%'
    END AS discount_status         -- итоговый статус скидки

FROM products p

-- Соединяем товары с заказами, чтобы получить цену
JOIN order_items oi USING (product_id)

-- Оставляем только категорию "Одежда"
WHERE p.product_category_name = 'Одежда'

-- Сортировка:
-- сначала по товару, затем по цене (по возрастанию)
ORDER BY p.product_id, oi.price;

