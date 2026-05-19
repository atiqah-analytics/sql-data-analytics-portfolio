-- ============================================================================
-- PROJECT: Automated Data Cleaning & Standardisation Pipeline
-- DB DIALECT: PostgreSQL
-- PURPOSE: Transform raw, messy customer data into an analytics-ready layer.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Handle Missing Values & Standardise Strings
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW staging_cleaned_customers AS
SELECT 
    customer_id,
    -- Fix inconsistent casing and strip accidental whitespace
    INITCAP(TRIM(first_name)) AS clean_first_name,
    INITCAP(TRIM(last_name)) AS clean_last_name,
    
    -- Standardise emails to lowercase; flag missing entries safely
    CASE 
        WHEN email IS NULL OR TRIM(email) = '' THEN 'MISSING_EMAIL'
        WHEN email NOT LIKE '%@%.%' THEN 'INVALID_EMAIL_FORMAT'
        ELSE LOWER(TRIM(email))
    END AS clean_email,
    
    -- Handle missing numeric values safely using a placeholder or default
    COALESCE(age, 0) AS imputed_age
FROM raw_customers;

-- ----------------------------------------------------------------------------
-- 2. Deduplicate Records using Window Functions
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW staging_deduplicated_events AS
WITH ranked_events AS (
    SELECT 
        event_id,
        session_id,
        event_name,
        event_time,
        -- Partition by unique user actions to isolate true duplicates
        ROW_NUMBER() OVER (
            PARTITION BY session_id, event_name, event_time 
            ORDER BY event_id ASC
        ) as occurrence_rank
    FROM raw_web_events
)
SELECT 
    event_id,
    session_id,
    event_name,
    event_time
FROM ranked_events
WHERE occurrence_rank = 1; -- Drops subsequent duplicate rows completely
