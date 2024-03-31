use divine_taste;


-- Stored Procedure to Update Product Quantity:
DELIMITER $$
CREATE PROCEDURE UpdateProductQuantity(
    IN product_id INT,
    IN new_quantity INT
)
BEGIN
    DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE Product
    SET Quantity = new_quantity
    WHERE ProductID = product_id;

    COMMIT;
END$$
DELIMITER ;
CALL UpdateProductQuantity(11, 75);
SELECT Quantity FROM Product WHERE ProductID = 11;

-- Stored Procedure to Add a New Event:
DELIMITER $$
CREATE PROCEDURE AddNewEvent(
    IN event_name VARCHAR(50),
    IN event_date DATE,
    IN event_location VARCHAR(50),
    IN event_description VARCHAR(255)
)
BEGIN
    DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Event (EventName, date, Location, Description)
    VALUES (event_name, event_date, event_location, event_description);

    COMMIT;
END$$
DELIMITER ;

CALL AddNewEvent('Corporate Event', '2023-07-20', 'Downtown Hotel', 'Annual company event');
SELECT * FROM Event WHERE EventName = 'Corporate Event';

-- Stored Procedure to Get Customer Orders:	
DELIMITER $$
CREATE PROCEDURE GetCustomerOrders(
    IN customer_id INT
)
BEGIN
    SELECT o.OrderID, o.Orderdate, o.TotalAmount, od.Occasion, od.stats
    FROM Orders o
    JOIN Customer c ON o.OrderID = c.OrderID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE c.CustomerID = customer_id;
END$$
DELIMITER ;

CALL GetCustomerOrders(51);

-- Triggers

-- Trigger to Update Product Quantity After Order:
DELIMITER $$
CREATE TRIGGER UpdateProductQuantityAfterOrder
AFTER INSERT ON Product_order
FOR EACH ROW
BEGIN
    UPDATE Product
    SET Quantity = Quantity - (SELECT Quantity
                               FROM OrderDetails
                               WHERE OrderID = NEW.OrderID)
    WHERE ProductID = NEW.ProductID;
END$$
DELIMITER ;

-- Trigger to Prevent Deleting Active Orders:
DELIMITER $$
CREATE TRIGGER PreventDeletingActiveOrders
BEFORE DELETE ON Orders
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1
               FROM OrderDetails
               WHERE OrderID = OLD.OrderID AND stats <> 'Waiting')
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete an active order.';
    END IF;
END$$
DELIMITER ;
DELETE FROM Orders WHERE OrderID = 35;

-- Trigger to Update Total Amount After Order Details Change:
DELIMITER $$
CREATE TRIGGER UpdateTotalAmountAfterOrderDetailsChange
AFTER UPDATE ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET TotalAmount = NEW.Subtotal
    WHERE OrderID = NEW.OrderID;
END$$
DELIMITER ;

-- Trigger to Prevent Updating Paid Orders:
DELIMITER $$
CREATE TRIGGER PreventUpdatingPaidOrders
BEFORE UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1
               FROM Payment
               WHERE OrderID = OLD.OrderID)
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update a paid order.';
    END IF;
END$$
DELIMITER ;