-- 1.2. Доля платящих пользователей в разрезе расы персонажа:
-- Тот же запрос, но в разрезе расы игроков - общее число, число платящих и их доля от общего числа
SELECT
	r.race,
	SUM(u.payer) AS paying_users_by_race, -- платящие пользователи в разрезе по расам
	COUNT(u.id) AS cnt_users_by_race, -- общее количество игроков в разрезе по расам
	SUM(u.payer)::float / COUNT(u.id) AS paying_users_share_by_race -- доля платящих от всех в разрезе по расе
FROM fantasy.race r 
JOIN fantasy.users u ON r.race_id = u.race_id 
GROUP BY r.race
ORDER BY paying_users_share_by_race DESC;