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

--3.2. Как часто игроки совершают покупки?
--Игроков можно разделить на три равные группы - с высокой частотой покупок предметов, средней и низкой. 
--В среднем, интервал между покупками у игроков в категории с высокой активностью - около 2-х дней, со средней - 6 дней, и с высокой - 12 дней. 
--Среднее количество покупок - 396, 58 и 33 соответственно. Однако, доля платящих игроков среди них не сильно разнится - 18.3%, 17.5% и 17.1%
