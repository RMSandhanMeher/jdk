drop database if exists healthsure;
 
create database healthsure;

use healthsure;
 
CREATE TABLE Recipient (

    h_id VARCHAR(20) PRIMARY KEY,

    first_name VARCHAR(100) NOT NULL,

    last_name VARCHAR(100) NOT NULL,

    mobile VARCHAR(10) UNIQUE NOT NULL,

    user_name VARCHAR(100) UNIQUE NOT NULL,

    gender ENUM('MALE', 'FEMALE') NOT NULL,

    dob DATE NOT NULL,

    address VARCHAR(255) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    password VARCHAR(255) NOT NULL,

    email VARCHAR(150) UNIQUE NOT NULL,

    status ENUM('ACTIVE', 'INACTIVE', 'BLOCKED') DEFAULT 'ACTIVE',

    login_attempts INT DEFAULT 0,

    locked_until DATETIME DEFAULT NULL,

    last_login DATETIME DEFAULT NULL,

    password_updated_at DATETIME DEFAULT CURRENT_TIMESTAMP

);
 
-- Nirmalaya 

CREATE TABLE medical_procedure (

    procedure_id VARCHAR(20) PRIMARY KEY,

    appointment_id VARCHAR(20) NOT NULL,

    h_id VARCHAR(20) NOT NULL,

    provider_id VARCHAR(20) NOT NULL,

    doctor_id VARCHAR(20) NOT NULL,

    procedure_date DATE NOT NULL,

    diagnosis TEXT NOT NULL,

    recommendations TEXT,

    from_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    to_date TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),

    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),

    FOREIGN KEY (provider_id) REFERENCES providers(provider_id),

    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)

);
 
-- Abishek

CREATE TABLE providers (

    provider_id VARCHAR(20) PRIMARY KEY,

    provider_name VARCHAR(100) NOT NULL,

    hospital_name VARCHAR(100) NOT NULL,

    email VARCHAR(100) UNIQUE NOT NULL,

    address VARCHAR(225),

    city VARCHAR(225),

    state VARCHAR(225),

    zipcode VARCHAR(225),

    password VARCHAR(255) NOT NULL,

    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);
 
CREATE TABLE doctors (

    doctor_id VARCHAR(20) PRIMARY KEY,

    provider_id VARCHAR(20),

    doctor_name VARCHAR(100) NOT NULL,

    qualification VARCHAR(255),

    specialization VARCHAR(100),

    license_no VARCHAR(50),

    email VARCHAR(100) UNIQUE NOT NULL,

    address VARCHAR(225),

    status ENUM('STANDARD', 'ADHOC') DEFAULT 'STANDARD',

    gender ENUM('MALE','FEMALE'), 

    FOREIGN KEY (provider_id) REFERENCES providers(provider_id)

);
 
 
CREATE TABLE prescription (

    prescription_id VARCHAR(20) PRIMARY KEY,

    procedure_id VARCHAR(20) NOT NULL,

    h_id VARCHAR(20) NOT NULL,

    provider_id VARCHAR(20) NOT NULL,

    doctor_id VARCHAR(20) NOT NULL,

    medicine_name VARCHAR(255) NOT NULL,

    dosage VARCHAR(100),

    duration VARCHAR(100),

    notes TEXT,

    written_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (procedure_id) REFERENCES medical_procedure(procedure_id),

    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),

    FOREIGN KEY (provider_id) REFERENCES providers(provider_id),

    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)

);
 
 
CREATE TABLE procedure_test (

    test_id VARCHAR(20) PRIMARY KEY,

    procedure_id VARCHAR(20) NOT NULL,

    test_name VARCHAR(100) NOT NULL,

    test_date DATE NOT NULL,

    result_summary TEXT,

    status VARCHAR(50) DEFAULT 'Completed',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (procedure_id) REFERENCES medical_procedure(procedure_id)

);
 
CREATE TABLE appointment (

    appointment_id VARCHAR(36) PRIMARY KEY,

    provider_id VARCHAR(36) NOT NULL,

    doctor_id VARCHAR(36) NOT NULL,

    h_id VARCHAR(36) NOT NULL,

    availability_id VARCHAR(36) NOT NULL,

    slot_no int NOT NULL,

    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    booked_at TIMESTAMP NULL,

    status ENUM('PENDING', 'BOOKED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',

    notes TEXT,

    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),

    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),

    FOREIGN KEY (availability_id) REFERENCES doctor_availability(availability_id),

    FOREIGN KEY (provider_id) REFERENCES providers(provider_id)

);
 
 
CREATE TABLE doctor_availability (

    availability_id VARCHAR(36) PRIMARY KEY,

    doctor_id VARCHAR(36) NOT NULL,

    available_date DATE,

    start_time TIME NOT NULL,

    end_time TIME NOT NULL,

    slot_type ENUM('STANDARD', 'ADHOC') DEFAULT 'STANDARD',

    is_recurring BOOLEAN DEFAULT TRUE,

    notes VARCHAR(255),

    total_slots INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)

);
 
 
CREATE TABLE otp (

    otp_id INT PRIMARY KEY AUTO_INCREMENT,

    user_name VARCHAR(100) UNIQUE NOT NULL,

    otp_code INT NOT NULL,

    new_password VARCHAR(255),

    status ENUM('PENDING', 'VERIFIED', 'EXPIRED') DEFAULT 'PENDING',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    expires_at DATETIME NOT NULL,

    purpose ENUM('REGISTER','FORGOT_PASSWORD') NOT NULL,

    FOREIGN KEY (user_name) REFERENCES Recipient(user_name) ON DELETE CASCADE

);
 
 
 