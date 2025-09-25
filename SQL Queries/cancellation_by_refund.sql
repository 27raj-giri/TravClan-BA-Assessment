WITH refund_analysis AS (
    SELECT 
        refund_status,
        payment_method,
        COUNT(*) AS booking_count,
        SUM(CASE WHEN booking_status IN ('Cancelled', 'Failed') THEN 1::NUMERIC ELSE 0::NUMERIC END) AS cancellations,
        ROUND(AVG(refund_amount)::NUMERIC, 2) AS avg_refund
    FROM hotel_bookings
    GROUP BY refund_status, payment_method
)
SELECT 
    refund_status,
    payment_method,
    booking_count,
    cancellations,
    ROUND((cancellations::NUMERIC / NULLIF(booking_count::NUMERIC, 0)) * 100, 2) AS cancellation_rate,
    avg_refund
FROM refund_analysis
ORDER BY cancellation_rate DESC;