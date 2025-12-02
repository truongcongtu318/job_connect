-- Setup Supabase Storage for Resume Uploads
-- Run this in Supabase SQL Editor

-- 1. Create storage bucket for resumes (if not exists)
INSERT INTO storage.buckets (id, name, public)
VALUES ('resumes', 'resumes', false)
ON CONFLICT (id) DO NOTHING;

-- 2. Enable RLS on storage.objects
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- 3. Policy: Users can upload their own resumes
CREATE POLICY "Users can upload own resumes"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'resumes' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- 4. Policy: Users can view their own resumes
CREATE POLICY "Users can view own resumes"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'resumes' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- 5. Policy: Recruiters can view resumes of applicants for their jobs
CREATE POLICY "Recruiters can view applicant resumes"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'resumes' AND
  EXISTS (
    SELECT 1 FROM applications a
    JOIN jobs j ON a.job_id = j.id
    WHERE j.recruiter_id IN (
      SELECT id FROM profiles WHERE user_id = auth.uid() AND role = 'recruiter'
    )
    AND a.resume_url LIKE '%' || name || '%'
  )
);

-- 6. Policy: Users can delete their own resumes
CREATE POLICY "Users can delete own resumes"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'resumes' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Verify setup
SELECT * FROM storage.buckets WHERE id = 'resumes';
