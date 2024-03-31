create database Divine_Taste;

use Divine_Taste;

create table Supplier (
    SupplierID int primary key,
    SupplierName varchar(25) not null
);

create table Ingredients (
    IngredientID int primary key,
    IngredientName varchar(50) not null,
    SupplierID int,
    Quantity int,
    foreign key (SupplierID) references Supplier(SupplierID)
);

create table Product (
    ProductID int primary key,
    Name varchar(25) not null,
    Price int not null,
    Quantity int not null,
    Category varchar(25) not null
);

create table ProductDescription (
    ProductDescriptionID int primary key,
    Description varchar(255) not null,
    ProductID int,
    foreign key (ProductID) references Product(ProductID)
);

create table Event (
    EventID int primary key,
    EventName varchar(50) not null,
    date date not null,
    Location varchar(50) not null
);

create table EventDescription (
    EventDescriptionID int primary key,
    Description varchar(255) not null,
    EventID int,
    foreign key (EventID) references Event(EventID)
);

create table Orders (
    OrderID int primary key,
    Orderdate date not null
);

create table OrderTotalAmount (
    OrderTotalAmountID int primary key,
    TotalAmount int not null,
    OrderID int,
    foreign key (OrderID) references Orders(OrderID)
);

create table Payment (
    PaymentID int primary key,
    Mode varchar(25) not null,
    Amount int not null,
    Timestamp TIMESTAMP not null,
    EventID int,
    OrderID int,
    foreign key (EventID) references Event(EventID),
    foreign key (OrderID) references Orders(OrderID)
);

create table Customer (
    CustomerID int primary key not null,
    PaymentID int not null,
    OrderID int not null,
    foreign key (PaymentID) references Payment(PaymentID),
    foreign key (OrderID) references Orders(OrderID)
);

create table CustomerName (
    CustomerNameID int primary key,
    Fname varchar(25) not null,
    Lname varchar(25) not null,
    CustomerID int,
    foreign key (CustomerID) references Customer(CustomerID)
);

create table Delivery (
    DeliveryDate date not null,
    DeliveryMode varchar(20) not null,
    DeliveryInstruction varchar(50),
    OrderID int primary key,
    foreign key (OrderID) references Orders(OrderID)
);

create table Staff (
    StaffID int primary key,
    ContactDetails varchar(25) not null,
    Role varchar(25) not null,
    Salary int not null
);

create table StaffName (
    StaffNameID int primary key,
    Fname varchar(25) not null,
    Lname varchar(25) not null,
    StaffID int,
    foreign key (StaffID) references Staff(StaffID)
);

create table Staff_event (
    StaffID int,
    EventID int,
    primary key (StaffID, EventID),
    foreign key (StaffID) references Staff(StaffID),
    foreign key (EventID) references Event(EventID)
);

create table Product_Supplier (
    ProductID int,
    SupplierID int,
    primary key (ProductID, SupplierID),
    foreign key (ProductID) references Product(ProductID),
    foreign key (SupplierID) references Supplier(SupplierID)
);

create table Customer_product (
    CustomerID int,
    ProductID int,
    primary key (CustomerID, ProductID),
    foreign key (CustomerID) references Customer(CustomerID),
    foreign key (ProductID) references Product(ProductID)
);

create table Product_order (
    ProductID int,
    OrderID int,
    primary key (ProductID, OrderID),
    foreign key (ProductID) references Product(ProductID),
    foreign key (OrderID) references Orders(OrderID)
);

create table Customer_ContactDetails (
    ContactDetails varchar(25),
    CustomerID int,
    primary key (ContactDetails, CustomerID),
    foreign key (CustomerID) references Customer(CustomerID)
);

create table OrderDetails (
    Quantity int not null,
    Occasion varchar(50) not null,
    OrderID int primary key,
    foreign key (OrderID) references Orders(OrderID)
);

create table OrderSubtotal (
    OrderSubtotalID int primary key,
    Subtotal int not null,
    OrderID int,
    foreign key (OrderID) references Orders(OrderID)
);

create table OrderMessage (
    OrderMessageID int primary key,
    Message varchar(100),
    OrderID int,
    foreign key (OrderID) references Orders(OrderID)
);

create table Staff_order (
    StaffID int,
    OrderID int,
    primary key (StaffID, OrderID),
    foreign key (StaffID) references Staff(StaffID),
    foreign key (OrderID) references Orders(OrderID)
);

create table Supplier_ContactDetails (
    ContactDetails varchar(25),
    SupplierID int,
    primary key (ContactDetails, SupplierID),
    foreign key (SupplierID) references Supplier(SupplierID)
);