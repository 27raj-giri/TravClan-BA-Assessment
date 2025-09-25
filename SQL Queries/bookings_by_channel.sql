WITH channel_analysis AS (
    SELECT 
        booking_channel,
        COUNT(*) AS booking_count,
        SUM(CASE WHEN booking_status IN ('Cancelled', 'Failed') THEN 1::NUMERIC ELSE 0::NUMERIC END) AS cancellations,
        SUM(CASE WHEN refund_status = 'Yes' THEN 1::NUMERIC ELSE 0::NUMERIC END) AS refunds,
        ROUND(AVG(booking_value)::NUMERIC, 2) AS avg_booking_value,
        (SELECT AVG(booking_value)::NUMERIC FROM hotel_bookings) AS overall_avg_value
    FROM hotel_bookings
    GROUP BY booking_channel
)
SELECT 
    booking_channel,
    booking_count,
    cancellations,
    ROUND((cancellations::NUMERIC / NULLIF(booking_count::NUMERIC, 0)) * 100, 2) AS cancellation_rate,
    refunds,
    ROUND((refunds::NUMERIC / NULLIF(booking_count::NUMERIC, 0)) * 100, 2) AS refund_rate,
    avg_booking_value,
    ROUND((avg_booking_value - overall_avg_value)::NUMERIC, 2) AS value_diff
FROM channel_analysis
ORDER BY booking_count DESC;