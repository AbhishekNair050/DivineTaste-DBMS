insert into supplier (supplierID, supplierName, quantity)
values
    (1, 'Fresh Groceries', 500),
    (2, 'Spice Haven', 300),
    (3, 'Bakery Delights', 200),
    (4, 'Farmers Market', 150),
    (5, 'Dairy Delight', 200),
    (6, 'Organic Farms', 100),
    (7, 'Sweet Delicacies', 80),
    (8, 'Seafood Paradise', 120),
    (9, 'Health Nut', 90),
    (10, 'Sip-n-Snack', 150);
select * from supplier;

insert into Ingredients (IngredientName, Price, IngredientQuantity, SupplierID)
values 
    ('Milk', 1.50, 100, 1),
    ('Flour', 2.00, 200, 2),
    ('Sugar', 1.00, 150, 3),
    ('Salt', 0.75, 120, 4),
    ('Eggs', 2.50, 80, 5),
    ('Butter', 3.00, 90, 6),
    ('Chocolate', 2.75, 100, 7),
    ('Vanilla Extract', 4.50, 50, 8),
    ('Baking Powder', 1.25, 80, 9),
    ('Yeast', 2.25, 60, 10);
select * from Ingredients;
insert into product (productID, name, price, quantity, category, description)
values
    (11, 'Blueberry Muffin', 15, 35, 'Bakery', 'Moist blueberry muffin'),
    (12, 'Red Velvet Cake', 45, 25, 'Cakes', 'Velvety smooth red velvet cake'),
    (13, 'Chocolate Chip Cookie', 10, 50, 'Bakery', 'Classic chocolate chip cookie'),
    (14, 'Strawberry Cheesecake', 55, 20, 'Cakes', 'Creamy strawberry cheesecake'),
    (15, 'Croissant', 18, 40, 'Bakery', 'Flaky and buttery croissant'),
    (16, 'Fruit Tart', 25, 30, 'Bakery', 'Colorful fruit tart with custard filling'),
    (17, 'Cheese Danish', 20, 45, 'Bakery', 'Delicious pastry with cream cheese filling'),
    (18, 'Chocolate Eclair', 30, 25, 'Bakery', 'Classic French pastry with chocolate ganache'),
    (19, 'Tiramisu', 40, 20, 'Desserts', 'Italian coffee-flavored dessert'),
    (20, 'Cinnamon Roll', 12, 60, 'Bakery', 'Soft and gooey cinnamon roll');
select * from product;

insert into event (eventID, eventName, date, location, description)
values
    (21, 'Food Festival', '2024-03-10', 'City Park', 'Annual celebration of diverse cuisines'),
    (22, 'Spice Workshop', '2024-04-15', 'Spice Haven Store', 'Learn the art of blending spices'),
    (23, 'Baking Class', '2024-05-20', 'Bakery Delights', 'Hands-on experience in baking'),
    (24, 'Wine Tasting', '2024-06-12', 'Vineyard Estates', 'Explore a variety of fine wines'),
    (25, 'Health and Wellness Expo', '2024-07-25', 'Community Center', 'Promoting healthy lifestyle choices'),
    (26, 'Seafood Extravaganza', '2024-08-18', 'Seafood Paradise Restaurant', 'Feast on a variety of seafood'),
    (27, 'Dessert Fair', '2024-09-30', 'Sweet Delicacies Pavilion', 'Indulge in a sweet paradise'),
    (28, 'Nutrition Workshop', '2024-10-15', 'Health Nut Store', 'Learn about balanced nutrition'),
    (29, 'Tea Tasting', '2024-11-22', 'Sip-n-Snack Tea House', 'Discover a world of tea flavors'),
    (30, 'Holiday Baking Class', '2024-12-18', 'Bakery Delights', 'Create festive treats for the holidays');
select * from event;

insert into orders (orderID, orderDate, totalAmount)
values
    (31, '2024-03-12', 150),
    (32, '2024-04-18', 120),
    (33, '2024-05-25', 200),
    (34, '2024-06-30', 180),
    (35, '2024-07-10', 220),
    (36, '2024-08-22', 160),
    (37, '2024-09-05', 250),
    (38, '2024-10-18', 190),
    (39, '2024-11-25', 200),
    (40, '2024-12-20', 180);
select * from orders;

insert into payment (paymentID, mode, amount, timestamp, eventID, orderID)
values
    (41, 'Credit Card', 50, CURRENT_TIMESTAMP, 21, NULL),
    (42, 'Cash', 80, CURRENT_TIMESTAMP, 22, NULL),
    (43, 'Online Transfer', 70, CURRENT_TIMESTAMP, 23, NULL),
    (44, 'Debit Card', 60, CURRENT_TIMESTAMP, NULL, 31),
    (45, 'Cash', 90, CURRENT_TIMESTAMP, NULL, 32),
    (46, 'Credit Card', 75, CURRENT_TIMESTAMP, NULL, 33),
    (47, 'Online Transfer', 100, CURRENT_TIMESTAMP, NULL, 34),
    (48, 'Debit Card', 85, CURRENT_TIMESTAMP, 28, NULL),
    (49, 'Cash', 95, CURRENT_TIMESTAMP, 29, NULL),
    (50, 'Credit Card', 80, CURRENT_TIMESTAMP, 30, NULL);
select * from payment;

