CREATE OR REPLACE FUNCTION get_movie_revenue(p_movie_id INT)
RETURNS NUMERIC(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_revenue NUMERIC(12,2);
BEGIN
    SELECT COALESCE(SUM(t.ticket_price), 0)
    INTO v_revenue
    FROM tickets t
    JOIN bookings b ON b.booking_id = t.booking_id
    JOIN showtimes st ON st.showtime_id = t.showtime_id
    WHERE st.movie_id = p_movie_id
      AND b.booking_status = 'Confirmed';

    RETURN v_revenue;
END;
$$;
