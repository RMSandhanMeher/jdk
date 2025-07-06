DROP DATABASE IF EXISTS healthsure;
CREATE DATABASE healthsure;
USE healthsure;

-- ===========================
-- 1. Provider Operations
-- ===========================
CREATE TABLE Providers (
    provider_id VARCHAR(20) PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL,
    hospital_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(225) NOT NULL,
    city VARCHAR(225) NOT NULL,
    state VARCHAR(225) NOT NULL,   
    zip_code VARCHAR(225) NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Doctors (
    doctor_id VARCHAR(20) PRIMARY KEY,
    provider_id VARCHAR(20),
    doctor_name VARCHAR(100) NOT NULL,
    qualification VARCHAR(255),
    specialization VARCHAR(100),
    license_no VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(225) NOT NULL,
    gender VARCHAR(10),
    password VARCHAR(255) NOT NULL,
    login_status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    doctor_status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'INACTIVE',
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    provider_id VARCHAR(20),
    bank_name VARCHAR(100),
    ifsc_code VARCHAR(11),
    account_number VARCHAR(20),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

CREATE TABLE Otp_logs (
    otp_id INT PRIMARY KEY AUTO_INCREMENT,
    user_type ENUM('PROVIDER', 'RECIPIENT', 'PHARMACY', 'ADMIN'),
    otp_code VARCHAR(10) NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Provider_password (
    reset_id INT PRIMARY KEY AUTO_INCREMENT,
    provider_id VARCHAR(20) NOT NULL,
    old_password VARCHAR(255),
    new_password VARCHAR(255),
    reset_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

CREATE TABLE Doctor_availability (
    availability_id VARCHAR(36) PRIMARY KEY,
    doctor_id VARCHAR(36) NOT NULL,
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    slot_type ENUM('STANDARD', 'ADHOC') DEFAULT 'STANDARD',
    max_capacity INT NOT NULL ,
    is_recurring BOOLEAN DEFAULT FALSE,
    notes VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- ===========================
-- 2. Recipient
-- ===========================
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

CREATE TABLE Otp (
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

-- ===========================
-- 3. Appointment
-- ===========================
CREATE TABLE Appointment (
    appointment_id VARCHAR(36) PRIMARY KEY,
    doctor_id VARCHAR(36) NOT NULL,
    h_id VARCHAR(36) NOT NULL,
    availability_id VARCHAR(36) NOT NULL,
    provider_id VARCHAR(36) NOT NULL,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    booked_at TIMESTAMP NULL,
    status ENUM('PENDING', 'BOOKED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    notes TEXT,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (availability_id) REFERENCES Doctor_availability(availability_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

-- ===========================
-- 4. Procedure & Prescription
-- ===========================
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
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id),
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
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
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
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

-- ===========================
-- 5. Pharmacy
-- ===========================
CREATE TABLE Pharmacy (
    pharmacy_id VARCHAR(10) PRIMARY KEY,
    pharmacy_name VARCHAR(100) NOT NULL,
    contact_no VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(45) NOT NULL,
    created_at DATE NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(100) NOT NULL,
    license_no VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE Medicines (
    medicine_id VARCHAR(10) PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    quantity_in_stock INT NOT NULL,
    expiry_date DATE NOT NULL,
    unit_price DOUBLE NOT NULL,
    pharmacy_id VARCHAR(10) NOT NULL,
    purpose VARCHAR(100) NOT NULL,
    batch_no VARCHAR(20) NOT NULL,
    FOREIGN KEY (pharmacy_id) REFERENCES Pharmacy(pharmacy_id)
);

CREATE TABLE Pharmacists (
    pharmacist_id VARCHAR(10) PRIMARY KEY,
    pharmacist_name VARCHAR(100) NOT NULL,
    phone_no VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    pharmacy_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (pharmacy_id) REFERENCES Pharmacy(pharmacy_id)
);

CREATE TABLE Dispensed_Medicines (
    dispense_id VARCHAR(10) PRIMARY KEY,
    medicine_id VARCHAR(10) NOT NULL,
    quantity_dispensed INT NOT NULL,
    dispense_date DATE NOT NULL,
    prescription_id VARCHAR(20) NOT NULL,
    doctor_id VARCHAR(10) NOT NULL,
    h_id VARCHAR(10) NOT NULL,
    pharmacist_id VARCHAR(10) NOT NULL,
    pharmacy_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id),
    FOREIGN KEY (pharmacist_id) REFERENCES Pharmacists(pharmacist_id),
    FOREIGN KEY (pharmacy_id) REFERENCES Pharmacy(pharmacy_id)
);

CREATE TABLE Equipment (
    equipment_id VARCHAR(10) PRIMARY KEY,
    equipment_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    unit_price DOUBLE NOT NULL,
    purpose VARCHAR(100) NOT NULL,
    purchase_date DATE NOT NULL,
    pharmacy_id VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (pharmacy_id) REFERENCES Pharmacy(pharmacy_id)
);

CREATE TABLE Dispensed_Equipments (
    dispensed_equip_id VARCHAR(10) PRIMARY KEY,
    equipment_id VARCHAR(10) NOT NULL,
    quantity_dispensed INT NOT NULL,
    dispense_date DATE NOT NULL,
    prescription_id VARCHAR(20) NOT NULL,
    doctor_id VARCHAR(10) NOT NULL,
    h_id VARCHAR(10) NOT NULL,
    pharmacist_id VARCHAR(10) NOT NULL,
    pharmacy_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id),
    FOREIGN KEY (pharmacist_id) REFERENCES Pharmacists(pharmacist_id),
    FOREIGN KEY (pharmacy_id) REFERENCES Pharmacy(pharmacy_id)
);

CREATE TABLE Pharmacy_Otp (
    otp_id INT AUTO_INCREMENT PRIMARY KEY,
    pharmacy_id VARCHAR(20) NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    purpose ENUM('REGISTER', 'FORGOT_PASSWORD') NOT NULL,
    new_password VARCHAR(255),
    status ENUM('PENDING', 'VERIFIED', 'EXPIRED') DEFAULT 'PENDING',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    FOREIGN KEY (pharmacy_id) REFERENCES Pharmacy(pharmacy_id)
);

-- ===========================
-- 6. Insurance
-- ===========================
CREATE TABLE Insurance_company (
    company_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    logo_url VARCHAR(255),
    head_office VARCHAR(255),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20)
);

CREATE TABLE Insurance_plan (
    plan_id VARCHAR(50) PRIMARY KEY,
    company_id VARCHAR(50) NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    plan_type ENUM('SELF', 'FAMILY', 'SENIOR', 'CRITICAL_ILLNESS'),
    min_entry_age INT DEFAULT 18,
    max_entry_age INT DEFAULT 65,
    description TEXT,
    available_cover_amounts VARCHAR(100),
    waiting_period VARCHAR(50),
    created_on DATE DEFAULT '2025-06-01',
    expire_date DATE DEFAULT '2099-12-31',
    periodic_diseases ENUM('YES', 'NO'),
    FOREIGN KEY (company_id) REFERENCES Insurance_company(company_id)
);

CREATE TABLE Insurance_coverage_option (
    coverage_id VARCHAR(50) PRIMARY KEY,
    plan_id VARCHAR(50),
    premium_amount NUMERIC(9,2),
    coverage_amount NUMERIC(9,2),
    status VARCHAR(30) DEFAULT 'ACTIVE',
    FOREIGN KEY (plan_id) REFERENCES Insurance_plan(plan_id)
);

CREATE TABLE subscribe (
    subscribe_id VARCHAR(50) PRIMARY KEY,
    h_id VARCHAR(50),
    coverage_id VARCHAR(50),
    subscribe_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    status ENUM('Active', 'Expired') NOT NULL,
    total_premium DECIMAL(10, 2) NOT NULL,
    amount_paid DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (coverage_id) REFERENCES Insurance_coverage_option(coverage_id)
);

-- ===========================
-- 7. Claims
-- ===========================
CREATE TABLE Claims (
    claim_id VARCHAR(20) PRIMARY KEY,
    coverage_id VARCHAR(20) NOT NULL,
    procedure_id VARCHAR(20) NOT NULL,
    provider_id VARCHAR(20) NOT NULL,
    h_id VARCHAR(20) NOT NULL,
    claim_status ENUM('PENDING', 'APPROVED', 'DENIED') DEFAULT 'PENDING',
    claim_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount_claimed DECIMAL(10, 2) NOT NULL,
    amount_approved DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (procedure_id) REFERENCES medical_procedure(procedure_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id),
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (coverage_id) REFERENCES subscribe(coverage_id)
);

CREATE TABLE Claim_history (
    claim_history_id VARCHAR(20) PRIMARY KEY,
    claim_id VARCHAR(20),
    description VARCHAR(255),
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (claim_id) REFERENCES Claims(claim_id)
);

-- ===========================
-- 8. Payment History
-- ===========================
CREATE TABLE Payment_history (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    h_id VARCHAR(20) NOT NULL,
    provider_id VARCHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);
INSERT INTO Providers (
    provider_id, provider_name, hospital_name, email, address, city, state, zip_code, status, created_at
) VALUES
('P1003', 'Dr. Alok Mehta', 'AIIMS', 'alok.m@aiims.edu', 'AIIMS Campus', 'Delhi', 'Delhi', '110029', 'APPROVED', NOW()),
('P1004', 'Dr. Neha Reddy', 'Manipal Hospitals', 'neha.r@manipal.com', 'Sector 7, JP Nagar', 'Bangalore', 'Karnataka', '560078', 'PENDING', NOW()),
('P1005', 'Dr. Arjun Desai', 'Max Healthcare', 'arjun.d@max.com', 'Max Complex', 'Noida', 'Uttar Pradesh', '201301', 'APPROVED', NOW()),
('P1006', 'Dr. Kavita Sharma', 'Narayana Health', 'kavita.s@narayana.com', 'NH Towers', 'Hyderabad', 'Telangana', '500081', 'PENDING', NOW()),
('P1007', 'Dr. Sameer Khan', 'Care Hospitals', 'sameer.k@care.com', 'Near Railway Station', 'Pune', 'Maharashtra', '411001', 'REJECTED', NOW()),
('P1008', 'Dr. Meera Joshi', 'Medanta', 'meera.j@medanta.com', 'Sector 38', 'Gurgaon', 'Haryana', '122001', 'APPROVED', NOW()),
('P1009', 'Dr. Ravi Singh', 'KIMS Hospitals', 'ravi.s@kims.com', 'KIMS Lane', 'Chennai', 'Tamil Nadu', '600001', 'APPROVED', NOW()),
('P1010', 'Dr. Shalini Das', 'Columbia Asia', 'shalini.d@columbia.com', 'Ring Road', 'Kochi', 'Kerala', '682001', 'PENDING', NOW()),
('P1011', 'Dr. Ashok Patil', 'Global Hospitals', 'ashok.p@global.com', 'Health City', 'Lucknow', 'Uttar Pradesh', '226001', 'APPROVED', NOW()),
('P1012', 'Dr. Anjali Gupta', 'Sunshine Hospitals', 'anjali.g@sunshine.com', 'Sunshine Towers', 'Indore', 'Madhya Pradesh', '452001', 'REJECTED', NOW()),
('P1013', 'Dr. Rakesh Yadav', 'Ruby Hall Clinic', 'rakesh.y@rubyhall.com', 'Ruby Rd', 'Pune', 'Maharashtra', '411004', 'APPROVED', NOW()),
('P1014', 'Dr. Preeti Nair', 'SevenHills Hospital', 'preeti.n@sevenhills.com', 'Seven Hills Area', 'Mumbai', 'Maharashtra', '400059', 'PENDING', NOW()),
('P1015', 'Dr. Sunil Arora', 'Lilavati Hospital', 'sunil.a@lilavati.com', 'Bandra West', 'Mumbai', 'Maharashtra', '400050', 'APPROVED', NOW()),
('P1016', 'Dr. Anju George', 'Jaslok Hospital', 'anju.g@jaslok.com', 'Pedder Road', 'Mumbai', 'Maharashtra', '400026', 'APPROVED', NOW()),
('P1017', 'Dr. Mohan Iyer', 'Sankara Nethralaya', 'mohan.i@sankara.com', 'College Rd', 'Chennai', 'Tamil Nadu', '600006', 'PENDING', NOW()),
('P1018', 'Dr. Priya Rathi', 'Shankar Hospital', 'priya.r@shankar.com', 'BTM Layout', 'Bangalore', 'Karnataka', '560076', 'REJECTED', NOW()),
('P1019', 'Dr. Vikram Chauhan', 'HCG Cancer Hospital', 'vikram.c@hcg.com', 'Navrangpura', 'Ahmedabad', 'Gujarat', '380009', 'APPROVED', NOW()),
('P1020', 'Dr. Aarti Kulkarni', 'Sterling Hospitals', 'aarti.k@sterling.com', 'Ring Road', 'Surat', 'Gujarat', '395001', 'PENDING', NOW());
INSERT INTO Providers (
    provider_id, provider_name, hospital_name, email, address, city, state, zip_code, status, created_at
) VALUES
('P1021', 'Dr. Ritu Sharma', 'Apollo Hospitals', 'ritu.s@apollo.com', 'Greenfield Area', 'Delhi', 'Delhi', '110060', 'APPROVED', NOW()),
('P1022', 'Dr. Nikhil Roy', 'Fortis Hospital', 'nikhil.r@fortis.com', 'Sector 62', 'Noida', 'Uttar Pradesh', '201309', 'APPROVED', NOW()),
('P1023', 'Dr. Tanya Mehra', 'BLK Hospital', 'tanya.m@blk.com', 'Rajendra Place', 'Delhi', 'Delhi', '110008', 'APPROVED', NOW()),
('P1024', 'Dr. Karan Kapoor', 'Medico Hospitals', 'karan.k@medico.com', 'MG Road', 'Bangalore', 'Karnataka', '560001', 'APPROVED', NOW()),
('P1025', 'Dr. Sneha Dutta', 'Heritage Hospital', 'sneha.d@heritage.com', 'Gomti Nagar', 'Lucknow', 'Uttar Pradesh', '226010', 'APPROVED', NOW()),
('P1026', 'Dr. Ankit Verma', 'Apex Hospital', 'ankit.v@apex.com', 'GT Road', 'Kanpur', 'Uttar Pradesh', '208012', 'APPROVED', NOW()),
('P1027', 'Dr. Mehul Shah', 'Shalby Hospital', 'mehul.s@shalby.com', 'Satellite', 'Ahmedabad', 'Gujarat', '380015', 'APPROVED', NOW()),
('P1028', 'Dr. Sujata Rao', 'Amrita Hospital', 'sujata.r@amrita.com', 'AIMS Campus', 'Kochi', 'Kerala', '682041', 'APPROVED', NOW()),
('P1029', 'Dr. Rajeev Menon', 'Aster Medcity', 'rajeev.m@aster.com', 'South Chittoor', 'Kochi', 'Kerala', '682027', 'APPROVED', NOW()),
('P1030', 'Dr. Nisha Thomas', 'Rainbow Children Hospital', 'nisha.t@rainbow.com', 'Banjara Hills', 'Hyderabad', 'Telangana', '500034', 'APPROVED', NOW()),
('P1031', 'Dr. Harsh Vardhan', 'Breach Candy Hospital', 'harsh.v@breachcandy.com', 'Breach Candy', 'Mumbai', 'Maharashtra', '400026', 'APPROVED', NOW()),
('P1032', 'Dr. Leela Iyer', 'Kokilaben Hospital', 'leela.i@kokilaben.com', 'Andheri West', 'Mumbai', 'Maharashtra', '400053', 'APPROVED', NOW()),
('P1033', 'Dr. Aakash Jain', 'Batra Hospital', 'aakash.j@batra.com', 'Tughlakabad Institutional Area', 'Delhi', 'Delhi', '110062', 'APPROVED', NOW()),
('P1034', 'Dr. Bhavna Joshi', 'CareMax Hospital', 'bhavna.j@caremax.com', 'Civil Lines', 'Nagpur', 'Maharashtra', '440001', 'APPROVED', NOW()),
('P1035', 'Dr. Raj Kumar', 'SRM Hospital', 'raj.k@srm.com', 'SRM Nagar', 'Chennai', 'Tamil Nadu', '603203', 'APPROVED', NOW()),
('P1036', 'Dr. Priyanka Shah', 'Metro Hospital', 'priyanka.s@metro.com', 'Sector 11', 'Noida', 'Uttar Pradesh', '201301', 'APPROVED', NOW()),
('P1037', 'Dr. Gaurav Mishra', 'Sunshine Hospitals', 'gaurav.m@sunshine.com', 'Begumpet', 'Hyderabad', 'Telangana', '500016', 'APPROVED', NOW()),
('P1038', 'Dr. Sangeeta Chauhan', 'Sahara Hospital', 'sangeeta.c@sahara.com', 'Gomti Nagar', 'Lucknow', 'Uttar Pradesh', '226010', 'APPROVED', NOW()),
('P1039', 'Dr. Rohit Saxena', 'Paras Hospitals', 'rohit.s@paras.com', 'Sector 43', 'Gurgaon', 'Haryana', '122002', 'APPROVED', NOW()),
('P1040', 'Dr. Anuradha Das', 'Holy Family Hospital', 'anuradha.d@holyfamily.com', 'Okhla Road', 'Delhi', 'Delhi', '110025', 'APPROVED', NOW()),
('P1041', 'Dr. Deepak Reddy', 'Continental Hospitals', 'deepak.r@continental.com', 'Gachibowli', 'Hyderabad', 'Telangana', '500032', 'APPROVED', NOW()),
('P1042', 'Dr. Kaveri Nair', 'Columbia Asia', 'kaveri.n@columbia.com', 'Hebbal', 'Bangalore', 'Karnataka', '560024', 'APPROVED', NOW()),
('P1043', 'Dr. Vivek Sharma', 'Manipal Hospitals', 'vivek.s@manipal.com', 'Old Airport Road', 'Bangalore', 'Karnataka', '560017', 'APPROVED', NOW()),
('P1044', 'Dr. Reena Paul', 'Motherhood Hospital', 'reena.p@motherhood.com', 'Indiranagar', 'Bangalore', 'Karnataka', '560038', 'APPROVED', NOW()),
('P1045', 'Dr. Ishita Sen', 'Hiranandani Hospital', 'ishita.s@hiranandani.com', 'Powai', 'Mumbai', 'Maharashtra', '400076', 'APPROVED', NOW());

INSERT INTO Doctors (
    doctor_id, provider_id, doctor_name, qualification, specialization, license_no,
    email, address, gender, password, login_status, doctor_status
) VALUES
('D1003', 'P1003', 'Dr. Alok Nair', 'MBBS, DM', 'Neurology', 'LIC1003', 'alok.n@aiims.edu', 'South Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D1004', 'P1004', 'Dr. Shreya Menon', 'MBBS, DNB', 'Gynecology', 'LIC1004', 'shreya.m@manipal.com', 'JP Nagar, Bangalore', 'FEMALE', 'pass123', 'PENDING', 'INACTIVE'),
('D1005', 'P1005', 'Dr. Arjun Rao', 'MBBS, MS', 'Orthopedics', 'LIC1005', 'arjun.r@max.com', 'Sector 18, Noida', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D1006', 'P1006', 'Dr. Kavita Das', 'MBBS, MD', 'Pediatrics', 'LIC1006', 'kavita.d@narayana.com', 'Banjara Hills, Hyderabad', 'FEMALE', 'pass123', 'PENDING', 'INACTIVE'),
('D1007', 'P1007', 'Dr. Sameer Khan', 'MBBS, MS', 'ENT', 'LIC1007', 'sameer.k@care.com', 'Shivajinagar, Pune', 'MALE', 'pass123', 'REJECTED', 'INACTIVE'),
('D1008', 'P1008', 'Dr. Meera Singh', 'MBBS, DGO', 'Gynecology', 'LIC1008', 'meera.s@medanta.com', 'DLF Phase 3, Gurgaon', 'FEMALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D1009', 'P1009', 'Dr. Ravi Joshi', 'MBBS, MD', 'Dermatology', 'LIC1009', 'ravi.j@kims.com', 'T. Nagar, Chennai', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D1010', 'P1010', 'Dr. Shalini Reddy', 'MBBS, MD', 'Psychiatry', 'LIC1010', 'shalini.r@columbia.com', 'Edappally, Kochi', 'FEMALE', 'pass123', 'PENDING', 'INACTIVE'),
('D1011', 'P1011', 'Dr. Ashok Sharma', 'MBBS, DM', 'Nephrology', 'LIC1011', 'ashok.s@global.com', 'Hazratganj, Lucknow', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D1012', 'P1012', 'Dr. Anjali Varma', 'MBBS, MD', 'General Medicine', 'LIC1012', 'anjali.v@sunshine.com', 'MG Road, Indore', 'FEMALE', 'pass123', 'REJECTED', 'INACTIVE'),
('D1013', 'P1013', 'Dr. Rakesh Shetty', 'MBBS, MS', 'Urology', 'LIC1013', 'rakesh.s@rubyhall.com', 'Deccan, Pune', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D1014', 'P1014', 'Dr. Preeti Bhargav', 'MBBS, DNB', 'Pediatrics', 'LIC1014', 'preeti.b@sevenhills.com', 'Powai, Mumbai', 'FEMALE', 'pass123', 'PENDING', 'INACTIVE'),
('D1015', 'P1015', 'Dr. Sunil Goyal', 'MBBS, MS', 'Cardiothoracic Surgery', 'LIC1015', 'sunil.g@lilavati.com', 'Bandra West, Mumbai', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D1016', 'P1016', 'Dr. Anju Thomas', 'MBBS, MD', 'Internal Medicine', 'LIC1016', 'anju.t@jaslok.com', 'Marine Lines, Mumbai', 'FEMALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D1017', 'P1017', 'Dr. Mohan Nair', 'MBBS, MS', 'Ophthalmology', 'LIC1017', 'mohan.n@sankara.com', 'Anna Salai, Chennai', 'MALE', 'pass123', 'PENDING', 'INACTIVE'),
('D1018', 'P1018', 'Dr. Priya Shekhar', 'MBBS, MD', 'Dermatology', 'LIC1018', 'priya.s@shankar.com', 'BTM Layout, Bangalore', 'FEMALE', 'pass123', 'REJECTED', 'INACTIVE'),
('D1019', 'P1019', 'Dr. Vikram Rathi', 'MBBS, DM', 'Oncology', 'LIC1019', 'vikram.r@hcg.com', 'Navrangpura, Ahmedabad', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D1020', 'P1020', 'Dr. Aarti Deshpande', 'MBBS, MS', 'Gynecology', 'LIC1020', 'aarti.d@sterling.com', 'Athwa Gate, Surat', 'FEMALE', 'pass123', 'PENDING', 'INACTIVE');

USE healthsure;
-- Doctors for P1003 - AIIMS (New IDs to avoid duplicate key)
-- Doctors for P1003 - AIIMS with unique emails
INSERT INTO Doctors (
    doctor_id, provider_id, doctor_name, qualification, specialization, license_no,
    email, address, gender, password, login_status, doctor_status
) VALUES
('D4001', 'P1003', 'Dr. Neeraj Tiwari', 'MBBS, MD', 'Cardiology', 'LIC4001', 'neeraj.tiwari4001@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4002', 'P1003', 'Dr. Rina Kapoor', 'MBBS, MS', 'ENT', 'LIC4002', 'rina.kapoor4002@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4003', 'P1003', 'Dr. Amit Bansal', 'MBBS, DM', 'Neurology', 'LIC4003', 'amit.bansal4003@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4004', 'P1003', 'Dr. Leena Joshi', 'MBBS, DNB', 'Gynecology', 'LIC4004', 'leena.joshi4004@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'PENDING', 'INACTIVE'),
('D4005', 'P1003', 'Dr. Suresh Iyer', 'MBBS, MD', 'Pediatrics', 'LIC4005', 'suresh.iyer4005@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4006', 'P1003', 'Dr. Anjali Mehta', 'MBBS, MS', 'Ophthalmology', 'LIC4006', 'anjali.mehta4006@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4007', 'P1003', 'Dr. Rohit Sharma', 'MBBS, MS', 'Orthopedics', 'LIC4007', 'rohit.sharma4007@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4008', 'P1003', 'Dr. Pooja Verma', 'MBBS, MD', 'Dermatology', 'LIC4008', 'pooja.verma4008@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'PENDING', 'INACTIVE'),
('D4009', 'P1003', 'Dr. Abhishek Rathi', 'MBBS, DM', 'Oncology', 'LIC4009', 'abhishek.rathi4009@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4010', 'P1003', 'Dr. Meena Das', 'MBBS, DNB', 'Psychiatry', 'LIC4010', 'meena.das4010@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4011', 'P1003', 'Dr. Arjun Patel', 'MBBS, MS', 'Urology', 'LIC4011', 'arjun.patel4011@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4012', 'P1003', 'Dr. Kavita Nair', 'MBBS, DNB', 'Endocrinology', 'LIC4012', 'kavita.nair4012@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'PENDING', 'INACTIVE'),
('D4013', 'P1003', 'Dr. Rakesh Kumar', 'MBBS, MD', 'Nephrology', 'LIC4013', 'rakesh.kumar4013@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4014', 'P1003', 'Dr. Sneha Rao', 'MBBS, MS', 'Gastroenterology', 'LIC4014', 'sneha.rao4014@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4015', 'P1003', 'Dr. Deepak Menon', 'MBBS, DM', 'Hematology', 'LIC4015', 'deepak.menon4015@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4016', 'P1003', 'Dr. Swati Singh', 'MBBS, MS', 'Plastic Surgery', 'LIC4016', 'swati.singh4016@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4017', 'P1003', 'Dr. Nikhil Joshi', 'MBBS, MD', 'Pulmonology', 'LIC4017', 'nikhil.joshi4017@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4018', 'P1003', 'Dr. Priya Kaul', 'MBBS, MS', 'Rheumatology', 'LIC4018', 'priya.kaul4018@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'PENDING', 'INACTIVE'),
('D4019', 'P1003', 'Dr. Varun Saxena', 'MBBS, DM', 'Radiology', 'LIC4019', 'varun.saxena4019@aiims.edu', 'AIIMS Campus, Delhi', 'MALE', 'pass123', 'APPROVED', 'ACTIVE'),
('D4020', 'P1003', 'Dr. Anusha Pillai', 'MBBS, DNB', 'Pathology', 'LIC4020', 'anusha.pillai4020@aiims.edu', 'AIIMS Campus, Delhi', 'FEMALE', 'pass123', 'APPROVED', 'ACTIVE');

use  healthsure;
INSERT INTO recipient (
    h_id,
    first_name,
    last_name,
    mobile,
    user_name,
    gender,
    dob,
    address,
    created_at,
    password,
    email,
    status,
    login_attempts,
    locked_until,
    last_login,
    password_updated_at
) VALUES
('H1003', 'Robert', 'Brown', '9876543212', 'robert.brown', 'MALE', '1988-03-03', '789 Pine St', NOW(), 'pass123', 'robert.brown@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1004', 'Emily', 'Davis', '9876543213', 'emily.davis', 'FEMALE', '1995-04-04', '234 Oak St', NOW(), 'pass123', 'emily.davis@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1005', 'Michael', 'Wilson', '9876543214', 'michael.wilson', 'MALE', '1985-05-05', '567 Birch St', NOW(), 'pass123', 'michael.wilson@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1006', 'Sarah', 'Miller', '9876543215', 'sarah.miller', 'FEMALE', '1993-06-06', '890 Cedar St', NOW(), 'pass123', 'sarah.miller@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1007', 'William', 'Moore', '9876543216', 'william.moore', 'MALE', '1980-07-07', '135 Walnut St', NOW(), 'pass123', 'william.moore@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1008', 'Jessica', 'Taylor', '9876543217', 'jessica.taylor', 'FEMALE', '1991-08-08', '246 Maple St', NOW(), 'pass123', 'jessica.taylor@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1009', 'James', 'Anderson', '9876543218', 'james.anderson', 'MALE', '1987-09-09', '357 Chestnut St', NOW(), 'pass123', 'james.anderson@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1010', 'Ashley', 'Thomas', '9876543219', 'ashley.thomas', 'FEMALE', '1994-10-10', '468 Spruce St', NOW(), 'pass123', 'ashley.thomas@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1011', 'David', 'Jackson', '9876543220', 'david.jackson', 'MALE', '1990-11-11', '579 Hickory St', NOW(), 'pass123', 'david.jackson@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1012', 'Amanda', 'White', '9876543221', 'amanda.white', 'FEMALE', '1989-12-12', '680 Aspen St', NOW(), 'pass123', 'amanda.white@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1013', 'Richard', 'Harris', '9876543222', 'richard.harris', 'MALE', '1996-01-13', '781 Redwood St', NOW(), 'pass123', 'richard.harris@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1014', 'Stephanie', 'Martin', '9876543223', 'stephanie.martin', 'FEMALE', '1997-02-14', '882 Willow St', NOW(), 'pass123', 'stephanie.martin@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1015', 'Charles', 'Thompson', '9876543224', 'charles.thompson', 'MALE', '1983-03-15', '983 Sycamore St', NOW(), 'pass123', 'charles.thompson@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1016', 'Karen', 'Garcia', '9876543225', 'karen.garcia', 'FEMALE', '1998-04-16', '108 Beech St', NOW(), 'pass123', 'karen.garcia@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1017', 'Joseph', 'Martinez', '9876543226', 'joseph.martinez', 'MALE', '1986-05-17', '209 Poplar St', NOW(), 'pass123', 'joseph.martinez@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1018', 'Nancy', 'Robinson', '9876543227', 'nancy.robinson', 'FEMALE', '1984-06-18', '310 Palm St', NOW(), 'pass123', 'nancy.robinson@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1019', 'Thomas', 'Clark', '9876543228', 'thomas.clark', 'MALE', '1982-07-19', '411 Dogwood St', NOW(), 'pass123', 'thomas.clark@example.com', 'ACTIVE', 0, NULL, NULL, NOW()),
('H1020', 'Lisa', 'Rodriguez', '9876543229', 'lisa.rodriguez', 'FEMALE', '1999-08-20', '512 Magnolia St', NOW(), 'pass123', 'lisa.rodriguez@example.com', 'ACTIVE', 0, NULL, NULL, NOW());

INSERT INTO Doctor_availability (
    availability_id, doctor_id, available_date, start_time, end_time, slot_type,
    max_capacity, is_recurring, notes
) VALUES
('A1003', 'D1003', '2025-06-17', '14:00:00', '17:00:00', 'ADHOC', 8, FALSE, 'Follow-up session'),
('A1004', 'D1004', '2025-06-18', '08:00:00', '11:00:00', 'STANDARD', 15, FALSE, 'Consultation slots'),
('A1005', 'D1005', '2025-06-19', '15:00:00', '18:00:00', 'STANDARD', 10, TRUE, 'Weekly Thursday'),
('A1006', 'D1006', '2025-06-20', '09:30:00', '11:30:00', 'ADHOC', 6, FALSE, 'Vaccination day'),
('A1007', 'D1007', '2025-06-21', '11:00:00', '14:00:00', 'STANDARD', 9, TRUE, 'Alternate Saturdays'),
('A1008', 'D1008', '2025-06-22', '13:00:00', '16:00:00', 'STANDARD', 10, FALSE, 'Pediatric checkups'),
('A1009', 'D1009', '2025-06-23', '07:00:00', '10:00:00', 'STANDARD', 14, TRUE, 'Daily early shift'),
('A1010', 'D1010', '2025-06-24', '16:00:00', '19:00:00', 'ADHOC', 5, FALSE, 'On-demand slots'),
('A1011', 'D1011', '2025-06-25', '09:00:00', '12:00:00', 'STANDARD', 10, FALSE, 'Routine checkup'),
('A1012', 'D1012', '2025-06-26', '10:00:00', '13:00:00', 'ADHOC', 7, TRUE, 'Monthly checkup'),
('A1013', 'D1013', '2025-06-27', '14:00:00', '17:00:00', 'STANDARD', 15, FALSE, 'Surgery discussion'),
('A1014', 'D1014', '2025-06-28', '08:00:00', '11:00:00', 'STANDARD', 12, FALSE, 'Pre-natal appointments'),
('A1015', 'D1015', '2025-06-29', '15:00:00', '18:00:00', 'STANDARD', 10, TRUE, 'Friday slots'),
('A1016', 'D1016', '2025-06-30', '09:30:00', '11:30:00', 'ADHOC', 6, FALSE, 'General OPD'),
('A1017', 'D1017', '2025-07-01', '11:00:00', '14:00:00', 'STANDARD', 9, TRUE, 'Alternate Mondays'),
('A1018', 'D1018', '2025-07-02', '13:00:00', '16:00:00', 'STANDARD', 10, FALSE, 'Skin clinic'),
('A1019', 'D1019', '2025-07-03', '07:00:00', '10:00:00', 'STANDARD', 14, TRUE, 'Early hours'),
('A1020', 'D1020', '2025-07-04', '16:00:00', '19:00:00', 'ADHOC', 5, FALSE, 'Evening appointments');

