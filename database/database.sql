-- plik z wszystkimi zmianami do bazy danych, zeby mozna bylo latwo cala baze wgrac

create table users(
	user_id int not null primary key auto_increment,
	login varchar(20) not null,
	password varchar(50) not null,
	acc_type enum('admin', 'client', 'warehouse', 'salesman') not null
);

create table clients(
	client_id int not null primary key auto_increment,
	user_id int not null,
	address varchar(100),
	email varchar(50),
	phone varchar(15)
);

create table products(
	product_id int not null primary key auto_increment,
	name varchar(50) not null,
	category enum{'men', 'women', 'boys', 'girls'} not null,
	type varchar(50) not null,
	color varchar(20) not null,
	price float not null,
	discount int
);

create table warehouse(
	warehouse_id int not null primary key auto_increment,
	product_id int not null,
	size enum('XS', 'S', 'M', 'L', 'XL') not null,
	amount int not null
);

create table orders(
	order_id int not null primary key auto_increment,
	client_id int not null,
	invoice_id int,
	status enum('not placed', 'placed', 'paid', 'completed', 'return reported', 'returned') not null
);

create table order_pos(
	pos_id int not null primary key auto_increment,
	order_id int not null,
	product_id int not null,
	amount int not null
);

create table order_logs(
	log_id int not null primary key auto_increment,
	order_id int not null,
	old_status enum('not placed', 'placed', 'paid', 'completed', 'return reported', 'returned') not null,
	new_status enum('not placed', 'placed', 'paid', 'completed', 'return reported', 'returned') not null,
	log_date timestamp not null
);

create table invoices(
	invoice_id int not null primary key auto_increment,
	client_id int not null,
	status enum('not paid', 'paid')
);

create table invoice_pos(
	pos_id int not null primary key auto_increment,
	invoice_id int not null,
	product_id int not null,
	amount int not null
);