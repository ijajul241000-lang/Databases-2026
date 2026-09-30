-- Week 39 - Exercise 3: Hotel Booking System

CREATE TABLE hotels (
    hotel_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    star_rating INTEGER NOT NULL
        CHECK (star_rating BETWEEN 1 AND 5),
    phone VARCHAR(20)
);

CREATE TABLE rooms (
    hotel_id INTEGER NOT NULL
        REFERENCES hotels(hotel_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    room_number VARCHAR(10) NOT NULL,
    room_type VARCHAR(30) NOT NULL,
    floor INTEGER NOT NULL,
    price_per_night NUMERIC(10,2) NOT NULL
        CHECK (price_per_night > 0),
    has_balcony BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (hotel_id, room_number)
);

CREATE TABLE guests (
    guest_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    phone VARCHAR(20),
    passport_number VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    guest_id INTEGER NOT NULL
        REFERENCES guests(guest_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL
        CHECK (total_amount >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'confirmed'
        CHECK (
            status IN (
                'pending',
                'confirmed',
                'cancelled',
                'completed'
            )
        ),
    CHECK (check_out_date > check_in_date)
);

CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price NUMERIC(10,2) NOT NULL
        CHECK (price >= 0)
);

CREATE TABLE booking_rooms (
    booking_id INTEGER NOT NULL
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    hotel_id INTEGER NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    room_check_in DATE NOT NULL,
    room_check_out DATE NOT NULL,
    PRIMARY KEY (booking_id, hotel_id, room_number),
    FOREIGN KEY (hotel_id, room_number)
        REFERENCES rooms(hotel_id, room_number)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CHECK (room_check_out > room_check_in)
);

CREATE TABLE booking_services (
    booking_id INTEGER NOT NULL
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    service_id INTEGER NOT NULL
        REFERENCES services(service_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    used_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    quantity INTEGER NOT NULL DEFAULT 1
        CHECK (quantity > 0),
    PRIMARY KEY (booking_id, service_id, used_at)
);

