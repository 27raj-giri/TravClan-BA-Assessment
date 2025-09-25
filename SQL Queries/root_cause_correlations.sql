WITH root_cause_analysis AS (
    SELECT 
        booking_channel,
        ROUND(AVG(markup)::NUMERIC, 2) AS avg_markup,
        ROUND(AVG(cashback)::NUMERIC, 2) AS avg_cashback,
        ROUND(AVG(coupon_redeem)::NUMERIC, 2) AS avg_coupon_redeem,
        SUM(CASE WHEN "Coupon Used?" = 'Yes' THEN 1::NUMERIC ELSE 0::NUMERIC END) AS coupon_used_count,
        SUM(CASE WHEN booking_status IN ('Cancelled', 'Failed') THEN 1::NUMERIC ELSE 0::NUMERIC END) AS cancellations
    FROM hotel_bookings
    GROUP BY booking_channel
)
SELECT 
    booking_channel,
    avg_markup,
    avg_cashback,
    avg_coupon_redeem,
    coupon_used_count,
    cancellations,
    ROUND((cancellations::NUMERIC / NULLIF((coupon_used_count + cancellations)::NUMERIC, 0)) * 100, 2) AS coupon_cancellation_rate
FROM root_cause_analysis
ORDER BY cancellations DESC;