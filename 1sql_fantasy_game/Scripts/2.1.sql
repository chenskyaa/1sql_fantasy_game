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