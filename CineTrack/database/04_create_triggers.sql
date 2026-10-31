CREATE OR REPLACE FUNCTION validate_ticket_seat()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_showtime_screen INT;
    v_seat_screen INT;
BEGIN
    SELECT screen_id INTO v_showtime_screen
    FROM showtimes WHERE showtime_id = NEW.showtime_id;

    SELECT screen_id INTO v_seat_screen
    FROM seats WHERE seat_id = NEW.seat_id;

    IF v_showtime_screen IS NULL OR v_seat_screen IS NULL THEN
        RAISE EXCEPTION 'Invalid showtime or seat.';
    END IF;

    IF v_showtime_screen <> v_seat_screen THEN
        RAISE EXCEPTION 'The selected seat does not belong to the showtime screen.';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validate_ticket_seat
BEFORE INSERT OR UPDATE OF showtime_id, seat_id ON tickets
FOR EACH ROW EXECUTE FUNCTION validate_ticket_seat();
