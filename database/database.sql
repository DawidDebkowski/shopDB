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


-----triggers-----
delimiter $$

-- users: prevent two users with same login
create trigger BI_users_login
    before insert on users
    for each row
begin
    if (SELECT login FROM users WHERE login LIKE new.login) is not null then
		signal sqlstate '45000'
        SET message_text = 'User with this login already exists.';
    end if;
end$$

create trigger BU_users_login
    before update on users
    for each row
begin
    if new.login <> old.login then
		if (SELECT login FROM users WHERE login like new.login) is not null then
			signal sqlstate '45000'
			SET message_text = 'User with this login already exists.';
        end if;
    end if;
end$$

-- clients: validate email address
create trigger BI_clients_email
    before insert on clients
    for each row
begin
    if not new.email regexp '^[a-z0-9._-]+@[a-z0-9._-]+\.[a-z]{2,}$' then
		signal sqlstate '45000'
		SET message_text = 'Invalid email address.';
    end if;
end$$

create trigger BU_clients_email
    before update on clients
    for each row
begin
    if new.email <> old.email then
		if not new.email regexp '^[a-z0-9._-]+@[a-z0-9._-]+\.[a-z]{2,}$' then
			signal sqlstate '45000'
			SET message_text = 'Invalid email address.';
        end if;
    end if;
end$$

-- clients: validate phone
create trigger BI_clients_phone
    before insert on clients
    for each row
begin
    if new.phone regexp '^\+?[0-9]{7,15}$' then
        signal sqlstate '45000'
        SET message_text = 'Invalid phone number.';
    end if;
end$$

create trigger BU_clients_phone
    before update on clients
    for each row
begin
    if new.phone <> old.phone then
        if new.phone regexp '^\+?[0-9]{7,15}$' then
            signal sqlstate '45000'
            SET message_text = 'Invalid phone.';
        end if;
    end if;
end$$

-- clients: validating nip
create trigger BI_clients_NIP
    before insert on clients
    for each row
begin
    if not new.NIP regexp '^[0-9]{10}$' then
        signal sqlstate '45000'
        SET message_text = 'Invalid NIP.';
    end if;
end$$

create trigger BU_clients_NIP
    before update on clients
    for each row
begin
    if old.NIP <> new.NIP then
        if not new.NIP regexp '^[0-9]{10}$' then
            signal sqlstate '45000'
            SET message_text = 'Invalid NIP.';
    end if;
end$$

-- addresses: validate address
create trigger BI_addresses_postal_code
    before insert on addresses
    for each row
begin
    if not new.postal_code regexp '^[0-9]{2}-[0-9]{3}$' then
        signal sqlstate '45000'
        SET message_text = 'Invalid postal_code number.';
    end if;
end$$

create trigger BU_addresses_postal_code
    before update on addresses
    for each row
begin
    if new.postal_code <> old.postal_code then
        if not new.not new.postal_code regexp '^[0-9]{2}-[0-9]{3}$' then
            signal sqlstate '45000'
            SET message_text = 'Invalid postal_code number.';
        end if;
    end if;
end$$

-- order: default starting value = 0
create trigger BI_order_value
    before insert on orders
    for each row 
begin
    SET new.value = 0;
end$$

-- order: block value change after placing order
create trigger BU_order_block
    before update on orders
    for each row
begin
    if old.status not like '%not placed%' and old.value <> new.value then
        signal sqlstate '45000'
        SET message_text = 'Unable to change placed order.';
    end if;
end$$

-- order: block deleting placed orders
create trigger BD_order_block
    before delete on orders
    for each row 
begin
    if old.status not like '%not placed%' then
        signal sqlstate '45000'
        SET message_text = 'Unable to delete placed order.';
    end if;
end$$

-- order: automatic value calculation from order_pos
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

-- order_pos: block adding/updating/deleting positions of placed orders
create trigger BI_order_pos_block
    before insert on order_pos
    for each row
begin
    if (SELECT status FROM orders WHERE order_id = new.order_id) not like '%not placed%' then 
        signal sqlstate '45000'
        SET message_text = 'Unable to add new positions to placed order.';
    end if;
