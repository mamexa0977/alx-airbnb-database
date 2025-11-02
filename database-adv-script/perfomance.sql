
## Task 4: Optimize Complex Queries

### perfomance.sql
```sql
-- Task 4: Optimize Complex Queries
-- Objective: Refactor complex queries to improve performance.

-- Initial Query (Before Optimization)
-- Retrieves all bookings with user, property, and payment details
SELECT 
    b.booking_id,
    b.booking_date,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status as booking_status,
    
    u.user_id,
    u.first_name as user_first_name,
    u.last_name as user_last_name,
    u.email as user_email,
    u.phone as user_phone,
    
    p.property_id,
    p.property_name,
    p.property_type,
    p.city as property_city,
    p.country as property_country,
    p.price_per_night,
    
    h.user_id as host_id,
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    
    pay.payment_id,
    pay.amount as payment_amount,
    pay.payment_date,
    pay.payment_method,
    pay.status as payment_status,
    
    r.review_id,
    r.rating as review_rating,
    r.comment as review_comment
    
FROM bookings b

-- Join with users table
LEFT JOIN users u ON b.user_id = u.user_id

-- Join with properties table  
LEFT JOIN properties p ON b.property_id = p.property_id

-- Join with hosts (users table again)
LEFT JOIN users h ON p.host_id = h.user_id

-- Join with payments table
LEFT JOIN payments pay ON b.booking_id = pay.booking_id

-- Join with reviews table
LEFT JOIN reviews r ON b.booking_id = r.booking_id

WHERE b.booking_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY b.booking_date DESC;

-- Optimized Query (After Analysis)
-- Strategy: Reduce unnecessary joins, use selective columns, leverage indexes

SELECT 
    b.booking_id,
    b.booking_date,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status as booking_status,
    
    -- User details (only essential fields)
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) as user_full_name,
    u.email as user_email,
    
    -- Property details (only essential fields)  
    p.property_id,
    p.property_name,
    p.property_type,
    CONCAT(p.city, ', ', p.country) as property_location,
    p.price_per_night,
    
    -- Host details (simplified)
    CONCAT(h.first_name, ' ', h.last_name) as host_name,
    
    -- Payment summary (aggregated if multiple payments)
    pay.total_paid_amount,
    pay.last_payment_date,
    pay.payment_status,
    
    -- Review summary
    r.rating as review_rating,
    LEFT(r.comment, 100) as review_preview  -- Only first 100 chars

FROM bookings b

-- Essential joins only
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
INNER JOIN users h ON p.host_id = h.user_id

-- Use subqueries for payments to avoid duplicate rows from LEFT JOIN
LEFT JOIN (
    SELECT 
        booking_id,
        SUM(amount) as total_paid_amount,
        MAX(payment_date) as last_payment_date,
        MAX(status) as payment_status
    FROM payments
    GROUP BY booking_id
) pay ON b.booking_id = pay.booking_id

-- Use subquery for reviews
LEFT JOIN (
    SELECT 
        booking_id,
        rating,
        comment
    FROM reviews
    WHERE review_id IN (
        SELECT MAX(review_id) 
        FROM reviews 
        GROUP BY booking_id
    )
) r ON b.booking_id = r.booking_id

-- Add selective WHERE clause with indexed columns
WHERE b.booking_date >= '2024-01-01' 
  AND b.booking_date < '2025-01-01'
  AND b.status IN ('confirmed', 'completed')

-- Use indexed ORDER BY
ORDER BY b.booking_date DESC

-- Limit results for pagination
LIMIT 100;

-- Additional Optimized Query: Summary View for Dashboard
-- Uses aggregation and avoids multiple joins

SELECT 
    b.booking_id,
    b.booking_date,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status,
    
    u.first_name,
    u.last_name,
    
    p.property_name,
    p.city,
    
    COALESCE((
        SELECT SUM(amount) 
        FROM payments 
        WHERE booking_id = b.booking_id 
        AND status = 'completed'
    ), 0) as total_paid,
    
    COALESCE((
        SELECT rating 
        FROM reviews 
        WHERE booking_id = b.booking_id 
        LIMIT 1
    ), 0) as rating

FROM bookings b
INNER JOIN users u USING (user_id)
INNER JOIN properties p USING (property_id)
WHERE b.booking_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY b.booking_date DESC
LIMIT 50;
