-- Sample Jobs Data for Testing
-- Chạy script này trong Supabase SQL Editor

-- Bước 1: Lấy recruiter_id của bạn
-- Chạy query này trước để lấy ID:
-- SELECT id FROM profiles WHERE role = 'recruiter' LIMIT 1;

-- Bước 2: Thay YOUR_RECRUITER_ID bằng ID vừa lấy được, sau đó chạy:

INSERT INTO jobs (recruiter_id, title, description, requirements, location, job_type, salary_min, salary_max, status)
VALUES 
-- Job 1: Flutter Developer
('YOUR_RECRUITER_ID', 
 'Flutter Developer', 
 'Chúng tôi đang tìm kiếm Flutter Developer có kinh nghiệm để tham gia vào đội ngũ phát triển ứng dụng mobile. Bạn sẽ làm việc với các dự án thú vị và công nghệ hiện đại.', 
 '- Kinh nghiệm 2+ năm với Flutter/Dart
- Hiểu biết về State Management (Riverpod, Bloc, Provider)
- Kinh nghiệm với RESTful APIs và Firebase
- Có kinh nghiệm với Git và Agile/Scrum', 
 'Hồ Chí Minh & 145 nơi khác', 
 'full-time', 
 15000000, 
 25000000, 
 'active'),

-- Job 2: React Native Developer  
('YOUR_RECRUITER_ID',
 'React Native Developer',
 'Phát triển và maintain các ứng dụng mobile sử dụng React Native. Làm việc trong môi trường năng động với team trẻ trung.',
 '- Kinh nghiệm 1+ năm với React Native
- Thành thạo JavaScript/TypeScript
- Hiểu biết về Redux, React Hooks
- Có kinh nghiệm deploy app lên App Store/Play Store',
 'Hà Nội & 7 nơi khác',
 'full-time',
 12000000,
 20000000,
 'active'),

-- Job 3: Backend Developer
('YOUR_RECRUITER_ID',
 'Backend Developer (Node.js)',
 'Xây dựng và phát triển các API services cho hệ thống. Tham gia thiết kế kiến trúc hệ thống và database.',
 '- Kinh nghiệm 2+ năm với Node.js
- Thành thạo Express.js, NestJS
- Kinh nghiệm với PostgreSQL, MongoDB
- Hiểu biết về microservices, Docker',
 'Hồ Chí Minh',
 'full-time',
 18000000,
 30000000,
 'active'),

-- Job 4: UI/UX Designer
('YOUR_RECRUITER_ID',
 'UI/UX Designer',
 'Thiết kế giao diện và trải nghiệm người dùng cho các ứng dụng mobile và web. Làm việc chặt chẽ với team development.',
 '- Kinh nghiệm 1+ năm về UI/UX Design
- Thành thạo Figma, Adobe XD
- Có portfolio về mobile app design
- Hiểu biết về Design System',
 'Remote',
 'full-time',
 10000000,
 18000000,
 'active'),

-- Job 5: Intern Developer
('YOUR_RECRUITER_ID',
 'Intern Mobile Developer',
 'Cơ hội thực tập cho sinh viên năm cuối hoặc mới tốt nghiệp. Học hỏi và làm việc với các dự án thực tế.',
 '- Đang học hoặc mới tốt nghiệp ngành CNTT
- Có kiến thức cơ bản về Flutter hoặc React Native
- Nhiệt huyết, ham học hỏi
- Có thể làm việc full-time',
 'Hồ Chí Minh',
 'internship',
 5000000,
 8000000,
 'active');

-- Verify data đã insert
SELECT id, title, job_type, salary_min, salary_max, location, status 
FROM jobs 
ORDER BY created_at DESC;
