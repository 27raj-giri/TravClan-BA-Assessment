WITH monthly_bookings AS (
    SELECT 
        TO_CHAR(booking_date, 'YYYY-MM') AS booking_month,
        COUNT(*) AS booking_count,
        SUM(CASE WHEN booking_status IN ('Cancelled', 'Failed') THEN 1::NUMERIC ELSE 0::NUMERIC END) AS cancellations
    FROM hotel_bookings
    GROUP BY booking_month
),
ranked_bookings AS (
    SELECT 
        booking_month,
        booking_count,
        cancellations,
        ROUND((cancellations::NUMERIC / NULLIF(booking_count::NUMERIC, 0)) * 100, 2) AS cancellation_rate,
        RANK() OVER (ORDER BY booking_count DESC) AS rank,
        LAG(booking_count) OVER (ORDER BY TO_DATE(booking_month, 'YYYY-MM')) AS previous_count,
        ROUND(((booking_count::NUMERIC - LAG(booking_count) OVER (ORDER BY TO_DATE(booking_month, 'YYYY-MM')))::NUMERIC / 
               NULLIF(LAG(booking_count) OVER (ORDER BY TO_DATE(booking_month, 'YYYY-MM'))::NUMERIC, 0)) * 100, 2) AS growth_rate
    FROM monthly_bookings
)
SELECT 
    booking_month,
    booking_count,
    cancellations,
    cancellation_rate,
    rank,
    COALESCE(growth_rate, 0) AS growth_rate
FROM ranked_bookings
ORDER BY TO_DATE(booking_month, 'YYYY-MM');