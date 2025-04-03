/* Проект «Секреты Тёмнолесья»
 * Цель проекта: изучить влияние характеристик игроков и их игровых персонажей 
 * на покупку внутриигровой валюты «райские лепестки», а также оценить 
 * активность игроков при совершении внутриигровых покупок
 * 
 * Автор: Ченская Анастасия
 * Дата:  21.11.24
*/

-- Часть 1. Исследовательский анализ данных
-- Задача 1. Исследование доли платящих игроков

-- 1.1. Доля платящих пользователей по всем данным:
-- В запросе первое поле - общее количество игроков, 2 и 3 это количество платящих игкроков и их доля от общего числа соответственно
SELECT 
	COUNT(id) AS users_count, -- общее количество пользователей 
	SUM(payer) AS paying_users, -- сумма всех платящих пользователей
	SUM(payer)::float / COUNT(id) AS paying_users_share -- доля платящих игрков от всех пользователей
FROM fantasy.users u;


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
ORDER BY paying_users_share_by_race DESC; -- сортировка (исправлено)

-- Задача 2. Исследование внутриигровых покупок
-- 2.1. Статистические показатели по полю amount:
-- Анализ стоимости, количество покупок, сумма, максимальное и минимальное значение, среднее, медиана и стандартное отклонение
SELECT
	ROUND(COUNT(amount::numeric), 2) AS cnt_amt, --добавила округление в этот запрос
	ROUND(SUM(amount::numeric), 2) AS sum_amt,
	ROUND(MAX(amount::numeric), 2) AS max_amt,
	ROUND(MIN(amount::numeric), 2) AS min_amt,
	ROUND(AVG(amount::numeric), 2) AS avg_amt,
	ROUND((PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY amount))::NUMERIC, 2) AS median_amt,
	ROUND(STDDEV(amount::numeric), 2) AS std_amt
FROM fantasy.events e;

-- 2.2: Аномальные нулевые покупки:
--Количество нулевых покупок и их доля от общего количества покупок

--старый запрос
SELECT 
	(SELECT COUNT(*) FROM fantasy.events) AS total_purchases,
	(SELECT COUNT(*) FROM fantasy.events WHERE amount = 0) AS zero_purchases,
	(SELECT COUNT(*) FROM fantasy.events WHERE amount = 0)::float / (SELECT COUNT(*) FROM fantasy.events) AS zero_purch_share;

--обновленный запрос для этой задачи
SELECT 
	COUNT(amount) AS total_purchases,
	COUNT(amount)::float / (SELECT COUNT(amount) FROM fantasy.events) AS zero_purch_share
	FROM fantasy.events
	WHERE amount = 0;

-- 2.3: Сравнительный анализ активности платящих и неплатящих игроков:
-- Анализ платящих и неплатящих игроков (общее количество игроков, среднее количество покупок и средняя суммарная стоимость покупок на одного игрока)

-- новый отредактированный запрос
SELECT  
	u.payer,
	COUNT(DISTINCT e.id) AS uniqie_active_users, -- уникальные, активные юзеры (из events потому что ищу активных, они хоть раз совершили транзакцию)
	COUNT(e.transaction_id)::float / COUNT(DISTINCT e.id) AS avg_purchase_per_user,  -- среднее кол-во покупок в разрезе по платящим и неплатящим
    SUM(e.amount)::float / COUNT(DISTINCT e.id) AS avg_amount_per_user -- средняя стоимость
FROM 
	fantasy.events e JOIN fantasy.users u ON e.id = u.id  --INNER joint потому что учитываю только активных (кто точно делал хоть одно действие в events)
WHERE e.amount <> 0
GROUP BY u.payer

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
	COUNT(DISTINCT u.id) AS total_users -- добавила DISTINCT 
FROM fantasy.events e
LEFT JOIN fantasy.users u ON u.id = e.id -- поменяла вид присоединения 
)
SELECT
	ip.game_items,
	ip.item_sales,
	ip.item_sales::float / tp.total_sales AS sales_share,
	ip.unique_users::float / tp.total_users AS user_share
FROM item_purchases ip
CROSS JOIN total_purchases tp
ORDER BY user_share DESC;

-- Часть 2. Решение ad hoc-задач
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

-- Задача 2: Частота покупок
WITH purchase_intervals AS (
    SELECT 
        e.id AS player_id,
        u.payer,
        e.date::timestamp AS purchase_date,
        DATE_TRUNC('day', e.date::timestamp) - DATE_TRUNC('day', LAG(e.date::timestamp) OVER (PARTITION BY e.id ORDER BY e.date)) AS days_between_purchases
    FROM fantasy.events e
    JOIN fantasy.users u ON e.id = u.id
    WHERE e.amount > 0
),
player_stats AS (
    SELECT 
        player_id,
        payer,
        COUNT(*) AS total_purchases,
        AVG(days_between_purchases) AS avg_days_between_purchases
    FROM purchase_intervals
    WHERE days_between_purchases IS NOT NULL
    GROUP BY player_id, payer
    HAVING COUNT(*) >= 25
),
player_groups AS (
    SELECT 
        player_id,
        payer,
        total_purchases,
        avg_days_between_purchases,
        NTILE(3) OVER (ORDER BY avg_days_between_purchases) AS frequency_group
    FROM player_stats
),
group_summary AS (
    SELECT 
        CASE 
            WHEN frequency_group = 1 THEN 'высокая частота'
            WHEN frequency_group = 2 THEN 'умеренная частота'
            ELSE 'низкая частота'
        END AS category,
        COUNT(player_id) AS players_with_purchases,
        SUM(CASE WHEN payer = 1 THEN 1 ELSE 0 END) AS paying_players,
        SUM(CASE WHEN payer = 1 THEN 1 ELSE 0 END)::float / COUNT(player_id) AS share_of_paying_players,
        AVG(total_purchases) AS avg_purchases_per_player,
        AVG(avg_days_between_purchases) AS avg_days_between_purchases
    FROM player_groups
    GROUP BY frequency_group
)
SELECT 
    category,
    players_with_purchases, --количество игроков, которые совершили покупки (количество игроков по группам) 
    paying_players, --количество платящих игроков
    share_of_paying_players, --доля платящих игроков от общего количества игроков
    avg_purchases_per_player, --среднее количество покупок на одного игрока
    avg_days_between_purchases --среднее количество дней между покупками
FROM group_summary;

--Спасибо за проверку и хорошего денечка!!