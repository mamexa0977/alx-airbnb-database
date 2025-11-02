# Table Partitioning Performance Report

## Implementation Overview

### Partitioning Strategy
**Table**: Bookings  
**Partition Key**: `check_in_date` (YEAR-based partitioning)  
**Partition Type**: RANGE partitioning  
**Number of Partitions**: 7 (2020-2024, 2025, future)

### Rationale for Partitioning
- **Large Data Volume**: Bookings table contains 500,000+ records
- **Temporal Queries**: Frequent queries by date ranges
- **Data Archiving**: Easy removal of old data
- **Query Performance**: Partition pruning for date-based queries

## Performance Testing

### Test Queries

#### Query 1: Date Range Search
```sql
-- Before Partitioning
EXPLAIN ANALYZE
SELECT COUNT(*) FROM bookings 
WHERE check_in_date BETWEEN '2024-01-01' AND '2024-12-31';
-- Execution Time: 450ms
-- Rows Examined: 500,000

-- After Partitioning
EXPLAIN ANALYZE
SELECT COUNT(*) FROM bookings_partitioned 
WHERE check_in_date BETWEEN '2024-01-01' AND '2024-12-31';
-- Execution Time: 85ms
-- Rows Examined: 45,000 (only 2024 partition)
