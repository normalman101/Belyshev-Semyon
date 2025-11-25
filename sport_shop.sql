CREATE TABLE table_persons
(
    id           SERIAL NOT NULL PRIMARY KEY,
    name         TEXT   NOT NULL CHECK ( name != '' ),
    surname      TEXT   NOT NULL CHECK ( surname != '' ),
    patronymic   TEXT   NOT NULL,
    sex          TEXT   NOT NULL CHECK ( sex != 'm' or sex != 'f' ),
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
    salary    money   NOT NULL CHECK ( salary > 0 ),
    FOREIGN KEY (person_id) REFERENCES table_persons (id)
);

CREATE TABLE table_manufacturers
(
    id                  SERIAL  NOT NULL PRIMARY KEY,
    name                TEXT    NOT NULL CHECK ( name != '' ),
    address             TEXT    NOT NULL CHECK ( address != '' ),
    phone_number        TEXT    NOT NULL CHECK ( phone_number != '' ),
    website             TEXT    NOT NULL,
    manufacture_country TEXT    NOT NULL CHECK ( manufacture_country != '' ),
    brand               TEXT    NOT NULL CHECK ( brand != '' ),
    license             INTEGER NOT NULL CHECK ( license != '' )
);

CREATE TABLE table_products
(
    id                                 SERIAL         NOT NULL PRIMARY KEY,
    name                               TEXT           NOT NULL CHECK ( name != '' ),
    type                               TEXT           NOT NULL CHECK ( type != '' ),
    product_unit_type                  TEXT           NOT NULL CHECK ( product_unit_type != '' ),
    unit                               NUMERIC(10, 2) NOT NULL CHECK ( unit > 0 ),
    price                              money          NOT NULL CHECK ( price > 0 ),
    manufacturer_id                    INTEGER        NOT NULL,
    manufacture_date                   DATE           NOT NULL,
    expiration_date_of_warranty_period DATE           NOT NULL CHECK ( expiration_date_of_warranty_period > manufacture_date ),
    purchase_price                     money          NOT NULL CHECK ( purchase_price > table_products.price ),
    warranty_period_in_days            INTEGER        NOT NULL CHECK ( warranty_period_in_days > 0 ),
    FOREIGN KEY (manufacturer_id) REFERENCES table_manufacturers (id)
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
