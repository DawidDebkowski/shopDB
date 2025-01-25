----- views -----

create view ind_client_view as (
	SELECT c.name, c.surname, c.email, c.phone, a.street, a.house_number, a.apartment_number, a.city, a.postal_code
	FROM clients c JOIN addresses a ON c.address_id = a.address_id;
)

create view com_client_view as (
	SELECT c.company_name, c.email, c.phone, c.NIP, a.street, a.house_number, a.apartment_number, a.city, a.postal_code
	FROM clients c JOIN addresses a ON c.address_id = a.address_id;
)

create view product_view as (
	SELECT p.name, p.category, t.type, c.name AS color, p.price, COALESCE(p.discount, 0) AS discount
	FROM products p JOIN product_types t ON p.type_id = t.type_id
		JOIN product_colors c ON p.color_id = c.color_id
);

create view order_view as (
	SELECT o.order_id, o.status, o.value
	FROM orders o
);