-- 2.3: Сравнительный анализ активности платящих и неплатящих игроков:
-- Анализ платящих и неплатящих игроков (общее количество игроков, среднее количество покупок и средняя суммарная стоимость покупок на одного игрока)

SELECT  
	u.payer,
	COUNT(DISTINCT e.id) AS uniqie_active_users, -- уникальные, активные юзеры (из events потому что ищу активных, они хоть раз совершили транзакцию)
	COUNT(e.transaction_id)::float / COUNT(DISTINCT e.id) AS avg_purchase_per_user,  -- среднее кол-во покупок в разрезе по платящим и неплатящим
    SUM(e.amount)::float / COUNT(DISTINCT e.id) AS avg_amount_per_user -- средняя стоимость
FROM 
	fantasy.events e JOIN fantasy.users u ON e.id = u.id  --INNER joint потому что учитываю только активных (кто точно делал хоть одно действие в events)
WHERE e.amount <> 0
GROUP BY u.payer;