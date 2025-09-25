WITH revenue_trends AS (
    SELECT 
        TO_CHAR(booking_date, 'YYYY-MM') AS booking_month,
        ROUND(SUM(selling_price)::NUMERIC, 2) AS total_revenue,
        ROUND(AVG(AVG(selling_price)::NUMERIC) OVER (ORDER BY TO_DATE(TO_CHAR(booking_date, 'YYYY-MM'), 'YYYY-MM') 
                                           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_revenue
    FROM hotel_bookings
    GROUP BY booking_month
)
SELECT 
    booking_month,
    total_revenue,
    moving_avg_revenue
FROM revenue_trends
ORDER BY TO_DATE(booking_month, 'YYYY-MM');