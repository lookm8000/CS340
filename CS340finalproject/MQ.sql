
-- View all customers
SELECT * FROM Customers;

-- View all rooms
SELECT * FROM Rooms;

-- View all resort activities
SELECT * FROM Resort_Activities;

-- View all reservations
SELECT * FROM Reservation;

-- View all reservation activity links
SELECT * FROM Reservation_Resort_Activities;

-- Insert Additional Sample Data
-- Insert an additional customer
INSERT INTO Customers (email) VALUES ('newcustomer@example.com');

-- Insert an additional room
INSERT INTO Rooms (Room_type, Prices_per_night) VALUES ('Deluxe Suite', 200.00);

-- Insert an additional resort activity
INSERT INTO Resort_Activities (Name, Description, Location, Availability, price) VALUES 
('Snorkeling', 'Discover the underwater world with our guided snorkeling tours.', 'Beach', TRUE, 50.00);

-- Update Data
-- Update a customer's email
UPDATE Customers SET email = 'updatedemail@example.com' WHERE customerID = 1;

-- Update a room's price per night
UPDATE Rooms SET Prices_per_night = 115.00 WHERE room_ID = 1;

-- Update a resort activity's availability
UPDATE Resort_Activities SET Availability = FALSE WHERE activity_ID = 1;

-- Delete Data
-- Delete a reservation
DELETE FROM Reservation WHERE reservation_ID = 2;

-- Delete a resort activity
DELETE FROM Resort_Activities WHERE activity_ID = 3;

-- Example of a more complex SELECT query: Find all reservations for a specific customer
SELECT r.reservation_ID, r.Checkin_date, r.Checkout_date, r.Total_price 
FROM Reservation r
JOIN Customers c ON r.customer_ID = c.customerID
WHERE c.email = 'customer1@example.com';