-- Task 1: Practice Subqueries
-- Objective: Write both correlated and non-correlated subqueries.

-- 1. Non-correlated subquery: Find all properties where the average rating is greater than 4.0
SELECT 
    p.property_id,
    p.property_name,
    p.property_type,
    p.city,
    p.country,
    (SELECT AVG(r.rating) FROM reviews r WHERE r.property_id = p.property_id) as avg_rating
FROM 
    properties p
WHERE 
    (SELECT AVG(r.rating) FROM reviews r WHERE r.property_id = p.property_id) > 4.0
ORDER BY 
    avg_rating DESC;

-- Alternative approach using HAVING with subquery
SELECT 
    p.property_id,
    p.property_name,
    p.property_type,
    p.city,
    p.country
FROM 
    properties p
WHERE 
    p.property_id IN (
        SELECT r.property_id 
        FROM reviews r 
        GROUP BY r.property_id 
        HAVING AVG(r.rating) > 4.0
    )
ORDER BY 
    p.property_name;

-- 2. Correlated subquery: Find users who have made more than 3 bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.created_at,
    (SELECT COUNT(*) FROM bookings b WHERE b.user_id = u.user_id) as total_bookings
FROM 
    users u
WHERE 
    (SELECT COUNT(*) FROM bookings b WHERE b.user_id = u.user_id) > 3
ORDER BY 
    total_bookings DESC;

-- Alternative approach using EXISTS with correlated subquery
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    users u
WHERE 
    EXISTS (
        SELECT 1 
        FROM bookings b 
        WHERE b.user_id = u.user_id 
        GROUP BY b.user_id 
        HAVING COUNT(*) > 3
    );

-- Additional examples for practice:

-- 3. Non-correlated subquery: Find properties that have never been booked
SELECT 
    p.property_id,
    p.property_name,
    p.city
FROM 
    properties p
WHERE 
    p.property_id NOT IN (
        SELECT DISTINCT property_id 
        FROM bookings 
        WHERE property_id IS NOT NULL
    );

-- 4. Correlated subquery: Find users who have written reviews for all their bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name
FROM 
    users u
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM bookings b 
        WHERE b.user_id = u.user_id 
        AND NOT EXISTS (
            SELECT 1 
            FROM reviews r 
            WHERE r.booking_id = b.booking_id 
            AND r.user_id = u.user_id
        )
    );
