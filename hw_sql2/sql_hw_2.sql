CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    gender VARCHAR,
    DOB DATE,
    job_title VARCHAR,
    job_industry_category VARCHAR,
    wealth_segment VARCHAR,
    deceased_indicator CHAR(1),
    owns_car VARCHAR,
    address VARCHAR,
    postcode INT,
    state VARCHAR,
    country VARCHAR,
    property_valuation INT
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT REFERENCES customer(customer_id),
    transaction_date DATE,
    online_order BOOLEAN,
    order_status VARCHAR,
    brand VARCHAR,
    product_line VARCHAR,
    product_class VARCHAR,
    product_size VARCHAR,
    list_price DECIMAL,
    standard_cost DECIMAL
);

-- пришлось убрать это наблюдение из транзакций, чтобы не было нарушений условия ключа
SELECT * FROM customer WHERE customer_id = 5034;

-- Данные по customer загружены
select *
from customer c;

-- Данные по transactions загружены
select *
from transactions c;

-- 1 Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.

SELECT DISTINCT brand
FROM transactions
WHERE standard_cost > 1500;

-- 2 Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.

SELECT *
FROM transactions
WHERE order_status = 'Approved' AND
      transaction_date BETWEEN '2017-04-01' AND '2017-04-09';

-- 3 Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.

SELECT job_title
FROM customer
WHERE (job_industry_category = 'IT' OR job_industry_category = 'Financial Services')
      AND job_title LIKE 'Senior%';
      
-- 4 Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services.
     
SELECT DISTINCT t.brand
FROM transactions t
JOIN customer c ON t.customer_id = c.customer_id
WHERE c.job_industry_category = 'Financial Services';


-- 5 Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.

SELECT DISTINCT t.customer_id
FROM transactions t
WHERE t.brand IN ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles') AND t.online_order = TRUE
LIMIT 10;


-- 6 Вывести всех клиентов, у которых нет транзакций.

SELECT c.customer_id
FROM customer c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_id IS NULL;

-- 7 Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.

SELECT c.customer_id, MAX(t.standard_cost)
FROM customer c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE c.job_industry_category = 'IT'
GROUP BY c.customer_id
ORDER BY MAX(t.standard_cost) DESC;

-- 8 Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.

SELECT DISTINCT c.customer_id
FROM customer c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE c.job_industry_category IN ('IT', 'Health') AND
      t.order_status = 'Approved' AND
      t.transaction_date BETWEEN '2017-07-07' AND '2017-07-17';

