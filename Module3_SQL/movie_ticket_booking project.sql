CREATE DATABASE movie_ticket_booking;
use movie_ticket_booking;

-- Theaters Table
CREATE TABLE Theaters (
    theater_id INT PRIMARY KEY AUTO_INCREMENT,
    theater_name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    total_seats INT 
);

-- Movies Table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_title VARCHAR(255) NOT NULL,
    genre VARCHAR(255),
    release_date DATE,
    duration INT -- in minutes
);

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20)
);

-- Bookings Table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    movie_id INT,
    theater_id INT,
    show_time DATETIME,
    total_seats_booked INT,
    total_amount DECIMAL(10, 2),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (theater_id) REFERENCES Theaters(theater_id)
);

-- Showtimes Table (for better management of shows)
CREATE TABLE Showtimes (
    showtime_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT,
    theater_id INT,
    show_time DATETIME,
    price DECIMAL(10, 2),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (theater_id) REFERENCES Theaters(theater_id)
);

-- Insert values into Theaters table
insert into Theaters(theater_name, location, total_seats)
values
('Cinema Deluxe','Andheri',200),
('Galaxy Cinemas','Bandra',150),
('Indie Movie House','Borivali',100),
('Big Screen Plaza','Central Mall',300);

-- Insert values into Movies table
insert into Movies(movie_title, genre, release_date, duration)
values
('Action Heroes 3','Action','2023-11-15',120),
('Love in Paris','Romance','2023-12-01',110),
('Mystery of the Lost City','Mystery','2023-12-10',135),
('Sci-Fi Odyssey','Sci-Fi','2024-01-05',150);

-- Insert values into Customers table
insert into Customers(first_name, last_name, email, phone)
values
('Gaurav','Jadhav','gaurav@gmail.com','123456789'),
('Ganesh','Jadhav','ganesh@gmail.com','213456789'),
('Tejal','Palkar','tejal@gmail.com','321456789'),
('Rutika','Shigavan','rutika@gmail.com','41256789'),
('Rohini','Gunjal','rohini@gmail.com','51235675');

-- Insert values into Showtimes table
INSERT INTO Showtimes (movie_id, theater_id, show_time, price) VALUES
(1, 1, '2023-12-15 19:00:00', 200), -- Action Heroes 3 in Cinema Deluxe
(2, 2, '2023-12-16 20:30:00', 300), -- Love in Paris in Galaxy Cinemas
(3, 3, '2023-12-17 18:00:00', 350), -- Mystery of the Lost City in Indie Movie House
(4, 1, '2024-01-06 21:00:00', 400), -- Sci-Fi Odyssey in Cinema Deluxe
(1, 4, '2023-12-15 20:00:00', 500), -- Action Heroes 3 in Big Screen Plaza
(2, 4, '2023-12-16 19:30:00', 450); -- Love in Paris in Big Screen Plaza

-- Insert values into Bookings Table 
INSERT INTO Bookings (customer_id, movie_id, theater_id, show_time, total_seats_booked, total_amount) VALUES
(1, 1, 1, '2023-12-15 19:00:00', 2, 400), -- Alice books 2 tickets for Action Heroes 3
(2, 2, 2, '2023-12-16 20:30:00', 1, 300), -- Bob books 1 ticket for Love in Paris
(3, 3, 3, '2023-12-17 18:00:00', 3, 1150), -- Carol books 3 tickets for Mystery of the Lost City
(4, 1, 1, '2023-12-15 19:00:00', 4, 800), -- David Books 4 tickets for Action Heroes 3
(1, 4, 1, '2024-01-06 21:00:00', 2, 800), -- Alice books 2 tickets for Sci-Fi Odyssey
(5, 1, 4, '2023-12-15 20:00:00', 5, 1000), -- Eve books 5 tickets for Action Heroes 3
(2, 2, 4, '2023-12-16 19:30:00', 2, 600); -- Bob books 2 tickets for Love in Paris

