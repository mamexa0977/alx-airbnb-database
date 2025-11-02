
## Task 6: Monitor and Refine Database Performance

### performance_monitoring.md
```markdown
# Database Performance Monitoring and Refinement Report

## Monitoring Strategy

### 1. Performance Monitoring Tools Used

#### SQL Built-in Tools
```sql
-- Query execution analysis
EXPLAIN [query];
EXPLAIN ANALYZE [query];
SHOW PROFILE;
SHOW STATUS LIKE 'Handler%';
SHOW ENGINE INNODB STATUS;

-- Performance schema
SELECT * FROM performance_schema.events_statements_summary_by_digest;
SELECT * FROM sys.schema_table_statistics;
