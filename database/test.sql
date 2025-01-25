-- reset bazy danych
source database.sql;
source proc.sql;

-- typy produktow
call add_type('koszulka');
call add_type('spodnie');
call add_type('koszula');
call add_type('BLUZA');
call add_type('bluzka');
call edit_type(5, 'bluza');
call remove_type(6);
-- bledne 
call add_type('koszulka');
call edit_type(5, 'koszulka');
-- wynik: (inne, koszulka, spodnie, koszula, bluza)

-- kolory produktow
call add_color('CZERWONY', 'FF0000');
call add_color('zielony', '00FF01');
call add_color('NIEBIESKI', '0001FF');
call add_color('fajny', '123456');
call edit_color(2, 'czerwony', 'FF0000');
call edit_color(3, 'zielony', '00FF00');
call edit_color(4, 'niebieski', '0000FF');
call remove_color(5);
-- bledne
call add_color('czerwony', 'a');
call add_color('a', 'FF0000');
call edit_color(2, 'zielony', 'FF0000');
call edit_color(2, 'czerwony', '0000FF');
-- wynik: (inny, czerwony, zielony, niebieski)

-- produkty
call add_product('KOSZULKA 1', 'men', 2, 2, 39.99);
call add_product('koszulka 2', 'men', 2, 3, 49.99);
call add_product('koszulka 3', 'boys', 2, 2, 29.99);
call add_product('spodnie 1', 'men', 3, 4, 79.99);
call add_product('spodnie 2', 'women', 3, 1, 79.99);
call edit_product(1, 'koszulka 1', 'men', 2, 2);
call edit_product(2, 'koszula 2', 'women', 4, 3);
call change_price(1, 29.99);
call change_price(2, 59.99);
call change_discount(1, 10);
call change_discount(2, 20);
call change_discount(2, 0);
-- bledne
call add_product('koszulka 1', 'men', 2, 2, 99.99);
call edit_product(2, 'koszulka 1', 'men', 2, 2);
call change_price(1, 0);
call change_price(1, -10);
call change_discount(2, -10);
-- wynik: (koszulka 1, koszula 2, koszulka 3, spodnie 1, spodnie 2)

-- zdjecia
call add_photo(1, 'path/koszulka1a');
call add_photo(1, 'path/koszulka1b');
call add_photo(2, 'path/koszula2');
call add_photo(3, 'path/koszula3a');
call add_photo(3, 'path/koszula3b');
call remove_photo(5);
-- bledne
call add_photo(1, 'path/koszulka1a');
-- wynik: (path/koszulka1a, path/koszulka1b, path/koszula2, path/koszula3a)

-- magazyn
call add_warehouse(1, 'XS', 2);
call add_warehouse(1, 'S', 3);
call add_warehouse(1, 'M', 4);
call add_warehouse(1, 'L', 5);
call add_warehouse(1, 'XL', 6);
call add_warehouse(1, 'XS', 5);
call edit_warehouse(1, 1);
call edit_warehouse(2, -1);
call edit_warehouse(3, -4);
-- bledne
call add_warehouse(1, 'XS', 0);
call add_warehouse(1, 'XS', -1);
call edit_warehouse(1, -9);
-- wynik: (1 - 8, 2 - 2, 3 - 0, 4 - 5, 5 - 6)

-- klienci
call add_client('ind1', 'a', 'individual', 'ind1@a.pl', '111111111', null, true);
call add_client('ind2', 'a', 'individual', 'ind2@a.pl', '222222222', null, true);
call add_client('ind3', 'a', 'individual', 'ind3@a.pl', '333333333', null, true);
call add_client('ind4', 'a', 'individual', 'ind4@a.pl', '444444444', null, false);
call add_client('ind5', 'a', 'individual', 'ind5@a.pl', '555555555', null, false);
call add_client('com1', 'a', 'company', 'com1@a.pl', '666666666', '1111111111', true);
call add_client('com2', 'a', 'company', 'com2@a.pl', '777777777', '2222222222', false);
call change_acc_info_individual(1, 'name1', 'surname1', 'ind1@a.pl', '111111111');
call change_acc_info_individual(2, 'name2', 'surname2', 'ind2@b.pl', '222222222');
call change_acc_info_individual(3, 'name3', 'surname3', 'ind3@a.pl', '3333333330');
call change_acc_info_individual(4, 'name4', 'surname4', 'ind4@b.pl', '4444444440');
call change_acc_info_company(6, 'companyname1', '1111111111', 'com1@a.pl', '666666666');
call change_acc_info_company(7, 'companyname2', '2222222220', 'com2@b.pl', '7777777770');
-- bledne
call add_client('ind1', 'a', 'individual', 'ind1@a.pl', '111111111', null, true);
call add_client('ind6', 'a', 'individual', 'ind1@a.pl', '111111111', null, true);
call add_client('ind6', 'a', 'individual', 'ind6@a.pl', '111111111', null, true);
call add_client('com3', 'a', 'company', 'com3@a.pl', '888888888', '1111111111', true);
call change_acc_info_individual(6, 'name1', 'surname1', 'com1@a.pl', '666666666');
call change_acc_info_company(1, 'name1', null, 'ind1@a.pl', '111111111');
-- wynik (7 klientow)

-- adresy
call change_address(1, 'ulica1', 1, null, 'miasto1', '11-111');
call change_address(2, 'ulica1', 1, null, 'miasto1', '11-111');
call change_address(3, 'ulica2', 2, 1, 'miasto2', '22-222');
call change_address(4, 'ulica3', 3, 2, 'miasto3', '33-333');
call change_address(6, 'ulica4', 4, null, 'miasto4', '44-444');
call change_address(6, 'ulica1', 1, null, 'miasto1', '11-111');
-- wynik (4 adresy, klienci 1, 2, 3, 4, 6 maja adresy, w tym 1, 2, 6 taki sam)

-- zamowienia
call add_order_pos(1, 2, 1);
call add_order_pos(2, 2, 2);
call change_price(1, 39.99);
call change_discount(1, 0);
call place_order(1, false);
call add_order_pos(1, 4, 1);
-- bledne
call place_order(2, false);
-- wynik: 1 zlozone zamowienie, 1 zamowienie z produktami

call edit_order_pos(2, 2, 1);
call place_order(2, false);
call add_order_pos(1, 5, 1);
-- bledne
call edit_order_pos(1, 4, 7);
call place_order(3, false);
-- wynik: 2 zlozone zamowienia, 1 zamowienie z produktami

call pay_order(1);
-- bledne
call pay_order(9);
-- wynik: 1 zlozone, 1 oplacone, 1 koszyk

call place_order(1, false);
call cancel_order(9);
call cancel_order(1);
call add_order_pos(1, 4, 1);
-- bledne
call cancel_order(13);
call place_order(1, true);

call place_order(1, false);
call pay_order(13);
call complete_order(13);
-- bledne
call complete_order(1);
call complete_order(2);
call complete_order(3);

call add_order_pos(6, 5, 3);
call place_order(6, true);
call pay_order(6);
call complete_order(6);

call report_return(6);
call report_return(13);

call consider_return(6, true);
call consider_return(13, false);