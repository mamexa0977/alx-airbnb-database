
## Task 5: Partitioning Large Tables

### partitioning.sql
```sql
-- Task 5: Partitioning Large Tables
-- Objective: Implement table partitioning to optimize queries on large datasets.

-- 1. Check if partitioning is supported and current table structure
SELECT TABLE_NAME, PARTITION_NAME, PARTITION_ORDINAL_POSITION, TABLE_ROWS
FROM information_schema.PARTITIONS 
WHERE TABLE_NAME = 'bookings';

-- 2. Create a partitioned version of the Bookings table
-- First, create a new partitioned table

CREATE TABLE bookings_partitioned (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    booking_date DATE NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_user_id (user_id),
    KEY idx_property_id (property_id),
    KEY idx_booking_date (booking_date),
    KEY idx_check_in_date (check_in_date)
) 
PARTITION BY RANGE (YEAR(check_in_date)) (
    PARTITION p_2020 VALUES LESS THAN (2021),
    PARTITION p_2021 VALUES LESS THAN (2022),
    PARTITION p_2022 VALUES LESS THAN (2023),
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_2025 VALUES LESS THAN (2026),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 3. Alternative: Partition by monthly ranges for more granularity
CREATE TABLE bookings_monthly_partitioned (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    booking_date DATE NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_user_id (user_id),
    KEY idx_property_id (property_id),
    KEY idx_booking_date (booking_date)
) 
PARTITION BY RANGE (TO_DAYS(check_in_date)) (
    PARTITION p_2023_q1 VALUES LESS THAN (TO_DAYS('2023-04-01')),
    PARTITION p_2023_q2 VALUES LESS THAN (TO_DAYS('2023-07-01')),
    PARTITION p_2023_q3 VALUES LESS THAN (TO_DAYS('2023-10-01')),
    PARTITION p_2023_q4 VALUES LESS THAN (TO_DAYS('2024-01-01')),
    PARTITION p_2024_q1 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_2024_q2 VALUES LESS THAN (TO_DAYS('2024-07-01')),
    PARTITION p_2024_q3 VALUES LESS THAN (TO_DAYS('2024-10-01')),
    PARTITION p_2024_q4 VALUES LESS THAN (TO_DAYS('2025-01-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 4. Data migration from original bookings table to partitioned table
-- Insert data into yearly partitioned table
INSERT INTO bookings_partitioned 
SELECT * FROM bookings 
WHERE check_in_date IS NOT NULL;

-- 5. Create partition-based indexes for optimized queries
CREATE INDEX idx_partition_check_in ON bookings_partitioned (check_in_date);
CREATE INDEX idx_partition_user_date ON bookings_partitioned (user_id, check_in_date);
CREATE INDEX idx_partition_status_date ON bookings_partitioned (status, check_in_date);

-- 6. Query to analyze partition usage
EXPLAIN PARTITIONS 
SELECT * FROM bookings_partitioned 
WHERE check_in_date BETWEEN '2024-01-01' AND '2024-12-31';

-- 7. Partition maintenance operations
-- Add new partition for 2026
ALTER TABLE bookings_partitioned 
REORGANIZE PARTITION p_future INTO (
    PARTITION p_2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 8. Drop old partitions (data cleanup)
-- ALTER TABLE bookings_partitioned DROP PARTITION p_2020;

-- 9. Analyze partition performance
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    AVG_ROW_LENGTH,
    DATA_LENGTH,
    INDEX_LENGTH
FROM information_schema.PARTITIONS 
WHERE TABLE_NAME = 'bookings_partitioned';

-- 10. Create a stored procedure for partition maintenance
DELIMITER //
CREATE PROCEDURE MaintainBookingPartitions()
BEGIN
    -- Add yearly partition for next year
    SET @next_year = YEAR(CURDATE()) + 1;
    SET @sql = CONCAT(
        'ALTER TABLE bookings_partitioned REORGANIZE PARTITION p_future INTO (',
        'PARTITION p_', @next_year, ' VALUES LESS THAN (', @next_year + 1, '),',
        'PARTITION p_future VALUES LESS THAN MAXVALUE)'
    );
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Optional: Drop partitions older than 3 years
    SET @drop_year = YEAR(CURDATE()) - 3;
    SET @drop_sql = CONCAT(
        'ALTER TABLE bookings_partitioned DROP PARTITION p_', @drop_year
    );
    
    PREPARE drop_stmt FROM @drop_sql;
    EXECUTE drop_stmt;
    DEALLOCATE PREPARE drop_stmt;
END//
DELIMITER ;
