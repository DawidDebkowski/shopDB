----- views -----

create view ind_client_view as (
	SELECT c.client_id, c.name, c.surname, c.email, c.phone, a.street, a.house_number, a.apartment_number, a.city, a.postal_code
	FROM clients c JOIN addresses a ON c.address_id = a.address_id
	WHERE c.type LIKE '%individual%'
);

create view com_client_view as (
	SELECT c.client_id, c.company_name, c.email, c.phone, c.NIP, a.street, a.house_number, a.apartment_number, a.city, a.postal_code
	FROM clients c JOIN addresses a ON c.address_id = a.address_id
	WHERE c.type LIKE '%company%'
);

create view orders_view as (
	SELECT o.order_id, o.client_id, o.status, o.value
	FROM orders o
	WHERE o.status not like '%cart%'
);

create view order_detailed_view as (
	SELECT p.product_id, op.order_id, p.name, w.size, p.price, p.discount, op.amount, 
		CAST((p.price * (100 - COALESCE(p.discount, 0)) / 100) AS decimal(4, 2)) AS price_for_one, 
		CAST((p.price * (100 - COALESCE(p.discount, 0)) / 100 * op.amount) AS decimal(10, 2)) AS price_for_all  
	FROM order_pos op JOIN warehouse w ON op.warehouse_id = w.warehouse_id
		JOIN products p ON w.product_id = p.product_id
);

create view invoice_view as (
	SELECT i.order_id, i.NIP, i.company_name, a.street, a.house_number, a.apartment_number, a.city, a.postal_code, o.value
	FROM invoices i JOIN addresses a ON i.address_id = a.address_id
		JOIN orders o ON i.order_id = o.order_id
);

create view product_view as (
	SELECT p.product_id, p.name, p.category, t.type, c.name AS color, p.price, COALESCE(p.discount, 0) AS discount
	FROM products p JOIN product_types t ON p.type_id = t.type_id
		JOIN product_colors c ON p.color_id = c.color_id
);

create view product_detailed_view as (
	SELECT p.product_id, p.name, p.category, t.type, c.name AS color, p.price, 
		COALESCE(p.discount, 0) AS discount, w.size, (w.amount - w.reserved) AS available
	FROM products p JOIN product_types t ON p.type_id = t.type_id
		JOIN product_colors c ON p.color_id = c.color_id
		JOIN warehouse w ON p.product_id = w.product_id
);