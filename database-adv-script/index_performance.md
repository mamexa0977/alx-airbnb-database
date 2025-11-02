# Index Performance Analysis Report

## Objective
Identify high-usage columns and create appropriate indexes to improve query performance in the Airbnb database.

## Index Implementation Strategy

### 1. High-Usage Column Identification

#### Users Table
- **Primary Key**: user_id (auto-indexed)
- **High Usage**: email (login, lookups), name (searches), city (filtering), created_at (analytics)

#### Bookings Table  
- **Foreign Keys**: user_id, property_id (JOIN operations)
- **High Usage**: booking_date, check_in_date, check_out_date (date range queries), status (filtering)

#### Properties Table
- **High Usage**: city, country (location searches), property_type (categorization), price_per_night (filtering)

### 2. Indexes Created

#### Single-Column Indexes
- Created for frequently filtered columns
- Examples: email, city, booking_date, rating

#### Composite Indexes
- Created for common query patterns
- Examples: (first_name, last_name, city), (user_id, check_in_date, check_out_date)

#### Unique Indexes
- Email field for integrity and fast lookups

### 3. Performance Measurement

#### Before Indexing
```sql
EXPLAIN SELECT * FROM users WHERE email = 'user@example.com';
-- Expected: Full table scan, high cost
