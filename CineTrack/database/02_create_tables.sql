-- CineTrack schema: PostgreSQL 18
CREATE TABLE genres (
    genre_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE movies (
    movie_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    release_year INT CHECK (release_year BETWEEN 1888 AND 2100),
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    language VARCHAR(50) NOT NULL,
    rating NUMERIC(3,1) CHECK (rating BETWEEN 0 AND 10),
    movie_status VARCHAR(20) DEFAULT 'Active'
        CHECK (movie_status IN ('Active', 'Coming Soon', 'Archived'))
);

CREATE TABLE movie_genres (
    movie_id INT REFERENCES movies(movie_id) ON DELETE CASCADE,
    genre_id INT REFERENCES genres(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, genre_id)
);

CREATE TABLE cinemas (
    cinema_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cinema_name VARCHAR(100) NOT NULL,
    city VARCHAR(80) NOT NULL,
    address TEXT,
    UNIQUE (cinema_name, city)
);

CREATE TABLE screens (
    screen_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cinema_id INT NOT NULL REFERENCES cinemas(cinema_id),
    screen_name VARCHAR(50) NOT NULL,
    screen_type VARCHAR(30) DEFAULT 'Standard',
    UNIQUE (cinema_id, screen_name)
);

CREATE TABLE seats (
    seat_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    screen_id INT NOT NULL REFERENCES screens(screen_id),
    seat_number VARCHAR(10) NOT NULL,
    seat_type VARCHAR(20) DEFAULT 'Regular'
        CHECK (seat_type IN ('Regular', 'Premium', 'VIP')),
    UNIQUE (screen_id, seat_number)
);

CREATE TABLE customers (
    customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE showtimes (
    showtime_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    movie_id INT NOT NULL REFERENCES movies(movie_id),
    screen_id INT NOT NULL REFERENCES screens(screen_id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    base_price NUMERIC(10,2) NOT NULL CHECK (base_price >= 0),
    CHECK (end_time > start_time),
    UNIQUE (screen_id, start_time)
);

CREATE TABLE bookings (
    booking_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    booking_status VARCHAR(20) DEFAULT 'Confirmed'
        CHECK (booking_status IN ('Confirmed', 'Cancelled', 'Pending'))
);

CREATE TABLE tickets (
    ticket_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES bookings(booking_id),
    showtime_id INT NOT NULL REFERENCES showtimes(showtime_id),
    seat_id INT NOT NULL REFERENCES seats(seat_id),
    ticket_price NUMERIC(10,2) NOT NULL CHECK (ticket_price >= 0),
    UNIQUE (showtime_id, seat_id)
);

CREATE TABLE payments (
    payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id INT NOT NULL UNIQUE REFERENCES bookings(booking_id),
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    payment_method VARCHAR(30)
        CHECK (payment_method IN ('Cash', 'Card', 'eSewa', 'Khalti', 'Bank')),
    payment_status VARCHAR(20) DEFAULT 'Completed'
        CHECK (payment_status IN ('Completed', 'Pending', 'Refunded', 'Failed')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reviews (
    review_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    movie_id INT NOT NULL REFERENCES movies(movie_id),
    review_rating INT NOT NULL CHECK (review_rating BETWEEN 1 AND 10),
    review_text TEXT,
    review_date DATE DEFAULT CURRENT_DATE,
    UNIQUE (customer_id, movie_id)
);
