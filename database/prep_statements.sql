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

delimiter ;