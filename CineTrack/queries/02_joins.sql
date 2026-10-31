-- Movies and genres
SELECT m.title, g.genre_name
FROM movies m
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
ORDER BY m.title;

-- Cinemas and screens
SELECT c.cinema_name, c.city, s.screen_name, s.screen_type
FROM cinemas c
JOIN screens s ON c.cinema_id = s.cinema_id;

-- Customer booking details
SELECT c.full_name, b.booking_id, b.booking_date, b.booking_status
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id;

-- Ticket details
SELECT t.ticket_id, c.full_name, m.title, ci.cinema_name,
       st.start_time, se.seat_number, t.ticket_price
FROM tickets t
JOIN bookings b ON t.booking_id = b.booking_id
JOIN customers c ON b.customer_id = c.customer_id
JOIN showtimes st ON t.showtime_id = st.showtime_id
JOIN movies m ON st.movie_id = m.movie_id
JOIN screens sc ON st.screen_id = sc.screen_id
JOIN cinemas ci ON sc.cinema_id = ci.cinema_id
JOIN seats se ON t.seat_id = se.seat_id
ORDER BY st.start_time;
