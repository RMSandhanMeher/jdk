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
