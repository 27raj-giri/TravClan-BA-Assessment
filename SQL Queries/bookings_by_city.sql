WITH city_performance AS (
    SELECT 
        city,
        star_rating,
        COUNT(*) AS booking_count,
        SUM(CASE WHEN booking_status IN ('Cancelled', 'Failed') THEN 1::NUMERIC ELSE 0::NUMERIC END) AS cancellations,
        ROUND(AVG(booking_value)::NUMERIC, 2) AS avg_booking_value,
        (SELECT AVG(booking_value)::NUMERIC FROM hotel_bookings) AS overall_avg_value
    FROM hotel_bookings
    GROUP BY city, star_rating
)
SELECT 
    city,
    star_rating,
    booking_count,
    cancellations,
    ROUND((cancellations::NUMERIC / NULLIF(booking_count::NUMERIC, 0)) * 100, 2) AS cancellation_rate,
    avg_booking_value,
    ROUND((avg_booking_value - overall_avg_value)::NUMERIC, 2) AS value_diff_from_avg
FROM city_performance
ORDER BY booking_count DESC;