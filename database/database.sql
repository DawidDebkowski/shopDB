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
	add unique key addresses_unique(street, house_number, apartment_number, city, postal_code),
	add constraint addresses_postal_code_check
		check(postal_code regexp '^[0-9]{2}-[0-9]{3}$');

alter table products
	add unique key products_unique(name, category, type_id, color_id),
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
	add unique key photos_unique(product_id, path),
	add constraint photos_fk_product
		foreign key (product_id)
		references products(product_id)
		on update cascade;

alter table warehouse
	add unique key warehouse_unique(product_id, size),
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
	add unique key order_pos_unique(order_id, warehouse_id),
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
		on update cascade;

-----triggers-----
delimiter $$

-- order: automatic value calculation from order_pos
create trigger AI_order_pos_value
    after insert on order_pos
    for each row
begin
    UPDATE orders o
    SET o.value = (
        SELECT SUM(p.price * (100 - COALESCE(p.discount, 0)) / 100 * op.amount)
        FROM products p JOIN warehouse w ON p.product_id = w.product_id
            JOIN order_pos op ON w.warehouse_id = op.warehouse_id
        WHERE op.order_id = new.order_id
        GROUP BY op.order_id
    )
    WHERE o.order_id = new.order_id;
end $$

create trigger AU_order_pos_value
    after update on order_pos
    for each row
begin
    UPDATE orders o
    SET o.value = (
        SELECT SUM(p.price * (100 - COALESCE(p.discount, 0)) / 100 * op.amount)
        FROM products p JOIN warehouse w ON p.product_id = w.product_id
            JOIN order_pos op ON w.warehouse_id = op.warehouse_id
        WHERE op.order_id = old.order_id
        GROUP BY op.order_id
    )
    WHERE o.order_id = old.order_id;

    UPDATE orders o
    SET o.value = (
        SELECT SUM(p.price * (100 - COALESCE(p.discount, 0)) / 100 * op.amount)
        FROM products p JOIN warehouse w ON p.product_id = w.product_id
            JOIN order_pos op ON w.warehouse_id = op.warehouse_id
        WHERE op.order_id = new.order_id
        GROUP BY op.order_id
    )
    WHERE o.order_id = new.order_id;
end $$

create trigger AD_order_pos_value
    after delete on order_pos
    for each row
begin
    UPDATE orders o
    SET o.value = (
        SELECT SUM(p.price * (100 - COALESCE(p.discount, 0)) / 100 * op.amount)
        FROM products p JOIN warehouse w ON p.product_id = w.product_id
            JOIN order_pos op ON w.warehouse_id = op.warehouse_id
        WHERE op.order_id = old.order_id
        GROUP BY op.order_id
    )
    WHERE o.order_id = old.order_id;
end $$

-- order_pos: if amount is 0 - delete row
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

-- order_log: adding order status change log
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

-- client

create procedure add_client(
	IN login varchar(255),
	IN password varchar(255),
	IN type enum('individual', 'company'),
	IN email varchar(255),
	IN phone varchar(15),
	IN NIP char(10),
	IN cookies boolean
)
begin
	declare user int;
	declare cid int;
	
	declare ready_to_commit boolean default true;
    declare continue handler for sqlexception
        SET ready_to_commit = false;

	start transaction;
		INSERT INTO users(login, password, acc_type)
		VALUES(login, password, 'client');

		SELECT u.user_id INTO user
		FROM users u
		WHERE u.login LIKE login;

		if type like 'individual' then
			INSERT INTO clients(user_id, type, email, phone, RODO, terms_of_use, cookies)
			VALUES(user, type, email, phone, true, true, cookies);
		else
			INSERT INTO clients(user_id, type, email, phone, NIP, RODO, terms_of_use, cookies)
			VALUES(user, type, email, phone, NIP, true, true, cookies);
		end if;

		SELECT c.client_id INTO cid
		FROM clients c
		WHERE c.user_id = user;

		INSERT INTO orders(client_id, status)
		VALUES(cid, 'cart');
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;
end$$

