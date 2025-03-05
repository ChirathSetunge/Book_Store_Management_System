-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 03, 2023 at 09:05 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Book_Haven`
--

-- --------------------------------------------------------

--
-- Table structure for table `BankTransferPayment`
--

CREATE TABLE `BankTransferPayment` (
  `bankPaymentId` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `paymentDate` date NOT NULL,
  `bankName` varchar(50) NOT NULL,
  `accNo` varchar(20) NOT NULL,
  `accHolderName` varchar(100) NOT NULL,
  `customerId` int(11) DEFAULT NULL,
  `orderId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `BankTransferPayment`
--

INSERT INTO `BankTransferPayment` (`bankPaymentId`, `amount`, `paymentDate`, `bankName`, `accNo`, `accHolderName`, `customerId`, `orderId`) VALUES
(1, 25350.00, '2023-06-26', 'Sampath Bank', '1234567890', 'Naomi Krishnarajha', 1, 4),
(2, 25080.00, '2023-08-02', 'Seylan Bank', '0987654321', 'Dileeka Alwis', 5, 7),
(3, 55000.00, '2023-10-12', 'HNB Bank', '1234554321', 'Damitha Karunaratna', 4, 9);

-- --------------------------------------------------------

--
-- Table structure for table `BookItem`
--

CREATE TABLE `BookItem` (
  `itemCode` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stockLevel` int(11) NOT NULL,
  `reorderLevel` int(11) NOT NULL,
  `ISBN` varchar(13) NOT NULL,
  `title` varchar(200) NOT NULL,
  `genre` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `author` varchar(100) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `yearOfPublication` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `BookItem`
--

INSERT INTO `BookItem` (`itemCode`, `price`, `stockLevel`, `reorderLevel`, `ISBN`, `title`, `genre`, `category`, `author`, `publisher`, `yearOfPublication`) VALUES
(1, 4000.00, 100, 20, '9780132061221', 'Fundamentals of Database Systems', 'Technology', 'Textbook', 'Ramez Elmasri and Shamkant Navathe', 'Pearson', 2006),
(2, 12000.00, 80, 15, '9781292097619', 'Database Systems: A Practical Approach to Design, Implementation, and Management', 'Technology', 'Textbook', 'Carolyn E. Begg and Thomas M. Connolly', 'Pearson', 2016),
(3, 9000.00, 120, 25, '9781449373320', 'Designing Data-Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems', 'Technology', 'Non-fiction', 'Martin Kleppmann', 'O\'Reilly Media', 2017),
(4, 7500.00, 90, 15, '9781530308874', 'SQL & NoSQL Databases: Models, Languages, Consistency Options and Architectures for Big Data Management', 'Technology', 'Non-fiction', 'Andreas Meier and Michael Kaufmann', 'CreateSpace Independent Publishing Platform', 2016),
(5, 15000.00, 110, 20, '9781133526855', 'Database Systems: Design, Implementation, and Management', 'Educational', 'Textbook', 'Peter Rob', 'Cengage Learning', 2012),
(6, 25000.00, 95, 15, '9783030436744', 'Modern Database Management', 'Technology', 'Non-fiction', 'Jeffrey A. Hoffer, Ramesh Venkataraman, Heikki Topi', 'Springer', 2020);

-- --------------------------------------------------------

--
-- Table structure for table `BookItemSupplier`
--

CREATE TABLE `BookItemSupplier` (
  `itemCode` int(11) NOT NULL,
  `supplierId` int(11) NOT NULL,
  `suppliedDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `BookItemSupplier`
--

INSERT INTO `BookItemSupplier` (`itemCode`, `supplierId`, `suppliedDate`) VALUES
(1, 5, '2023-04-28'),
(2, 5, '2023-04-28'),
(3, 6, '2023-04-30'),
(4, 6, '2023-04-30'),
(5, 6, '2023-04-30');

-- --------------------------------------------------------

--
-- Table structure for table `BookOrderItem`
--

CREATE TABLE `BookOrderItem` (
  `orderId` int(11) NOT NULL,
  `itemCode` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `BookOrderItem`
--

INSERT INTO `BookOrderItem` (`orderId`, `itemCode`, `quantity`, `price`) VALUES
(1, 2, 1, 12000.00),
(1, 3, 1, 9000.00),
(3, 4, 1, 7500.00),
(4, 1, 2, 8000.00),
(4, 3, 1, 9000.00),
(5, 1, 1, 4000.00),
(7, 6, 1, 25000.00),
(8, 1, 1, 4000.00),
(9, 5, 1, 15000.00),
(9, 6, 1, 25000.00),
(10, 4, 1, 7500.00);

--
-- Triggers `BookOrderItem`
--
DELIMITER $$
CREATE TRIGGER `calculate_book_order_item_price` BEFORE INSERT ON `BookOrderItem` FOR EACH ROW BEGIN
    SET NEW.price = NEW.quantity * (SELECT price FROM BookItem WHERE itemCode = NEW.itemCode); -- subquery in the main query --
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_online_order_total_price_book` AFTER INSERT ON `BookOrderItem` FOR EACH ROW BEGIN
    UPDATE OnlineOrder -- updating the OnlineOrder table -- 
    SET totalPrice = totalPrice + (
        SELECT SUM(boi.quantity * bi.price)
        FROM BookOrderItem AS boi
        JOIN BookItem AS bi ON boi.itemCode = bi.itemCode
        WHERE boi.orderId = NEW.orderId
    )
    WHERE orderId = NEW.orderId; -- subquery in the main query --
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Customer`
--

CREATE TABLE `Customer` (
  `customerId` int(11) NOT NULL,
  `fName` varchar(50) NOT NULL,
  `lName` varchar(50) NOT NULL,
  `eMail` varchar(100) NOT NULL,
  `stNo` varchar(10) NOT NULL,
  `street` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `postal_code` varchar(10) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Customer`
--

INSERT INTO `Customer` (`customerId`, `fName`, `lName`, `eMail`, `stNo`, `street`, `city`, `postal_code`, `password`) VALUES
(1, 'Naomi', 'Krishnarajha', 'naomi.k@iit.ac.lk', '123', 'Queens Rd', 'Bambalapitiya', '00400', 'password123'),
(2, 'Nihal', 'Kodikara', 'nihal.k@iit.ac.lk', '456', 'Carmel Rd', 'Colpetty', '00300', 'securepass'),
(3, 'Prasad', 'Wimalaratne', 'prasad.w@iit.ac.lk', '789', 'Kynsey Rd', 'Borella', '00800', 'pass'),
(4, 'Damitha', 'Karunaratne', 'damitha.k@iit.ac.lk', '321', 'Dharmapala Pl', 'Rajagiriya', '10100', 'passdamitha'),
(5, 'Dileeka', 'Alwis', 'dileeka.a@iit.ac.lk', '007', 'Ward Pl', 'Cinnamon Gardens', '00700', 'database');

-- --------------------------------------------------------

--
-- Table structure for table `CustomerContact`
--

CREATE TABLE `CustomerContact` (
  `customerId` int(11) NOT NULL,
  `tel` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `CustomerContact`
--

INSERT INTO `CustomerContact` (`customerId`, `tel`) VALUES
(1, '+94711234567'),
(1, '+94722345678'),
(1, '+94733456789'),
(2, '+94744567890'),
(3, '+94764532342'),
(4, '+94713454390'),
(5, '+94755678901');

-- --------------------------------------------------------

--
-- Table structure for table `Delivery`
--

CREATE TABLE `Delivery` (
  `deliveryId` int(11) NOT NULL,
  `deliveryDate` date NOT NULL,
  `stNo` varchar(10) NOT NULL,
  `street` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `postal_code` varchar(10) NOT NULL,
  `deliveryStatus` varchar(20) DEFAULT 'pending' CHECK (`deliveryStatus` in ('pending','in transit','delivered')),
  `customerId` int(11) DEFAULT NULL,
  `orderId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Delivery`
--

INSERT INTO `Delivery` (`deliveryId`, `deliveryDate`, `stNo`, `street`, `city`, `postal_code`, `deliveryStatus`, `customerId`, `orderId`) VALUES
(1, '2023-06-15', '123', 'Queens Rd', 'Bambalapitiya', '00400', 'delivered', 1, 1),
(2, '2023-06-15', '456', 'Carmel Rd', 'Colpetty', '00300', 'delivered', 2, 2),
(3, '2023-06-30', '789', 'Kynsey Rd', 'Borella', '00800', 'delivered', 3, 3),
(4, '2023-06-30', '101', 'Trelawney Place', 'Bambalapitya', '00400', 'delivered', 1, 4),
(5, '2023-06-30', '123', 'Queens Rd', 'Bambalapitiya', '00400', 'delivered', 1, 5),
(6, '2023-07-05', '456', 'Carmel Rd', 'Colpetty', '00300', 'delivered', 2, 6),
(7, '2023-08-16', '007', 'Ward Pl', 'Cinnamon Gardens', '00700', 'delivered', 5, 7),
(8, '2023-08-19', '456', 'Carmel Rd', 'Colpetty', '00300', 'delivered', 2, 8),
(9, '2023-10-18', '321', 'Dharmapala Pl', 'Rajagiriya', '10100', 'delivered', 4, 9);

-- --------------------------------------------------------

--
-- Table structure for table `OnlineOrder`
--

CREATE TABLE `OnlineOrder` (
  `orderId` int(11) NOT NULL,
  `orderDate` date NOT NULL,
  `orderStatus` varchar(20) DEFAULT 'pending' CHECK (`orderStatus` in ('pending','processing','out for delivery','delivered','store pickup')),
  `totalPrice` decimal(10,2) DEFAULT 0.00,
  `customerId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `OnlineOrder`
--

INSERT INTO `OnlineOrder` (`orderId`, `orderDate`, `orderStatus`, `totalPrice`, `customerId`) VALUES
(1, '2023-06-07', 'delivered', 35720.00, 1),
(2, '2023-06-09', 'delivered', 5930.00, 2),
(3, '2023-06-25', 'delivered', 7500.00, 3),
(4, '2023-06-26', 'delivered', 25350.00, 1),
(5, '2023-06-27', 'delivered', 4200.00, 1),
(6, '2023-06-29', 'delivered', 450.00, 2),
(7, '2023-08-02', 'delivered', 25080.00, 5),
(8, '2023-08-15', 'delivered', 7950.00, 2),
(9, '2023-10-12', 'delivered', 55000.00, 4),
(10, '2023-10-21', 'store pickup', 7500.00, 5);

-- --------------------------------------------------------

--
-- Table structure for table `OnlinePayment`
--

CREATE TABLE `OnlinePayment` (
  `onlinePaymentId` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `paymentDate` date NOT NULL,
  `transactionId` varchar(50) NOT NULL,
  `cardType` varchar(20) NOT NULL,
  `cardNumber` varchar(25) NOT NULL,
  `expiryDate` date NOT NULL,
  `cvv` varchar(4) NOT NULL,
  `customerId` int(11) DEFAULT NULL,
  `orderId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `OnlinePayment`
--

INSERT INTO `OnlinePayment` (`onlinePaymentId`, `amount`, `paymentDate`, `transactionId`, `cardType`, `cardNumber`, `expiryDate`, `cvv`, `customerId`, `orderId`) VALUES
(1, 35720.00, '2023-06-07', 'ABC123', 'Visa', '1234-5678-9012-3456', '2024-12-31', '123', 1, 1),
(2, 5930.00, '2023-06-09', 'XYZ789', 'MasterCard', '9876-5432-1098-7654', '2025-06-30', '456', 2, 2),
(3, 7500.00, '2023-06-25', 'DEF456', 'Amex', '1111-2222-3333-4444', '2023-11-30', '789', 3, 3),
(4, 4200.00, '2023-06-27', 'GHI789', 'Discover', '5555-6666-7777-8888', '2024-03-31', '987', 1, 5),
(5, 450.00, '2023-06-29', 'JKL012', 'Visa', '9999-8888-7777-6666', '2024-09-30', '654', 2, 6),
(6, 7950.00, '2023-08-15', 'MNO345', 'MasterCard', '1234-5678-9876-5432', '2025-02-28', '321', 2, 8),
(7, 7500.00, '2023-10-21', 'PQR678', 'Amex', '8765-4321-9876-5432', '2024-07-31', '234', 5, 10);

-- --------------------------------------------------------

--
-- Table structure for table `StationeryItem`
--

CREATE TABLE `StationeryItem` (
  `itemCode` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stockLevel` int(11) NOT NULL,
  `reorderLevel` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `brand` varchar(100) NOT NULL,
  `color` varchar(50) NOT NULL,
  `size` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `StationeryItem`
--

INSERT INTO `StationeryItem` (`itemCode`, `price`, `stockLevel`, `reorderLevel`, `type`, `brand`, `color`, `size`) VALUES
(1000, 600.00, 350, 30, 'Writing Book', 'ProMate', 'White', 'A4'),
(1001, 80.00, 200, 40, 'Pen', 'ATLAS', 'Blue', NULL),
(1002, 100.00, 200, 30, 'Pencil', 'NATRAJ', 'Yellow', NULL),
(1003, 150.00, 250, 50, 'Eraser', 'Faber-Castell', 'Pink', NULL),
(1004, 170.00, 120, 20, 'Ruler', 'ATLAS', 'Transparent', '30 cm'),
(1005, 250.00, 100, 20, 'Scissor', 'mango', 'Silver', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `StationeryItemSupplier`
--

CREATE TABLE `StationeryItemSupplier` (
  `itemCode` int(11) NOT NULL,
  `supplierId` int(11) NOT NULL,
  `suppliedDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `StationeryItemSupplier`
--

INSERT INTO `StationeryItemSupplier` (`itemCode`, `supplierId`, `suppliedDate`) VALUES
(1000, 2, '2023-04-15'),
(1001, 1, '2023-04-04'),
(1002, 3, '2023-04-04'),
(1003, 4, '2023-04-05'),
(1004, 1, '2023-04-07'),
(1005, 2, '2023-04-15');

-- --------------------------------------------------------

--
-- Table structure for table `StationeryOrderItem`
--

CREATE TABLE `StationeryOrderItem` (
  `orderId` int(11) NOT NULL,
  `itemCode` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `StationeryOrderItem`
--

INSERT INTO `StationeryOrderItem` (`orderId`, `itemCode`, `quantity`, `price`) VALUES
(1, 1000, 2, 1200.00),
(1, 1001, 4, 320.00),
(2, 1000, 2, 1200.00),
(2, 1001, 2, 160.00),
(2, 1002, 2, 200.00),
(2, 1005, 1, 250.00),
(4, 1002, 1, 100.00),
(4, 1003, 1, 150.00),
(5, 1002, 2, 200.00),
(6, 1002, 1, 100.00),
(6, 1005, 1, 250.00),
(7, 1001, 1, 80.00),
(8, 1000, 2, 1200.00),
(8, 1002, 1, 100.00),
(8, 1003, 1, 150.00);

--
-- Triggers `StationeryOrderItem`
--
DELIMITER $$
CREATE TRIGGER `calculate_stationery_order_item_price` BEFORE INSERT ON `StationeryOrderItem` FOR EACH ROW BEGIN
    SET NEW.price = NEW.quantity * (SELECT price FROM StationeryItem WHERE itemCode = NEW.itemCode); -- subquery in the main query --
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_online_order_total_price_stationery` AFTER INSERT ON `StationeryOrderItem` FOR EACH ROW BEGIN
    UPDATE OnlineOrder -- updating the OnlineOrder table -- 
    SET totalPrice = totalPrice + (
        SELECT SUM(soi.quantity * si.price)
        FROM StationeryOrderItem AS soi
        JOIN StationeryItem AS si ON soi.itemCode = si.itemCode 
        WHERE soi.orderId = NEW.orderId
    )
    WHERE orderId = NEW.orderId; -- subquery in the main query --
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Supplier`
--

CREATE TABLE `Supplier` (
  `supplierId` int(11) NOT NULL,
  `supplierType` varchar(50) NOT NULL CHECK (`supplierType` in ('Individual','Company')),
  `name` varchar(100) NOT NULL,
  `eMail` varchar(100) NOT NULL,
  `stNo` varchar(10) NOT NULL,
  `street` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `postal_code` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Supplier`
--

INSERT INTO `Supplier` (`supplierId`, `supplierType`, `name`, `eMail`, `stNo`, `street`, `city`, `postal_code`) VALUES
(1, 'Company', 'ATLAS AXILLIA Co.(Pvt)Ltd', 'supplies@atlasaxillia.com', '96', 'Parakrama Rd', 'Peliyagoda', '11830'),
(2, 'Company', 'ProMate', 'info@promateworld.com', '164', 'Seelavimala Mawatha', 'Athurugiriya', '10150'),
(3, 'Company', 'M.D.Gunasena', 'webstore@mdguasena.com', '217', 'Olcott Mawatha', 'Pettah', '01100'),
(4, 'Company', 'Sakura', 'orders@sakuralk.com', '2', 'Trelawney Place', 'Bambalapitiya', '00400'),
(5, 'individual', 'Naveen Fernando', 'naveenfdo@gmail.com', '34', 'Ave Maria Rd', 'Ja Ela', '02340'),
(6, 'Company', 'Expographic Books (Pvt)', 'orders@expographic.com', '59', 'Main St', 'Pettah', '01100');

-- --------------------------------------------------------

--
-- Table structure for table `SupplierContact`
--

CREATE TABLE `SupplierContact` (
  `supplierId` int(11) NOT NULL,
  `tel` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `SupplierContact`
--

INSERT INTO `SupplierContact` (`supplierId`, `tel`) VALUES
(1, '+94711244567'),
(1, '+94722344678'),
(1, '+94733456799'),
(2, '+94744547890'),
(3, '+94764532342'),
(4, '+94713954390'),
(5, '+94755688901'),
(6, '+94743344579');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `BankTransferPayment`
--
ALTER TABLE `BankTransferPayment`
  ADD PRIMARY KEY (`bankPaymentId`),
  ADD KEY `bp_cid_fk` (`customerId`),
  ADD KEY `bp_oid_fk` (`orderId`);

--
-- Indexes for table `BookItem`
--
ALTER TABLE `BookItem`
  ADD PRIMARY KEY (`itemCode`),
  ADD UNIQUE KEY `ISBN` (`ISBN`);

--
-- Indexes for table `BookItemSupplier`
--
ALTER TABLE `BookItemSupplier`
  ADD PRIMARY KEY (`itemCode`,`supplierId`,`suppliedDate`),
  ADD KEY `bis_sid_fk` (`supplierId`);

--
-- Indexes for table `BookOrderItem`
--
ALTER TABLE `BookOrderItem`
  ADD PRIMARY KEY (`orderId`,`itemCode`),
  ADD KEY `boi_ic_fk` (`itemCode`);

--
-- Indexes for table `Customer`
--
ALTER TABLE `Customer`
  ADD PRIMARY KEY (`customerId`),
  ADD UNIQUE KEY `eMail` (`eMail`);

--
-- Indexes for table `CustomerContact`
--
ALTER TABLE `CustomerContact`
  ADD PRIMARY KEY (`customerId`,`tel`);

--
-- Indexes for table `Delivery`
--
ALTER TABLE `Delivery`
  ADD PRIMARY KEY (`deliveryId`),
  ADD KEY `d_cid_fk` (`customerId`),
  ADD KEY `d_oid_fk` (`orderId`);

--
-- Indexes for table `OnlineOrder`
--
ALTER TABLE `OnlineOrder`
  ADD PRIMARY KEY (`orderId`),
  ADD KEY `oo_cid_fk` (`customerId`);

--
-- Indexes for table `OnlinePayment`
--
ALTER TABLE `OnlinePayment`
  ADD PRIMARY KEY (`onlinePaymentId`),
  ADD UNIQUE KEY `transactionId` (`transactionId`),
  ADD KEY `op_cid_fk` (`customerId`),
  ADD KEY `op_oid_fk` (`orderId`);

--
-- Indexes for table `StationeryItem`
--
ALTER TABLE `StationeryItem`
  ADD PRIMARY KEY (`itemCode`);

--
-- Indexes for table `StationeryItemSupplier`
--
ALTER TABLE `StationeryItemSupplier`
  ADD PRIMARY KEY (`itemCode`,`supplierId`,`suppliedDate`),
  ADD KEY `sis_sid_fk` (`supplierId`);

--
-- Indexes for table `StationeryOrderItem`
--
ALTER TABLE `StationeryOrderItem`
  ADD PRIMARY KEY (`orderId`,`itemCode`),
  ADD KEY `soi_ic_fk` (`itemCode`);

--
-- Indexes for table `Supplier`
--
ALTER TABLE `Supplier`
  ADD PRIMARY KEY (`supplierId`),
  ADD UNIQUE KEY `eMail` (`eMail`);

--
-- Indexes for table `SupplierContact`
--
ALTER TABLE `SupplierContact`
  ADD PRIMARY KEY (`supplierId`,`tel`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `BankTransferPayment`
--
ALTER TABLE `BankTransferPayment`
  MODIFY `bankPaymentId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `BookItem`
--
ALTER TABLE `BookItem`
  MODIFY `itemCode` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `Customer`
--
ALTER TABLE `Customer`
  MODIFY `customerId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Delivery`
--
ALTER TABLE `Delivery`
  MODIFY `deliveryId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `OnlinePayment`
--
ALTER TABLE `OnlinePayment`
  MODIFY `onlinePaymentId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `StationeryItem`
--
ALTER TABLE `StationeryItem`
  MODIFY `itemCode` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1006;

--
-- AUTO_INCREMENT for table `Supplier`
--
ALTER TABLE `Supplier`
  MODIFY `supplierId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `BankTransferPayment`
--
ALTER TABLE `BankTransferPayment`
  ADD CONSTRAINT `bp_cid_fk` FOREIGN KEY (`customerId`) REFERENCES `Customer` (`customerId`),
  ADD CONSTRAINT `bp_oid_fk` FOREIGN KEY (`orderId`) REFERENCES `OnlineOrder` (`orderId`);

--
-- Constraints for table `BookItemSupplier`
--
ALTER TABLE `BookItemSupplier`
  ADD CONSTRAINT `bis_ic_fk` FOREIGN KEY (`itemCode`) REFERENCES `BookItem` (`itemCode`),
  ADD CONSTRAINT `bis_sid_fk` FOREIGN KEY (`supplierId`) REFERENCES `Supplier` (`supplierId`);

--
-- Constraints for table `BookOrderItem`
--
ALTER TABLE `BookOrderItem`
  ADD CONSTRAINT `boi_ic_fk` FOREIGN KEY (`itemCode`) REFERENCES `BookItem` (`itemCode`),
  ADD CONSTRAINT `boi_oid_fk` FOREIGN KEY (`orderId`) REFERENCES `OnlineOrder` (`orderId`);

--
-- Constraints for table `CustomerContact`
--
ALTER TABLE `CustomerContact`
  ADD CONSTRAINT `cc_cid_fk` FOREIGN KEY (`customerId`) REFERENCES `Customer` (`customerId`);

--
-- Constraints for table `Delivery`
--
ALTER TABLE `Delivery`
  ADD CONSTRAINT `d_cid_fk` FOREIGN KEY (`customerId`) REFERENCES `Customer` (`customerId`),
  ADD CONSTRAINT `d_oid_fk` FOREIGN KEY (`orderId`) REFERENCES `OnlineOrder` (`orderId`);

--
-- Constraints for table `OnlineOrder`
--
ALTER TABLE `OnlineOrder`
  ADD CONSTRAINT `oo_cid_fk` FOREIGN KEY (`customerId`) REFERENCES `Customer` (`customerId`);

--
-- Constraints for table `OnlinePayment`
--
ALTER TABLE `OnlinePayment`
  ADD CONSTRAINT `op_cid_fk` FOREIGN KEY (`customerId`) REFERENCES `Customer` (`customerId`),
  ADD CONSTRAINT `op_oid_fk` FOREIGN KEY (`orderId`) REFERENCES `OnlineOrder` (`orderId`);

--
-- Constraints for table `StationeryItemSupplier`
--
ALTER TABLE `StationeryItemSupplier`
  ADD CONSTRAINT `sis_ic_fk` FOREIGN KEY (`itemCode`) REFERENCES `StationeryItem` (`itemCode`),
  ADD CONSTRAINT `sis_sid_fk` FOREIGN KEY (`supplierId`) REFERENCES `Supplier` (`supplierId`);

--
-- Constraints for table `StationeryOrderItem`
--
ALTER TABLE `StationeryOrderItem`
  ADD CONSTRAINT `soi_ic_fk` FOREIGN KEY (`itemCode`) REFERENCES `StationeryItem` (`itemCode`),
  ADD CONSTRAINT `soi_oid_fk` FOREIGN KEY (`orderId`) REFERENCES `OnlineOrder` (`orderId`);

--
-- Constraints for table `SupplierContact`
--
ALTER TABLE `SupplierContact`
  ADD CONSTRAINT `sc_sid_fk` FOREIGN KEY (`supplierId`) REFERENCES `Supplier` (`supplierId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
