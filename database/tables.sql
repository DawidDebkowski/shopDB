delimiter ;
-- tables
create table users(
	user_id int not null primary key auto_increment,
	login varchar(20) not null,
	password varchar(50) not null,
	acc_type enum('admin', 'client', 'warehouse', 'salesman') not null
);

create table clients(
	client_id int not null primary key auto_increment,
	user_id int not null,
    address_id int not null,
	email varchar(50),
	phone varchar(15)
);

create table addresses (
    address_id int not null primary key auto_increment,
    postal_code varchar(6),
    city varchar(30),
    street varchar(30),
    house_number int,
    apartment_number int
);

create table products(
	product_id int not null primary key auto_increment,
	name varchar(50) not null,
	category enum('men', 'women', 'boys', 'girls') not null,
	type_id int not null,
	color_id int not null,
	price float not null,
	discount int
);

create table product_types(
    type_id int not null primary key auto_increment,
    type varchar(50) not null
);

create table product_colors(
    color_id int not null primary key auto_increment,
    color varchar(20) not null
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

-- foreign keys
alter table clients
add constraint clients_fk_user
foreign key (user_id)
references users(user_id),
add constraint clients_fk_user
foreign key (address_id)
references addresses(address_id)
on update cascade;

alter table products
add constraint products_fk_type
foreign key (type_id)
references product_types(type_id),
add constraint products_fk_color
foreign key (color_id)
references product_colors(color_id)
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
on update cascade;

alter table orders
add constraint orders_fk_invoice
foreign key (invoice_id)
references invoices(invoice_id)
on update cascade;

alter table order_pos
add constraint order_pos_fk_order
foreign key (order_id)
references orders(order_id)
on update cascade;

alter table order_pos
add constraint order_pos_fk_product
foreign key (product_id)
references products(product_id)
on update cascade;

alter table order_logs
add constraint order_logs_fk_order
foreign key (order_id)
references orders(order_id)
on update cascade;

alter table invoices
add constraint invoices_fk_client
foreign key (client_id)
references clients(client_id)
on update cascade;

alter table invoice_pos
add constraint invoice_pos_fk_invoice
foreign key (invoice_id)
references invoices(invoice_id)
on update cascade;

alter table invoice_pos
add constraint invoice_pos_fk_product
foreign key (product_id)
references products(product_id)
on update cascade;