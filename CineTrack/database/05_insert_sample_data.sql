-- Run once on a fresh CineTrack database.
INSERT INTO genres (genre_name) VALUES
('Action'), ('Comedy'), ('Drama'), ('Sci-Fi'),
('Thriller'), ('Romance'), ('Adventure'), ('Animation');

INSERT INTO movies
(title, release_year, duration_minutes, language, rating, movie_status)
VALUES
('The Last Mission', 2025, 135, 'English', 8.5, 'Active'),
('Kathmandu Dreams', 2026, 120, 'Nepali', 9.0, 'Active'),
('Beyond the Stars', 2025, 148, 'English', 8.8, 'Active'),
('The Hidden Truth', 2024, 128, 'Hindi', 7.9, 'Active'),
('Laughing Weekend', 2026, 110, 'Nepali', 8.1, 'Active'),
('Ocean Adventure', 2025, 140, 'English', 8.3, 'Coming Soon');

INSERT INTO movie_genres (movie_id, genre_id) VALUES
(1,1),(1,5),(2,3),(2,6),(3,4),(3,7),
(4,5),(4,3),(5,2),(6,7),(6,1);

INSERT INTO cinemas (cinema_name, city, address) VALUES
('QFX Civil Mall', 'Kathmandu', 'Sundhara, Kathmandu'),
('Big Movies', 'Pokhara', 'Chipledhunga, Pokhara'),
('Labim Cinemas', 'Lalitpur', 'Pulchowk, Lalitpur');

INSERT INTO screens (cinema_id, screen_name, screen_type) VALUES
(1,'Screen 1','IMAX'),(1,'Screen 2','Standard'),
(2,'Screen 1','Standard'),(2,'Screen 2','3D'),
(3,'Screen 1','Premium');

INSERT INTO seats (screen_id, seat_number, seat_type)
SELECT s.screen_id, 'A' || gs.seat_no,
       CASE WHEN gs.seat_no BETWEEN 1 AND 2 THEN 'VIP'
            WHEN gs.seat_no BETWEEN 3 AND 5 THEN 'Premium'
            ELSE 'Regular' END
FROM screens s CROSS JOIN generate_series(1,12) AS gs(seat_no);

INSERT INTO customers (full_name, email, phone) VALUES
('Aarav Sharma','aarav@example.com','9800000001'),
('Sita Thapa','sita@example.com','9800000002'),
('Rohan Adhikari','rohan@example.com','9800000003'),
('Priya Karki','priya@example.com','9800000004'),
('Samir Gurung','samir@example.com','9800000005'),
('Anisha Rai','anisha@example.com','9800000006'),
('Bikash KC','bikash@example.com','9800000007'),
('Nisha Lama','nisha@example.com','9800000008');

INSERT INTO showtimes (movie_id, screen_id, start_time, end_time, base_price) VALUES
(1,1,'2026-11-01 10:00','2026-11-01 12:15',350),
(2,2,'2026-11-01 13:00','2026-11-01 15:00',300),
(3,3,'2026-11-01 11:00','2026-11-01 13:28',400),
(4,4,'2026-11-02 14:00','2026-11-02 16:08',300),
(5,5,'2026-11-02 17:00','2026-11-02 18:50',250),
(1,2,'2026-11-03 10:00','2026-11-03 12:15',350),
(2,3,'2026-11-03 15:00','2026-11-03 17:00',300),
(3,1,'2026-11-04 18:00','2026-11-04 20:28',400);

INSERT INTO bookings (customer_id, booking_date, booking_status) VALUES
(1,'2026-10-28 09:00','Confirmed'),
(2,'2026-10-28 10:00','Confirmed'),
(3,'2026-10-28 11:00','Confirmed'),
(4,'2026-10-28 12:00','Cancelled'),
(5,'2026-10-29 09:00','Confirmed'),
(6,'2026-10-29 10:00','Confirmed'),
(7,'2026-10-29 11:00','Pending'),
(8,'2026-10-29 12:00','Confirmed');

-- Seat IDs 1-12 belong to screen 1, 13-24 to screen 2, etc.
INSERT INTO tickets (booking_id, showtime_id, seat_id, ticket_price) VALUES
(1,1,1,350),(1,1,2,350),(2,2,13,300),(3,3,25,400),
(4,4,37,300),(5,5,49,250),(6,6,14,350),(6,6,15,350),
(7,7,26,300),(8,8,3,400);

INSERT INTO payments (booking_id, amount, payment_method, payment_status) VALUES
(1,700,'eSewa','Completed'),
(2,300,'Khalti','Completed'),
(3,400,'Card','Completed'),
(4,300,'Cash','Refunded'),
(5,250,'eSewa','Completed'),
(6,700,'Bank','Completed'),
(7,300,'Khalti','Pending'),
(8,400,'Cash','Completed');

INSERT INTO reviews
(customer_id, movie_id, review_rating, review_text, review_date) VALUES
(1,1,9,'Excellent action movie.','2026-10-28'),
(2,2,10,'A beautiful Nepali story.','2026-10-28'),
(3,3,9,'Amazing science fiction experience.','2026-10-29'),
(4,4,7,'Good story and acting.','2026-10-29'),
(5,5,8,'Very entertaining.','2026-10-29'),
(6,1,8,'Great movie experience.','2026-10-30');
