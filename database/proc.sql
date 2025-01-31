delimiter $$

create procedure auth_user(
	IN login varchar(255),
	OUT password varchar(255),
	OUT acc_type enum('client', 'warehouse', 'salesman')
)
begin
	SELECT u.acc_type INTO acc_type
	FROM users u
	WHERE u.login LIKE login;

	SELECT u.password INTO password
    FROM users u
    WHERE u.login LIKE login;
end$$

-- client

create procedure add_client(
	IN login varchar(255),
	IN password varchar(255),
	IN type enum('individual', 'company'),
	IN email varchar(255),
	IN phone varchar(15),
	IN NIP char(10),
	IN cookies boolean,
	OUT exit_msg varchar(255)
)
begin
	declare user int;
	declare cid int;
	
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

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

		if cid is not null then
			INSERT INTO orders(client_id, status)
			VALUES(cid, 'cart');
		end if;
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;

	SET exit_msg = case
		when locate('login_unique', error_msg) > 0 then 'Uzytkownik z takim loginem juz istnieje.'
		when locate('clients_email_unique', error_msg) > 0 then 'Ten email jest juz zarejestrowany na innego uzytkownika.'
		when locate('clients_phone_unique', error_msg) > 0 then 'Ten numer telefonu jest juz zarejestrowany na innego uzytkownika'
		when locate('clients_NIP_unique', error_msg) > 0 then 'Ten NIP jest juz zarejestrowany na innego uzytkownika'
		when locate('clients_email_check', error_msg) > 0 then 'Niepoprawny adres email'
		when locate('clients_phone_check', error_msg) > 0 then 'Niepoprawny numer telefonu'
		when locate('clients_NIP_check', error_msg) > 0 then 'Niepoprawny NIP'
		when error_msg is not null then error_msg
		else CONCAT('Dodano nowego klienta: ', login, '.')
 	end;
end$$

