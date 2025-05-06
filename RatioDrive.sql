-- Drop tables in reverse order to avoid foreign key issues during re-runs
DROP TABLE IF EXISTS LoginHistory;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Ratings;
DROP TABLE IF EXISTS Journeys;
DROP TABLE IF EXISTS DrivingLicenses;
DROP TABLE IF EXISTS Vehicles;
DROP TABLE IF EXISTS EmergencyContacts;
DROP TABLE IF EXISTS Users;

-- Users table (Drivers and Passengers)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('driver', 'passenger') NOT NULL,
    national_id VARCHAR(30) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Emergency Contacts table
CREATE TABLE EmergencyContacts (
    contact_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(20) NOT NULL,
    relation VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- Vehicles table
CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    model VARCHAR(50),
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    year_of_manufacture YEAR,
    odometer_reading INT,
    tax_expiry DATE,
    fitness_expiry DATE,
    FOREIGN KEY (driver_id) REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- Driving Licenses table
CREATE TABLE DrivingLicenses (
    license_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    license_number VARCHAR(30) UNIQUE NOT NULL,
    issue_date DATE,
    expiry_date DATE,
    FOREIGN KEY (driver_id) REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- Journeys table
CREATE TABLE Journeys (
    journey_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT NOT NULL,
    driver_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    start_location VARCHAR(100),
    end_location VARCHAR(100),
    distance_km DECIMAL(5,2),
    duration_minutes INT,
    fare DECIMAL(10,2),
    journey_date DATETIME,
    FOREIGN KEY (passenger_id) REFERENCES Users(user_id),
    FOREIGN KEY (driver_id) REFERENCES Users(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);

-- Ratings table
CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    journey_id INT NOT NULL,
    rating_value INT CHECK (rating_value BETWEEN 1 AND 5),
    review_text TEXT,
    FOREIGN KEY (journey_id) REFERENCES Journeys(journey_id)
        ON DELETE CASCADE
);

-- Payments table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    journey_id INT NOT NULL,
    payment_method ENUM('cash', 'card', 'mobile_banking') NOT NULL,
    amount_paid DECIMAL(10,2),
    commission DECIMAL(10,2),
    payment_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (journey_id) REFERENCES Journeys(journey_id)
        ON DELETE CASCADE
);

-- Login History table
CREATE TABLE LoginHistory (
    login_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    login_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45),
    device_info VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON DELETE CASCADE
);
-- Inserting 15 records into the Users table
INSERT INTO Users (full_name, email, phone_number, password_hash, user_type, national_id) VALUES
('John Smith', 'john.smith@example.com', '123-456-7890', 'hashed_password_1', 'driver', '1234567890123'),
('Alice Johnson', 'alice.johnson@example.com', '234-567-8901', 'hashed_password_2', 'passenger', '2345678901234'),
('Robert Williams', 'robert.williams@example.com', '345-678-9012', 'hashed_password_3', 'driver', '3456789012345'),
('Emily Brown', 'emily.brown@example.com', '456-789-0123', 'hashed_password_4', 'passenger', '4567890123456'),
('Michael Davis', 'michael.davis@example.com', '567-890-1234', 'hashed_password_5', 'driver', '5678901234567'),
('Jessica Wilson', 'jessica.wilson@example.com', '678-901-2345', 'hashed_password_6', 'passenger', '6789098765432'),
('Christopher Garcia', 'christopher.garcia@example.com', '789-012-3456', 'hashed_password_7', 'driver', '7890123456789'),
('Ashley Rodriguez', 'ashley.rodriguez@example.com', '890-123-4567', 'hashed_password_8', 'passenger', '8901234567890'),
('Matthew Martinez', 'matthew.martinez@example.com', '901-234-5678', 'hashed_password_9', 'driver', '9012345678901'),
('Brittany Robinson', 'brittany.robinson@example.com', '012-345-6789', 'hashed_password_10', 'passenger', '0123456789012'),
('Brandon Clark', 'brandon.clark@example.com', '123-567-9012', 'hashed_password_11', 'driver', '1234567890987'),
('Stephanie Young', 'stephanie.young@example.com', '234-678-0123', 'hashed_password_12', 'passenger', '2345678901987'),
('Justin Allen', 'justin.allen@example.com', '345-789-1234', 'hashed_password_13', 'driver', '3456789012876'),
('Nicole Hall', 'nicole.hall@example.com', '456-890-2345', 'hashed_password_14', 'passenger', '4567890123765'),
('Ryan Adams', 'ryan.adams@example.com', '567-901-3456', 'hashed_password_15', 'driver', '5678901234654');

