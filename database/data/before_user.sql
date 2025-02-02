delimiter ;

INSERT INTO product_types (type) VALUES
	("koszulka"),
	("koszula"),
	("spodnie"),
	("spodenki"),
	("spódnica"),
	("sukienka");

INSERT INTO product_colors (name, code) VALUES
	("biały", "#FFFFFF"),
	("żółty", "#FFFF00"),
	("czerwony", "#FF0000"),
	("różowy", "#FF00FF"),
	("niebieski", "#0000FF"),
	("zielony", "#00FF00"),
	("czarny", "#000000");

INSERT INTO products (name, category, type_id, color_id, price, discount) VALUES
	('Koszulka bawełniana', 'men', 2, 1, 49.99, NULL),
	('Koszula formalna', 'men', 3, 2, 129.99, 20),
	('Spodnie jeansowe', 'men', 4, 3, 159.99, NULL),
	('Spodenki sportowe', 'men', 5, 4, 79.99, 10),
	('Koszulka polo', 'men', 2, 5, 89.99, NULL),
	('Spodnie garniturowe', 'men', 4, 6, 199.99, NULL),
	('Koszula flanelowa', 'men', 3, 7, 139.99, 10),
	('Bluzka elegancka', 'women', 2, 1, 69.99, NULL),
	('Sukienka letnia', 'women', 7, 2, 149.99, 20),
	('Spódnica ołówkowa', 'women', 6, 3, 119.99, NULL),
	('Spodnie wysokie', 'women', 4, 4, 179.99, NULL),
	('Bluzka jedwabna', 'women', 2, 5, 99.99, 10),
	('Sukienka wieczorowa', 'women', 7, 6, 249.99, NULL),
	('Spódnica plisowana', 'women', 6, 7, 89.99, NULL),
	('Koszulka z nadrukiem', 'boys', 2, 1, 39.99, NULL),
	('Spodenki dresowe', 'boys', 5, 2, 59.99, 10),
	('Spodnie cargo', 'boys', 4, 3, 99.99, NULL),
	('Sukienka kwiecista', 'girls', 7, 4, 79.99, NULL),
	('Bluzka z kokardą', 'girls', 2, 5, 49.99, NULL),
	('Spódnica falbana', 'girls', 6, 6, 69.99, 20);

INSERT INTO warehouse (product_id, size, amount) VALUES
	(1, 'XS', 1),
	(1, 'S', 2),
	(1, 'M', 3),
	(1, 'L', 4),
	(1, 'XL', 5),
	(2, 'XS', 10),
	(2, 'S', 10),
	(2, 'M', 10),
	(2, 'L', 10),
	(3, 'XS', 10),
	(3, 'S', 10),
	(3, 'M', 10),
	(3, 'L', 10),
	(3, 'XL', 10),
	(4, 'XS', 10),
	(4, 'S', 10),
	(4, 'M', 10),
	(4, 'L', 10),
	(4, 'XL', 10),
	(5, 'XS', 10),
	(5, 'S', 10),
	(5, 'M', 10),
	(5, 'L', 10),
	(5, 'XL', 10);

-- następnie wejść do aplikacji i:
	-- zarejstrowac konto: login: warehouse, hasło: wh123
	-- zarejstrowac konto: login: salesman, hasło: sm123
	-- zarejstrowac konto (indywidualne): login: client1, hasło: client1
	-- zarejstrowac konto (firma): login: client2, hasło: client2