-- Movies above average rating
SELECT title, rating FROM movies
WHERE rating > (SELECT AVG(rating) FROM movies);

-- Customers who have bookings
SELECT full_name FROM customers c
WHERE EXISTS (
    SELECT 1 FROM bookings b WHERE b.customer_id = c.customer_id
);

-- Movies without tickets
SELECT title FROM movies m
WHERE NOT EXISTS (
    SELECT 1 FROM showtimes st
    JOIN tickets t ON t.showtime_id = st.showtime_id
    WHERE st.movie_id = m.movie_id
);

-- Customers spending more than the average customer spending
WITH spending AS (
    SELECT c.customer_id, c.full_name,
           COALESCE(SUM(t.ticket_price) FILTER (
               WHERE b.booking_status = 'Confirmed'
           ), 0) AS total_spending
    FROM customers c
    LEFT JOIN bookings b ON c.customer_id = b.customer_id
    LEFT JOIN tickets t ON b.booking_id = t.booking_id
    GROUP BY c.customer_id, c.full_name
)
SELECT *
FROM spending
WHERE total_spending > (SELECT AVG(total_spending) FROM spending);