-- Inserting 15 records into the EmergencyContacts table
INSERT INTO EmergencyContacts (user_id, contact_name, contact_phone, relation) VALUES
(1, 'Jane Smith', '987-654-3210', 'Spouse'),
(2, 'Tom Johnson', '876-543-2109', 'Parent'),
(3, 'Sara Williams', '765-432-1098', 'Sibling'),
(4, 'David Brown', '654-321-0987', 'Friend'),
(5, 'Karen Davis', '543-210-9876', 'Spouse'),
(6, 'Kevin Wilson', '432-109-8765', 'Parent'),
(7, 'Laura Garcia', '321-098-7654', 'Sibling'),
(8, 'Adam Rodriguez', '210-987-6543', 'Friend'),
(9, 'Susan Martinez', '109-876-5432', 'Spouse'),
(10, 'Paul Robinson', '098-765-4321', 'Parent'),
(11, 'Nancy Clark', '987-543-2100', 'Sibling'),
(12, 'Eric Young', '876-432-1099', 'Friend'),
(13, 'Michelle Allen', '765-321-0988', 'Spouse'),
(14, 'Jason Hall', '654-210-9877', 'Parent'),
(15, 'Lisa Adams', '543-109-8766', 'Sibling');

-- Inserting 15 records into the Vehicles table
INSERT INTO Vehicles (driver_id, model, registration_number, year_of_manufacture, odometer_reading, tax_expiry, fitness_expiry) VALUES
(1, 'Toyota Camry', 'ABC-123', 2018, 50000, '2024-12-31', '2024-12-31'),
(3, 'Honda Civic', 'XYZ-789', 2019, 45000, '2025-01-15', '2025-01-15'),
(5, 'Ford F-150', 'DEF-456', 2020, 40000, '2024-11-30', '2024-11-30'),
(7, 'Chevrolet Malibu', 'GHI-012', 2017, 55000, '2025-02-28', '2025-02-28'),
(9, 'Nissan Altima', 'JKL-345', 2021, 35000, '2024-10-31', '2024-10-31'),
(11, 'Hyundai Sonata', 'MNO-678', 2016, 60000, '2025-03-31', '2025-03-31'),
(13, 'Kia Optima', 'PQR-901', 2022, 30000, '2024-09-30', '2024-09-30'),
(1, 'Toyota Corolla', 'STU-234', 2015, 65000, '2025-04-30', '2025-04-30'),
(3, 'Honda Accord', 'VWX-567', 2014, 70000, '2024-08-31', '2024-08-31'),
(5, 'Ford Mustang', 'YZA-890', 2023, 25000, '2025-05-31', '2025-05-31'),
(7, 'Chevrolet Cruze', 'BCD-123', 2013, 75000, '2024-07-31', '2024-07-31'),
(9, 'Nissan Maxima', 'EFG-456', 2012, 80000, '2025-06-30', '2025-06-30'),
(11, 'Hyundai Elantra', 'HIJ-789', 2011, 85000, '2024-06-30', '2024-06-30'),
(13, 'Kia Soul', 'KLM-012', 2010, 90000, '2025-07-31', '2025-07-31'),
(1, 'Toyota RAV4', 'NOP-345', 2009, 95000, '2024-05-31', '2024-05-31');

-- Inserting 15 records into the DrivingLicenses table
INSERT INTO DrivingLicenses (driver_id, license_number, issue_date, expiry_date) VALUES
(1, 'DL12345', '2018-01-01', '2028-01-01'),
(3, 'DL67890', '2019-02-15', '2029-02-15'),
(5, 'DL11223', '2020-03-30', '2030-03-30'),
(7, 'DL44556', '2017-04-10', '2027-04-10'),
(9, 'DL77889', '2021-05-20', '2031-05-20'),
(11, 'DL22334', '2016-06-25', '2026-06-25'),
(13, 'DL55667', '2022-07-01', '2032-07-01'),
(1, 'DL88990', '2015-08-08', '2025-08-08'),
(3, 'DL33445', '2014-09-15', '2024-09-15'),
(5, 'DL66778', '2023-10-20', '2033-10-20'),
(7, 'DL99001', '2013-11-30', '2023-11-30'),
(9, 'DL44552', '2012-12-10', '2022-12-10'),
(11, 'DL77883', '2011-01-05', '2021-01-05'),
(13, 'DL22336', '2010-02-28', '2020-02-28'),
(1, 'DL55669', '2009-03-15', '2019-03-15');

