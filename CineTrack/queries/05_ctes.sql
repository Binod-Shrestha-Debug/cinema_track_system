-- Movie revenue CTE
WITH movie_revenue AS (
    SELECT m.movie_id, m.title,
           COALESCE(SUM(t.ticket_price) FILTER (
               WHERE b.booking_status = 'Confirmed'
           ), 0) AS revenue
    FROM movies m
    LEFT JOIN showtimes st ON m.movie_id = st.movie_id
    LEFT JOIN tickets t ON st.showtime_id = t.showtime_id
    LEFT JOIN bookings b ON t.booking_id = b.booking_id
    GROUP BY m.movie_id, m.title
)
SELECT * FROM movie_revenue ORDER BY revenue DESC;

-- Customer value categories
WITH customer_spending AS (
    SELECT c.customer_id, c.full_name,
           COALESCE(SUM(t.ticket_price) FILTER (
               WHERE b.booking_status = 'Confirmed'
           ), 0) AS total_spending
    FROM customers c
    LEFT JOIN bookings b ON c.customer_id = b.customer_id
    LEFT JOIN tickets t ON b.booking_id = t.booking_id
    GROUP BY c.customer_id, c.full_name
),
spending_category AS (
    SELECT *,
        CASE WHEN total_spending >= 700 THEN 'High Value'
             WHEN total_spending >= 300 THEN 'Medium Value'
             ELSE 'Low Value' END AS customer_category
    FROM customer_spending
)
SELECT * FROM spending_category ORDER BY total_spending DESC;

-- Recursive CTE
WITH RECURSIVE number_sequence(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM number_sequence WHERE n < 10
)
SELECT * FROM number_sequence;
