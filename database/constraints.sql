alter table users
	add constraint login_unique
		unique(login);

alter table clients
	add constraint clients_email_unique
		unique(email),
	add constraint clients_phone_unique
		unique(phone),
	add constraint clients_NIP_unique
		unique(NIP),
	add constraint clients_email_check
		check(email regexp '^[a-z0-9._-]+@[a-z0-9._-]+\.[a-z]{2,}$'),
	add constraint clients_phone_check
		check(phone regexp '^[0-9]{7,15}$'),
	add constraint clients_NIP_check
		check(NIP regexp '^[0-9]{10}$'),
	add constraint clients_fk_user
		foreign key (user_id)
		references users(user_id)
		on update cascade,
	add constraint clients_fk_address
		foreign key (address_id)
		references addresses(address_id)
		on update cascade;

alter table addresses
	add constraint addresses_unique
		unique(street, house_number, apartment_number, city, postal_code),
	add constraint addresses_postal_code_check
		check(postal_code regexp '^[0-9]{2}-[0-9]{3}$');

alter table products
	add constraint products_unique
		unique(name, category, type_id, color_id),
	add constraint products_fk_type
		foreign key (type_id)
		references product_types(type_id)
		on update cascade,
	add constraint products_fk_color
		foreign key (color_id)
		references product_colors(color_id)
		on update cascade;

alter table product_types
	add constraint product_types_unique
		unique(type);

alter table product_colors
	add constraint product_colors_name_unique
		unique(name),
	add constraint product_colors_code_unique
		unique(code);

alter table photos
	add constraint photos_unique
		unique(product_id, path),
	add constraint photos_fk_product
		foreign key (product_id)
		references products(product_id)
		on update cascade;

alter table warehouse
	add constraint warehouse_unique
		unique(product_id, size),
	add constraint warehouse_fk_product
		foreign key (product_id)
		references products(product_id)
		on update cascade;

alter table orders
	add constraint orders_fk_client
		foreign key (client_id)
		references clients(client_id)
		on update cascade,
	add constraint orders_fk_invoice
		foreign key (invoice_id)
		references invoices(invoice_id)
		on update cascade;

alter table order_pos
	add constraint order_pos_unique
		unique(order_id, warehouse_id),
	add constraint order_pos_fk_order
		foreign key (order_id)
		references orders(order_id)
		on update cascade
		on delete cascade,
	add constraint order_pos_fk_warehouse
		foreign key (warehouse_id)
		references warehouse(warehouse_id)
		on update cascade;

alter table order_logs
	add constraint order_logs_fk_order
		foreign key (order_id)
		references orders(order_id)
		on update cascade
		on delete cascade;

alter table invoices
	add constraint invoices_fk_order
		foreign key (order_id)
		references orders(order_id)
		on update cascade;