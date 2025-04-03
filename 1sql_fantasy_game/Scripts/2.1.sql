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

--2.1. Есть ли аномальные покупки по стоимости? Если есть, то сколько их?
--(По результату запроса) Была обнаружена аномальная стоимость покупки в 0 райских лепестков, всего было выявлено 907 транзакций, что составляет меньше 0.07% (0.00693) от общего количества покупок внутри игры. 
--Эти данные было решено убрать из дальнейшего анализа.
