CREATE OR REPLACE PROCEDURE cancel_booking(p_booking_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    SELECT booking_status INTO v_status
    FROM bookings
    WHERE booking_id = p_booking_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Booking % does not exist.', p_booking_id;
    END IF;

    IF v_status = 'Cancelled' THEN
        RAISE EXCEPTION 'Booking % is already cancelled.', p_booking_id;
    END IF;

    UPDATE bookings SET booking_status = 'Cancelled'
    WHERE booking_id = p_booking_id;

    UPDATE payments SET payment_status = 'Refunded'
    WHERE booking_id = p_booking_id
      AND payment_status = 'Completed';

    RAISE NOTICE 'Booking % has been cancelled.', p_booking_id;
END;
$$;

-- Test carefully on a booking you are willing to cancel:
-- CALL cancel_booking(1);
