--Enums begin
CREATE TYPE payment_method AS ENUM ('pay_after_receiving', 'pay_after_buying');
CREATE TYPE sex AS ENUM ('m', 'f');
--Enums end


--Tables begin
--Tables of person begin
CREATE TABLE table_persons
(
    id           SERIAL NOT NULL PRIMARY KEY,
    name         TEXT   NOT NULL CHECK ( name != '' ),
    surname      TEXT   NOT NULL CHECK ( surname != '' ),
    patronymic   TEXT   NOT NULL,
    sex          sex    NOT NULL CHECK ( sex = 'm' or sex = 'f' ),
    phone_number TEXT   NOT NULL,
    email        TEXT   NOT NULL
);

CREATE TABLE table_clients
(
    id                SERIAL        NOT NULL PRIMARY KEY,
    person_id         INTEGER       NOT NULL,
    discount          NUMERIC(4, 2) NOT NULL,
    agreed_on_mailing BOOLEAN       NOT NULL DEFAULT false,
    FOREIGN KEY (person_id) REFERENCES table_persons (id)
);

CREATE TABLE table_employees
(
    id        SERIAL  NOT NULL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    position  TEXT    NOT NULL CHECK ( position != '' ),
    hire_date DATE    NOT NULL,
    salary    money   NOT NULL CHECK ( salary > '$0' ),
    FOREIGN KEY (person_id) REFERENCES table_persons (id)
);
--Tables of person end


--Tables of product begin
CREATE TABLE table_manufacturers
(
    id                  SERIAL NOT NULL PRIMARY KEY,
    name                TEXT   NOT NULL CHECK ( name != '' ),
    address             TEXT   NOT NULL CHECK ( address != '' ),
    phone_number        TEXT   NOT NULL CHECK ( phone_number != '' ),
    website             TEXT   NOT NULL,
    manufacture_country TEXT   NOT NULL CHECK ( manufacture_country != '' ),
    brand               TEXT   NOT NULL CHECK ( brand != '' ),
    license             TEXT   NOT NULL CHECK ( license != '' )
);

CREATE TABLE table_units
(
    id         SERIAL         NOT NULL PRIMARY KEY,
    unit_type  TEXT           NOT NULL CHECK ( unit_type != '' ),
    unit_value NUMERIC(10, 2) NOT NULL CHECK ( unit_value > 0 )
);

CREATE TABLE table_types
(
    id                 SERIAL NOT NULL PRIMARY KEY,
    name               TEXT   NOT NULL CHECK ( name != '' ),
    main_parameters    TEXT   NOT NULL CHECK ( main_parameters != '' ),
    series             TEXT   NOT NULL CHECK ( series != '' ),
    special_properties TEXT   NOT NULL CHECK ( special_properties != '' )
);

CREATE TABLE table_products
(
    id                                 SERIAL  NOT NULL PRIMARY KEY,
    name                               TEXT    NOT NULL CHECK ( name != '' ),
    type_id                            INTEGER NOT NULL,
    price                              money   NOT NULL CHECK ( price > '$0' ),
    unit_id                            INTEGER NOT NULL,
    manufacturer_id                    INTEGER NOT NULL,
    manufacture_date                   DATE    NOT NULL,
    expiration_date_of_warranty_period DATE    NOT NULL CHECK ( expiration_date_of_warranty_period > manufacture_date ),
    purchase_price                     money   NOT NULL CHECK ( purchase_price > table_products.price ),
    warranty_period_in_days            INTEGER NOT NULL CHECK ( warranty_period_in_days > 0 ),
    FOREIGN KEY (type_id) REFERENCES table_types (id),
    FOREIGN KEY (unit_id) REFERENCES table_units (id),
    FOREIGN KEY (manufacturer_id) REFERENCES table_manufacturers (id)
);
--Tables of product end


--Tables of purchase begin
CREATE TABLE table_salespoint
(
    id      SERIAL NOT NULL PRIMARY KEY,
    address TEXT   NOT NULL CHECK ( address != '' )
);

CREATE TABLE table_online_purchases
(
    id                       SERIAL         NOT NULL PRIMARY KEY,
    payment                  payment_method NOT NULL,
    product_delivery_address INTEGER        NOT NULL,
    FOREIGN KEY (product_delivery_address) REFERENCES table_salespoint (id)
);

CREATE TABLE table_offline_purchases
(
    id            SERIAL  NOT NULL PRIMARY KEY,
    employee_id   INTEGER NOT NULL,
    salespoint_id INTEGER,
    FOREIGN KEY (employee_id) REFERENCES table_employees (id),
    FOREIGN KEY (salespoint_id) REFERENCES table_salespoint (id)
);

CREATE TABLE table_purchases
(
    id                  SERIAL  NOT NULL PRIMARY KEY,
    online_purchase_id  INTEGER CHECK ( online_purchase_id = 1 or online_purchase_id = 0 ) DEFAULT 0,
    offline_purchase_id INTEGER CHECK ( online_purchase_id = 1 or online_purchase_id = 0 ) DEFAULT 0,
    client_id           INTEGER NOT NULL,
    product_id          INTEGER NOT NULL,
    purchase_date       DATE    NOT NULL,
    FOREIGN KEY (online_purchase_id) REFERENCES table_online_purchases (id),
    FOREIGN KEY (offline_purchase_id) REFERENCES table_offline_purchases (id),
    FOREIGN KEY (client_id) REFERENCES table_clients (id),
    FOREIGN KEY (product_id) REFERENCES table_products (id)
);
--Tables of purchase end
--Tables end