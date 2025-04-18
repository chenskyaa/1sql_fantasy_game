Анализ "Секреты Темнолесья"

Цель проекта:
Цель проекта изучить влияние характеристик игроков и их игровых персонажей на покупку внутриигровой валюты «райские лепестки», а также оценить активность игроков при совершении внутриигровых покупок. А также проанализировать, зависит ли доля платящих игроков от выбранной расы в самой игре 


Описание данных:

Таблица `users`
Содержит информацию об игроках.
* `id` — идентификатор игрока. Первичный ключ таблицы.
* `tech_nickname` — никнейм игрока.
* `class_id` — идентификатор класса. Внешний ключ, который связан со столбцом class_id таблицы classes.
* `ch_id` — идентификатор легендарного умения. Внешний ключ, который связан со столбцом ch_id таблицы skills.
* `birthdate` — дата рождения игрока.
* `pers_gender` — пол персонажа.
* `registration_dt` — дата регистрации пользователя.
* `server` — сервер, на котором играет пользователь.
* `race_id` — идентификатор расы персонажа. Внешний ключ, который связан со столбцом race_id таблицы race.
* `payer` — значение, которое указывает, является ли игрок платящим — покупал ли валюту «райские лепестки» за реальные деньги. 1 — платящий, 0 — не платящий.
* `lоc_id` — идентификатор страны, где находится игрок. Внешний ключ, который связан со столбцом loc_id таблицы country.

Таблица `events`
Содержит информацию о покупках.
* `transaction_id` — идентификатор покупки. Первичный ключ таблицы.
* `id` — идентификатор игрока. Внешний ключ, который связан со столбцом id таблицы users.
* `date` — дата покупки.
* `time` — время покупки.
* `item_code` — код эпического предмета. Внешний ключ, который связан со столбцом item_code таблицы items.
* `amount` — стоимость покупки во внутриигровой валюте «райские лепестки».
* `seller_id` — идентификатор продавца.
  
Таблица `skills`
Содержит информацию о легендарных умениях.
* `ch_id` — идентификатор легендарного умения. Первичный ключ таблицы.
* `legendary_skill` — название легендарного умения.

Таблица `race`
Содержит информацию о расах персонажей.
* `race_id` — идентификатор расы персонажа. Первичный ключ таблицы.
* `race` — название расы.

Таблица `country`
Содержит информацию о странах игроков.
* `lоc_id` — идентификатор страны, где находится игрок. Первичный ключ таблицы.
* `location` — название страны.
  
Таблица `classes`
Содержит информацию о классах персонажей.
* `class_id` — идентификатор класса. Первичный ключ таблицы.
* `class` — название класса персонажа.
  
Таблица `items`
Содержит информацию об эпических предметах.
* `item_code` — код эпического предмета. Первичный ключ таблицы.
* `game_items` — название эпического предмета.

Результаты исследования:

1.1. Какая доля платящих игроков характерна для всей игры и как раса
персонажа влияет на изменение этого показателя?

Характерная доля платящих игроков для “Секретов Темнолесья” - 17%
Наибольшая доля платящих пользователей играют под расой “Демонов” - 19% и
“Хоббитов” - 18%

1.2. Сколько было совершено внутриигровых покупок и что можно сказать об их
стоимости (минимум и максимум, есть ли различие между средним значением
и медианой, какой разброс данных)?

1,307,678 покупок совершено на сумму 686,615,040 райских лепестков
(внутриигровая валюта), максимальная покупка была произведена на сумму в
486,615 лепестков
Средняя стоимость покупки - около 525, медиана стоимости - 74.8
Медиана намного ниже средней стоимости, что означает, что многие покупки
имеют небольшую цену, и небольшая часть пользователей совершает более
крупные траты. Также, максимальная покупка стоимостью 486,615 говорит что
эта покупка не является “нормальным” поведением в границах игры и является
крупной покупкой.

2.1. Есть ли аномальные покупки по стоимости? Если есть, то сколько их?

Была обнаружена аномальная стоимость покупки в 0 райских лепестков, всего было
выявлено 907 транзакций, что составляет меньше 0.07% (0.00693) от общего
количества покупок внутри игры. Эти данные было решено убрать из дальнейшего
анализа.

2.2. Сколько игроков совершают внутриигровые покупки и насколько активно?
Сравните поведение платящих и неплатящих игроков.

