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
	address varchar(100),
	email varchar(50),
	phone varchar(15)
);

create table products(
	product_id int not null primary key auto_increment,
	name varchar(50) not null,
	category enum('men', 'women', 'boys', 'girls') not null,
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

-- foreign keys
alter table clients
add constraint clients_fk_user
foreign key (user_id)
references users(user_id)
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

-- triggers
delimiter $$

-- users: prevent two users with same login
create trigger BI_users_login
before insert on users
for each row
begin
	if(
		select login
		from users
		where login like new.login
	) is not null then
		signal sqlstate '45000'
		set message_text = 'User with this login already exists.';
	end if;
end$$

create trigger BU_users_login
before update on users
for each row
begin
	if new.login <> old.login then
		if(
			select login
			from users
			where login like new.login
		) is not null then
			signal sqlstate '45000'
			set message_text = 'User with this login already exists.';
		end if;
	end if;
end$$

-- clients: validate email address
create procedure validate_email(
	IN email varchar(50),
	OUT is_valid boolean
) begin
	if email regexp '^[a-z0-9._-]+@[a-z0-9._-]+\.[a-z]{2,}$' then
		set is_valid = true;
	else
		set is_valid = false;
	end if;
end$$

create trigger BI_clients_email
before insert on clients
for each row
begin
	call validate_email(new.email, @is_valid);
	if @is_valid = false then
		signal sqlstate '45000'
		set message_text = 'Invalid email address.';
	end if;
end$$

create trigger BU_clients_email
before update on clients
for each row
begin
	if new.email <> old.email then
		call validate_email(new.email, @is_valid);
		if @is_valid = false then 
			signal sqlstate '45000'
			set message_text = 'Invalid email address.';
		end if;
	end if;
end$$

-- products: prevent price <= 0
create trigger BI_products_price
before insert on products
for each row
begin
	if new.price <= 0 then
		signal sqlstate '45000'
		set message_text = 'Invalid price. Has to be greater than 0.';
	end if;
end$$

create trigger BU_products_price
before update on products
for each row 
begin
	if old.price <> new.price then
		if new.price <= 0 then
			signal sqlstate '45000'
			set message_text = 'Invalid price. Has to be greater then 0.';
		end if;
	end if;
end$$

-- warehouse: if amount is 0 - delete row
create trigger AU_warehouse_amount
after update on warehouse
for each row
begin
	if old.amount <> new.amount then
		if new.amount = 0 then
			delete from warehouse where warehouse_id = new.warehouse_id;
		end if;
	end if;
end$$

-- order_log: adding logs
create trigger AU_order_add_log
after update on orders
for each row
begin
	if old.status <> new.status then
		insert into order_logs (
			order_id, 
			old_status, 
			new_status, 
			log_date)
		values (
			new.order_id,
			old.status,
			new.status,
			CURRENT_TIMESTAMP
		);
	end if;
end$$

delimiter ;