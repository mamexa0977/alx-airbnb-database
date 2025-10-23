-- ==========================================================
-- DATABASE SEED SCRIPT: ALX Airbnb Clone
-- Purpose: Insert sample data for development and testing
-- ==========================================================

-- 1️⃣ USERS
INSERT INTO User (first_name, last_name, email, password_hash, phone_number, role)
VALUES
('Abel', 'Kebede', 'abel@example.com', 'hashed_pass_1', '+251900000001', 'guest'),
('Sara', 'Tadesse', 'sara@example.com', 'hashed_pass_2', '+251900000002', 'host'),
('Mahi', 'Tesfaye', 'mahi@example.com', 'hashed_pass_3', '+251900000003', 'host'),
('Nati', 'Mekonnen', 'nati@example.com', 'hashed_pass_4', '+251900000004', 'guest'),
('Admin', 'Root', 'admin@alxairbnb.com', 'hashed_admin_pass', NULL, 'admin');

-- 2️⃣ PROPERTIES
INSERT INTO Property (host_id, name, description, location, price_per_night)
VALUES
(2, 'Addis Cozy Apartment', 'Modern 2-bedroom apartment in Bole with Wi-Fi and workspace.', 'Addis Ababa, Ethiopia', 65.00),
(3, 'Lalibela Heritage Lodge', 'Beautiful lodge near the rock-hewn churches with breakfast included.', 'Lalibela, Ethiopia', 120.00),
(3, 'Bahir Dar Lake View', 'Peaceful home with an amazing view of Lake Tana.', 'Bahir Dar, Ethiopia', 80.00);

-- 3️⃣ BOOKINGS
INSERT INTO Booking (property_id, user_id, start_date, end_date, total_price, status)
VALUES
(1, 1, '2025-11-10', '2025-11-15', 325.00, 'confirmed'),
(2, 4, '2025-12-01', '2025-12-04', 240.00, 'pending');

-- 4️⃣ PAYMENTS
INSERT INTO Payment (booking_id, amount, payment_method)
VALUES
(1, 325.00, 'credit_card'),
(2, 240.00, 'paypal');

-- 5️⃣ REVIEWS
INSERT INTO Review (property_id, user_id, rating, comment)
VALUES
(1, 1, 5, 'Amazing place! Clean, comfy, and close to everything.'),
(2, 4, 4, 'Beautiful view and great service. Will book again.');

-- 6️⃣ MESSAGES
INSERT INTO Message (sender_id, recipient_id, message_body)
VALUES
(1, 2, 'Hi, I’d like to confirm check-in time for tomorrow.'),
(2, 1, 'Sure, check-in starts at 2 PM. Looking forward to hosting you!');
