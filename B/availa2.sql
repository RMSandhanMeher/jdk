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
 
iska pojo or mapping bana ke bhejo
    FOREIGN KEY (availability_id) REFERENCES doctor_availability(availability_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
);