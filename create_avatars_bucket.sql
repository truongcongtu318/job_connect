-- Create avatars bucket
INSERT INTO storage.buckets (id, name, public) 
VALUES ('avatars', 'avatars', true);

-- Policy: Anyone can view avatars
CREATE POLICY "Avatar Public Access" 
ON storage.objects FOR SELECT 
USING ( bucket_id = 'avatars' );

-- Policy: Authenticated users can upload their own avatar
-- Assumes path structure: userId/filename
CREATE POLICY "Users can upload own avatar" 
ON storage.objects FOR INSERT 
TO authenticated 
WITH CHECK ( bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text );

-- Policy: Authenticated users can update their own avatar
CREATE POLICY "Users can update own avatar" 
ON storage.objects FOR UPDATE
TO authenticated 
USING ( bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text );

-- Policy: Authenticated users can delete their own avatar
CREATE POLICY "Users can delete own avatar" 
ON storage.objects FOR DELETE
TO authenticated 
USING ( bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text );
