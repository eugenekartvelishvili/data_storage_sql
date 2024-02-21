select * 
from customer c;

select * 
from transactions t;



# Задание 1 Распределение клиентов по сферам деятельности

SELECT job_industry_category, COUNT(customer_id) AS customer_count
FROM customer
GROUP BY job_industry_category
ORDER BY customer_count DESC;

# Задание 2 Сумма транзакций за каждый месяц по сферам деятельности

SELECT 
    EXTRACT(YEAR FROM transaction_date) AS year,
    EXTRACT(MONTH FROM transaction_date) AS month,
    c.job_industry_category,
    SUM(t.list_price) AS total_sales
FROM transactions t
JOIN customer c ON t.customer_id = c.customer_id
GROUP BY year, month, c.job_industry_category
ORDER BY year, month, c.job_industry_category;

# Задание 3 Количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT


SELECT t.brand, COUNT(t.transaction_id) AS online_orders_count
FROM transactions t
JOIN customer c ON t.customer_id = c.customer_id
WHERE t.online_order = TRUE AND t.order_status = 'Approved' AND c.job_industry_category = 'IT'
GROUP BY t.brand
ORDER BY online_orders_count DESC;


# Задание 4 Сумма всех транзакций (list_price), максимум, минимум и количество транзакций

#без оконки
SELECT 
    customer_id,
    SUM(list_price) AS total_sales,
    MAX(list_price) AS max_sale,
    MIN(list_price) AS min_sale,
    COUNT(transaction_id) AS transactions_count
FROM transactions
GROUP BY customer_id
ORDER BY total_sales DESC, transactions_count DESC;


#с оконкой
SELECT DISTINCT
    customer_id,
    SUM(list_price) OVER (PARTITION BY customer_id) AS total_sales,
    MAX(list_price) OVER (PARTITION BY customer_id) AS max_sale,
    MIN(list_price) OVER (PARTITION BY customer_id) AS min_sale,
    COUNT(transaction_id) OVER (PARTITION BY customer_id) AS transactions_count
FROM transactions
ORDER BY total_sales DESC, transactions_count DESC;

#Вывод: результаты запросов - идентичны

# Задание 5 Имена и фамилии клиентов с минимальной/максимальной суммой транзакций
# Минимальная сумма транзакций:

WITH ranked_customers AS (
  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(t.list_price) AS total_spent,
    RANK() OVER (ORDER BY SUM(t.list_price)) as rank_min
  FROM customer c
  JOIN transactions t ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
)
SELECT first_name, last_name, total_spent
FROM ranked_customers
WHERE rank_min = 1;

# Максимальная сумма транзакций:

WITH ranked_customers AS (
  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(t.list_price) AS total_spent,
    RANK() OVER (ORDER BY SUM(t.list_price) DESC) as rank_max
  FROM customer c
  JOIN transactions t ON c.customer_id = t.customer_id
  GROUP BY c.customer_id
)
SELECT first_name, last_name, total_spent
FROM ranked_customers
WHERE rank_max = 1;



# Задание 6 Выбор только самых первых транзакций клиентов

WITH first_transactions AS (
  SELECT
    t.*,
    ROW_NUMBER() OVER (PARTITION BY t.customer_id ORDER BY t.transaction_date ASC) AS rn
  FROM transactions t
)
SELECT
  ft.customer_id,
  ft.transaction_id,
  ft.transaction_date
FROM first_transactions ft
WHERE ft.rn = 1;





# Задание 7 Нахождение максимального интервала между транзакциями
# этапы
#Вычисление интервалов между транзакциями
#Нахождение максимального интервала
#Определение клиента с максимальным интервалом
#Получение информации о клиенте

WITH transaction_intervals AS (
  SELECT
    customer_id,
    transaction_date,
    LEAD(transaction_date) OVER (PARTITION BY customer_id ORDER BY transaction_date) - transaction_date AS interval
  FROM transactions
),
max_interval AS (
  SELECT
    MAX(interval) AS max_interval
  FROM transaction_intervals
),
customer_with_max_interval AS (
  SELECT
    ti.customer_id,
    mi.max_interval
  FROM transaction_intervals ti
  JOIN max_interval mi ON ti.interval = mi.max_interval
  LIMIT 1
)
SELECT
  c.first_name,
  c.last_name,
  c.job_title,
  cm.max_interval
FROM customer c
JOIN customer_with_max_interval cm ON c.customer_id = cm.customer_id;

