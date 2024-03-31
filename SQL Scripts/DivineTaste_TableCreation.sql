create database Divine_Taste;
use Divine_Taste;

create table Supplier (
    SupplierID int auto_increment primary key,
    SupplierName varchar(25) not null,
    Quantity INT
);
desc Supplier;

CREATE TABLE Ingredients (
    IngredientID INT AUTO_INCREMENT PRIMARY KEY,
    IngredientName VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    IngredientQuantity INT,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
    on delete cascade
    on update cascade
);
desc Ingredients;
create table Product (
    ProductID int auto_increment primary key,
    Name varchar(25) not null,
    Price int not null,
    Quantity int not null,
    Category varchar(25) not null,
    Description varchar(255) not null
);
desc Product;

create table Event (
    EventID int auto_increment primary key,
    EventName varchar(50) not null,
    date date not null,
    Location varchar(50) not null,
    Description varchar(255)
);
desc Event;

create table Orders (
    OrderID int auto_increment primary key,
    Orderdate date not null,
    TotalAmount int not null
);
desc Orders;

create table Payment (
    PaymentID int auto_increment primary key,
    Mode varchar(25) not null,
    Amount int not null,
    Timestamp TIMESTAMP not null,
    EventID int,
    OrderID int,
    foreign key (EventID) references Event(EventID)
    on delete cascade
    on update cascade,
    foreign key (OrderID) references Orders(OrderID)
    on delete cascade
    on update cascade
);
desc Payment;

create table Customer (
    CustomerID int auto_increment primary key not null,
    Fname varchar(25) not null,
    Lname varchar(25) not null,
    PaymentID int not null,
    OrderID int not null,
    foreign key (PaymentID) references Payment(PaymentID)
    on delete cascade
    on update cascade,
    foreign key (OrderID) references Orders(OrderID)
    on delete cascade
    on update cascade
);	
desc Customer;

 create table Delivery(
   DeliveryDate date not null,
   DeliveryMode varchar(20) not null,
   DeliveryInstruction varchar(50),
   OrderID int primary key,
   foreign key (OrderID) references Orders(OrderID)
   on delete cascade
   on update cascade
);
desc Delivery;

create table Staff (
    StaffID int auto_increment primary key,
    ContactDetails varchar(25) not null,
    Role varchar(25) not null,
    Salary int not null,
    Fname varchar(25) not null,
    Lname varchar(25) not null
);
desc Staff;

create table Staff_event (
    StaffID int,
    EventID int,
    primary key (StaffID, EventID),
    foreign key (StaffID) references Staff(StaffID)
    on delete cascade
    on update cascade,
    foreign key (EventID) references Event(EventID)
    on delete cascade
    on update cascade
);
desc Staff_event;

create table Product_Supplier (
    ProductID int,
    SupplierID int,
    primary key (ProductID, SupplierID),
    foreign key (ProductID) references Product(ProductID)
    on delete cascade
    on update cascade,
    foreign key (SupplierID) references Supplier(SupplierID)
    on delete cascade
    on update cascade
);
desc Product_Supplier;

create table Customer_product (
    CustomerID int,
    ProductID int,
    primary key (CustomerID, ProductID),
    foreign key (CustomerID) references Customer(CustomerID)
    on delete cascade
    on update cascade,
    foreign key (ProductID) references Product(ProductID)
    on delete cascade
    on update cascade
);
desc Customer_product;

create table Product_order (
    ProductID int,
    OrderID int,
    primary key (ProductID, OrderID),
    foreign key (ProductID) references Product(ProductID)
    on delete cascade
    on update cascade,
    foreign key (OrderID) references Orders(OrderID)
    on delete cascade
    on update cascade
);
desc Product_order;

create table Customer_ContactDetails (
    ContactDetails varchar(25),
    CustomerID int,
    primary key (ContactDetails, CustomerID),
    foreign key (CustomerID) references Customer(CustomerID)
    on delete cascade
    on update cascade
);
desc Customer_ContactDetails;

create table OrderDetails (
    Quantity int not null,
    Subtotal int not null,
    Occasion varchar(50) not null,
    Message varchar(100),
    OrderID int primary key,
    stats varchar(30) not null,
    foreign key (OrderID) references Orders(OrderID)
    on delete cascade
    on update cascade
);
desc OrderDetails;

create table Staff_order (
    StaffID int,
    OrderID int,
    primary key (StaffID, OrderID),
    foreign key (StaffID) references Staff(StaffID)
    on delete cascade
    on update cascade,
    foreign key (OrderID) references Orders(OrderID)
    on delete cascade
    on update cascade
);
desc Staff_order;

create table Supplier_ContactDetails (
    ContactDetails varchar(25),
    SupplierID int,
    primary key (ContactDetails, SupplierID),
    foreign key (SupplierID) references Supplier(SupplierID)
    on delete cascade
    on update cascade
);
desc Supplier_ContactDetails;