insert into customer (customerID, fname, lname, paymentID, orderID)
values
    (51, 'Abhishek', 'Nair', 41, 31),
    (52, 'Dhrumi', 'Shah', 42, 32),
    (53, 'Raghav', 'Gaggar', 43, 33),
    (54, 'Ananya', 'Gupta', 44, 34),
    (55, 'Vikram', 'Singh', 45, 35),
    (56, 'Priya', 'Sharma', 46, 36),
    (57, 'Rohan', 'Patel', 47, 37),
    (58, 'Sanya', 'Malhotra', 48, 38),
    (59, 'Amit', 'Verma', 49, 39),
    (60, 'Kavita', 'Kumar', 50, 40);
select * from customer;

insert into delivery (deliveryDate, DeliveryMode, DeliveryInstruction, orderID)
values
    ('2024-03-15', 'Takeaway', 'Handle with care', 31),
    ('2024-04-20', 'Pickup', 'Urgent Delivery', 32),
    ('2024-05-27', 'Home Delivery', 'No contact delivery', 33),
    ('2024-07-02', 'Takeaway', 'Express Delivery', 34),
    ('2024-08-12', 'Home Delivery', 'Fragile items', 35),
    ('2024-09-25', 'Pickup', 'Special Instructions: None', 36),
    ('2024-10-28', 'Takeaway', 'Handle with gloves', 37),
    ('2024-11-10', 'Home Delivery', 'Contactless delivery', 38),
    ('2024-12-15', 'Pickup', 'Check items before acceptance', 39),
    ('2024-12-30', 'Home Delivery', 'Festive season delivery', 40);
select * from delivery;

insert into staff (staffID, contactDetails, role, salary, fname, lname)
values
    (61, '9876543210', 'Manager', 70000, 'Radhika', 'Chapaneri'),
    (62, '8765432109', 'Chef', 60000, 'Abhishek', 'Nair'),
    (63, '7654321098', 'Server', 55000, 'Dhrumi', 'Shah'),
    (64, '6543210987', 'Baker', 65000, 'Raghav', 'Gaggar'),
    (65, '7890123456', 'Waiter', 50000, 'Ananya', 'Gupta'),
    (66, '8901234567', 'Barista', 52000, 'Vikram', 'Singh'),
    (67, '9012345678', 'Sommelier', 75000, 'Priya', 'Sharma'),
    (68, '1234567890', 'Cashier', 48000, 'Rohan', 'Patel'),
    (69, '2345678901', 'Kitchen Helper', 40000, 'Sanya', 'Malhotra'),
    (70, '3456789012', 'Event Coordinator', 60000, 'Amit', 'Verma');
select * from staff;

insert into staff_event (staffID, eventID)
values
    (61, 21),
    (62, 22),
    (63, 23),
    (64, 24),
    (65, 25),
    (66, 26),
    (67, 27),
    (68, 28),
    (69, 29),
    (70, 30);
select * from staff_event;

insert into product_supplier (productID, supplierID)
values
    (11, 1),
    (12, 2),
    (13, 3),
    (14, 4),
    (15, 5),
    (16, 6),
    (17, 7),
    (18, 8),
    (19, 9),
    (20, 10);
select * from product_supplier;

insert into customer_product (customerID, productID)
values
    (51, 11),
    (52, 12),
    (53, 13),
    (54, 14),
    (55, 15),
    (56, 16),
    (57, 17),
    (58, 18),
    (59, 19),
    (60, 20);
select * from customer_product;

insert into product_order (productID, orderID)
values
    (11, 31),
    (12, 32),
    (13, 33),
    (14, 34),
    (15, 35),
    (16, 36),
    (17, 37),
    (18, 38),
    (19, 39),
    (20, 40);
select * from product_order;

insert into customer_contactDetails (contactDetails, customerID)
values
    ('9876543210', 51),
    ('8765432109', 52),
    ('7654321098', 53),
    ('8901234567', 54),
    ('7890123456', 55),
    ('9012345678', 56),
    ('1234567890', 57),
    ('2345678901', 58),
    ('3456789012', 59),
    ('4567890123', 60);
select * from customer_contactDetails;

insert into orderDetails (quantity, subtotal, occasion, message, orderID, stats)
values
    (5, 100, 'Family Dinner', 'Please add extra sauce', 31, 'waiting'),
    (8, 150, 'Birthday Celebration', 'Add a birthday message on the cake', 32, 'waiting'),
    (6, 120, 'Special Occasion', 'Handle with care', 33, 'waiting'),
    (7, 130, 'Casual Lunch', 'No spicy ingredients', 34, 'waiting'),
    (10, 180, 'Anniversary Dinner', 'Surprise dessert required', 35, 'waiting'),
    (5, 90, 'Tea Time Snack', 'Include complimentary tea bags', 36, 'waiting'),
    (8, 160, 'Holiday Gathering', 'Festive decorations needed', 37, 'waiting'),
    (9, 190, 'Weekend Brunch', 'Vegetarian options required', 38, 'waiting'),
    (6, 110, 'Business Meeting', 'Prompt delivery needed', 39, 'waiting'),
    (7, 120, 'Dinner Date', 'Romantic setting preferred', 40, 'waiting');
select * from orderDetails;

insert into staff_order (staffID, orderID)
values
    (61, 31),
    (62, 32),
    (63, 33),
    (64, 34),
    (65, 35),
    (66, 36),
    (67, 37),
    (68, 38),
    (69, 39),
    (70, 40);
select * from staff_order;

insert into supplier_contactDetails (contactDetails, supplierID)
values
    ('1112233445', 1),
    ('2233445566', 2),
    ('3344556677', 3),
    ('4455667788', 4),
    ('5566778899', 5),
    ('6677889900', 6),
    ('7788990011', 7),
    ('8899001122', 8),
    ('9900112233', 9),
    ('1122334455', 10);
select * from supplier_contactDetails;