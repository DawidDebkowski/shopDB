call add_type("koszulka", @a);
call add_type("spodnie", @a);
call add_type("buty", @a);
call add_type("bluza", @a);
call add_type("koszula", @a);
call add_type("spodenki", @a);

call add_color("czerwony", "FF0000", @a);
call add_color("niebieski", "0000FF", @a);
call add_color("zielony", "00FF00", @a);

call add_product("koszulka czerwona meska", 'men', 2, 2, 24.99, @a);
call add_product("koszulka zielona meska 1", 'men', 2, 4, 29.99, @a);
call add_product("koszulka zielona meska 2", 'men', 2, 4, 24.99, @a);
call add_product("koszulka niebieska meska", 'men', 2, 3, 29.99, @a);
call add_product("spodnie czerwone meski", 'men', 3, 2, 59.99, @a);
call add_product("spodnie czerwone damskie", 'women', 3, 2, 59.99, @a);

call add_warehouse(1, 'XS', 2, @a);
call add_warehouse(1, 'S', 3, @a);
call add_warehouse(1, 'M', 4, @a);
call add_warehouse(1, 'XL', 5, @a);
call add_warehouse(2, 'L', 15, @a);
call add_warehouse(2, 'M', 10, @a);
call add_warehouse(2, 'S', 20, @a);