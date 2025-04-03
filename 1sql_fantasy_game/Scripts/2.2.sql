-- 2.2: Аномальные нулевые покупки:
--Количество нулевых покупок и их доля от общего количества покупок
SELECT 
	COUNT(amount) AS total_purchases,
	COUNT(amount)::float / (SELECT COUNT(amount) FROM fantasy.events) * 100 AS zero_purch_share_percent
	FROM fantasy.events
	WHERE amount = 0;