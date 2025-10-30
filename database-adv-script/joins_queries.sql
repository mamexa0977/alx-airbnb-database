

-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings
SELECT 
    b.booking_id,
    b.booking_date,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
ORDER BY 
    b.booking_date DESC;

-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews
SELECT 
    p.property_id,
    p.property_name,
    p.property_type,
    p.city,
    p.country,
    r.review_id,
    r.rating,
    r.comment,
    r.review_date,
    r.user_id as reviewer_id
FROM 
    properties p
LEFT JOIN 
    reviews r ON p.property_id = r.property_id
ORDER BY 
    p.property_id, r.review_date DESC;

-- 3. FULL OUTER JOIN: Retrieve all users and all bookings, even if the user has no booking 
-- or a booking is not linked to a user
-- Note: MySQL doesn't support FULL OUTER JOIN directly, so we use UNION of LEFT and RIGHT JOIN

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.booking_date,
    b.check_in_date,
    b.check_out_date,
    b.total_price
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id

UNION

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.booking_date,
    b.check_in_date,
    b.check_out_date,
    b.total_price
FROM 
    users u
RIGHT JOIN 
    bookings b ON u.user_id = b.user_id
WHERE 
    u.user_id IS NULL
ORDER BY 
    user_id, booking_date DESC;

-- Alternative approach using COALESCE for better handling of NULL values
SELECT 
    COALESCE(u.user_id, b.user_id) as user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.booking_date,
    b.check_in_date,
    b.check_out_date,
    b.total_price
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id

UNION

SELECT 
    COALESCE(u.user_id, b.user_id) as user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.booking_date,
    b.check_in_date,
    b.check_out_date,
    b.total_price
FROM 
    users u
RIGHT JOIN 
    bookings b ON u.user_id = b.user_id
ORDER BY 
    user_id, booking_date DESC;
