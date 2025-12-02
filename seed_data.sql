-- Enable UUID extension if not enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Create Tables if they don't exist

-- Saved Jobs Table
CREATE TABLE IF NOT EXISTS public.saved_jobs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    job_id UUID REFERENCES public.jobs(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, job_id)
);

-- Enable RLS and add policies for saved_jobs
ALTER TABLE public.saved_jobs ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Users can manage their own saved jobs" ON public.saved_jobs;
DROP POLICY IF EXISTS "Users can insert their own saved jobs" ON public.saved_jobs;
DROP POLICY IF EXISTS "Users can select their own saved jobs" ON public.saved_jobs;
DROP POLICY IF EXISTS "Users can delete their own saved jobs" ON public.saved_jobs;

-- Explicit policies
CREATE POLICY "Users can insert their own saved jobs" 
ON public.saved_jobs 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can select their own saved jobs" 
ON public.saved_jobs 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own saved jobs" 
ON public.saved_jobs 
FOR DELETE 
USING (auth.uid() = user_id);

-- Notifications Table
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL, -- 'application_status', 'new_job', 'system'
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS and add policies for notifications
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own notifications" ON public.notifications;
DROP POLICY IF EXISTS "Users can update their own notifications" ON public.notifications;

CREATE POLICY "Users can view their own notifications" 
ON public.notifications 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications" 
ON public.notifications 
FOR UPDATE 
USING (auth.uid() = user_id);

-- Ensure jobs are readable
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public jobs are viewable by everyone" 
ON public.jobs 
FOR SELECT 
USING (true);

-- 2. Seed Data

DO $$
DECLARE
    -- REPLACE THESE WITH REAL UUIDS FROM YOUR AUTH.USERS TABLE
    -- Recruiter 1: Tech Recruiter A
    recruiter1_id UUID := 'd5c3403d-0b6c-4d04-9e77-d4058eba4a96'; 
    -- Recruiter 2: HR Manager B (Replace this with the second user's UUID you created)
    recruiter2_id UUID := 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22'; 
BEGIN
    -- Insert Profiles
    -- We use the same UUID for id and user_id.
    INSERT INTO public.profiles (id, user_id, role, full_name, email, company_name, avatar_url)
    VALUES 
    (recruiter1_id, recruiter1_id, 'recruiter', 'Tech Recruiter A', 'recruiter.a@tech.com', 'Tech Corp', 'https://ui-avatars.com/api/?name=Tech+Corp&background=random'),
    (recruiter2_id, recruiter2_id, 'recruiter', 'HR Manager B', 'hr.b@startup.io', 'Startup IO', 'https://ui-avatars.com/api/?name=Startup+IO&background=random')
    ON CONFLICT (id) DO UPDATE SET 
        user_id = EXCLUDED.user_id,
        role = EXCLUDED.role,
        full_name = EXCLUDED.full_name,
        company_name = EXCLUDED.company_name;

    -- Insert Jobs for Recruiter 1 (Tech Corp)
    INSERT INTO public.jobs (recruiter_id, title, description, requirements, location, job_type, salary_min, salary_max, salary_currency, status, created_at)
    VALUES
    (recruiter1_id, 'Senior Flutter Developer', 'We are looking for an experienced Flutter developer to lead our mobile team.', '- 5+ years experience\n- Strong knowledge of Dart\n- State management (Riverpod/Bloc)', 'Ho Chi Minh City', 'Full-time', 20000000, 40000000, 'VND', 'active', NOW() - INTERVAL '2 days'),
    (recruiter1_id, 'Backend Node.js Engineer', 'Join our backend team to build scalable APIs.', '- Node.js, Express/NestJS\n- PostgreSQL\n- Docker/Kubernetes', 'Remote', 'Full-time', 18000000, 35000000, 'VND', 'active', NOW() - INTERVAL '5 days'),
    (recruiter1_id, 'UI/UX Designer', 'Design beautiful interfaces for our products.', '- Figma mastery\n- User research experience', 'Ha Noi', 'Part-time', 10000000, 20000000, 'VND', 'active', NOW() - INTERVAL '1 week');

    -- Insert Jobs for Recruiter 2 (Startup IO)
    INSERT INTO public.jobs (recruiter_id, title, description, requirements, location, job_type, salary_min, salary_max, salary_currency, status, created_at)
    VALUES
    (recruiter2_id, 'Marketing Executive', 'Drive our growth through creative marketing campaigns.', '- Social media marketing\n- Content creation', 'Da Nang', 'Full-time', 12000000, 18000000, 'VND', 'active', NOW() - INTERVAL '1 day'),
    (recruiter2_id, 'React Native Developer', 'Build cross-platform apps.', '- React Native\n- TypeScript\n- Redux', 'Ho Chi Minh City', 'Contract', 25000000, 45000000, 'VND', 'active', NOW() - INTERVAL '3 hours'),
    (recruiter2_id, 'Product Owner', 'Lead the product vision.', '- Agile/Scrum\n- Product roadmap', 'Remote', 'Full-time', 30000000, 50000000, 'VND', 'active', NOW() - INTERVAL '4 days');

    -- Insert some more random jobs
    INSERT INTO public.jobs (recruiter_id, title, description, requirements, location, job_type, salary_min, salary_max, salary_currency, status, created_at)
    VALUES
    (recruiter1_id, 'Junior Tester', 'Manual and automated testing.', '- Detail oriented\n- Basic coding skills', 'Ho Chi Minh City', 'Internship', 5000000, 8000000, 'VND', 'active', NOW() - INTERVAL '6 hours'),
    (recruiter2_id, 'Sales Manager', 'Lead our sales team.', '- B2B sales experience\n- Leadership', 'Ha Noi', 'Full-time', 20000000, 30000000, 'VND', 'active', NOW() - INTERVAL '12 hours');

END $$;
