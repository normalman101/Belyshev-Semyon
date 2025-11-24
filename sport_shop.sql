-- При именовании баз данных, таблиц, столбцов и других объектов необходимо придерживаться рекомендаций по именованию объектов в базах данных. Наименования объектов в заданиях даны только для объяснения поставленной задачи.

-- Создайте базу данных «Спортивный магазин». Эта база данных должна содержать информацию о товарах, продажах, сотрудниках, клиентах. Необходимо хранить следующую информацию:

-- О товарах: название товара, вид товара (одежда, обувь и т.д), количество товара в наличии, себестоимость, производитель, цена продажи
-- О продажах: название проданного товара, цена продажи, количество, дата продажи, информация о продавце (ФИО сотрудника, выполнившего продажу), информация о покупателе (ФИО покупателя, если купил зарегистрированный покупатель)
-- О сотрудниках: ФИО сотрудника, должность, дата приёма на работу, пол, зарплата
-- О клиентах: ФИО клиента, email, контактный телефон, пол, история заказов, процент скидки, подписан ли на почтовую рассылку.

CREATE TABLE table_clients
(
    id                  SERIAL  NOT NULL PRIMARY KEY,
    client_name         TEXT    NOT NULL CHECK ( client_name != '' ),
    client_surname      TEXT    NOT NULL CHECK ( client_name != '' ),
    client_patronymic   TEXT,
    client_email        TEXT,
    client_phone_number TEXT    NOT NULL CHECK ( client_phone_number != '' ),
    client_sex          TEXT    NOT NULL CHECK ( client_sex = 'm' or client_sex = 'f' ),
    client_discount     REAL    NOT NULL,
    agreed_on_mailing   BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE table_employees
(
    id                  SERIAL NOT NULL PRIMARY KEY,
    employee_name       TEXT   NOT NULL CHECK ( employee_name != '' ),
    employee_surname    TEXT   NOT NULL CHECK ( employee_surname != '' ),
    employee_patronymic TEXT,
    employee_position   TEXT   NOT NULL CHECK ( employee_position != '' ),
    hire_date           DATE   NOT NULL,
    employee_sex        TEXT   NOT NULL CHECK ( employee_sex = 'm' or employee_sex = 'f' ),
    employee_salary     REAL   NOT NULL CHECK ( employee_salary > 0 )
);

CREATE TABLE table_products
(
    id                     SERIAL  NOT NULL PRIMARY KEY,
    product_name           TEXT    NOT NULL CHECK ( product_name != '' ),
    product_type           TEXT    NOT NULL CHECK ( product_type != '' ),
    product_quantity       INTEGER NOT NULL CHECK ( product_quantity >= 0 ),
    product_price          REAL    NOT NULL CHECK ( product_price > 0 ),
    product_manufacturer   TEXT    NOT NULL CHECK ( product_manufacturer != '' ),
    product_purchase_price REAL GENERATED ALWAYS AS ( product_quantity * product_price ) STORED
);

CREATE TABLE table_purchase_history
(
    id            SERIAL  NOT NULL PRIMARY KEY,
    client_id     INTEGER NOT NULL,
    product_id    INTEGER NOT NULL,
    employee_id   INTEGER NOT NULL,
    purchase_date DATE    NOT NULL,
    FOREIGN KEY (client_id) REFERENCES table_clients (id),
    FOREIGN KEY (product_id) REFERENCES table_products (id),
    FOREIGN KEY (employee_id) REFERENCES table_employees (id)
);
