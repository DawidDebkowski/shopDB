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