end$$

create trigger BU_order_pos_block
    before update on order_pos
    for each row
begin
    if (SELECT status FROM orders WHERE order_id = old.order_id) not like '%not placed%' then
        signal sqlstate '45000'
        SET message_text = 'Unable to edit positions of placed order.';
    end if;

    if old.order_id <> new.order_id then
        if (SELECT status FROM orders WHERE order_id = new.order_id) not like '%not placed%' then
            signal sqlstate '45000'
            SET message_text = 'Unable to edit positions of placed order.';
        end if;
    end if;
end$$

create trigger BD_order_pos_block
    before delete on order_pos
    for each row
begin
    if (SELECT status FROM orders WHERE order_id = old.order_id) not like '%not placed%' then
        signal sqlstate '45000'
        SET message_text = 'Unable to delete positions of placed order.';
    end if;
end$$

-- order_pos: block adding products we don't have in magazine
create trigger BI_order_pos_no_products
    before insert on order_pos
    for each row
begin
    if (SELECT (amount - reserved) FROM warehouse WHERE warehouse_id = new.warehouse_id) = 0 then
        signal sqlstate '45000'
        SET message_text = 'No products available.';
    end if;
end$$

create trigger BU_order_pos_no_products
    before update on order_pos
    for each row
begin
    if old.warehouse_id <> new.warehouse_id then
        if (SELECT (amount - reserved) FROM warehouse WHERE warehouse_id = new.warehouse_id) <= old.amount - new.amount then
            signal sqlstate '45000'
            SET message_text = 'No products available.';
    end if;
end$$

-- products: prevent price <= 0
create trigger BI_products_price
    before insert on products
    for each row
begin
    if new.price <= 0 then
		signal sqlstate '45000'
		SET message_text = 'Invalid price. Has to be greater than 0.';
    if new.discount <= 0 then
        signal sqlstate '45000'
        SET message_text = 'Invalid discount. Has to be greater then 0.';
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
			SET message_text = 'Invalid price. Has to be greater then 0.';
        end if;
    end if;
    if old.discount <> new.discount then
        if new.discount <= 0 then
            signal sqlstate '45000'
            SET message_text = 'Invalid discount. Has to be greater then 0.';
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
        SET message_text = 'Invalid amount. Has to be greater then 0.';
    end if;
end$$

-- warehouse: if amount is 0 - delete row
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

-- order_log: adding logs
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


delimiter $$
-----procedures-----

-- warehouse_manager
-- adding products to warehouse from app
-- if none in warehouse create new, else add to existing
create procedure add_warehouse(
	IN product_id int,
	IN size enum('XS', 'S', 'M', 'L', 'XL'),
	IN amount int,
	OUT exit_code int
)
begin
	declare warehouse_id int;

	SELECT w.warehouse_id INTO warehouse_id
	FROM warehouse w
	WHERE w.product_id = product_id AND w.size LIKE size;

start transaction;
	if warehouse_id is null then
		INSERT INTO warehouse(product_id, size, amount, reserved) 
		VALUES(product_id, size, amount, 0);
	else
		UPDATE warehouse w
		SET w.amount = w.amount + amount
		WHERE w.warehouse_id = warehouse_id;
	end if;

	SET exit_code = 0;
commit;
end$$

-- client
-- creating account from app
-- inserts new account into users and creates client connected to user
-- exit_code = -1: another account with same login
-- exit_code = -2: wrong email format
-- exit_code = -3: another client registered on same email
create procedure add_client(
	IN login varchar(255),
	IN password varchar(255),
	IN type enum('individual', 'company'),
	IN email varchar(255),
	IN cookies boolean,
	OUT exit_code int
)
begin
	declare id int;

