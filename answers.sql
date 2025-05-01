
-- TASK 1: Achieving 1NF

-- Creating a Database: assignDB to use
CREATE DATABASE assignDB;
USE assignDB;

-- Create the original table and insert data
CREATE TABLE ProductDetail (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Products TEXT
);

INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Creating the new normalized table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(100),
    FOREIGN KEY (OrderID) REFERENCES ProductDetail(OrderID)
);

-- Insert split values from ProductDetail.Products into Products
INSERT INTO Products (OrderID, Product)
SELECT 
    pd.OrderID,
    TRIM(jt.Product) AS Product
FROM 
    ProductDetail pd,
    JSON_TABLE(
        CONCAT('["', REPLACE(pd.Products, ', ', '","'), '"]'),
        '$[*]' COLUMNS (Product VARCHAR(100) PATH '$')
    ) AS jt;


-- TASK 2: Achieving 2NF

-- Creating the original table and insert data:
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Create Orders table removing partial dependency
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Creating OrderProducts table
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

