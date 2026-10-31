EXPLAIN ANALYZE
SELECT * FROM movies WHERE title = 'The Last Mission';

EXPLAIN ANALYZE
SELECT c.full_name, b.booking_id, b.booking_status
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
WHERE c.customer_id = 1;

EXPLAIN ANALYZE
SELECT st.movie_id, SUM(t.ticket_price) AS revenue
FROM showtimes st
JOIN tickets t ON st.showtime_id = t.showtime_id
JOIN bookings b ON t.booking_id = b.booking_id
WHERE b.booking_status = 'Confirmed'
GROUP BY st.movie_id;

ANALYZE movies;
ANALYZE showtimes;
ANALYZE bookings;
ANALYZE tickets;

SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
