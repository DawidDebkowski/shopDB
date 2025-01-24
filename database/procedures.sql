delimiter $$
-----procedures-----

-- client
-- creating account from app
-- inserts new account into users
-- creates client connected to user
-- creates empty order (cart)
----- READY -----
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
	if ready_to_commit = true then
		commit;
	else 
		rollback;
	end if;
end$$

-- changing account info, if individual, from app
-- changes individual client data to given
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
	if ready_to_commit = true then
		commit;
	else
		rollback;
	end if;
end$$

-- changing account info, if company from app
-- changes company client data to given
create procedure change_acc_info_company(
	IN id int,
	IN company_name varchar(255),
	IN NIP varchar(255),
	IN email varchar(255),
	IN phone varchar(15)
)
begin
start transaction;
	if (SELECT type FROM clients WHERE client_id = id) not like '%company%' then
		rollback;
	end if;

	UPDATE clients c
	SET c.company_name = company_name,
		c.NIP = NIP,
		c.email = email,
		c.phone = phone
	WHERE c.client_id = id;
commit;
end$$

-- changing/adding address from app
-- if address with given info exists connects it to the client, else creates new address then connects it to the client
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

	SELECT a.address_id INTO id
	FROM addresses a
	WHERE a.street LIKE street AND
		a.house_number = house_number AND
		a.apartment_number = apartment_number AND
		a.city LIKE city AND
		a.postal_code LIKE postal_code;

start transaction;
	if id is null then
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
commit;
end$$

-- adding products to cart
create procedure add_order_pos(
	IN client_id int,
	IN warehouse_id int,
	IN amount int
)
begin
	declare oid int;
	
	SELECT o.order_id INTO oid
	FROM orders o
	WHERE o.client_id = client_id AND o.status LIKE '%cart%';
start transaction;
	if (
		SELECT (w.amount-w.reserved)
		FROM warehouse w
		WHERE w.warehouse_id = warehouse_id
	) < amount then
		rollback;
	end if;

	INSERT INTO order_pos(order_id, warehouse_id, amount)
	VALUES(oid, warehouse_id, amount);
commit;
end$$

-- editing amount of products in cart
create procedure edit_order_pos(
	IN pos_id int,
	IN new_amount int
)
begin
start transaction;
	if (
		SELECT o.status
		FROM orders o JOIN order_pos p ON o.order_id = p.order_id
		WHERE p.pos_id = pos_id
	) not like '%cart%' then
		rollback;
	end if;

	if (
		SELECT (w.amount-w.reserved+o.amount)
		FROM warehouse w JOIN order_pos o ON w.warehouse_id = o.warehouse_id
		WHERE o.pos_id = pos_id
	) < new_amount then
		rollback;
	end if;

	UPDATE o.order_pos
	SET o.amount = new.amount
	WHERE o.pos_id = pos_id;
commit;
end$$

-- remove order_pos
create procedure remove_order_pos(
	IN pos_id int,
	IN client_id int
)
begin
start transaction;
	if (
		SELECT o.status 
		FROM orders o JOIN order_pos p ON o.order_id = p.order_id 
		WHERE p.pos_id = pos_id
	) not like '%cart%' then
		rollback;
	end if;

	DELETE FROM order_pos
	WHERE order_pos.pos_id = pos_id;
commit;
end$$

-- placing order
create procedure place_order(
	IN order_id int,
	IN invoice boolean
)
begin
	declare done boolean default false;
	declare pid int;
	declare wid int;
	declare oamount int;

	declare pos_cursor cursor for (
		SELECT o.pos_id
		FROM order_pos o
		WHERE o.order_id = order_id
	);

	declare continue handler for not found
		SET done = true;
start transaction;
	if (SELECT o.status FROM orders o WHERE o.order_id = order_id) not like '%cart%' then
		rollback;
	end if;

	open pos_cursor;
	positions_loop: loop
		fetch pos_cursor into pid;

		SELECT amount INTO oamount
		FROM order_pos
		WHERE pos_id = pid;

		SELECT warehouse_id INTO wid
		FROM order_pos
		WHERE pos_id = pid;

		if (
			SELECT (w.amount-w.reserved)
			FROM warehouse w
			WHERE w.warehouse_id = wid
		) < oamount then
			rollback;
		end if;

		UPDATE warehouse 
		SET reserved = reserved + oamount
		WHERE warehouse_id = wid;

		if done then
			leave positions_loop;
		end if;
	end loop;

	UPDATE orders o
	SET o.status = 'placed', 
		o.invoice = invoice
	WHERE o.order_id = order_id;
commit;
end$$

-- cancelling order
create procedure cancel_order(
	IN order_id int
)
begin
	declare done boolean default false;
	declare pid int;
	declare wid int;
	declare oamount int;

	declare pos_cursor cursor for (
		SELECT o.pos_id
		FROM order_pos o
		WHERE o.order_id = order_id
	);

	declare continue handler for not found
		SET done = true;
