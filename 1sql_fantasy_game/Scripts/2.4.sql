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

--2.3. Есть ли среди эпических предметов популярные, которые покупают чаще всего?
--(По результату запроса) Самый популярный внутриигровой предмет для покупки - Книга легенд (Book of Legends), 88% пользователей хоть раз купили этот предмет, а доля продаж Книги легенд состовляет аж 76.8% от общего числа транзакций. Этот предмет был куплен 1,005,423 раз. 
--На втором месте по популярности - Сумка хранения (Bag of Holding), этот предмет хоть раз купили 86% игроков, количество покупок - 271,875 что составляет 20% от всех внутриигровых покупок. 
--Также, стало известно что минимальное количество покупок, а именно 1 было выявлено у 22 предметов (всего 144), что указывает на то, что 15% всех предметов было куплено всего 1 раз, эти предметы не пользуются популярностью среди наших игроков.
--Возможно стоит отдельно рассмотреть цену/применение таких товаров и выстроить маркетинговую стратегию для повышения популярности подобных товаров
