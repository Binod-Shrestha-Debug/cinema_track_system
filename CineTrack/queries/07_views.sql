CREATE OR REPLACE VIEW vw_movie_performance AS
WITH ticket_stats AS (
    SELECT st.movie_id,
           COUNT(t.ticket_id) FILTER (
               WHERE b.booking_status = 'Confirmed'
           ) AS tickets_sold,
           COALESCE(SUM(t.ticket_price) FILTER (
               WHERE b.booking_status = 'Confirmed'
           ), 0) AS total_revenue
    FROM showtimes st
    LEFT JOIN tickets t ON st.showtime_id = t.showtime_id
    LEFT JOIN bookings b ON t.booking_id = b.booking_id
    GROUP BY st.movie_id
),
review_stats AS (
    SELECT movie_id, COUNT(*) AS review_count,
           ROUND(AVG(review_rating), 2) AS average_review
    FROM reviews GROUP BY movie_id
)
SELECT m.movie_id, m.title, m.rating AS movie_rating,
       COALESCE(ts.tickets_sold, 0) AS tickets_sold,
       COALESCE(ts.total_revenue, 0) AS total_revenue,
       COALESCE(rs.review_count, 0) AS review_count,
       rs.average_review
FROM movies m
LEFT JOIN ticket_stats ts ON m.movie_id = ts.movie_id
LEFT JOIN review_stats rs ON m.movie_id = rs.movie_id;

CREATE OR REPLACE VIEW vw_customer_summary AS
WITH booking_stats AS (
    SELECT c.customer_id,
           COUNT(DISTINCT b.booking_id) FILTER (
               WHERE b.booking_status = 'Confirmed'
           ) AS confirmed_bookings,
           COUNT(t.ticket_id) FILTER (
               WHERE b.booking_status = 'Confirmed'
           ) AS tickets_purchased,
           COALESCE(SUM(t.ticket_price) FILTER (
               WHERE b.booking_status = 'Confirmed'
           ), 0) AS total_spending
    FROM customers c
    LEFT JOIN bookings b ON c.customer_id = b.customer_id
    LEFT JOIN tickets t ON b.booking_id = t.booking_id
    GROUP BY c.customer_id
)
SELECT c.customer_id, c.full_name, c.email,
       COALESCE(bs.confirmed_bookings, 0) AS confirmed_bookings,
       COALESCE(bs.tickets_purchased, 0) AS tickets_purchased,
       COALESCE(bs.total_spending, 0) AS total_spending
FROM customers c
LEFT JOIN booking_stats bs ON c.customer_id = bs.customer_id;

SELECT * FROM vw_movie_performance ORDER BY total_revenue DESC;
SELECT * FROM vw_customer_summary ORDER BY total_spending DESC;