-- Inserting 15 records into the Journeys table
INSERT INTO Journeys (passenger_id, driver_id, vehicle_id, start_location, end_location, distance_km, duration_minutes, fare, journey_date) VALUES
(2, 1, 1, 'Downtown A', 'Suburb B', 15.5, 30, 25.00, '2024-01-10 08:00:00'),
(4, 3, 2, 'Suburb C', 'Airport D', 25.0, 45, 40.00, '2024-01-10 09:30:00'),
(6, 5, 3, 'Residential E', 'Commercial F', 10.0, 20, 18.00, '2024-01-10 10:45:00'),
(8, 7, 4, 'Industrial G', 'Downtown H', 30.0, 50, 50.00, '2024-01-10 12:00:00'),
(10, 9, 5, 'Suburb I', 'Suburb J', 12.0, 25, 22.00, '2024-01-10 13:15:00'),
(12, 11, 6, 'Downtown K', 'Residential L', 18.0, 35, 30.00, '2024-01-10 14:30:00'),
(14, 13, 7, 'Commercial M', 'Airport N', 28.0, 48, 45.00, '2024-01-10 15:45:00'),
(2, 1, 8, 'Suburb O', 'Downtown P', 14.0, 28, 24.00, '2024-01-11 08:00:00'),
(4, 3, 9, 'Residential Q', 'Industrial R', 22.0, 40, 38.00, '2024-01-11 09:30:00'),
(6, 5, 10, 'Downtown S', 'Commercial T', 9.0, 18, 16.00, '2024-01-11 10:45:00'),
(8, 7, 11, 'Suburb U', 'Suburb V', 11.0, 23, 20.00, '2024-01-11 12:00:00'),
(10, 9, 12, 'Residential W', 'Downtown X', 17.0, 33, 29.00, '2024-01-11 13:15:00'),
(12, 11, 13, 'Commercial Y', 'Airport Z', 27.0, 46, 43.00, '2024-01-11 14:30:00'),
(14, 13, 14, 'Downtown AA', 'Suburb BB', 13.0, 26, 23.00, '2024-01-11 15:45:00'),
(2, 1, 15, 'Suburb CC', 'Residential DD', 21.0, 38, 36.00, '2024-01-11 17:00:00');

-- Inserting 15 records into the Ratings table
INSERT INTO Ratings (journey_id, rating_value, review_text) VALUES
(1, 5, 'Great ride!'),
(2, 4, 'Good service.'),
(3, 3, 'Average experience.'),
(4, 5, 'Excellent driver.'),
(5, 4, 'Comfortable journey.'),
(6, 3, 'Okay.'),
(7, 5, 'Highly recommended.'),
(8, 4, 'Nice and clean.'),
(9, 3, 'Could be better.'),
(10, 5, 'Fantastic!'),
(11, 4, 'Pleasant ride.'),
(12, 3, 'Nothing special.'),
(13, 5, 'The best.'),
(14, 4, 'Good value.'),
(15, 3, 'Just fine.');

-- Inserting 15 records into the Payments table
INSERT INTO Payments (journey_id, payment_method, amount_paid, commission) VALUES
(1, 'card', 25.00, 2.50),
(2, 'cash', 40.00, 4.00),
(3, 'mobile_banking', 18.00, 1.80),
(4, 'card', 50.00, 5.00),
(5, 'cash', 22.00, 2.20),
(6, 'mobile_banking', 30.00, 3.00),
(7, 'card', 45.00, 4.50),
(8, 'cash', 24.00, 2.40),
(9, 'mobile_banking', 38.00, 3.80),
(10, 'card', 16.00, 1.60),
(11, 'cash', 20.00, 2.00),
(12, 'mobile_banking', 29.00, 2.90),
(13, 'card', 43.00, 4.30),
(14, 'cash', 23.00, 2.30),
(15, 'mobile_banking', 36.00, 3.60);

-- Inserting 15 records into the LoginHistory table
INSERT INTO LoginHistory (user_id, login_time, ip_address, device_info) VALUES
(1, '2024-01-10 07:55:00', '192.168.1.100', 'Web browser'),
(2, '2024-01-10 09:25:00', '192.168.1.101', 'Mobile app'),
(3, '2024-01-10 10:40:00', '192.168.1.102', 'Web browser'),
(4, '2024-01-10 11:55:00', '192.168.1.103', 'Mobile app'),
(5, '2024-01-10 13:10:00', '192.168.1.104', 'Web browser'),
(6, '2024-01-10 14:25:00', '192.168.1.105', 'Mobile app'),
(7, '2024-01-10 15:40:00', '192.168.1.106', 'Web browser'),
(8, '2024-01-11 07:55:00', '192.168.1.107', 'Mobile app'),
(9, '2024-01-11 09:25:00', '192.168.1.108', 'Web browser'),
(10, '2024-01-11 10:40:00', '192.168.1.109', 'Mobile app'),
(11, '2024-01-11 11:55:00', '192.168.1.110', 'Web browser'),
(12, '2024-01-11 13:10:00', '192.168.1.111', 'Mobile app'),
(13, '2024-01-11 14:25:00', '192.168.1.112', 'Web browser'),
(14, '2024-01-11 15:40:00', '192.168.1.113', 'Mobile app'),
(15, '2024-01-11 16:55:00', '192.168.1.114', 'Web browser');