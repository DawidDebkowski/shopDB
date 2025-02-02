delimiter ;

UPDATE users SET acc_type = 'warehouse' WHERE login LIKE 'warehouse';
UPDATE users SET acc_type = 'salesman' WHERE login LIKE 'salesman';

call change_acc_info_individual(3, 'Jan', 'Kowalski', 'jankowalski@shopdb.pl', '123456798', @a);
call change_acc_info_company(4, 'Firma', '1234567890', 'firma@shopdb.pl', '987654321', @a);

call change_address(3, 'Główna', 15, null, 'Wrocław', '50-000', @a);

-- anulowane zamówienie
call add_order_pos(3, 1, 1, @a);
call add_order_pos(3, 6, 1, @a);
call place_order(3, false, @a);
call cancel_order(3, @a);

-- zwrócone zamówienie
call add_order_pos(3, 1, 1, @a);
call add_order_pos(3, 6, 1, @a);
call place_order(3, false, @a);
call pay_order(5, @a);
call complete_order(5, @a);
call report_return(5, @a);
call consider_return(5, true, @a);

-- zrealizowane zamówienie
call add_order_pos(3, 11, 2, @a);
call add_order_pos(3, 16, 1, @a);
call place_order(3, false, @a);
call pay_order(6, @a);
call complete_order(6, @a);

-- opłacone zamówienie
call add_order_pos(3, 11, 2, @a);
call add_order_pos(3, 16, 1, @a);
call place_order(3, false, @a);
call pay_order(7, @a);

-- zgłoszony zwrot zamówienia
call add_order_pos(3, 11, 2, @a);
call add_order_pos(3, 16, 1, @a);
call place_order(3, false, @a);
call pay_order(8, @a);
call complete_order(8, @a);
call report_return(8, @a);

-- zaloguj się jako salesman i dodaj zdjęcia do odpowiednich produktów