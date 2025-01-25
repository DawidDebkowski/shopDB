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

	if ((
		SELECT c.type
		FROM clients c
		WHERE c.client_id = client_id
	) like '%individual%') = invoice then
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

delimiter ;