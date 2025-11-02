-- Task 2: Apply Aggregations and Window Functions
-- Objective: Use SQL aggregation and window functions to analyze data.

-- 1. Aggregation with GROUP BY: Total bookings per user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) as total_bookings,
    SUM(b.total_price) as total_spent,
    AVG(b.total_price) as avg_booking_value,
    MIN(b.booking_date) as first_booking_date,
    MAX(b.booking_date) as last_booking_date
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
HAVING 
    COUNT(b.booking_id) > 0
ORDER BY 
    total_bookings DESC, total_spent DESC;

-- 2. Window Functions: Rank properties by number of bookings
SELECT 
    p.property_id,
    p.property_name,
    p.property_type,
    p.city,
    p.country,
    COUNT(b.booking_id) as total_bookings,
    SUM(b.total_price) as total_revenue,
    -- ROW_NUMBER: Unique sequential number for each row
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) as booking_rank_row,
    -- RANK: Rank with gaps for ties
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) as booking_rank,
    -- DENSE_RANK: Rank without gaps for ties
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) as booking_dense_rank,
    -- NTILE: Divide into 4 quartiles
    NTILE(4) OVER (ORDER BY COUNT(b.booking_id) DESC) as revenue_quartile
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.property_name, p.property_type, p.city, p.country
ORDER BY 
    total_bookings DESC;

-- 3. Advanced Window Functions: Running totals and moving averages
SELECT 
    b.booking_id,
    b.booking_date,
    b.user_id,
    b.total_price,
    -- Running total of booking prices
    SUM(b.total_price) OVER (
        ORDER BY b.booking_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as running_total,
    -- Moving average of last 3 bookings
    AVG(b.total_price) OVER (
        ORDER BY b.booking_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as moving_avg_3_bookings,
    -- Percentage of total revenue
    ROUND(
        (b.total_price / SUM(b.total_price) OVER ()) * 100, 2
    ) as percent_of_total_revenue
FROM 
    bookings b
WHERE 
    b.booking_date >= '2024-01-01'
ORDER BY 
    b.booking_date;

-- 4. Window Functions with PARTITION BY: User booking patterns
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.booking_date,
    b.total_price,
    -- User's total bookings count
    COUNT(b.booking_id) OVER (PARTITION BY u.user_id) as user_total_bookings,
    -- User's total spending
    SUM(b.total_price) OVER (PARTITION BY u.user_id) as user_total_spent,
    -- Rank bookings by price within each user
    RANK() OVER (PARTITION BY u.user_id ORDER BY b.total_price DESC) as price_rank_per_user,
    -- Cumulative spending per user
    SUM(b.total_price) OVER (
        PARTITION BY u.user_id 
        ORDER BY b.booking_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as user_cumulative_spent
FROM 
    users u
JOIN 
    bookings b ON u.user_id = b.user_id
ORDER BY 
    u.user_id, b.booking_date;
