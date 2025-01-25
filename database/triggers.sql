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