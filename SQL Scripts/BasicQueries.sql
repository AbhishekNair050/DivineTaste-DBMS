-- Retrieve all customers and their order details: 
SELECT customer.fname, customer.lname, orders.orderID, orders.orderDate, orders.totalAmount
FROM customer, orders
WHERE customer.orderID = orders.orderID;

-- List all products along with their suppliers: 
SELECT product.name AS product_name, supplier.supplierName
FROM product, product_supplier, supplier
WHERE product.productID = product_supplier.productID
AND product_supplier.supplierID = supplier.supplierID;

-- Find the total quantity and amount spent on each order:
SELECT orders.orderID, SUM(orderDetails.quantity) AS total_quantity, SUM(orderDetails.subtotal) AS total_amount
FROM orders, orderDetails
WHERE orders.orderID = orderDetails.orderID
GROUP BY orders.orderID;

-- Retrieve the details of events attended by each staff member:
SELECT staff.fname, staff.lname, event.eventName, event.date
FROM staff_event, staff, event
WHERE staff_event.staffID = staff.staffID
AND staff_event.eventID = event.eventID;

-- List all customers who made payments online:
SELECT customer.fname, customer.lname, payment.mode
FROM customer, payment
WHERE customer.paymentID = payment.paymentID
AND payment.mode = 'Online Transfer';

-- Find the products supplied by a specific supplier:
SELECT product.name AS product_name
FROM product_supplier, product
WHERE product_supplier.productID = product.productID
AND product_supplier.supplierID = 1;

-- Retrieve the total salary cost for each role in the staff:
SELECT staff.role, SUM(staff.salary) AS total_salary_cost
FROM staff
GROUP BY staff.role;

-- Find the most recent deliveries and their details:
SELECT delivery.deliveryDate, delivery.DeliveryMode, delivery.DeliveryInstruction, orders.orderID
FROM delivery, orders
WHERE delivery.orderID = orders.orderID
AND delivery.deliveryDate = (SELECT MAX(deliveryDate) FROM delivery);

-- Get the staff members who participated in the event with the name 'Wine Tasting':
SELECT * FROM staff_event
WHERE eventID = (
    SELECT eventID FROM event
    WHERE eventName = 'Wine Tasting'
);

-- Get the events that took place between '2024-05-01' and '2024-08-01':
SELECT * FROM event
WHERE date BETWEEN '2023-05-01' AND '2024-08-01';

-- Retrieve products with names starting with the letter 'C':
SELECT * FROM product
WHERE name LIKE 'C%';

-- Retrieve all products in the "Bakery" or "Cakes" category:
SELECT * FROM product
WHERE category IN ('Bakery', 'Cakes');

-- Advanced Queries

-- 1 Find the total revenue generated from orders for each event:
select EventName, sum(Amount) as "Total Amount"
from event natural inner join payment
group by EventName;
 
-- 2 Get the top 3 best-selling products based on the total quantity ordered:
select Name
from product
order by quantity desc limit 3;
 
-- 3 Find the customers who have placed orders for a specific product category:
select c.Fname, c.Lname
from Customer c
join Orders o on c.OrderID = o.OrderID
join Product_order po on o.OrderID = po.OrderID
join Product p on po.ProductID = p.ProductID
where p.Category = 'Desserts'
group by c.CustomerID;
 
-- 4 Get the total amount of orders placed on a specific date for each occasion:
select sum(TotalAmount) as TotalOrderAmount, Occasion
from orders natural inner join orderdetails
where Orderdate = '2024-03-12'
group by Occasion;

-- 5 Find the suppliers who supply ingredients for a specific product:
select SupplierName
from supplier natural inner join product_supplier as ps
join product as p on ps.ProductID = p.ProductID
where Name = "Tiramisu";

-- 6 Get the total revenue generated from each supplier:
select s.SupplierName, sum(i.Price * i.Quantity) as TotalRevenue
from Supplier s
join Ingredients i on s.SupplierID = i.SupplierID
group by s.SupplierID;

-- 7 Find the customers who have placed orders for a specific occasion:
select Fname, Lname
from customer natural inner join orders natural inner join orderdetails
where occasion = "Birthday Celebration";

-- 8 Get the total revenue generated from each delivery mode:
select d.DeliveryMode, sum(o.TotalAmount) as TotalRevenue
from Delivery d
join Orders o on d.OrderID = o.OrderID
group by d.DeliveryMode;

-- 9 Find the number of suppliers who supply ingredients for products in each category:
select Category, count(SupplierName) as "Total Suppliers"
from supplier natural inner join product_supplier as ps
join product as p on ps.ProductID = p.ProductID
group by Category;

-- 10 Find the staff members who have handled orders for a specific supplier:
select distinct  s.Fname, s.Lname
from Staff s
join Staff_order so on s.StaffID = so.StaffID
join Orders o on so.OrderID = o.OrderID
join Product_order po on o.OrderID = po.OrderID
join Product p on po.ProductID = p.ProductID
join Product_Supplier ps on p.ProductID = ps.ProductID
join Supplier sup ON ps.SupplierID = sup.SupplierID
where sup.SupplierName = 'Spice Haven';