create procedure change_acc_info_individual(
	IN id int,
	IN name varchar(255),
	IN surname varchar(255),
	IN email varchar(255),
	IN phone varchar(15)
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;
	start transaction;
		if (SELECT type FROM clients WHERE client_id = id) not like '%individual%' then
			SET ready_to_commit = false;
		end if;

		UPDATE clients c
		SET c.name = name,
			c.surname = surname,
			c.email = email,
			c.phone = phone
		WHERE c.client_id = id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure change_acc_info_company(
	IN id int,
	IN company_name varchar(255),
	IN NIP varchar(255),
	IN email varchar(255),
	IN phone varchar(15)
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;
	start transaction;
		if (SELECT type FROM clients WHERE client_id = id) not like '%company%' then
			SET ready_to_commit = false;
		end if;

		UPDATE clients c
		SET c.company_name = company_name,
			c.NIP = NIP,
			c.email = email,
			c.phone = phone
		WHERE c.client_id = id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure change_address(
	IN client_id int,
	IN street varchar(255),
	IN house_number int,
	IN apartment_number int,
	IN city varchar(255),
	IN postal_code varchar(6)
)
begin
	declare id int;

	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	SELECT a.address_id INTO id
	FROM addresses a
	WHERE a.street LIKE street AND
		a.house_number = house_number AND
		(a.apartment_number = apartment_number OR (a.apartment_number IS NULL AND apartment_number IS NULL)) AND
		a.city LIKE city AND
		a.postal_code LIKE postal_code;

	start transaction;
		if id is null then
			INSERT INTO addresses (street, house_number, apartment_number, city, postal_code)
			VALUES (street, house_number, apartment_number, city, postal_code);

			SELECT a.address_id INTO id
			FROM addresses a
			WHERE a.street LIKE street AND
				a.house_number = house_number AND
				(a.apartment_number = apartment_number OR (a.apartment_number IS NULL AND apartment_number IS NULL)) AND
				a.city LIKE city AND
				a.postal_code LIKE postal_code;
		end if;

		UPDATE clients c
		SET c.address_id = id
		WHERE c.client_id = client_id;
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;
end$$

create procedure add_order_pos(
	IN client_id int,
	IN warehouse_id int,
	IN amount int
)
begin
	declare oid int;

	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	SELECT o.order_id INTO oid
	FROM orders o
	WHERE o.client_id = client_id AND o.status LIKE '%cart%';
	
	if (
		SELECT w.amount - w.reserved
		FROM warehouse w
		WHERE w.warehouse_id = warehouse_id
	) < amount then
		SET ready_to_commit = false;
	end if;

	if amount <= 0 then
		SET ready_to_commit = false;
	end if;

	start transaction;
		INSERT INTO order_pos (order_id, warehouse_id, amount)
		VALUES (oid, warehouse_id, amount);
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;
end$$

create procedure edit_order_pos(
	IN client_id int,
	IN pos_id int,
	IN new_amount int
)
begin
	declare oid int;
	declare wid int;

	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	SELECT o.order_id INTO oid
	FROM orders o
	WHERE o.client_id = client_id AND o.status LIKE '%basket%';
	
	if (
		SELECT o.order_id 
		FROM order_pos o
		WHERE o.pos_id = pos_id
	) <> oid then 
		SET ready_to_commit = false;
	end if;

	SELECT o.warehouse_id INTO wid
	FROM order_pos o
	WHERE o.pos_id = pos_id;

	if (
		SELECT w.amount - w.reserved
		FROM warehouse w
		WHERE w.warehouse_id = wid
	) < new_amount then	
		SET ready_to_commit = false;
	end if;

	start transaction;
		UPDATE order_pos o
		SET o.amount = new_amount
		WHERE o.pos_id = pos_id;
	if ready_to_commit then 
		commit;
	else
		rollback;
	end if;
end$$

create procedure remove_order_pos(
	IN client_id int,
	IN pos_id int
)
begin
	declare oid int;

	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	SELECT o.order_id INTO oid
	FROM orders o
	WHERE o.client_id = client_id AND o.status LIKE '%cart%';

	if (
		SELECT o.order_id
		FROM order_pos o
		WHERE o.pos_id = pos_id
	) <> oid then 
		SET ready_to_commit = false;
	end if;
	
	start transaction;
		DELETE FROM order_pos
		WHERE order_pos.pos_id = pos_id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure place_order(
	IN client_id int,
	IN invoice boolean
)
begin
	declare oid int;

	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	SELECT o.order_id INTO oid
	FROM orders o
	WHERE o.client_id = client_id AND o.status LIKE '%cart%';

	if (
		SELECT COUNT(COALESCE(o.pos_id, 0))
		FROM order_pos o
		WHERE o.order_id = oid
	) = 0 then
		SET ready_to_commit = false;
	end if;

	if (SELECT c.type FROM clients c WHERE c.client_id = client_id) like '%individual%' AND (
		(SELECT c.name FROM clients c WHERE c.client_id = client_id) is null OR
		(SELECT c.surname FROM clients c WHERE c.client_id = client_id) is null OR
		(SELECT c.address_id FROM clients c WHERE c.client_id = client_id) is null OR 
		invoice = true
	) then
		SET ready_to_commit = false;
	end if;

	if (SELECT c.type FROM clients c WHERE c.client_id = client_id) like '%company%' AND (
		(SELECT c.company_name FROM clients c WHERE c.client_id = client_id) is null OR
		(SELECT c.NIP FROM clients c WHERE c.client_id = client_id) is null OR
		(SELECT c.address_id FROM clients c WHERE c.client_id = client_id) is null OR 
		invoice = false
	) then
		SET ready_to_commit = false;
	end if;
	
	start transaction;
		if (
			SELECT COALESCE(COUNT(o.warehouse_id), 0)
			FROM order_pos o JOIN warehouse w ON o.warehouse_id = w.warehouse_id
			WHERE w.reserved + o.amount > w.amount AND o.order_id = oid
		) > 0 then
			set ready_to_commit = false;
		else 
			UPDATE warehouse w JOIN order_pos o ON w.warehouse_id = o.warehouse_id
			SET w.reserved = w.reserved + o.amount
			WHERE o.order_id = oid;
		end if;

		UPDATE orders o
		SET o.invoice = invoice,
			o.status = 'placed'
		WHERE o.order_id = oid; 

		INSERT INTO orders (client_id, status)
		VALUES (client_id, 'cart');
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure pay_order(
	IN order_id int
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	if (
		SELECT o.status
		FROM orders o
		WHERE o.order_id = order_id
	) not like '%placed%' then
		SET ready_to_commit = false;
	end if;

	start transaction;
		UPDATE orders o
		SET o.status = 'paid'
		WHERE o.order_id = order_id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure cancel_order(
	IN order_id int
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;
		
	if (
		SELECT o.status
		FROM orders o
		WHERE o.order_id = order_id
	) not like '%placed%' and (
		SELECT o.status
		FROM orders o
		WHERE o.order_id = order_id
	) not like '%paid%' then
		SET ready_to_commit = false;
	end if;
	
	start transaction;
		UPDATE warehouse w JOIN order_pos o ON w.warehouse_id = o.warehouse_id
		SET w.reserved = w.reserved - o.amount
		WHERE o.order_id = order_id;

		UPDATE orders o
		SET o.status = 'cancelled'
		WHERE o.order_id = order_id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure report_return(
	IN order_id int
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;
	
	if (
		SELECT o.status
		FROM orders o
		WHERE o.order_id = order_id
	) not like '%completed%' then
		SET ready_to_commit = false;
	end if;

	start transaction;
		UPDATE orders o
		SET o.status = 'return reported'
		WHERE o.order_id = order_id; 
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

-- salesman

create procedure add_type(
	IN type varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		INSERT INTO product_types(type)
		VALUES(type);
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;
end$$

create procedure edit_type(
	IN type_id int,
	IN type varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		UPDATE product_types p
		SET p.type = type
		WHERE p.type_id = type_id;
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;
end$$

create procedure remove_type(
	IN type_id int
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		if type_id = 1 then
			SET ready_to_commit = false;
		end if;

		UPDATE products p
		SET p.type_id = 1
		WHERE p.type_id = type_id;

		DELETE FROM product_types
		WHERE product_types.type_id = type_id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure add_color(
	IN name varchar(255),
	IN code varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		INSERT INTO product_colors(name, code)
		VALUES(name, code);
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure edit_color(
	IN color_id int,
	IN name varchar(255),
	IN code varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		UPDATE product_colors p
		SET p.name = name,
			p.code = code
		WHERE p.color_id = color_id; 
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;
end$$

create procedure remove_color(
	IN color_id int
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		if color_id = 1 then
			SET ready_to_commit = false;
		end if;

		UPDATE products p 
		SET p.color_id = 1
		WHERE p.color_id = color_id;

		DELETE FROM product_colors 
		WHERE product_colors.color_id = color_id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure add_product(
	IN name varchar(255),
	IN category enum('men', 'women', 'boys', 'girls'),
	IN type_id int,
	IN color_id int,
	IN price decimal(4, 2)
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		INSERT INTO products(name, category, type_id, color_id, price)
		VALUES(name, category, type_id, color_id, price);
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure edit_product(
	IN product_id int,
	IN name varchar(255),
	IN category enum('men', 'women', 'boys', 'girls'),
	IN type_id int,
	IN color_id int
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		UPDATE products p
		SET p.name = name,
			p.category = category,
			p.type_id = type_id,
			p.color_id = color_id
		WHERE p.product_id = product_id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure add_photo(
	IN product_id int,
	IN path varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		INSERT INTO photos(product_id, path)
		VALUES(product_id, path);
	if ready_to_commit then	
		commit;
	else
		rollback;
	end if;
end$$

create procedure remove_photo(
	IN photo_id int
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		DELETE FROM photos
		WHERE photos.photo_id = photo_id;
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;
end$$

create procedure change_price(
	IN product_id int,
	IN new_price decimal(4, 2)
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false; 

	start transaction;
		UPDATE products p
		SET p.price = new_price
		WHERE p.product_id = product_id;

		UPDATE orders o JOIN order_pos op ON o.order_id = op.order_id
			JOIN warehouse w ON w.warehouse_id = op.warehouse_id
			JOIN products p ON p.product_id = w.product_id
		SET o.value = (
			SELECT SUM(P.price * (100 - COALESCE(P.discount, 0)) / 100 * op.amount)
			FROM products P JOIN warehouse W ON P.product_id = W.product_id
				JOIN order_pos OP ON W.warehouse_id = OP.warehouse_id
			WHERE OP.order_id = o.order_id
			GROUP BY OP.order_id
		)
		WHERE p.product_id = product_id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure change_discount(
	IN product_id int,
	IN new_discount int
) 
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	start transaction;
		if new_discount = 0 then
			SET new_discount = null;
		end if;

		UPDATE products p
		SET p.discount = new_discount
		WHERE p.product_id = product_id;

		UPDATE orders o JOIN order_pos op ON o.order_id = op.order_id
			JOIN warehouse w ON w.warehouse_id = op.warehouse_id
			JOIN products p ON p.product_id = w.product_id
		SET o.value = (
			SELECT SUM(P.price * (100 - COALESCE(P.discount, 0)) / 100 * op.amount)
			FROM products P JOIN warehouse W ON P.product_id = W.product_id
				JOIN order_pos OP ON W.warehouse_id = OP.warehouse_id
			WHERE OP.order_id = o.order_id
			GROUP BY OP.order_id
		)
		WHERE p.product_id = product_id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

-- warehouse_manager

create procedure add_warehouse(
	IN product_id int,
	IN size enum('XS', 'S', 'M', 'L', 'XL'),
	IN amount int
)
begin
	declare wid int;

	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	SELECT w.warehouse_id INTO wid
	FROM warehouse w
	WHERE w.product_id = product_id AND w.size LIKE size;

	if amount <= 0 then
		set ready_to_commit = false;
	end if;

	start transaction;
		if wid is null then
			INSERT INTO warehouse (product_id, size, amount)
			VALUES (product_id, size, amount);
		else
			UPDATE warehouse w
			SET w.amount = w.amount + amount
			WHERE w.warehouse_id = wid;
		end if;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;
end$$

create procedure edit_warehouse(
	IN warehouse_id int,
	IN amount int
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;
	
	start transaction;
		UPDATE warehouse w
		SET w.amount = w.amount + amount
		WHERE w.warehouse_id = warehouse_id;
	if ready_to_commit then	
		commit;
	else
		rollback;
	end if;
end$$

create procedure complete_order(
	IN order_id int
)
begin
	declare cid int;

	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;

	SELECT o.client_id INTO cid
	FROM orders o
	WHERE o.order_id = order_id;
	
	if (
		SELECT o.status
		FROM orders o
		WHERE o.order_id = order_id
	) not like '%paid%' then
		SET ready_to_commit = false;
	end if;

	start transaction;
		if (
			SELECT COALESCE(COUNT(o.warehouse_id), 0)
			FROM order_pos o JOIN warehouse w ON o.warehouse_id = w.warehouse_id
			WHERE w.amount - o.amount < 0 AND o.order_id = order_id
		) > 0 then
			set ready_to_commit = false;
		else 
			UPDATE warehouse w JOIN order_pos o ON w.warehouse_id = o.warehouse_id
			SET w.reserved = w.reserved - o.amount,
				w.amount = w.amount - o.amount
			WHERE o.order_id = order_id;
		end if;
		
		UPDATE orders o
		SET o.status = 'completed'
		WHERE o.order_id = order_id;
		
		if (
			SELECT o.invoice
			FROM orders o
			WHERE o.order_id = order_id
		) then
			INSERT INTO invoices (order_id, NIP, company_name, address_id)
			VALUES (order_id, 
					(SELECT c.NIP FROM clients c WHERE c.client_id = cid),
					(SELECT c.company_name FROM clients c WHERE c.client_id = cid),
					(SELECT c.address_id FROM clients c WHERE c.client_id = cid));
		end if;
	if ready_to_commit then	
		commit;
	else
		rollback;
	end if;
end$$

create procedure consider_return(
	IN order_id int,
	IN accept boolean
)
begin
	declare ready_to_commit boolean default true;
	declare continue handler for sqlexception
		SET ready_to_commit = false;
	
	start transaction;
		if accept then
			UPDATE warehouse w JOIN order_pos o ON w.warehouse_id = o.warehouse_id
			SET w.amount = w.amount + o.amount
			WHERE o.order_id = order_id;

			UPDATE orders o
			SET o.status = 'returned'
			WHERE o.order_id = order_id;
		else
			UPDATE orders o
			SET o.status = 'completed'
			WHERE o.order_id = order_id;
		end if;
	if ready_to_commit then	
		commit;
	else
		rollback;
	end if;
end$$

delimiter ;

----- views -----

create view ind_client_view as (
	SELECT c.name, c.surname, c.email, c.phone, a.street, a.house_number, a.apartment_number, a.city, a.postal_code
	FROM clients c JOIN addresses a ON c.address_id = a.address_id
);

create view com_client_view as (
	SELECT c.company_name, c.email, c.phone, c.NIP, a.street, a.house_number, a.apartment_number, a.city, a.postal_code
	FROM clients c JOIN addresses a ON c.address_id = a.address_id
);

create view product_view as (
	SELECT p.name, p.category, t.type, c.name AS color, p.price, COALESCE(p.discount, 0) AS discount
	FROM products p JOIN product_types t ON p.type_id = t.type_id
		JOIN product_colors c ON p.color_id = c.color_id
);

create view order_view as (
	SELECT o.order_id, o.status, o.value
	FROM orders o
);