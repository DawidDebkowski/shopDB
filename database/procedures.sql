drop procedure if exists add_warehouse;
drop procedure if exists add_client;
drop procedure if exists change_acc_info_individual;
drop procedure if exists change_acc_info_company;
drop procedure if exists change_address;
drop procedure if exists add_products;
drop procedure if exists add_types;
drop procedure if exists add_colors;
drop procedure if exists add_photos;
drop procedure if exists add_discount;
drop procedure if exists change_price;

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