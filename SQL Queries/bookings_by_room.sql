WITH room_analysis AS (
    SELECT 
        room_type,
        star_rating,
        COUNT(*) AS booking_count,
        SUM(num_rooms_booked) AS total_rooms_booked,
        SUM(CASE WHEN booking_status IN ('Cancelled', 'Failed') THEN 1::NUMERIC ELSE 0::NUMERIC END) AS cancellations
    FROM hotel_bookings
    GROUP BY room_type, star_rating
)
SELECT 
    room_type,
    star_rating,
    booking_count,
    total_rooms_booked,
    ROUND((total_rooms_booked::NUMERIC / NULLIF(booking_count::NUMERIC, 0)), 2) AS avg_rooms_per_booking,
    cancellations,
    ROUND((cancellations::NUMERIC / NULLIF(booking_count::NUMERIC, 0)) * 100, 2) AS cancellation_rate
FROM room_analysis
ORDER BY booking_count DESC;