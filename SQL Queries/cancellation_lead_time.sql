WITH lead_time_data AS (
    SELECT 
        CASE 
            WHEN CAST((travel_date - booking_date) AS INTEGER) <= 30 THEN '0-30'
            WHEN CAST((travel_date - booking_date) AS INTEGER) <= 60 THEN '31-60'
            WHEN CAST((travel_date - booking_date) AS INTEGER) <= 90 THEN '61-90'
            ELSE '>90'
        END AS lead_time_bin,
        COUNT(*) AS booking_count,
        SUM(CASE WHEN booking_status IN ('Cancelled', 'Failed') THEN 1::NUMERIC ELSE 0::NUMERIC END) AS cancellations,
        ROUND(AVG(refund_amount)::NUMERIC, 2) AS avg_refund
    FROM hotel_bookings
    WHERE travel_date IS NOT NULL AND booking_date IS NOT NULL
    GROUP BY lead_time_bin
)
SELECT 
    lead_time_bin,
    booking_count,
    cancellations,
    ROUND((cancellations::NUMERIC / NULLIF(booking_count::NUMERIC, 0)) * 100, 2) AS cancellation_rate,
    avg_refund
FROM lead_time_data
ORDER BY lead_time_bin;