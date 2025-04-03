-- 2.4: Популярные эпические предметы:
-- В запросе общее количество продаж, доля продажи предметов от всех продаж, доля игроков которые купили предмет от всех игроков в разрезе по эпическим предметам

WITH item_purchases AS (
SELECT 
	i.game_items,
	COUNT(e.transaction_id) AS item_sales,
	COUNT(DISTINCT e.id) AS unique_users
FROM fantasy.items i 
RIGHT JOIN fantasy.events e ON i.item_code = e.item_code
GROUP BY i.game_items
),
total_purchases AS (
SELECT 
	COUNT(e.transaction_id) AS total_sales,
	COUNT(DISTINCT u.id) AS total_users
FROM fantasy.events e
LEFT JOIN fantasy.users u ON u.id = e.id
)
SELECT
	ip.game_items,
	ip.item_sales,
	ip.item_sales::float / tp.total_sales AS sales_share,
	ip.unique_users::float / tp.total_users AS user_share
FROM item_purchases ip
CROSS JOIN total_purchases tp
ORDER BY user_share DESC;