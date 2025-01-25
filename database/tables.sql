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
	NIP char(10),
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

INSERT INTO product_types(type)
VALUES('inne');

create table product_colors(
    color_id int not null primary key auto_increment,
    name varchar(255) not null unique,
    code varchar(255) unique
);

INSERT INTO product_colors(name)
VALUES('inny');

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
	invoice boolean,
	invoice_id int,
	status enum('cart', 'placed', 'paid', 'cancelled', 'completed', 'return reported', 'returned') not null,
	value decimal(10, 2) not null default 0
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