# SQL Joins Practice - ALX Airbnb Database

## Project Overview
This project focuses on mastering SQL joins by implementing different types of joins to retrieve and analyze data from the Airbnb database schema. The tasks demonstrate practical applications of INNER JOIN, LEFT JOIN, and FULL OUTER JOIN operations.

## Database Schema Context
The queries are designed to work with the following key tables in the Airbnb database:

- **users**: Contains user information (user_id, first_name, last_name, email, etc.)
- **bookings**: Stores booking records with user references (booking_id, user_id, booking_date, etc.)
- **properties**: Contains property listings (property_id, property_name, property_type, etc.)
- **reviews**: Stores user reviews for properties (review_id, property_id, rating, comment, etc.)

## Query Explanations

### 1. INNER JOIN Query
**Objective**: Retrieve all bookings and the respective users who made those bookings.

**Explanation**:
- Uses `INNER JOIN` between `bookings` and `users` tables
- Matches records where `bookings.user_id = users.user_id`
- Returns only bookings that have associated users and users that have made bookings
- Includes booking details and user information in the result set

**Use Case**: Useful for generating booking reports with customer details.

### 2. LEFT JOIN Query
**Objective**: Retrieve all properties and their reviews, including properties that have no reviews.

**Explanation**:
- Uses `LEFT JOIN` between `properties` and `reviews` tables
- Returns all properties from the left table (`properties`)
- Includes matching reviews from the right table (`reviews`)
- Properties without reviews will have NULL values in review-related columns
- Maintains complete property listing while showing available reviews

**Use Case**: Property performance analysis and identifying properties needing more reviews.

### 3. FULL OUTER JOIN Query
**Objective**: Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.

**Explanation**:
- MySQL doesn't natively support `FULL OUTER JOIN`, so we simulate it using `UNION` of `LEFT JOIN` and `RIGHT JOIN`
- First part: Gets all users and their bookings (including users with no bookings)
- Second part: Gets all bookings without associated users
- Combined result shows complete picture of users and bookings relationships
- Uses `COALESCE` to handle NULL values consistently

**Use Case**: Data integrity checks, identifying orphaned records, and comprehensive user activity reporting.

## Key Learning Outcomes

### INNER JOIN
- Returns only matching records from both tables
- Ideal for finding relationships where both sides must exist
- Most commonly used join type in practice

### LEFT JOIN
- Returns all records from the left table and matched records from the right table
- Preserves data from the primary table being analyzed
- Useful for finding "missing" relationships

### FULL OUTER JOIN
- Returns all records when there's a match in either left or right table
- Comprehensive view of relationships and non-relationships
- Important for data validation and completeness analysis

## Performance Considerations

1. **Indexing**: Ensure proper indexes on foreign key columns (user_id, property_id) for optimal join performance
2. **Selectivity**: Use WHERE clauses to limit result sets when working with large datasets
3. **Column Selection**: Specify only needed columns instead of SELECT * for better performance

## Usage Instructions

1. Execute the queries in your MySQL database with the Airbnb schema
2. Modify table and column names according to your actual database structure
3. Test each query individually to understand the result sets
4. Experiment with additional WHERE clauses and ORDER BY modifications

## File Structure
- `joins_queries.sql`: Contains all SQL join queries with comments
- `README.md`: This documentation file

## Next Steps
After mastering these basic joins, proceed to:
- Complex multi-table joins
- Subqueries with joins
- Aggregate functions with grouped joins
- Join performance optimization techniques

# Aggregations and Window Functions - ALX Airbnb Database

## Project Overview
This project demonstrates the use of SQL aggregation functions and advanced window functions for data analysis and reporting in the Airbnb database.

## Query Explanations

### 1. Aggregation with GROUP BY
**Objective**: Find the total number of bookings made by each user

**Features Used**:
- `COUNT()`: Count total bookings per user
- `SUM()`: Calculate total spending per user
- `AVG()`: Find average booking value
- `MIN()/MAX()`: Get first and last booking dates
- `GROUP BY`: Group results by user
- `HAVING`: Filter groups after aggregation

**Use Case**: Customer behavior analysis and segmentation.

### 2. Window Functions for Ranking
**Objective**: Rank properties based on total number of bookings

**Window Functions Demonstrated**:
- `ROW_NUMBER()`: Sequential numbering (no ties)
- `RANK()`: Ranking with gaps for tied values
- `DENSE_RANK()`: Ranking without gaps for ties
- `NTILE()`: Dividing results into quartiles

**Key Difference**: Window functions don't collapse rows like GROUP BY - they compute values for each row while maintaining the original dataset structure.

### 3. Advanced Window Functions
**Objective**: Calculate running totals and moving averages

**Features**:
- Running totals with `SUM() OVER()`
- Moving averages with frame specification
- Percentage of total calculations
- Frame clauses: `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`

### 4. PARTITION BY for Segment Analysis
**Objective**: Analyze user booking patterns within segments

**Features**:
- `PARTITION BY`: Divide data into user segments
- Per-user aggregations while maintaining row-level detail
- Cumulative calculations within partitions

## Key Concepts

### Aggregation Functions
- Collapse multiple rows into single summary rows
- Require GROUP BY for non-aggregated columns
- Useful for summary reports and dashboards

### Window Functions
- Perform calculations across related rows
- Maintain individual row visibility
- Don't require GROUP BY
- Essential for analytical queries and rankings

## Performance Considerations

1. **Window functions** are generally efficient but can be memory-intensive on large datasets
2. **Proper indexing** on ORDER BY columns in window functions
3. **PARTITION BY** columns should be indexed for better performance
4. Consider **query complexity** when using multiple window functions

## Real-World Applications

- Customer lifetime value analysis
- Property performance rankings
- Revenue trend analysis
- User behavior segmentation
- Booking pattern identification
