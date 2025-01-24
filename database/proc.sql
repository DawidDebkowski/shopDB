drop procedure if exists add_client;
drop procedure if exists change_acc_info_individual;
drop procedure if exists change_acc_info_company;
drop procedure if exists change_address;

delimiter $$

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

delimiter ;