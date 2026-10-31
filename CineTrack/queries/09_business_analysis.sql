-- Top revenue-generating movie
SELECT * FROM vw_movie_performance ORDER BY total_revenue DESC LIMIT 1;

-- Revenue by cinema
SELECT c.cinema_name, c.city, SUM(t.ticket_price) AS total_revenue
FROM cinemas c
JOIN screens sc ON c.cinema_id = sc.cinema_id
JOIN showtimes st ON sc.screen_id = st.screen_id
JOIN tickets t ON st.showtime_id = t.showtime_id
JOIN bookings b ON t.booking_id = b.booking_id
WHERE b.booking_status = 'Confirmed'
GROUP BY c.cinema_id, c.cinema_name, c.city
ORDER BY total_revenue DESC;

-- Top five customers
SELECT * FROM vw_customer_summary ORDER BY total_spending DESC LIMIT 5;

-- Average customer review per movie
SELECT m.title, ROUND(AVG(r.review_rating), 2) AS average_customer_rating,
       COUNT(r.review_id) AS total_reviews
FROM movies m
LEFT JOIN reviews r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY average_customer_rating DESC NULLS LAST;

-- Ticket sales by genre
SELECT g.genre_name, COUNT(t.ticket_id) AS tickets_sold
FROM genres g
JOIN movie_genres mg ON g.genre_id = mg.genre_id
JOIN showtimes st ON mg.movie_id = st.movie_id
JOIN tickets t ON st.showtime_id = t.showtime_id
JOIN bookings b ON t.booking_id = b.booking_id
WHERE b.booking_status = 'Confirmed'
GROUP BY g.genre_id, g.genre_name
ORDER BY tickets_sold DESC;

-- Customers who have no ticket bookings
SELECT c.customer_id, c.full_name, c.email
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM bookings b
    JOIN tickets t ON b.booking_id = t.booking_id
    WHERE b.customer_id = c.customer_id
);

-- Booking status distribution
SELECT booking_status, COUNT(*) AS total_bookings,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM bookings
GROUP BY booking_status;

-- Payment method analysis
SELECT payment_method, COUNT(*) AS transaction_count,
       SUM(amount) FILTER (WHERE payment_status = 'Completed') AS completed_amount
FROM payments
GROUP BY payment_method
ORDER BY completed_amount DESC NULLS LAST;

-- Showtimes with no tickets
SELECT st.showtime_id, m.title, st.start_time, c.cinema_name
FROM showtimes st
JOIN movies m ON st.movie_id = m.movie_id
JOIN screens sc ON st.screen_id = sc.screen_id
JOIN cinemas c ON sc.cinema_id = c.cinema_id
LEFT JOIN tickets t ON st.showtime_id = t.showtime_id
WHERE t.ticket_id IS NULL;

-- Daily confirmed ticket revenue
SELECT DATE(b.booking_date) AS booking_day, SUM(t.ticket_price) AS daily_revenue
FROM bookings b
JOIN tickets t ON b.booking_id = t.booking_id
WHERE b.booking_status = 'Confirmed'
GROUP BY DATE(b.booking_date)
ORDER BY booking_day;
