drop database if exists shop;
create database shop;
use shop;
delimiter ;
-----tables-----
create table users(
	user_id int not null primary key auto_increment,
	login varchar(255) not null,
	password varchar(255) not null,
	acc_type enum('client', 'warehouse', 'salesman') not null
);

create table clients(
	client_id int not null primary key auto_increment,
	user_id int not null,
	type enum('individual', 'company') not null,
	name varchar(255),
	surname varchar(255),
	company_name varchar(255),
	email varchar(255) not null,
	phone varchar(15) not null,
	address_id int,
	NIP char(10) not null,
	RODO boolean,
	terms_of_use boolean,
	cookies boolean
);

create table addresses (
    address_id int not null primary key auto_increment,
    street varchar(255) not null,
    house_number int not null,
    apartment_number int,
    city varchar(255) not null,
    postal_code varchar(6) not null
);

create table products(
	product_id int not null primary key auto_increment,
	name varchar(255) not null,
	category enum('men', 'women', 'boys', 'girls') not null,
	type_id int not null,
	color_id int not null,
	price decimal(4,2) not null,
	discount int
);

create table product_types(
    type_id int not null primary key auto_increment,
    type varchar(255) not null unique
);

create table product_colors(
    color_id int not null primary key auto_increment,
    name varchar(255) not null unique,
    code varchar(255) not null unique
);

create table photos(
	photo_id int not null primary key auto_increment,
	product_id int not null,
	path varchar(255) not null
);

create table warehouse(
	warehouse_id int not null primary key auto_increment,
	product_id int not null,
	size enum('XS', 'S', 'M', 'L', 'XL') not null,
	amount int not null,
	reserved int not null default 0
);

create table orders(
	order_id int not null primary key auto_increment,
	client_id int not null,
	invoice boolean not null,
	invoice_id int,
	status enum('cart', 'placed', 'paid', 'cancelled', 'completed', 'return reported', 'returned') not null,
	value int not null default 0
);

create table order_pos(
	pos_id int not null primary key auto_increment,
	order_id int not null,
	warehouse_id int not null,
	amount int not null
);

create table order_logs(
	log_id int not null primary key auto_increment,
	order_id int not null,
	old_status enum('cart', 'placed', 'paid', 'cancelled', 'completed', 'return reported', 'returned') not null,
	new_status enum('cart', 'placed', 'paid', 'cancelled', 'completed', 'return reported', 'returned') not null,
	log_date timestamp not null
);

create table invoices(
	invoice_id int not null primary key auto_increment,
	order_id int not null,
	NIP char(10) not null,
	company_name varchar(255) not null,
	address_id int not null
);
alter table users
	add constraint login_unique
		unique(login);

alter table clients
	add constraint clients_email_unique
		unique(email),
	add constraint clients_phone_unique
		unique(phone),
	add constraint clients_NIP_unique
		unique(NIP),
	add constraint clients_email_check
		check(email regexp '^[a-z0-9._-]+@[a-z0-9._-]+\.[a-z]{2,}$'),
	add constraint clients_phone_check
		check(phone regexp '^[0-9]{7,15}$'),
	add constraint clients_NIP_check
		check(NIP regexp '^[0-9]{10}$'),
	add constraint clients_fk_user
		foreign key (user_id)
		references users(user_id)
		on update cascade,
	add constraint clients_fk_address
		foreign key (address_id)
		references addresses(address_id)
		on update cascade;

alter table addresses
	add constraint addresses_unique
		unique(street, house_number, apartment_number, city, postal_code),
	add constraint addresses_postal_code_check
		check(postal_code regexp '^[0-9]{2}-[0-9]{3}$');

alter table products
	add constraint products_unique
		unique(name, category, type_id, color_id),
	add constraint products_price_check
		check(price > 0),
	add constraint products_discount_check
		check(discount > 0 or discount is null),
	add constraint products_fk_type
		foreign key (type_id)
		references product_types(type_id)
		on update cascade,
	add constraint products_fk_color
		foreign key (color_id)
		references product_colors(color_id)
		on update cascade;

alter table product_types
	add constraint product_types_unique
		unique(type);

alter table product_colors
	add constraint product_colors_name_unique
		unique(name),
	add constraint product_colors_code_unique
		unique(code);

alter table photos
	add constraint photos_unique
		unique(product_id, path),
	add constraint photos_fk_product
		foreign key (product_id)
		references products(product_id)
		on update cascade;