start transaction;
	if (SELECT u.user_id FROM users u WHERE u.login LIKE login) is not null then
		SET exit_code = -1;
		rollback;
	elseif not email regexp '^[a-z0-9._-]+@[a-z0-9._-]+\.[a-z]{2,}$' then
		SET exit_code = -2;
		rollback;
	elseif (SELECT c.client_id FROM clients c WHERE c.email LIKE email) <> id then
		SET exit_code = -3;
		rollback;
	end if;

	INSERT INTO users(login, password, type)
	VALUES(login, password, 'client');

	SELECT u.user_id INTO id
	FROM users u
	WHERE u.login LIKE login;

	INSERT INTO clients(user_id, type, email, RODO, terms_of_use, cookies)
	VALUES(id, type, email, true, true, cookies);

	SET exit_code = 0;
commit;
end$$

-- changing account info, if individual, from app
-- changes individual client data to given
-- exit_code = -1: wrong type of client (never achieved through app)
-- exit_code = -2: wrong format of email
-- exit_code = -3: wrong format of phone number
-- exit_code = -4: another client registered on same email
create procedure change_acc_info_individual(
	IN id int,
	IN name varchar(255),
	IN surname varchar(255),
	IN email varchar(255),
	IN phone varchar(15),
	OUT exit_code int
)
begin
start transaction;
	if (SELECT type FROM clients WHERE client_id = id) not like '%individual%' then
		SET exit_code = -1;
		rollback;
	elseif not email regexp '^[a-z0-9._-]+@[a-z0-9._-]+\.[a-z]{2,}$' then
		SET exit_code = -2;
		rollback;
	elseif not phone regexp '^\+?[0-9]{7,15}$' then
		SET exit_code = -3;
		rollback;
	elseif (SELECT c.client_id FROM clients c WHERE c.email LIKE email) <> id then
		SET exit_code = -4;
		rollback;
	end if;

	UPDATE clients c
	SET c.name = name,
		c.surname = surname,
		c.email = email,
		c.phone = phone
	WHERE c.client_id = id;

	SET exit_code = 0;
commit;
end$$

-- changing account info, if company from app
-- changes company client data to given
-- exit_code = -1: wrong type of client (never achieved through app)
-- exit_code = -2: wrong format of email
-- exit_code = -3: wrong format of phone number
-- exit_code = -4: another clinet registered on same email
-- exit_code = -5: wrong format of NIP
create procedure change_acc_info_company(
	IN id int,
	IN company_name varchar(255),
	IN NIP varchar(255),
	IN email varchar(255),
	IN phone varchar(15),
	OUT exit_code int
)
begin
start transaction;
	if (SELECT type FROM clients WHERE client_id = id) not like '%company%' then
		SET exit_code = -1;
		rollback;
	elseif not email regexp '^[a-z0-9._-]+@[a-z0-9._-]+\.[a-z]{2,}$' then
		SET exit_code = -2;
		rollback;
	elseif not phone regexp '^\+?[0-9]{7,15}$' then
		SET exit_code = -3;
		rollback;
	elseif (SELECT c.client_id FROM clients c WHERE c.email LIKE email) <> id then
		SET exit_code = -4;
		rollback;
	elseif not NIP regexp '^[0-9]{10}$' then
		SET exit_code = -5;
		rollback;
	end if;

	UPDATE clients c
	SET c.company_name = company_name,
		c.NIP = NIP,
		c.email = email,
		c.phone = phone
	WHERE c.client_id = id;

	SET exit_code = 0;
commit;
end$$

-- changing/adding address from app (DONE)
-- if address with given info exists connects it to the client, else creates new address then connects it to the client
-- exit_code = -1: invalid format of postal code
create procedure change_address(
	IN client_id int,
	IN street varchar(255),
	IN house_number int,
	IN apartment_number int,
	IN city varchar(255),
	IN postal_code varchar(6),
	OUT exit_code int
)
begin
	declare id int;

	SELECT a.address_id INTO id
	FROM addresses a
	WHERE a.street LIKE street AND
		a.house_number = house_number AND
		a.apartment_number = apartment_number AND
		a.city LIKE city AND
		a.postal_code LIKE postal_code;