Ожидаемо, количество неплатящих игроков сравнительно больше, чем игроков
совершающих покупки на реальные деньги, 11348 неплатящих игроков против 2444
платящих.
Однако, было выявлено что в среднем, неплатящие игроки совершают больше
внутриигровых покупок (97.5) чем платящие игроки (81.6)
Стоимость покупок у неплатящих игроков составляет в среднем 48,588 лепестков,
что ниже, чем у платящих игроков (средняя стоимость покупок у которых — 55,467
лепестков).
Это подтверждает, что неплатящие игроки делают больше покупок, но на
меньшие суммы, в то время как платящие игроки реже, но тратят больше на
каждую покупку.

2.3. Есть ли среди эпических предметов популярные, которые покупают чаще
всего?

Самый популярный внутриигровой предмет для покупки - Книга легенд (Book
of Legends), 88% пользователей хоть раз купили этот предмет, а доля
продаж Книги легенд состовляет аж 76.8% от общего числа транзакций.
Этот предмет был куплен 1,005,423 раз.
На втором месте по популярности - Сумка хранения (Bag of Holding), этот
предмет хоть раз купили 86% игроков, количество покупок - 271,875 что
составляет 20% от всех внутриигровых покупок.
Также, стало известно что минимальное количество покупок, а именно 1
было выявлено у 22 предметов (всего 144), что указывает на то, что 15%
всех предметов было куплено всего 1 раз, эти предметы не пользуются
популярностью среди наших игроков, возможно стоит отдельно
рассмотреть цену/применение таких товаров и выстроить маркетинговую
стратегию для повышения популярности подобных товаров

Результаты решения ad hoc задач
3.1. Существует ли зависимость активности игроков по совершению внутриигровых
покупок от расы персонажа?

Самый популярный выбор расы среди игроков - Люди и Хоббиты. Опираясь на
данные о доле игроков, которые совершают внутриигровые покупки от доли всех
игроков в разрезе по расам можно сказать, что выбор расы не влияет на
необходимость покупок эпических предметов при прохождении, у всех рас примерно равный процент внутриигровых покупок - 0,8 % - 1,2%
Однако, доля платящих игроков от всех игроков совершивших покупки отличается
от выбранной расы, так, Демоны (19.9%), Северяне (18,2%) и Люди (18,0%)
лидируют по доле платящих от игроков, покупающих предметы только на
внутриигровую валюту.
Самая маленькая же доля платящих к игрокам, которые используют только
внутриигровую валюту - среди расы Эльфов - всего 16,2% платящих игроков среди
покупателей эпических предметов.
Интересное наблюдение - по популярности, раса Демонов стоит на самом
последнем месте среди наших игроков, однако доля платящих среди них - самая
высокая в срезе по расам

3.2. Как часто игроки совершают покупки?

Игроков можно разделить на три равные группы - с высокой частотой покупок
предметов, средней и низкой.
В среднем, интервал между покупками у игроков в категории с высокой
активностью - около 2-х дней, со средней - 6 дней, и с высокой - 12 дней.
Среднее количество покупок - 396, 58 и 33 соответственно.
Однако, доля платящих игроков среди них не сильно разнится - 18.3%, 17.5% и 17.1%


Рекомендации:

* Несмотря на меньшую долю, платящие игроки приносят значительную
часть дохода за счёт более дорогих покупок (средняя стоимость покупок у
платящих игроков (34,503 лепестков) существенно превышает таковую у
неплатящих (30,181 лепестков))
Используйте статистику по популярным расам и предметам для более
точного таргетинга в маркетинговых кампаниях:
Особое внимание стоит уделить игрокам рас Ангелов и Демонов, так как они
демонстрируют наибольшую склонность к покупкам за реальные деньги.
* Неплатящие игроки в среднем совершают больше покупок (60.5 против 51.02
у платящих), но общая стоимость их покупок остаётся ниже
Для игроков, которые совершают только внутриигровые покупки, можно
ввести:
1 - Разовые акции на покупку внутриигровой валюты.
2 - Бесплатные пробные периоды с доступом к привилегиям платящих
игроков.

Общие выводы:

Полученные результаты показывают, что доход игры в основном зависит от
небольшого числа платящих игроков и нескольких популярных предметов. Чтобы
увеличить доходы и удержать игроков, стоит разработать персональные
стратегии, которые будут побуждать как платящих, так и неплатящих игроков к
покупкам. Также важно расширить ассортимент популярных внутриигровых
товаров.
