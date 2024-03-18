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
INSERT INTO `Reservation` (`customer_ID`, `room_ID`, `Checkin_date`, `Checkout_date`, `Total_price`) VALUES 
(1, 1, '2024-07-01', '2024-07-05', 440.00),
(2, 2, '2024-08-15', '2024-08-20', 700.00);

-- Assuming activity_IDs 1, 2, and 3 are valid after the above insertions
INSERT INTO `Reservation_Resort_Activities` (`reservation_ID`, `activity_ID`) VALUES 
(1, 1), 
(1, 2),
(2, 3);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;