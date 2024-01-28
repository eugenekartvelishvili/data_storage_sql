-- Создание таблицы Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    gender VARCHAR(50),
    DOB TIMESTAMP,
    job_title VARCHAR(255),
    job_industry_category VARCHAR(255),
    wealth_segment VARCHAR(255),
    deceased_indicator VARCHAR(50) NOT NULL,
    owns_car VARCHAR(50) NOT NULL,
    address VARCHAR(255),
    postcode INT,
    state VARCHAR(255),
    country VARCHAR(255) NOT NULL,
    property_valuation INT
);

-- Создание таблицы Transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    online_order BOOLEAN,
    order_status VARCHAR(255) NOT NULL,
    list_price FLOAT,
    standard_cost FLOAT
);

-- Создание таблицы Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    brand VARCHAR(255),
    product_line VARCHAR(255),
    product_class VARCHAR(255),
    product_size VARCHAR(255)
);

-- Добавление внешнего ключа к таблице Transactions для связи с Products
ALTER TABLE Transactions
ADD FOREIGN KEY (product_id) REFERENCES Products(product_id)

-- Добавление внешнего ключа к таблице Transactions для связи с Customers
ALTER TABLE Transactions
add FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);


select * from customers c;

select * from transactions t;

select * from products p;