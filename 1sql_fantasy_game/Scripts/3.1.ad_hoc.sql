-- Часть 3. Решение ad hoc-задач
-- Задача 1. Зависимость активности игроков от расы персонажа:
WITH unique_paying_per_race AS (
	SELECT
		u.race_id,
		COUNT(DISTINCT e.id) AS paying_users_per_race -- уникальные платящие юзеры по расе
	FROM fantasy.events e JOIN fantasy.users u ON u.id = e.id
	WHERE u.payer = 1
	GROUP BY u.race_id
	)
SELECT 
	r.race,
	COUNT(DISTINCT u.id) AS users_per_race, --общее количество зарегистрированных игроков по расе
	COUNT(DISTINCT e.id) AS purchases_per_race, --количество игроков, которые совершают внутриигровые покупки
	COUNT(DISTINCT e.id)::float / COUNT(DISTINCT u.id) *100 AS purchases_share, -- доля игроков которые совершают покупки от общего количества игроков
	upr.paying_users_per_race::float / COUNT(DISTINCT e.id) *100 AS payers_share, -- доля платящих игроков от количества игроков, которые совершили покупки
	COUNT(e.transaction_id)::float / COUNT(DISTINCT u.id) AS avg_purchases_per_user, -- среднее количество покупок на одного игрока
	SUM(e.amount)::float / COUNT(DISTINCT e.id) AS avg_amount_per_purchase, -- средняя суммарная стоимость покупок на игрока
	SUM(e.amount)::float / COUNT(e.id) AS avg_amount_per_user -- средняя стоимость одной покупки на одного игрока
FROM fantasy.race r 
LEFT JOIN fantasy.users u ON u.race_id = r.race_id
LEFT JOIN fantasy.events e ON e.id = u.id
LEFT JOIN unique_paying_per_race AS upr ON upr.race_id = r.race_id
GROUP BY r.race, upr.paying_users_per_race
ORDER BY users_per_race DESC;

--Результаты решения ad hoc задач 3.1. Существует ли зависимость активности игроков по совершению внутриигровых покупок от расы персонажа?
--Самый популярный выбор расы среди игроков - Люди и Хоббиты. 
--Опираясь на данные о доле игроков, которые совершают внутриигровые покупки от доли всех игроков в разрезе по расам можно сказать, что выбор расы не влияет на необходимость покупок эпических предметов при прохождении, у всех рас примерно равный процент внутриигровых покупок - 0,8 % - 1,2% 
--Однако, доля платящих игроков от всех игроков совершивших покупки отличается от выбранной расы, так, Демоны (19.9%), Северяне (18,2%) и Люди (18,0%) лидируют по доле платящих от игроков, покупающих предметы только на внутриигровую валюту. 
--Самая маленькая же доля платящих к игрокам, которые используют только внутриигровую валюту - среди расы Эльфов - всего 16,2% платящих игроков среди покупателей эпических предметов. 
--Интересное наблюдение - по популярности, раса Демонов стоит на самом последнем месте среди наших игроков, однако доля платящих среди них - самая высокая в срезе по расам
