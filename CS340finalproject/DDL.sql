-- Disable foreign key checks to avoid issues while creating or dropping tables
SET FOREIGN_KEY_CHECKS = 0;

-- Dropping tables if they exist to start fresh
-- Use with caution, especially in production environments
DROP TABLE IF EXISTS `Reservation_Resort_Activities`;
DROP TABLE IF EXISTS `Reservation`;
DROP TABLE IF EXISTS `Resort_Activities`;
DROP TABLE IF EXISTS `Rooms`;
DROP TABLE IF EXISTS `Customers`;

-- Creating necessary tables
CREATE TABLE `Customers` (
  `customerID` INT AUTO_INCREMENT PRIMARY KEY,
  `email` VARCHAR(255) NOT NULL
);

CREATE TABLE `Rooms` (
  `room_ID` INT AUTO_INCREMENT PRIMARY KEY,
  `Room_type` VARCHAR(50) NOT NULL,
  `Prices_per_night` DECIMAL(10, 2) NOT NULL
);

CREATE TABLE `Resort_Activities` (
  `activity_ID` INT AUTO_INCREMENT PRIMARY KEY,
  `Name` VARCHAR(100) NOT NULL,
  `Description` TEXT NOT NULL,
  `Location` VARCHAR(100) NOT NULL,
  `Availability` BOOLEAN NOT NULL,
  `price` DECIMAL(10, 2) NOT NULL
);

CREATE TABLE `Reservation` (
  `reservation_ID` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_ID` INT NOT NULL,
  `room_ID` INT NOT NULL,
  `Checkin_date` DATE NOT NULL,
  `Checkout_date` DATE NOT NULL,
  `Total_price` DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (`customer_ID`) REFERENCES `Customers`(`customerID`) ON DELETE CASCADE,
  FOREIGN KEY (`room_ID`) REFERENCES `Rooms`(`room_ID`) ON DELETE CASCADE
);

CREATE TABLE `Reservation_Resort_Activities` (
  `reservation_ID` INT NOT NULL,
  `activity_ID` INT NOT NULL,
  PRIMARY KEY (`reservation_ID`, `activity_ID`),
  FOREIGN KEY (`reservation_ID`) REFERENCES `Reservation`(`reservation_ID`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_ID`) REFERENCES `Resort_Activities`(`activity_ID`) ON DELETE CASCADE
);

-- Re-enable foreign key checks after tables have been created
SET FOREIGN_KEY_CHECKS = 1;

-- Inserting data into tables
INSERT INTO `Customers` (`email`) VALUES 
('customer1@example.com'), 
('customer2@example.com');

INSERT INTO `Rooms` (`Room_type`, `Prices_per_night`) VALUES 
('Standard Suite', 110.00), 
('Premium Suite', 140.00);


INSERT INTO `Resort_Activities` (`Name`, `Description`, `Location`, `Availability`, `price`) VALUES 
('Whale Watching', 'Experience the majestic beauty of whales in their natural habitat.', 'Coastline', TRUE, 60.00),
('Hiking', 'Guided hiking tours through scenic trails.', 'Trailhead', TRUE, 40.00),
('Surfing Lessons', 'Learn to surf with professional instructors', 'Beachside', TRUE, 70.00);

-- Make sure the customer_IDs are correctly referring to existing records in the Customers table
INSERT INTO `Reservation` (`customer_ID`, `room_ID`, `Checkin_date`, `Checkout_date`, `Total_price`) 
VALUES (
    (SELECT customerID FROM Customers WHERE email = 'john.doe@example.com'),
    (SELECT room_ID FROM Rooms WHERE Room_type = 'Standard Suite'),
    '2024-09-01',
    '2024-09-05',
    550.00
),
(
    (SELECT customerID FROM Customers WHERE email = 'jane.smith@example.com'),
    (SELECT room_ID FROM Rooms WHERE Room_type = 'Premium Suite'),
    '2024-10-15',
    '2024-10-20',
    900.00
),
(
    (SELECT customerID FROM Customers WHERE email = 'sam.wilson@example.com'),
    (SELECT room_ID FROM Rooms WHERE Room_type = 'Deluxe Suite'),
    '2024-11-01',
    '2024-11-07',
    1260.00
),
(
    (SELECT customerID FROM Customers WHERE email = 'sara.jones@example.com'),
    (SELECT room_ID FROM Rooms WHERE Room_type = 'Ocean View Suite'),
    '2024-12-10',
    '2024-12-15',
    1000.00
),
(
    (SELECT customerID FROM Customers WHERE email = 'michael.brown@example.com'),
    (SELECT room_ID FROM Rooms WHERE Room_type = 'Penthouse Suite'),
    '2025-01-05',
    '2025-01-10',
    1500.00
);

-- Assuming activity_IDs 1, 2, and 3 are valid after the above insertions
INSERT INTO `Reservation_Resort_Activities` (`reservation_ID`, `activity_ID`) VALUES 
(1, 1), 
(1, 2),
(2, 3);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;