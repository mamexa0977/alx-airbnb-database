-- Task 3: Implement Indexes for Optimization
-- Objective: Identify and create indexes to improve query performance.

-- 1. Indexes for Users table
-- Primary key index (usually automatically created)
-- CREATE PRIMARY KEY index is implicit when defining PRIMARY KEY

-- Index for email (unique constraint and frequent lookups)
CREATE UNIQUE INDEX idx_users_email ON users(email);

-- Index for frequently searched columns
CREATE INDEX idx_users_first_name ON users(first_name);
CREATE INDEX idx_users_last_name ON users(last_name);
CREATE INDEX idx_users_city ON users(city);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Composite index for common query patterns
CREATE INDEX idx_users_name_city ON users(first_name, last_name, city);

-- 2. Indexes for Bookings table
-- Foreign key indexes (improve JOIN performance)
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- Indexes for date-based queries
CREATE INDEX idx_bookings_booking_date ON bookings(booking_date);
CREATE INDEX idx_bookings_check_in_date ON bookings(check_in_date);
CREATE INDEX idx_bookings_check_out_date ON bookings(check_out_date);

-- Composite index for date range queries
CREATE INDEX idx_bookings_dates_user ON bookings(user_id, check_in_date, check_out_date);

-- Index for status filtering
CREATE INDEX idx_bookings_status ON bookings(status);

-- 3. Indexes for Properties table
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_country ON properties(country);
CREATE INDEX idx_properties_property_type ON properties(property_type);
CREATE INDEX idx_properties_price ON properties(price_per_night);
CREATE INDEX idx_properties_host_id ON properties(host_id);

-- Composite index for location-based searches
CREATE INDEX idx_properties_location_search ON properties(city, country, property_type);

-- 4. Indexes for Reviews table
CREATE INDEX idx_reviews_property_id ON reviews(property_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
CREATE INDEX idx_reviews_created_at ON reviews(created_at);

-- Composite index for property rating analysis
CREATE INDEX idx_reviews_property_rating ON reviews(property_id, rating);

-- 5. Indexes for Payments table
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payments_payment_date ON payments(payment_date);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_method ON payments(payment_method);

-- 6. Drop indexes if needed (example syntax)
-- DROP INDEX idx_users_city ON users;

-- 7. Show existing indexes (for reference)
-- SHOW INDEX FROM users;
-- SHOW INDEX FROM bookings;
-- SHOW INDEX FROM properties;
