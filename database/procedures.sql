drop procedure add_warehouse;
drop procedure add_client;
drop procedure change_acc_info_individual;
drop procedure change_acc_info_company;
drop procedure change_address;
drop procedure add_products;

delimiter $$

-- warehouse_manager
-- adding products to warehouse
-- from app
create procedure add_warehouse(
	IN product_id int,
	IN size enum('XS', 'S', 'M', 'L', 'XL'),
	IN amount int
)
begin
	declare warehouse_id int;
	declare amount int;

	SELECT w.warehouse_id INTO warehouse_id
	FROM warehouse w
	WHERE w.product_id = product_id AND w.size LIKE size;

start transaction;
	if warehouse_id IS NULL then
		insert into warehouse(product_id, size, amount, reserved) 
		values (product_id, size, amount, 0);
	else
		SELECT w.amount INTO amount
		FROM warehouse w
		WHERE w.warehouse_id = warehouse_id;

		update warehouse w
		set w.amount = w.amount + amount
		where w.warehouse_id = warehouse_id;
	end if;
commit;
end$$

-- client
-- creating account
-- from app
create procedure add_client(
	IN login varchar(255),
	IN password varchar(255),
	IN type enum('individual', 'company'),
	IN cookies boolean
)
begin
	declare id int;
start transaction;
	insert into users(login, password, type)
	values(login, password, 'client');

	select u.user_id into id
	from users u
	where u.login like login;

	insert into clients(user_id, type, RODO, terms_of_use, cookies)
	values(id, type, true, true, cookies);
commit;
end$$

-- changing account info (if individual)
-- from app
create procedure change_acc_info_individual(
	IN id int,
	IN name varchar(255),
	IN surname varchar(255),
	IN email varchar(255),
	IN phone varchar(15)
)
begin
start transaction;
	if(
		select type
		from clients
		where client_id = id 
	) not like '%individual%' then
		rollback;
	end if;

	update clients c
	set c.name = name,
		c.surname = surname,
		c.email = email,
		c.phone = phone
	where c.client_id = id;
commit;
end$$

-- changing account info (if company)
-- from app
create procedure change_acc_info_company(
	IN id int,
	IN company_name varchar(255),
	IN NIP varchar(255),
	IN email varchar(255),
	IN phone varchar(15)
)
begin
start transaction;
	if(
		select type
		from clients
		where client_id = id 
	) not like '%company%' then
		rollback;
	end if;

	update clients c
	set c.company_name = company_name,
		c.NIP = NIP,
		c.email = email,
		c.phone = phone
	where c.client_id = id;
commit;
end$$

-- changing/adding address
-- from app
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

	select a.address_id into id
	from addresses acc_type
	where a.street like street AND
		a.house_number = house_number AND
		a.apartment_number = apartment_number AND
		a.city like city AND
		a.postal_code like postal_code;

start transaction;
	if id is null then
		insert into addresses (street, house_number, apartment_number, city, postal_code)
		values (street, house_number, apartment_number, city, postal_code);

		select a.address_id into id
		from addresses acc_type
		where a.street like street AND
			a.house_number = house_number AND
			a.apartment_number = apartment_number AND
			a.city like city AND
			a.postal_code like postal_code;
	end if;

	update clients
	set address_id = id
	where client_id = client_id;
commit;
end$$

-- salesman
-- adding products 
-- from app
create procedure add_products(
	IN name varchar(255),
	IN category enum('men', 'women', 'boys', 'girls'),
	IN type_id int,
	IN color_id int,
	IN price float
)
begin
end$$

delimiter ;