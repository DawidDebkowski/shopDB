DROP USER IF EXISTS 'warehouse_manager'@'localhost';
DROP USER IF EXISTS 'client'@'localhost';
DROP USER IF EXISTS 'salesman'@'localhost';
DROP USER IF EXISTS 'app'@'localhost';

CREATE USER 'warehouse_manager'@'localhost' IDENTIFIED BY 'manager123';

GRANT INSERT ON shop.warehouse TO 'warehouse_manager'@'localhost';
GRANT UPDATE ON shop.warehouse TO 'warehouse_manager'@'localhost';
GRANT UPDATE ON shop.orders TO 'warehouse_manager'@'localhost';
GRANT DELETE ON shop.warehouse TO 'warehouse_manager'@'localhost';
GRANT SELECT ON shop.warehouse TO 'warehouse_manager'@'localhost';
GRANT SELECT ON shop.orders TO 'warehouse_manager'@'localhost';

FLUSH PRIVILEGES;

CREATE USER 'client'@'localhost' IDENTIFIED BY 'client123';

GRANT INSERT ON shop.order_pos TO 'client'@'localhost';
GRANT INSERT ON shop.clients TO 'client'@'localhost';
GRANT INSERT ON shop.addresses TO 'client'@'localhost';
GRANT INSERT ON shop.invoices TO 'client'@'localhost';

GRANT UPDATE ON shop.order_pos TO 'client'@'localhost';
GRANT UPDATE ON shop.orders TO 'client'@'localhost';
GRANT UPDATE ON shop.addresses TO 'client'@'localhost';
GRANT UPDATE ON shop.clients TO 'client'@'localhost';
GRANT UPDATE ON shop.invoices TO 'client'@'localhost';

GRANT DELETE ON shop.order_pos TO 'client'@'localhost';

GRANT SELECT ON shop.clients TO 'client'@'localhost';
GRANT SELECT ON shop.addresses TO 'client'@'localhost';
GRANT SELECT ON shop.orders TO 'client'@'localhost';
GRANT SELECT ON shop.order_logs TO 'client'@'localhost';
GRANT SELECT ON shop.invoices TO 'client'@'localhost';
GRANT SELECT ON shop.products TO 'client'@'localhost';

FLUSH PRIVILEGES;

CREATE USER 'salesman'@'localhost' IDENTIFIED BY 'seller123';

GRANT INSERT ON shop.products TO 'salesman'@'localhost';
GRANT INSERT ON shop.product_types TO 'salesman'@'localhost';
GRANT INSERT ON shop.product_colors TO 'salesman'@'localhost';

GRANT UPDATE ON shop.products TO 'salesman'@'localhost';

GRANT SELECT ON shop.products TO 'salesman'@'localhost';
GRANT SELECT ON shop.product_types TO 'salesman'@'localhost';
GRANT SELECT ON shop.product_colors TO 'salesman'@'localhost';
GRANT SELECT ON shop.warehouse TO 'salesman'@'localhost';

FLUSH PRIVILEGES;

CREATE USER 'app'@'localhost' IDENTIFIED BY 'App123';


GRANT EXECUTE ON shop.* TO 'app'@'localhost';
 
GRANT SELECT ON shop.* TO 'app'@'localhost';

FLUSH PRIVILEGES;
