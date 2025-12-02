-- Job Connect Database Schema for Supabase

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table (extends Supabase auth.users)
CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('candidate', 'recruiter', 'admin')),
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    avatar_url TEXT,
    resume_url TEXT, -- For candidates
    company_name TEXT, -- For recruiters
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Jobs table
CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recruiter_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT NOT NULL,
    location TEXT,
    job_type TEXT CHECK (job_type IN ('full-time', 'part-time', 'contract', 'internship')),
    salary_min NUMERIC,
    salary_max NUMERIC,
    salary_currency TEXT DEFAULT 'VND',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'closed', 'draft')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Applications table
CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE NOT NULL,
    candidate_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    resume_url TEXT NOT NULL,
    cover_letter TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewing', 'shortlisted', 'rejected', 'accepted')),
    applied_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(job_id, candidate_id) -- One application per candidate per job
);

-- AI Ratings table
CREATE TABLE ai_ratings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID REFERENCES applications(id) ON DELETE CASCADE UNIQUE NOT NULL,
    overall_score NUMERIC(3,1) CHECK (overall_score >= 0 AND overall_score <= 10),
    skill_match_score NUMERIC(3,1) CHECK (skill_match_score >= 0 AND skill_match_score <= 10),
    experience_score NUMERIC(3,1) CHECK (experience_score >= 0 AND experience_score <= 10),
    education_score NUMERIC(3,1) CHECK (education_score >= 0 AND education_score <= 10),
    insights JSONB, -- Detailed AI analysis
    summary TEXT, -- Brief summary
    analyzed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_jobs_recruiter_id ON jobs(recruiter_id);
CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_applications_job_id ON applications(job_id);
CREATE INDEX idx_applications_candidate_id ON applications(candidate_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_ai_ratings_application_id ON ai_ratings(application_id);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_ratings ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
CREATE POLICY "Users can view all profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = user_id);

-- Fixed: Allow authenticated users to insert their own profile
CREATE POLICY "Users can insert own profile" ON profiles 
FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- RLS Policies for jobs
CREATE POLICY "Anyone can view active jobs" ON jobs FOR SELECT USING (status = 'active' OR recruiter_id IN (SELECT id FROM profiles WHERE user_id = auth.uid()));
CREATE POLICY "Recruiters can create jobs" ON jobs FOR INSERT WITH CHECK (recruiter_id IN (SELECT id FROM profiles WHERE user_id = auth.uid() AND role = 'recruiter'));
CREATE POLICY "Recruiters can update own jobs" ON jobs FOR UPDATE USING (recruiter_id IN (SELECT id FROM profiles WHERE user_id = auth.uid() AND role = 'recruiter'));
CREATE POLICY "Recruiters can delete own jobs" ON jobs FOR DELETE USING (recruiter_id IN (SELECT id FROM profiles WHERE user_id = auth.uid() AND role = 'recruiter'));

-- RLS Policies for applications
CREATE POLICY "Candidates can view own applications" ON applications FOR SELECT USING (
    candidate_id IN (SELECT id FROM profiles WHERE user_id = auth.uid())
    OR
    job_id IN (SELECT id FROM jobs WHERE recruiter_id IN (SELECT id FROM profiles WHERE user_id = auth.uid()))
);
CREATE POLICY "Candidates can create applications" ON applications FOR INSERT WITH CHECK (candidate_id IN (SELECT id FROM profiles WHERE user_id = auth.uid() AND role = 'candidate'));
CREATE POLICY "Candidates can update own applications" ON applications FOR UPDATE USING (candidate_id IN (SELECT id FROM profiles WHERE user_id = auth.uid()));

-- RLS Policies for ai_ratings
CREATE POLICY "Recruiters can view ratings for their jobs" ON ai_ratings FOR SELECT USING (
    application_id IN (
        SELECT a.id FROM applications a
        JOIN jobs j ON a.job_id = j.id
        WHERE j.recruiter_id IN (SELECT id FROM profiles WHERE user_id = auth.uid())
    )
);
CREATE POLICY "Recruiters can create ratings" ON ai_ratings FOR INSERT WITH CHECK (
    application_id IN (
        SELECT a.id FROM applications a
        JOIN jobs j ON a.job_id = j.id
        WHERE j.recruiter_id IN (SELECT id FROM profiles WHERE user_id = auth.uid() AND role = 'recruiter')
    )
);
CREATE POLICY "Recruiters can update ratings" ON ai_ratings FOR UPDATE USING (
    application_id IN (
        SELECT a.id FROM applications a
        JOIN jobs j ON a.job_id = j.id
        WHERE j.recruiter_id IN (SELECT id FROM profiles WHERE user_id = auth.uid())
    )
);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_jobs_updated_at BEFORE UPDATE ON jobs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_applications_updated_at BEFORE UPDATE ON applications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
