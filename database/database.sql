delimiter ;
-----tables-----
create table users(
	user_id int not null primary key auto_increment,
	login varchar(255) not null,
	password varchar(255) not null,
	acc_type enum('admin', 'client', 'warehouse', 'salesman') not null
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
	regulamin boolean,
	cookies boolean 
);

create table addresses (
    address_id int not null primary key auto_increment,
    postal_code varchar(6) not null,
    city varchar(255) not null,
    street varchar(255) not null,
    house_number int not null,
    apartment_number int
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
    color varchar(255) not null
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

-----triggers-----

-- clients: validate phone
create procedure validate_phone(
    IN phone varchar(15),
    OUT is_valid boolean
) begin
    set is_valid = phone regexp '^\+?[0-9]{7,15}$';
end $$

create trigger BI_clients_phone
    before insert on clients
    for each row
begin
    call validate_phone(new.phone, @is_valid);
    if @is_valid = false then
        signal sqlstate '45000'
            set message_text = 'Invalid phone number.';
    end if;
end$$

create trigger BU_clients_phone
    before update on clients
    for each row
begin
    if new.phone <> old.phone then
        call validate_phone(new.phone, @is_valid);
        if @is_valid = false then
            signal sqlstate '45000'
                set message_text = 'Invalid phone.';
        end if;
    end if;
end$$

-- clients: validating nip
create trigger BI_clients_NIP
    before insert on clients
    for each row
begin
    if NOT new.NIP regexp '^[0-9]{10}$' then
        signal sqlstate '45000'
            set message_text = 'Invalid NIP.';
    end if;
end$$

create trigger BU_clients_NIP
    before update on clients
    for each row
begin
    if old.NIP <> new.NIP AND NOT new.NIP regexp '^[0-9]{10}$' then
        signal sqlstate '45000'
            set message_text = 'Invalid NIP.';
    end if;
end$$

-- addresses: validate address
create procedure validate_postal_code(
    IN postal_code varchar(6),
    OUT is_valid boolean
) begin
    set is_valid = postal_code regexp '^[0-9]{2}-[0-9]{3}$';
end $$

create trigger BI_addresses_postal_code
    before insert on addresses
    for each row
begin
    call validate_postal_code(new.postal_code, @is_valid);
    if @is_valid = false then
        signal sqlstate '45000'
            set message_text = 'Invalid postal_code number.';
    end if;
end$$

create trigger BU_addresses_postal_code
    before update on addresses
    for each row
begin
    if new.postal_code <> old.postal_code then
        call validate_postal_code(new.postal_code, @is_valid);
        if @is_valid = false then
            signal sqlstate '45000'
                set message_text = 'Invalid postal_code number.';
        end if;
    end if;
end$$

-- order: default starting value = 0
create trigger BI_order_value
    before insert on orders
    for each row 
begin
    set new.value = 0;
end$$

-- order: block value change after placing order
create trigger BU_order_block
    before update on orders
    for each row
begin
    if old.status = new.status AND old.status NOT LIKE '%not placed%' AND old.value <> new.value then
        signal sqlstate '45000'
        set message_text = 'Unable to change placed order.';
    end if;
end$$

-- order: block deleting placed orders
create trigger BD_order_block
    before delete on orders
    for each row 
begin
    if old.status NOT LIKE '%not placed%' then
        signal sqlstate '45000'
        set message_text = 'Unable to delete placed order.';
    end if;
end$$

-- order: automatic value calculation from order_pos
create trigger AI_order_pos_value
    after insert on order_pos
    for each row
begin
    DECLARE value int;
    DECLARE price int;
    SELECT o.value INTO value FROM orders o
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
    DECLARE value int;
    DECLARE price int;
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
    DECLARE value int;
    DECLARE price int;
    SELECT o.value INTO value FROM orders o
    WHERE old.order_id = o.order_id;

    SELECT p.price INTO price 
    FROM products p JOIN warehouse w ON p.product_id = w.product_id
    WHERE old.warehouse_id = w.warehouse_id;

    SET value = value - price * old.amount;

    UPDATE orders o SET o.value = value
    WHERE o.order_id = old.order_id;
end $$

-- order_pos: block adding/updating/deleting positions of placed orders
create trigger BI_order_pos_block
    before insert on order_pos
    for each row
begin
    if(
        SELECT status
        FROM orders
        WHERE order_id = new.order_id
    ) NOT LIKE '%not placed%' then 
        signal sqlstate '45000'
        set message_text = 'Unable to add new positions to placed order.';
    end if;
end$$

create trigger BU_order_pos_block
    before update on order_pos
    for each row
begin
    if(
        SELECT status
        FROM orders
        WHERE order_id = old.order_id
    ) NOT LIKE '%not placed%' then
        signal sqlstate '45000'
        set message_text = 'Unable to edit positions of placed order.';
    end if;

    if old.order_id <> new.order_id AND (
        SELECT status 
        FROM orders
        WHERE order_id = new.order_id
    ) NOT LIKE '%not placed%' then
        signal sqlstate '45000'
        set message_text = 'Unable to edit positions of placed order.';
    end if;
end$$

create trigger BD_order_pos_block
    before delete on order_pos
    for each row
begin
    if(
        SELECT status
        FROM orders
        WHERE order_id = old.order_id
    ) NOT LIKE '%not placed%' then
        signal sqlstate '45000'
        set message_text = 'Unable to delete positions of placed order.';
    end if;
end$$

-- order_pos: block adding products we don't have in magazine
create trigger BI_order_pos_no_products
    before insert on order_pos
    for each row
begin
    if(
        SELECT (amount - reserved)
        FROM warehouse
        WHERE warehouse_id = new.warehouse_id
    ) = 0 then
        signal sqlstate '45000'
            set message_text = 'No products available.';
    end if;
end$$

create trigger BU_order_pos_no_products
    before update on order_pos
    for each row
begin
    if old.warehouse_id <> new.warehouse_id AND (
        SELECT (amount - reserved)
        FROM warehouse
        WHERE warehouse_id = new.warehouse_id
    ) = 0 then
        signal sqlstate '45000'
            set message_text = 'No products available.';
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
    if new.discount <= 0 then
        signal sqlstate '45000'
            set message_text = 'Invalid discount. Has to be greater then 0.';
    end if;
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
    if old.discount <> new.discount then
        if new.discount <= 0 then
            signal sqlstate '45000'
                set message_text = 'Invalid discount. Has to be greater then 0.';
        end if;
    end if;
end$$

-- warehouse: if amount <= 0
create trigger AU_warehouse_amount_default
    after insert on warehouse
    for each row
begin
    if new.amount <= 0 then
        signal sqlstate '45000'
            set message_text = 'Invalid amount. Has to be greater then 0.';
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