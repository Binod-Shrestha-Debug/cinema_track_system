SELECT title, rating,
       RANK() OVER (ORDER BY rating DESC) AS movie_rank
FROM movies;

SELECT title, rating,
       DENSE_RANK() OVER (ORDER BY rating DESC) AS dense_rank
FROM movies;

WITH customer_spending AS (
    SELECT c.customer_id, c.full_name,
           COALESCE(SUM(t.ticket_price) FILTER (
               WHERE b.booking_status = 'Confirmed'
           ), 0) AS total_spending
    FROM customers c
    LEFT JOIN bookings b ON c.customer_id = b.customer_id
    LEFT JOIN tickets t ON b.booking_id = t.booking_id
    GROUP BY c.customer_id, c.full_name
)
SELECT *, DENSE_RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
FROM customer_spending;

SELECT title, release_year, rating,
       LAG(rating) OVER (ORDER BY release_year, movie_id) AS previous_rating
FROM movies;

WITH daily_revenue AS (
    SELECT DATE(b.booking_date) AS booking_day,
           SUM(t.ticket_price) AS revenue
    FROM bookings b
    JOIN tickets t ON b.booking_id = t.booking_id
    WHERE b.booking_status = 'Confirmed'
    GROUP BY DATE(b.booking_date)
)
SELECT booking_day, revenue,
       SUM(revenue) OVER (
           ORDER BY booking_day
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_revenue
FROM daily_revenue;

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
SELECT title, revenue,
       ROUND(100.0 * revenue / NULLIF(SUM(revenue) OVER (), 0), 2) AS revenue_percentage
FROM movie_revenue
ORDER BY revenue DESC;
