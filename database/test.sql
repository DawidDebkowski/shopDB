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