alter table warehouse
	add constraint warehouse_unique
		unique(product_id, size),
	add constraint warehouse_amount_check
		check(amount >= 0),
	add constraint warehouse_amount_reserved_check
		check(amount >= reserved),
	add constraint warehouse_fk_product
		foreign key (product_id)
		references products(product_id)
		on update cascade;

alter table orders
	add constraint orders_fk_client
		foreign key (client_id)
		references clients(client_id)
		on update cascade,
	add constraint orders_fk_invoice
		foreign key (invoice_id)
		references invoices(invoice_id)
		on update cascade;

alter table order_pos
	add constraint order_pos_unique
		unique(order_id, warehouse_id),
	add constraint order_pos_amount_check
		check(amount >= 0),
	add constraint order_pos_fk_order
		foreign key (order_id)
		references orders(order_id)
		on update cascade
		on delete cascade,
	add constraint order_pos_fk_warehouse
		foreign key (warehouse_id)
		references warehouse(warehouse_id)
		on update cascade;

alter table order_logs
	add constraint order_logs_fk_order
		foreign key (order_id)
		references orders(order_id)
		on update cascade
		on delete cascade;

alter table invoices
	add constraint invoices_fk_order
		foreign key (order_id)
		references orders(order_id)
		on update cascade;-----triggers-----
delimiter $$

-- order: automatic value calculation from order_pos (DONE)
create trigger AI_order_pos_value
    after insert on order_pos
    for each row
begin
    declare value int;
    declare price int;

    SELECT o.value INTO value 
    FROM orders o
    WHERE new.order_id = o.order_id;

    SELECT p.price INTO price 
    FROM products p JOIN warehouse w ON p.product_id = w.product_id
    WHERE new.warehouse_id = w.warehouse_id;

    SET value = value + price * new.amount;

    UPDATE orders o SET o.value = value
    WHERE o.order_id = new.order_id;
end $$

create trigger AU_order_pos_value
    after update on order_pos
    for each row
begin
    declare value int;
    declare price int;

    if new.amount <> old.amount THEN
        SELECT o.value INTO value FROM orders o
        WHERE new.order_id = o.order_id;

        SELECT p.price INTO price 
        FROM products p JOIN warehouse w ON p.product_id = w.product_id
        WHERE new.warehouse_id = w.warehouse_id;

        SET value = value + price * new.amount;

        if old.warehouse_id <> new.warehouse_id then
            SELECT p.price INTO price 
            FROM products p JOIN warehouse w ON p.product_id = w.product_id
            WHERE old.warehouse_id = w.warehouse_id;
        end if;

        SET value = value - price * old.amount;

        UPDATE orders o SET o.value = value
        WHERE o.order_id = new.order_id;
    end if;
end $$

create trigger AD_order_pos_value
    after delete on order_pos
    for each row
begin
    declare value int;
    declare price int;
    
    SELECT o.value INTO value FROM orders o
    WHERE old.order_id = o.order_id;

    SELECT p.price INTO price 
    FROM products p JOIN warehouse w ON p.product_id = w.product_id
    WHERE old.warehouse_id = w.warehouse_id;

    SET value = value - price * old.amount;

    UPDATE orders o SET o.value = value
    WHERE o.order_id = old.order_id;
end $$

-- order_pos: if amount is 0 - delete row (DONE)
create trigger AU_order_pos_amount
    after update on order_pos
    for each row
begin
    if old.amount <> new.amount then
        if new.amount = 0 then 
            DELETE FROM order_pos WHERE pos_id = new.pos_id;
        end if;
    end if;
end$$

-- warehouse: if amount is 0 - delete row (DONE)
create trigger AU_warehouse_amount
    after update on warehouse
    for each row
begin
    if old.amount <> new.amount then
		if new.amount = 0 then
            DELETE FROM warehouse WHERE warehouse_id = new.warehouse_id;
        end if;
    end if;
end$$

-- order_log: adding order status change logs (DONE)
create trigger AU_order_add_log
    after update on orders
    for each row
begin
    if old.status <> new.status then
		INSERT INTO order_logs(
			order_id,
			old_status,
			new_status,
			log_date)
		VALUES(
			new.order_id,
			old.status,
			new.status,
			CURRENT_TIMESTAMP
		);
    end if;
end$$

delimiter ;