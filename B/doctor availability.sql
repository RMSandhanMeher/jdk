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
