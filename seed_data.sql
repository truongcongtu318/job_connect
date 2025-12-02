-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Clean up existing data (Safe to run if tables are empty)
TRUNCATE TABLE public.notifications CASCADE;
TRUNCATE TABLE public.saved_jobs CASCADE;
TRUNCATE TABLE public.applications CASCADE;
TRUNCATE TABLE public.jobs CASCADE;
TRUNCATE TABLE public.profiles CASCADE;
TRUNCATE TABLE public.companies CASCADE;

-- 2. Fix Schema & Constraints (Run this BEFORE inserting data)

-- 2.1 Fix Jobs Constraints
ALTER TABLE public.jobs DROP CONSTRAINT IF EXISTS jobs_job_type_check;
ALTER TABLE public.jobs ADD CONSTRAINT jobs_job_type_check CHECK (job_type IN ('Full-time', 'Part-time', 'Contract', 'Freelance', 'Internship'));

-- 2.2 Fix Applications Schema (Add created_at if missing)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'applications' AND column_name = 'created_at') THEN
        ALTER TABLE public.applications ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'applications' AND column_name = 'updated_at') THEN
        ALTER TABLE public.applications ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now());
    END IF;
END $$;

-- 3. Variables for User IDs (Provided by User)
DO $$
DECLARE
    -- User IDs provided by user
    recruiter1_id UUID := 'a5c32961-8da7-4586-a09e-900f7ca5ed34';
    recruiter2_id UUID := 'd5c3403d-0b6c-4d04-9e77-d4058eba4a96';
    candidate1_id UUID := 'bef2261b-48d9-4926-9c58-c5f18b01e32c';
    candidate2_id UUID := 'd5497216-1e7e-44a5-ae03-a1684d26790a';

    -- Generated IDs for Companies and Jobs
    company1_id UUID;
    company2_id UUID;
    job1_id UUID;
    job2_id UUID;
    job3_id UUID;
    job4_id UUID;
    job5_id UUID;
