delimiter $$

-- warehouse_manager
-- adding products to warehouse
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

delimiter ;