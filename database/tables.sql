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
	email varchar(255),
	phone varchar(15),
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
	price float not null,
	discount int
);

create table product_types(
    type_id int not null primary key auto_increment,
    type varchar(255) not null
);

create table product_colors(
    color_id int not null primary key auto_increment,
    name varchar(255) not null,
	code varchar(255) not null
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
	reserved int not null
);

create table orders(
	order_id int not null primary key auto_increment,
	client_id int not null,
	invoice boolean not null,
	invoice_id int,
	status enum('not placed', 'placed', 'paid', 'completed', 'return reported', 'returned') not null,
    value int not null
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
	old_status enum('not placed', 'placed', 'paid', 'completed', 'return reported', 'returned') not null,
	new_status enum('not placed', 'placed', 'paid', 'completed', 'return reported', 'returned') not null,
	log_date timestamp not null
);

create table invoices(
	invoice_id int not null primary key auto_increment,
	order_id int not null,
	NIP char(10) not null,
	company_name varchar(255) not null,
	address_id int not null
);

-- foreign keys
alter table clients
	add constraint clients_fk_user
		foreign key (user_id)
		references users(user_id)
		on update cascade,
	add constraint clients_fk_address
		foreign key (address_id)
		references addresses(address_id)
		on update cascade;

alter table products
	add constraint products_fk_type
		foreign key (type_id)
		references product_types(type_id)
		on update cascade,
	add constraint products_fk_color
		foreign key (color_id)
		references product_colors(color_id)
		on update cascade;

alter table photos
	add constraint photos_fk_product
		foreign key (product_id)
		references products(product_id)
		on update cascade;

alter table warehouse
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
		on update cascade;