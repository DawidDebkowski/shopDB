----- prepared statements -----

delimiter $$

create procedure show_client_info(
	IN client_id int
)
begin
	declare ctype varchar(255);

	SELECT c.type INTO ctype
	FROM clients c
	WHERE c.client_id = client_id;


	if ctype like 'individual' then
		prepare statement from CONCAT(
			'SELECT name, surname, email, phone, street, house_number, apartment_number, city, postal_code ',
			'FROM ind_client_view WHERE client_id = ?'
		);
	else
		prepare statement from CONCAT(
			'SELECT company_name, email, phone, NIP, street, house_number, apartment_number, city, postal_code ',
			'FROM com_client_view WHERE client_id = ?'
		);
	end if;

	execute statement using client_id;
	deallocate prepare statement;
end$$

create procedure show_client_orders(
	IN client_id int
)
begin
	prepare statement from CONCAT(
		'SELECT order_id, status, value ',
		'FROM orders_view WHERE client_id = ?'
	);

	execute statement using client_id;
	deallocate prepare statement;
end$$

create procedure show_order_details(
	IN order_id int
)
begin
	if (SELECT o.status FROM orders o WHERE o.order_id = order_id) not like '%cart%' then
		prepare statement from CONCAT(
			'SELECT name, size, price, discount, amount, price_for_one, price_for_all ',
			'FROM order_detailed_view WHERE order_id = ?'
		);

		execute statement using order_id;
		deallocate prepare statement;	
	end if;
end$$

create procedure show_order_logs(
	IN order_id int
)
begin
	prepare statement from CONCAT(
		'SELECT new_status, log_date AS date ',
		'FROM order_logs WHERE order_id = ?'
	);

	execute statement using order_id;
	deallocate prepare statement;
end$$

create procedure show_invoice(
	IN order_id int
)
begin
	prepare statement from 'SELECT * FROM invoice_view WHERE order_id = ?';

	execute statement using order_id;
	deallocate prepare statement;
end$$

create procedure show_products(
	IN category enum('men', 'women', 'boys', 'girls'),
	IN type varchar(255),
	IN color varchar(255),
	IN min_price decimal(4, 2),
	IN max_price decimal(4, 2),
	IN order_by int
)
begin
	declare query text;
	declare order_text varchar(255);

	SET order_text = CASE
		WHEN order_by = 1 THEN 'product_id DESC'
		WHEN order_by = 2 THEN 'price ASC'
		WHEN order_by = 3 THEN 'price DESC'
		WHEN order_by = 4 THEN 'name ASC'
		ELSE 'product_id ASC'
	END;

	SET query = CONCAT(
		'SELECT name, category, type, color, price, discount ',
		'FROM product_view ',
		'WHERE category like ? ',
		'AND type like ? ',
		'AND color like ? ',
		'AND price >= ? ',
		'AND price <= ? ',
		'ORDER BY ',
		order_text
	);

	prepare statement from query;

	execute statement using 
		COALESCE(category, '%'),
		COALESCE(type, '%'),
		COALESCE(color, '%'),
		COALESCE(min_price, 0),
		COALESCE(max_price, 10000);
	deallocate prepare statement;
end$$

create procedure show_product_details(
	IN product_id int
)
begin
	prepare statement from CONCAT(
		'SELECT size, available ',
		'FROM product_detailed_view ',
		'WHERE product_id = ?'
	);

	execute statement using product_id;
	deallocate prepare statement;
end$$

create procedure show_paid_orders()
begin
	SELECT order_id
	FROM orders
	WHERE status LIKE '%paid%';
end$$

create procedure show_reported_returns()
begin
	SELECT order_id
	FROM orders
	WHERE status LIKE '%return reported%';
end$$

delimiter ;