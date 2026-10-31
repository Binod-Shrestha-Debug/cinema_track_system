SELECT COUNT(*) AS total_movies FROM movies;

SELECT ROUND(AVG(rating), 2) AS average_rating FROM movies;

SELECT language, COUNT(*) AS total_movies
FROM movies GROUP BY language ORDER BY total_movies DESC;

-- Ticket sales by movie; retain movies with no confirmed tickets.
SELECT m.title,
       COUNT(t.ticket_id) FILTER (WHERE b.booking_status = 'Confirmed') AS tickets_sold,
       COALESCE(SUM(t.ticket_price) FILTER (WHERE b.booking_status = 'Confirmed'), 0) AS revenue
FROM movies m
LEFT JOIN showtimes st ON m.movie_id = st.movie_id
LEFT JOIN tickets t ON st.showtime_id = t.showtime_id
LEFT JOIN bookings b ON t.booking_id = b.booking_id
GROUP BY m.movie_id, m.title
ORDER BY revenue DESC;

SELECT c.cinema_name, c.city, SUM(t.ticket_price) AS revenue
FROM cinemas c
JOIN screens sc ON c.cinema_id = sc.cinema_id
JOIN showtimes st ON sc.screen_id = st.screen_id
JOIN tickets t ON st.showtime_id = t.showtime_id
JOIN bookings b ON t.booking_id = b.booking_id
WHERE b.booking_status = 'Confirmed'
GROUP BY c.cinema_id, c.cinema_name, c.city
ORDER BY revenue DESC;

SELECT MAX(ticket_price) AS highest_price,
       MIN(ticket_price) AS lowest_price,
       ROUND(AVG(ticket_price), 2) AS average_price
FROM tickets;
