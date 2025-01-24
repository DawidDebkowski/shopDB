source database.sql;
source proc.sql;

-- dodawanie klientow i zmiana ich danych
call add_client('aaa', 'aaa', 'individual', 'aaa@aaa.pl', '000000000', null, true);
call add_client('aaa', 'aaa', 'individual', 'aaa@aaa.pl', '000000000', null, true);
call add_client('bbb', 'bbb', 'individual', 'aaa@aaa.pl', '000000000', null, true);
call add_client('bbb', 'bbb', 'individual', 'bbb@bbb.pl', '000000000', null, true);
call add_client('bbb', 'bbb', 'individual', 'bbb@bbb.pl', '111111111', null, true);
call add_client('firma', 'firma', 'company', 'firma@firma.pl', '222222222', '0123456789', true);

call change_acc_info_individual(1, 'blazej', null, 'aaa@aaa.pl', '000000001');
call change_acc_info_individual(6, 'blazej', null, 'firma@firma.pl', '000000001');
call change_acc_info_company(6, 'firma nazwa', '1234567890', 'nowyfirma@firma.pl', '222222222');

call change_address(1, 'ulica', 1, null, 'miasto', '12-345');
call change_address(1, 'ulica', 1, null, 'miasto', '54-321');
call change_address(6, 'ulica', 1, 1, 'miasto', '12-345');
call change_address(6, 'ulica', 1, 2, 'miasto', '12-345');

-- dodawanie/edytowanie/usuwanie typow produktow
call add_type('koszulka');
call add_type('koszulka');
call add_type('spodnie');
call edit_type(4, 'koszulka');
call edit_type(4, 'jeansy');
call remove_type(1);
call remove_type(3);
call remove_type(4);

-- dodawanie/edytowanie/usuwanie kolorow produktow
call add_color('czerwony', 'FF0000');
call add_color('czerwony', 'FF0001');
call add_color('niebieski', 'FF0000');
call add_color('niebieski', '0000FF');
call edit_color(2, 'CZERWONY', 'FF0000');
call edit_color(2, 'CZERWONY', 'FF0001');
call remove_color(1);
call remove_color(2);
call remove_color(3);

-- dodawanie/edytowanie produktow
call add_product('koszulka 1', 'men', 2, 5, 49.99);
call add_product('koszulka 1', 'men', 2, 5, 39.99);
call add_product('koszulka 2', 'men', 2, 5, 39.99);
call add_product('koszulka 3', 'men', 2, 1, 39.99);
call edit_product(1, 'KOSZULKA 1', 'men', 2, 5);
call edit_product(3, 'koszulka 2', 'women', 2, 5);
call edit_product(3, 'spodnie', 'boys', 1, 5);
call change_price(1, 59.99);
call change_price(2, 59.99);
call change_discount(1, 10);
call change_discount(1, 0);
call change_discount(3, 10);
call change_discount(3, 20);

-- dodawanie/usuwanie zdjec
call add_photo(1, 'zdj1');
call add_photo(1, 'zdj1');
call add_photo(1, 'zdj2');
call add_photo(1, 'zdj3');
call add_photo(3, 'zdj3');
call add_photo(3, 'zdj4');
call remove_photo(2);
call remove_photo(3);