BEGIN
    -- 4. Insert Companies
    INSERT INTO public.companies (name, description, logo_url, website, address)
    VALUES 
    ('Tech Corp', 'Tập đoàn công nghệ hàng đầu chuyên về các giải pháp phần mềm doanh nghiệp và AI.', 'https://ui-avatars.com/api/?name=Tech+Corp&background=0D8ABC&color=fff&size=128', 'https://techcorp.com', '123 Đường Công Nghệ, Q.9, TP.HCM')
    RETURNING id INTO company1_id;

    INSERT INTO public.companies (name, description, logo_url, website, address)
    VALUES 
    ('Startup IO', 'Startup năng động tập trung vào phát triển ứng dụng di động và thương mại điện tử.', 'https://ui-avatars.com/api/?name=Startup+IO&background=FF5722&color=fff&size=128', 'https://startup.io', '456 Đường Khởi Nghiệp, Q.3, TP.HCM')
    RETURNING id INTO company2_id;

    -- 5. Insert Profiles
    -- Recruiter 1 (Tech Corp)
    INSERT INTO public.profiles (id, user_id, role, full_name, email, company_name, avatar_url, company_id)
    VALUES 
    (recruiter1_id, recruiter1_id, 'recruiter', 'Nguyễn Văn Tuyển (HR Tech Corp)', 'hr.tech@example.com', 'Tech Corp', 'https://ui-avatars.com/api/?name=Nguyen+Tuyen&background=random', company1_id);

    -- Recruiter 2 (Startup IO)
    INSERT INTO public.profiles (id, user_id, role, full_name, email, company_name, avatar_url, company_id)
    VALUES 
    (recruiter2_id, recruiter2_id, 'recruiter', 'Trần Thị HR (Startup IO)', 'hr.startup@example.com', 'Startup IO', 'https://ui-avatars.com/api/?name=Tran+HR&background=random', company2_id);

    -- Candidate 1
    INSERT INTO public.profiles (id, user_id, role, full_name, email, avatar_url, resume_url)
    VALUES 
    (candidate1_id, candidate1_id, 'candidate', 'Lê Văn Ứng Viên', 'candidate1@example.com', 'https://ui-avatars.com/api/?name=Le+Ung+Vien&background=random', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');

    -- Candidate 2
    INSERT INTO public.profiles (id, user_id, role, full_name, email, avatar_url)
    VALUES 
    (candidate2_id, candidate2_id, 'candidate', 'Phạm Thị Developer', 'candidate2@example.com', 'https://ui-avatars.com/api/?name=Pham+Dev&background=random');

    -- 6. Insert Jobs
    -- Jobs for Tech Corp (Recruiter 1)
    INSERT INTO public.jobs (recruiter_id, company_id, title, description, requirements, benefits, location, job_type, salary_min, salary_max, salary_currency, status, created_at)
    VALUES
    (recruiter1_id, company1_id, 'Senior Flutter Developer', 'Chúng tôi đang tìm kiếm Senior Flutter Developer để dẫn dắt team mobile. Bạn sẽ chịu trách nhiệm thiết kế kiến trúc và phát triển các tính năng cốt lõi.', '- Ít nhất 4 năm kinh nghiệm với Mobile Development\n- 2+ năm kinh nghiệm với Flutter\n- Hiểu sâu về State Management (Bloc, Riverpod)\n- Có kinh nghiệm CI/CD là điểm cộng', '- Lương tháng 13 + Thưởng hiệu suất\n- Macbook Pro M2 được cung cấp\n- Bảo hiểm sức khỏe cao cấp\n- Review lương 2 lần/năm', 'Hồ Chí Minh', 'Full-time', 30000000, 50000000, 'VND', 'active', NOW() - INTERVAL '1 day') RETURNING id INTO job1_id;

    INSERT INTO public.jobs (recruiter_id, company_id, title, description, requirements, benefits, location, job_type, salary_min, salary_max, salary_currency, status, created_at)
    VALUES
    (recruiter1_id, company1_id, 'Backend Golang Engineer', 'Tham gia xây dựng hệ thống Microservices chịu tải cao.', '- Thành thạo Golang\n- Kinh nghiệm với Docker, Kubernetes\n- Hiểu biết về Database (PostgreSQL, Redis)', '- Môi trường làm việc Agile\n- Canteen miễn phí\n- Teambuilding hàng quý', 'Hà Nội', 'Full-time', 25000000, 45000000, 'VND', 'active', NOW() - INTERVAL '3 days') RETURNING id INTO job2_id;

    INSERT INTO public.jobs (recruiter_id, company_id, title, description, requirements, benefits, location, job_type, salary_min, salary_max, salary_currency, status, created_at)
    VALUES
    (recruiter1_id, company1_id, 'DevOps Engineer', 'Vận hành và tối ưu hóa hệ thống hạ tầng.', '- Kinh nghiệm AWS/GCP\n- Scripting (Bash, Python)\n- Monitoring (Prometheus, Grafana)', '- Chứng chỉ AWS được tài trợ\n- Làm việc Remote linh hoạt', 'Remote', 'Full-time', 35000000, 60000000, 'VND', 'active', NOW() - INTERVAL '5 days');

    -- Jobs for Startup IO (Recruiter 2)
    INSERT INTO public.jobs (recruiter_id, company_id, title, description, requirements, benefits, location, job_type, salary_min, salary_max, salary_currency, status, created_at)
    VALUES
    (recruiter2_id, company2_id, 'React Native Developer', 'Phát triển ứng dụng thương mại điện tử đa nền tảng.', '- React Native, TypeScript\n- Redux Toolkit\n- Có tư duy UI/UX tốt', '- Stock options cho nhân viên sớm\n- Môi trường trẻ trung, năng động\n- Trà sữa, snack miễn phí', 'Đà Nẵng', 'Full-time', 15000000, 30000000, 'VND', 'active', NOW() - INTERVAL '2 hours') RETURNING id INTO job3_id;

    INSERT INTO public.jobs (recruiter_id, company_id, title, description, requirements, benefits, location, job_type, salary_min, salary_max, salary_currency, status, created_at)
    VALUES
    (recruiter2_id, company2_id, 'Marketing Executive', 'Lên kế hoạch và thực thi các chiến dịch Marketing.', '- Kinh nghiệm Digital Marketing\n- Sáng tạo, chủ động\n- Tiếng Anh giao tiếp tốt', '- Hoa hồng theo doanh số\n- Được đào tạo chuyên sâu', 'Hồ Chí Minh', 'Part-time', 8000000, 15000000, 'VND', 'active', NOW() - INTERVAL '1 week') RETURNING id INTO job4_id;

    INSERT INTO public.jobs (recruiter_id, company_id, title, description, requirements, benefits, location, job_type, salary_min, salary_max, salary_currency, status, created_at)
    VALUES
    (recruiter2_id, company2_id, 'Product Owner', 'Định hướng phát triển sản phẩm.', '- Kinh nghiệm làm Product > 2 năm\n- Kỹ năng giao tiếp và phân tích tốt', '- Lương cạnh tranh\n- Cơ hội thăng tiến lên CPO', 'Hồ Chí Minh', 'Full-time', 40000000, 70000000, 'VND', 'active', NOW() - INTERVAL '12 hours') RETURNING id INTO job5_id;

    -- 7. Insert Saved Jobs
    -- Candidate 1 saves Job 1 and Job 3
    INSERT INTO public.saved_jobs (user_id, job_id) VALUES (candidate1_id, job1_id);
    INSERT INTO public.saved_jobs (user_id, job_id) VALUES (candidate1_id, job3_id);
    
    -- Candidate 2 saves Job 2
    INSERT INTO public.saved_jobs (user_id, job_id) VALUES (candidate2_id, job2_id);

    -- 8. Insert Notifications
    -- Notify Candidate 1
    INSERT INTO public.notifications (user_id, title, message, type, is_read, created_at)
    VALUES 
    (candidate1_id, 'Việc làm phù hợp mới', 'Có một công việc Flutter mới phù hợp với hồ sơ của bạn tại Tech Corp.', 'new_job', false, NOW() - INTERVAL '1 hour'),
    (candidate1_id, 'Chào mừng', 'Chào mừng bạn đến với Job Connect! Hãy cập nhật hồ sơ để nhà tuyển dụng dễ dàng tìm thấy bạn.', 'system', true, NOW() - INTERVAL '2 days');

    -- Notify Recruiter 1
    INSERT INTO public.notifications (user_id, title, message, type, is_read, created_at)
    VALUES 
    (recruiter1_id, 'Ứng viên mới', 'Lê Văn Ứng Viên vừa nộp đơn vào vị trí Senior Flutter Developer.', 'application_status', false, NOW() - INTERVAL '30 minutes');

    -- 9. Insert Applications (Optional but good for testing)
    -- Candidate 1 applies to Job 1 (Flutter)
    INSERT INTO public.applications (job_id, candidate_id, status, cover_letter, created_at)
    VALUES 
    (job1_id, candidate1_id, 'pending', 'Tôi rất yêu thích Tech Corp và mong muốn được cống hiến.', NOW() - INTERVAL '30 minutes');

    -- Candidate 2 applies to Job 2 (Golang)
    INSERT INTO public.applications (job_id, candidate_id, status, cover_letter, created_at)
    VALUES 
    (job2_id, candidate2_id, 'reviewed', 'Tôi có kinh nghiệm làm việc với Golang 3 năm.', NOW() - INTERVAL '1 day');

END $$;
