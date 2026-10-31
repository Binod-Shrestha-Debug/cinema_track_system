CREATE INDEX idx_movies_title ON movies(title);
CREATE INDEX idx_showtimes_movie ON showtimes(movie_id);
CREATE INDEX idx_showtimes_screen_time ON showtimes(screen_id, start_time);
CREATE INDEX idx_bookings_customer ON bookings(customer_id);
CREATE INDEX idx_bookings_status ON bookings(booking_status);
CREATE INDEX idx_tickets_showtime ON tickets(showtime_id);
CREATE INDEX idx_tickets_booking ON tickets(booking_id);
CREATE INDEX idx_reviews_movie ON reviews(movie_id);
CREATE INDEX idx_payments_status_date ON payments(payment_status, payment_date);
