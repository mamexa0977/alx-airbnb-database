-- ==========================================================
-- DATABASE SCHEMA: ALX Airbnb Clone
-- Description: Table creation script with constraints & indexes
-- ==========================================================

-- Drop tables in reverse dependency order (for rebuilds)
DROP TABLE IF EXISTS Message, Review, Payment, Booking, Property, User CASCADE;

-- ==========================================================
-- 1. USER TABLE
-- ==========================================================
CREATE TABLE User (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(20) CHECK (role IN ('guest', 'host', 'admin')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for quick lookups by email
CREATE INDEX idx_user_email ON User(email);

-- ==========================================================
-- 2. PROPERTY TABLE
-- ==========================================================
CREATE TABLE Property (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_property_host FOREIGN KEY (host_id)
        REFERENCES User(user_id) ON DELETE CASCADE
);

-- Index for property lookups by host and location
CREATE INDEX idx_property_host_id ON Property(host_id);
CREATE INDEX idx_property_location ON Property(location);

-- ==========================================================
-- 3. BOOKING TABLE
-- ==========================================================
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'canceled')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_property FOREIGN KEY (property_id)
        REFERENCES Property(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id)
        REFERENCES User(user_id) ON DELETE CASCADE
);

-- Indexes for frequent joins
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- ==========================================================
-- 4. PAYMENT TABLE
-- ==========================================================
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50)
        CHECK (payment_method IN ('credit_card', 'paypal', 'stripe')) NOT NULL,
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id)
        REFERENCES Booking(booking_id) ON DELETE CASCADE
);

-- Index for booking-based payment lookups
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- ==========================================================
-- 5. REVIEW TABLE
-- ==========================================================
CREATE TABLE Review (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_property FOREIGN KEY (property_id)
        REFERENCES Property(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_user FOREIGN KEY (user_id)
        REFERENCES User(user_id) ON DELETE CASCADE
);

-- Indexes for efficient review filtering
CREATE INDEX idx_review_property_id ON Review(property_id);
CREATE INDEX idx_review_user_id ON Review(user_id);

-- ==========================================================
-- 6. MESSAGE TABLE
-- ==========================================================
CREATE TABLE Message (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id)
        REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id)
        REFERENCES User(user_id) ON DELETE CASCADE
);

-- Indexes for fast message lookups
CREATE INDEX idx_message_sender_id ON Message(sender_id);
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- ==========================================================
-- END OF SCHEMA
-- ==========================================================