create procedure change_acc_info_individual(
	IN id int,
	IN name varchar(255),
	IN surname varchar(255),
	IN email varchar(255),
	IN phone varchar(15),
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;
	start transaction;
		if (SELECT type FROM clients WHERE client_id = id) not like '%individual%' then
			SET ready_to_commit = false;
			SET error_msg = 'wrong type';
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

	SET exit_msg = case
		when locate('clients_email_unique', error_msg) > 0 then 'Ten email jest juz zarejestrowany na innego uzytkownika.'
		when locate('clients_phone_unique', error_msg) > 0 then 'Ten numer telefonu jest juz zarejestrowany na innego uzytkownika'
		when locate('clients_NIP_unique', error_msg) > 0 then 'Ten NIP jest juz zarejestrowany na innego uzytkownika'
		when locate('clients_email_check', error_msg) > 0 then 'Niepoprawny adres email'
		when locate('clients_phone_check', error_msg) > 0 then 'Niepoprawny numer telefonu'
		when locate('clients_NIP_check', error_msg) > 0 then 'Niepoprawny NIP'
		when error_msg is not null then error_msg
		else 'Zmieniono dane.'
 	end;
end$$

create procedure change_acc_info_company(
	IN id int,
	IN company_name varchar(255),
	IN NIP varchar(255),
	IN email varchar(255),
	IN phone varchar(15),
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;
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

	SET exit_msg = case
		when locate('clients_email_unique', error_msg) > 0 then 'Ten email jest juz zarejestrowany na innego uzytkownika.'
		when locate('clients_phone_unique', error_msg) > 0 then 'Ten numer telefonu jest juz zarejestrowany na innego uzytkownika'
		when locate('clients_NIP_unique', error_msg) > 0 then 'Ten NIP jest juz zarejestrowany na innego uzytkownika'
		when locate('clients_email_check', error_msg) > 0 then 'Niepoprawny adres email'
		when locate('clients_phone_check', error_msg) > 0 then 'Niepoprawny numer telefonu'
		when locate('clients_NIP_check', error_msg) > 0 then 'Niepoprawny NIP'
		when error_msg is not null then error_msg
		else 'Zmieniono dane.'
 	end;
end$$

create procedure change_address(
	IN client_id int,
	IN street varchar(255),
	IN house_number int,
	IN apartment_number int,
	IN city varchar(255),
	IN postal_code varchar(6),
	OUT exit_msg varchar(255)
)
begin
	declare id int;

	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

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

	SET exit_msg = case
		when locate('addresses_postal_code_check', error_msg) > 0 then 'Niepoprawny kod pocztowy.'
		when error_msg is not null then error_msg
		else 'Zmieniono adres.'
 	end;
end$$

create procedure add_order_pos(
	IN client_id int,
	IN warehouse_id int,
	IN amount int,
	OUT exit_msg varchar(255)
)
begin
	declare oid int;

	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	SELECT o.order_id INTO oid
	FROM orders o
	WHERE o.client_id = client_id AND o.status LIKE '%cart%';
	
	if (
		SELECT w.amount - w.reserved
		FROM warehouse w
		WHERE w.warehouse_id = warehouse_id
	) < amount then
		SET ready_to_commit = false;
		SET error_msg = 'Produkt w danej ilosci nie jest obecnie dostepny.';
	end if;

	start transaction;
		INSERT INTO order_pos (order_id, warehouse_id, amount)
		VALUES (oid, warehouse_id, amount);
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;

	SET exit_msg = case
		when locate('order_pos_unique', error_msg) then 'Ten produkt jest juz w koszyku.'
		when locate('order_pos_amount_check', error_msg) then 'Niepoprawna liczba produktow.'
		when error_msg is not null then error_msg
		else 'Dodano nowa pozycje do koszyka.'
	end;
end$$

create procedure edit_order_pos(
	IN client_id int,
	IN pos_id int,
	IN new_amount int,
	OUT exit_msg varchar(255)
)
begin
	declare oid int;
	declare wid int;
	declare old_amount int;

	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	SELECT o.order_id INTO oid
	FROM orders o
	WHERE o.client_id = client_id AND o.status LIKE '%basket%';
	
	if (
		SELECT o.order_id 
		FROM order_pos o
		WHERE o.pos_id = pos_id
	) <> oid then 
		SET ready_to_commit = false;
		SET error_msg = 'Nie mozna zmienic ilosci produktow ze zlozonego zamowienia.';
	end if;

	SELECT o.warehouse_id INTO wid
	FROM order_pos o
	WHERE o.pos_id = pos_id;

	SELECT o.amount INTO old_amount
	FROM order_pos o
	WHERE o.pos_id = pos_id;

	if (
		SELECT w.amount - w.reserved
		FROM warehouse w
		WHERE w.warehouse_id = wid
	) < old_amount + new_amount then	
		SET ready_to_commit = false;
		SET error_msg = 'Produkt w danej ilosci nie jest obecnie dostepny.';
	end if;

	start transaction;
		UPDATE order_pos o
		SET o.amount = o.amount + new_amount
		WHERE o.pos_id = pos_id;
	if ready_to_commit then 
		commit;
	else
		rollback;
	end if;

	SET exit_msg = case
		when locate('order_pos_unique', error_msg) then 'Ten produkt jest juz w koszyku.'
		when locate('order_pos_amount_check', error_msg) then 'Niepoprawna liczba produktow.'
		when error_msg is not null then error_msg
		else 'Edytowno ilosc pozycji z koszyka.'
	end;
end$$

create procedure remove_order_pos(
	IN client_id int,
	IN pos_id int,
	OUT exit_msg varchar(255)
)
begin
	declare oid int;

	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	SELECT o.order_id INTO oid
	FROM orders o
	WHERE o.client_id = client_id AND o.status LIKE '%cart%';

	if (
		SELECT o.order_id
		FROM order_pos o
		WHERE o.pos_id = pos_id
	) <> oid then 
		SET ready_to_commit = false;
		SET error_msg = 'Nie mozna usunac pozycji ze zlozonego zamowienia.';
	end if;
	
	start transaction;
		DELETE FROM order_pos
		WHERE order_pos.pos_id = pos_id;
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;

	SET exit_msg = case 
		when error_msg is not null then error_msg
		else 'Usunieto pozycje z koszyka.'
	end;
end$$

create procedure place_order(
	IN client_id int,
	IN invoice boolean,
	OUT exit_msg varchar(255)
)
begin
	declare oid int;

	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	SELECT o.order_id INTO oid
	FROM orders o
	WHERE o.client_id = client_id AND o.status LIKE '%cart%';

	if (
		SELECT COUNT(COALESCE(o.pos_id, 0))
		FROM order_pos o
		WHERE o.order_id = oid
	) = 0 then
		SET ready_to_commit = false;
		SET error_msg = 'Nie mozna zlozyc pustego zamowienia.';
	end if;

	if (SELECT c.type FROM clients c WHERE c.client_id = client_id) like '%individual%' AND (
		(SELECT c.name FROM clients c WHERE c.client_id = client_id) is null OR
		(SELECT c.surname FROM clients c WHERE c.client_id = client_id) is null OR
		(SELECT c.address_id FROM clients c WHERE c.client_id = client_id) is null OR 
		invoice = true
	) then
		SET ready_to_commit = false;
		SET error_msg = 'Nie znamy wszystkich danych niezbednych do zlozenia zamowienia';
	end if;

	if (SELECT c.type FROM clients c WHERE c.client_id = client_id) like '%company%' AND (
		(SELECT c.company_name FROM clients c WHERE c.client_id = client_id) is null OR
		(SELECT c.NIP FROM clients c WHERE c.client_id = client_id) is null OR
		(SELECT c.address_id FROM clients c WHERE c.client_id = client_id) is null OR 
		invoice = false
	) then
		SET ready_to_commit = false;
		SET error_msg = 'Nie znamy wszystkich danych niezbednych do zlozenia zamowienia';
	end if;
	
	start transaction;
		if (
			SELECT COALESCE(COUNT(o.warehouse_id), 0)
			FROM order_pos o JOIN warehouse w ON o.warehouse_id = w.warehouse_id
			WHERE w.reserved + o.amount > w.amount AND o.order_id = oid
		) > 0 then
			SET ready_to_commit = false;
			SET error_msg = 'Niektore pozycje z koszyka nie sa juz dostepne';
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

	SET exit_msg = case
		when error_msg is not null then error_msg
		else 'Zlozono zamowienie'
	end;
end$$

create procedure pay_order(
	IN order_id int,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	if (
		SELECT o.status
		FROM orders o
		WHERE o.order_id = order_id
	) not like '%placed%' then
		SET ready_to_commit = false;
		SET error_msg = 'Nie mozna oplacic niezlozonego zamowienia.';
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

	SET exit_msg = case
		when error_msg is not null then error_msg
		else 'Oplacono zamowienie.'
	end;
end$$

create procedure cancel_order(
	IN order_id int,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;
		
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
		SET error_msg = 'Nie mozna anulowac zamowienia.';
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

	SET error_msg = case
		when error_msg is not null then error_msg
		else 'Anulowano zamowienie.'
	end;
end$$

create procedure report_return(
	IN order_id int,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;
	
	if (
		SELECT o.status
		FROM orders o
		WHERE o.order_id = order_id
	) not like '%completed%' then
		SET ready_to_commit = false;
		SET error_msg = 'Nie mozna zwrocic zamowienia, ktore nie zostalo dostarczone.';
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

	SET exit_msg = case
		when error_msg is not null then error_msg
		else 'Zgloszono zwrot.'
	end;
end$$

-- salesman

create procedure add_type(
	IN type varchar(255),
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	start transaction;
		INSERT INTO product_types(type)
		VALUES(type);
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;

	SET exit_msg = case
		when locate('product_types_unique', error_msg) > 0 then 'Taki typ jest juz w bazie.'
		when error_msg is not null then error_msg
		else 'Dodano nowy typ produktow.'
	end;
end$$

create procedure edit_type(
	IN type_id int,
	IN type varchar(255),
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	start transaction;
		if type_id = 1 then
			SET ready_to_commit = false;
			SET error_msg = 'Nie mozna edytowac tego typu.';
		end if;

		UPDATE product_types p
		SET p.type = type
		WHERE p.type_id = type_id;
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;

	SET exit_msg = case
		when locate('product_types_unique', error_msg) > 0 then 'Taki typ jest juz w bazie.'
		when error_msg is not null then error_msg
		else 'Edytowano typ produktow.'
	end;
end$$

create procedure remove_type(
	IN type_id int,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	start transaction;
		if type_id = 1 then
			SET ready_to_commit = false;
			SET error_msg = 'Nie mozna usunac tego typu.';
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

	SET exit_msg = case
		when error_msg is not null then error_msg
		else 'Usunieto typ produktow.'
	end;
end$$

create procedure add_color(
	IN name varchar(255),
	IN code varchar(255),
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	start transaction;
		INSERT INTO product_colors(name, code)
		VALUES(name, code);
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;

	SET exit_msg = case
		when locate('product_colors_name_unique', error_msg) > 0 then 'Kolor o takiej nazwie jest juz w bazie.'
		when locate('product_colors_code_unique', error_msg) > 0 then 'Ten kolor jest juz w bazie.'
		when error_msg is not null then error_msg
		else 'Dodano nowy kolor.'
	end;
end$$

create procedure edit_color(
	IN color_id int,
	IN name varchar(255),
	IN code varchar(255),
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	start transaction;
		if color_id = 1 then
			SET ready_to_commit = false;
			SET error_msg = 'Nie mozna edytowac tego koloru.';
		end if;

		UPDATE product_colors p
		SET p.name = name,
			p.code = code
		WHERE p.color_id = color_id; 
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;

	SET exit_msg = case
		when locate('product_colors_name_unique', error_msg) > 0 then 'Kolor o takiej nazwie jest juz w bazie.'
		when locate('product_colors_code_unique', error_msg) > 0 then 'Ten kolor jest juz w bazie.'
		when error_msg is not null then error_msg
		else 'Edytowano kolor.'
	end;
end$$

create procedure remove_color(
	IN color_id int,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	start transaction;
		if color_id = 1 then
			SET ready_to_commit = false;
			SET error_msg = 'Nie mozna usunac tego koloru.';
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

	SET exit_msg = case
		when error_msg is not null then error_msg
		else 'Usunieto kolor.'
	end;
end$$

create procedure add_product(
	IN name varchar(255),
	IN category enum('men', 'women', 'boys', 'girls'),
	IN type_id int,
	IN color_id int,
	IN price decimal(6, 2),
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	start transaction;
		INSERT INTO products(name, category, type_id, color_id, price)
		VALUES(name, category, type_id, color_id, price);
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;

	SET exit_msg = case
		when locate('products_unique', error_msg) > 0 then 'Taki produkt jest juz w bazie.'
		when locate('products_price_check', error_msg) > 0 then 'Nieprawidlowa cena.'
		when error_msg is not null then error_msg
		else 'Dodano nowy produkt.'
	end;
end$$

create procedure edit_product(
	IN product_id int,
	IN name varchar(255),
	IN category enum('men', 'women', 'boys', 'girls'),
	IN type_id int,
	IN color_id int,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

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

	SET exit_msg = case
		when locate('products_unique', error_msg) > 0 then 'Taki produkt jest juz w bazie.'
		when error_msg is not null then error_msg
		else 'Edytowano produkt.'
	end;
end$$

create procedure add_photo(
	IN product_id int,
	IN photo blob,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	start transaction;
		INSERT INTO photos(product_id, photo)
		VALUES(product_id, photo);
	if ready_to_commit then	
		commit;
	else
		rollback;
	end if;

	SET exit_msg = case
		when locate('photos_unique', error_msg) > 0 then 'To zdjecie juz zostalo dodane.'
		when error_msg is not null then error_msg
		else 'Dodano zdjecie.'
	end;
end$$

create procedure remove_photo(
	IN photo_id int,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	start transaction;
		DELETE FROM photos
		WHERE photos.photo_id = photo_id;
	if ready_to_commit then
		commit;
	else 
		rollback;
	end if;

	SET exit_msg = case
		when error_msg is not null then error_msg
		else 'Usunieto zdjecie.'
	end;
end$$

create procedure change_price(
	IN product_id int,
	IN new_price decimal(6, 2),
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end; 

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
		WHERE p.product_id = product_id AND o.status LIKE '%cart%';
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;

	SET exit_msg = case
		when locate('products_price_check', error_msg) > 0 then 'Nieprawidlowa cena.'
		when error_msg is not null then error_msg
		else 'Zmieniono cene.'
	end;
end$$

create procedure change_discount(
	IN product_id int,
	IN new_discount int,
	OUT exit_msg varchar(255)
) 
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

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
		WHERE p.product_id = product_id AND o.status LIKE '%cart%';
	if ready_to_commit then
		commit;
	else
		rollback;
	end if;

	SET exit_msg = case
		when locate('products_discount_check', error_msg) > 0 then 'Nieprawidlowa znizka.'
		when error_msg is not null then error_msg
		else 'Zmieniono znizke.'
	end;
end$$

-- warehouse_manager

create procedure add_warehouse(
	IN product_id int,
	IN size enum('XS', 'S', 'M', 'L', 'XL'),
	IN amount int,
	OUT exit_msg varchar(255)
)
begin
	declare wid int;

	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

	SELECT w.warehouse_id INTO wid
	FROM warehouse w
	WHERE w.product_id = product_id AND w.size LIKE size;

	if amount <= 0 then
		SET ready_to_commit = false;
		SET error_msg = 'Nieprawidlowa ilosc.';
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

	SET error_msg = case
		when error_msg is not null then error_msg
		else 'Dodano produkty do magazynu.'
	end;
end$$

create procedure edit_warehouse(
	IN warehouse_id int,
	IN amount int,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;
	
	start transaction;
		UPDATE warehouse w
		SET w.amount = w.amount + amount
		WHERE w.warehouse_id = warehouse_id;
	if ready_to_commit then	
		commit;
	else
		rollback;
	end if;

	SET error_msg = case
		when locate('warehouse_amount_check', error_msg) > 0 then 'Nieprawidlowa ilosc koncowa.'
		when error_msg is not null then error_msg
		else 'Dodano produkty do magazynu.'
	end;
end$$

create procedure complete_order(
	IN order_id int,
	OUT exit_msg varchar(255)
)
begin
	declare cid int;

	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;

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
			SET ready_to_commit = false;
			SET error_msg = 'Niektore pozycje nie sa obecnie dostepne.';
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

	SET exit_msg = case
		when error_msg is not null then error_msg
		else 'Zamowienie wykonane.'
	end;
end$$

create procedure consider_return(
	IN order_id int,
	IN accept boolean,
	OUT exit_msg varchar(255)
)
begin
	declare ready_to_commit boolean default true;
	declare error_msg varchar(255);
    declare continue handler for sqlexception
	begin
        SET ready_to_commit = false;
		if error_msg is null then
			get diagnostics condition 1 error_msg = message_text;
		end if;
	end;
	
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
	
	SET exit_msg = case
		when error_msg is not null then error_msg
		else 'Zwrot rozpatrzony.'
	end;
end$$

delimiter ;