start transaction;
	if id is null then
		if not postal_code regexp '^[0-9]{2}-[0-9]{3}$' then
			SET exit_code = -1;
			rollback;
		end if;

		INSERT INTO addresses (street, house_number, apartment_number, city, postal_code)
		VALUES(street, house_number, apartment_number, city, postal_code);

		SELECT a.address_id INTO id
		FROM addresses a
		WHERE a.street LIKE street AND
			a.house_number = house_number AND
			a.apartment_number = apartment_number AND
			a.city LIKE city AND
			a.postal_code LIKE postal_code;
	end if;

	UPDATE clients
	SET address_id = id
	WHERE client_id = client_id;

	SET exit_code = 0;
commit;
end$$

-- salesman
-- adding products from app
-- exit_code = -1: product with the same data already exists
-- exit_code = -2: price <= 0
create procedure add_products(
	IN name varchar(255),
	IN category enum('men', 'women', 'boys', 'girls'),
	IN type_id int,
	IN color_id int,
	IN price float,
	OUT exit_code int
)
begin
start transaction;
	if (
		SELECT p.product_id
		FROM products p
		WHERE p.name = name AND
			p.category = category AND
			p.type_id = type_id AND
			p.color_id = color_id
	) is not null then
		SET exit_code = -1;
		rollback;
	elseif price <= 0 then
		SET exit_code = -2;
		rollback;
	end if;

	INSERT INTO products(category, type_id, color_id, price)
	VALUES(category, type_id, color_id, price);

	SET exit_code = 0;
commit;
end$$

-- adding new types of products from app
-- exit_code = -1: another type with same name (case insensitive) already exists
create procedure add_types(
	IN type varchar(255),
	OUT exit_code int
)
begin
start transaction;
	if (
		SELECT p.type
		FROM product_types p
		WHERE lower(p.type) LIKE lower(type)
	) is not null then
		SET exit_code = -1;
		rollback;
	end if;

	INSERT INTO product_types(type)
	VALUES(type);

	SET exit_code = 0;
commit;
end$$

-- adding new colors from app
-- exit_code = -1: color with same name (case insensitive) already exixsts
-- exit_code = -2: color with same code already exists
create procedure add_colors(
	IN name varchar(255),
	IN code varchar(255),
	OUT exit_code int
)
begin
start transaction;
	if (SELECT p.color_id FROM product_colors p WHERE p.name LIKE name) is not null then
		SET exit_code = -1;
		rollback;
	elseif (SELECT p.color_id FROM product_colors p WHERE p.code LIKE code) is not null then
		SET exit_code = -2;
		rollback;
	end if;

	INSERT INTO product_colors(name, code)
	VALUES(name, code);

	SET exit_code = 0;
commit;
end$$

-- adding new photos from app
-- exit_code = -1: same photo for the same product
create procedure add_photos(
	IN product_id int,
	IN path varchar(255),
	OUT exit_code int
)
begin
start transaction;
	if (
		SELECT p.photo_id 
		FROM photos p
		WHERE p.product_id = product_id AND p.path LIKE path
	) is not null then
		SET exit_code = -1;
		rollback;
	end if;

	INSERT INTO photos(product_id, path)
	VALUES(product_id, path);

	SET exit_code = 0;
commit;
end$$

-- adding discount from app
-- if given discount is null or equals 0, removes discount
-- exit_code = -1: discount < 0
create procedure add_discount(
	IN product_id int,
	IN discount int,
	OUT exit_code int
)
begin
start transaction;
	if discount = 0 then
		UPDATE products p
		SET p.discount = null
		WHERE p.product_id = product_id;
	elseif discount < 0 then
		SET exit_code = -1;
		rollback;
	else
		UPDATE products p
		SET p.discount = discount
		WHERE p.product_id = product_id;
	end if;

	SET exit_code = 0;
commit;
end$$

-- changing product price from app
-- exit_code = -1: price <= 0
create procedure change_price(
	IN product_id int,
	IN price float,
	OUT exit_code int
)
begin
start transaction;
	if price <= 0 then
		SET exit_code = -1;
		rollback;
	end if;

	UPDATE products p 
	SET p.price = price
	WHERE p.product_id = product_id;

	SET exit_code = 0;
commit;
end$$

delimiter ;