-- 1.Retrieve available seats for a given show time in a particular theater.
select 
t.total_seats, ifnull(sum(b.total_seats_booked),0) as available_seats
from
Theaters t
left join
Bookings b on t.theater_id = b.theater_id
where
t.theater_id = 1 and b.show_time = '2023-12-15 19:00:00';

-- 2.Generate a report of total bookings for each movie in a specific month
select
m.movie_id,
m.movie_title,
count(b.booking_id) as total_bookings_count,
sum(b.total_amount) as total_revenue
from
Movies m
join
Bookings b on m.movie_id = b.movie_id
where 
month(b.show_time) = 12 and year(b.show_time) = 2023
group by 
m.movie_id, m.movie_title;

-- 3.Retrive customer booking history for a specific customer.
select
c.customer_id,
m.movie_title,
b.show_time,
b.total_seats_booked,
b.total_amount
from
Customers c
join
Bookings b on c.customer_id = b.customer_id
join
Movies m on b.movie_id = m.movie_id
where
c.customer_id = 1;

#Stored procedure for Bulk Bookings
DELIMITER //
CREATE PROCEDURE BulkBooking(
    IN movie_id INT,
    IN show_time DATETIME,
    IN num_seats INT,
    IN customer_ids VARCHAR(255) -- Comma-separated customer IDs
)
BEGIN
    DECLARE theater_id INT;
    DECLARE available_seats INT;
    DECLARE customer_id INT;
    DECLARE customer_list VARCHAR(255);
    DECLARE next_customer VARCHAR(255);
    DECLARE remaining_customers VARCHAR(255);
    DECLARE seat_price DECIMAL(10,2);

    -- Get theater ID and seat price
    SELECT t.theater_id, s.price INTO theater_id, seat_price
    FROM Showtimes s
    JOIN Theaters t ON s.theater_id = t.theater_id
    WHERE s.movie_id = movie_id AND s.show_time = show_time;

    -- Get available seats
    SELECT t.total_seats, ifnull
    (SUM(b.total_seats_booked), 0) INTO available_seats
    FROM Theaters t
    LEFT JOIN Bookings b ON t.theater_id = b.theater_id
    WHERE t.theater_id = theater_id AND b.show_time = show_time;

    IF available_seats >= num_seats THEN
        SET customer_list = customer_ids;

        WHILE LENGTH(customer_list) > 0 DO
            SET next_customer = SUBSTRING_INDEX(customer_list, ',', 1);
            SET remaining_customers = SUBSTRING(customer_list, LENGTH(next_customer) + 2);

            SET customer_id = CAST(next_customer AS UNSIGNED);

            INSERT INTO Bookings (customer_id, movie_id, theater_id, show_time, total_seats_booked, total_amount)
            VALUES (customer_id, movie_id, theater_id, show_time, 1, seat_price);

            SET customer_list = remaining_customers;
        END WHILE;

        SELECT 'Booking successful' AS message;
    ELSE
        SELECT 'Insufficient seats' AS message;
    END IF;
END //
DELIMITER ;

CREATE ROLE 'admin', 'staff', 'customer';

-- Admin
GRANT ALL PRIVILEGES ON movie_ticket_booking.* TO 'admin';

-- Staff
GRANT SELECT, INSERT, UPDATE, DELETE ON Bookings TO 'staff';
GRANT SELECT ON Movies TO 'staff';
GRANT SELECT ON Theaters TO 'staff';
GRANT SELECT ON Customers TO 'staff';
GRANT SELECT ON Showtimes TO 'staff';

-- Customer
GRANT SELECT, INSERT ON Bookings TO 'customer';
GRANT SELECT ON Movies TO 'customer';
GRANT SELECT ON Theaters TO 'customer';
GRANT SELECT ON Showtimes TO 'customer';
GRANT SELECT ON Customers TO 'customer';


CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_password';
GRANT ALL PRIVILEGES ON movie_ticket_booking.* TO 'admin_user'@'localhost';








