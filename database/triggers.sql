-----triggers-----
delimiter $$

-- order: automatic value calculation from order_pos (DONE)
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

-- order_pos: if amount is 0 - delete row (DONE)
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

-- warehouse: if amount is 0 - delete row (DONE)
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

-- order_log: adding order status change logs (DONE)
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