start transaction;
	if (SELECT o.status FROM orders o WHERE o.order_id = order_id) not like '%placed%' then
		rollback;
	end if;

	open pos_cursor;
	positions_loop: loop
		fetch pos_cursor into pid;

		SELECT amount INTO oamount
		FROM order_pos
		WHERE pos_id = pid;

		SELECT warehouse_id INTO wid
		FROM order_pos
		WHERE pos_id = pid;

		UPDATE warehouse 
		SET reserved = reserved - oamount
		WHERE warehouse_id = wid;

		if done then
			leave positions_loop;
		end if;
	end loop;

	UPDATE orders o
	SET o.status = 'cancelled'
	WHERE o.order_id = order_id;
commit;
end$$

-- paying for the order
create procedure pay_order(
	IN order_id int
)
begin
start transaction;
	if (
		SELECT o.status
		FROM orders o
		WHERE o.order_id = order_id
	) not like '%placed%' then
		rollback;
	end if;

	UPDATE orders o
	SET o.status = 'paid'
	WHERE o.order_id = order_id;
commit;
end$$

-- returning the order
create procedure return_order(
	IN order_id int
) 
begin
start transaction;
	if (
		SELECT o.status
		FROM orders o
		WHERE o.order_id = order_id
	) not like '%completed%' then
		rollback;
	end if;

	if timestampdiff(
		day,
		(
			SELECT o.log_date
			FROM order_log o
			WHERE o.order_id = order_id 
				AND o.old_status LIKE '%paid%'
				AND o.new_status LIKE '%completed%'
		),
		now()
	) > 30 then 
		rollback;
	end if;

	UPDATE orders o
	SET o.status = 'return reported'
	WHERE o.order_id = order_id;
commit;
end$$

-- salesman
-- adding product
create procedure add_products(
	IN name varchar(255),
	IN category enum('men', 'women', 'boys', 'girls'),
	IN type_id int,
	IN color_id int,
	IN price float
)
begin
start transaction;
	INSERT INTO products(category, type_id, color_id, price)
	VALUES(category, type_id, color_id, price);
commit;
end$$

-- adding new types of products
create procedure add_types(
	IN type varchar(255)
)
begin
start transaction;
	INSERT INTO product_types(type)
	VALUES(type);
commit;
end$$

-- adding new colors from app
create procedure add_colors(
	IN name varchar(255),
	IN code varchar(255)
)
begin
start transaction;
	INSERT INTO product_colors(name, code)
	VALUES(name, code);
commit;
end$$

-- adding new photos from app
create procedure add_photos(
	IN product_id int,
	IN path varchar(255)
)
begin
start transaction;
	INSERT INTO photos(product_id, path)
	VALUES(product_id, path);
commit;
end$$

-- editing products
create procedure edit_product(
	IN product_id int,
	IN name varchar(255),
	IN category enum('men', 'women', 'boys', 'girls'),
	IN type_id int,
	IN color_id int
)
begin
start transaction;
	UPDATE products p
	SET p.name = name,
		p.category = category,
		p.type_id = type_id,
		p.color_id = color_id
	WHERE p.product_id = product_id;
commit;
end$$

-- editing types of products
create procedure edit_type(
	IN type_id int,
	IN type varchar(255)
)
begin
start transaction;
	UPDATE product_types p
	SET p.type = type
	WHERE p.type_id = type_id;
commit;
end$$

-- editing colors of products
create procedure edit_color(
	IN color_id int,
	IN name varchar(255),
	IN code varchar(255)
)
begin
start transaction;
	UPDATE product_colors p
	SET p.name = name,
		p.code = code
	WHERE p.color_id = color_id; 
commit;
end$$

-- remove product
create procedure remove_product(
	IN product_id int
)
begin
start transaction;
	DELETE FROM products
	WHERE products.product_id = product_id; 
commit;
end$$

-- remove type
create procedure remove_type(
	IN type_id int
)
begin
start transaction;
	if type_id = 0 then
		rollback;
	end if;

	UPDATE products p
	SET p.type_id = 0
	WHERE p.type_id = type_id;

	DELETE FROM product_types
	WHERE product_types.type_id = type_id;
commit;
end$$

-- remove color
create procedure remove_color(
	IN color_id int
)
begin
start transaction;
	if color_id = 0 then
		rollback;
	end if;

	UPDATE products p 
	SET p.color_id = 0
	WHERE p.color_id = color_id;

	DELETE FROM product_colors 
	WHERE product_colors.color_id = color_id;
commit;
end$$

-- removing photos
create procedure remove_photo(
	IN photo_id int
)
begin
start transaction;
	DELETE FROM photos
	WHERE photos.photo_id = photo_id;
commit;
end$$

-- changing price
create procedure change_price(
	IN product_id int,
	IN new_price int
)
begin
start transaction;
	UPDATE products p
	SET p.price = new_price
	WHERE p.product_id = product_id;
commit;
end$$

-- changing discount
create procedure change_discount(
	IN product_id int,
	IN new_discount int
) 
begin
start transaction;
	if new_discount = 0 then
		SET new_discount = null;
	end if;

	UPDATE products p
	SET p.discount = new_discount
	WHERE p.product_id = product_id;
commit;
end$$

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

delimiter ;