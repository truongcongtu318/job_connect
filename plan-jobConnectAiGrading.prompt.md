# Plan: Job Connect App with AI-Powered Candidate Evaluation

Building a Flutter app connecting job seekers and recruiters with Gemini AI-powered candidate profile grading. Your current tech stack (Supabase, Riverpod, AutoRoute, Freezed, Flutter Hooks, Google Generative AI) is perfectly aligned with Flutter 3.29.3 and the provided coding guidelines.

## Steps

1. **Set up Supabase database schema** - Create tables for `users`, `user_profiles`, `job_postings`, `applications`, `ai_evaluations` with proper RLS policies in Supabase Dashboard, ensuring createdAt, updatedAt, isDeleted fields

2. **Implement authentication flow** - Build auth screens in `lib/features/auth/` using `supabase_flutter` auth methods, create providers with `@riverpod` annotation, and configure routes in app_router.dart

3. **Build candidate features** - Create profile management, job browsing, and application submission screens in `lib/features/candidate/` using ConsumerWidget/HookConsumerWidget with AsyncValue for state management

4. **Develop recruiter features** - Implement job posting creation, applicant list viewing, and profile details in `lib/features/recruiter/` with list optimizations using ListView.builder

5. **Integrate Gemini AI grading system** - Build AI evaluation service in `lib/features/ai_grading/` using `google_generative_ai` package, create prompts for candidate assessment, and store results in Supabase with proper error handling

6. **Create shared models and services** - Define Freezed data classes with `@JsonSerializable(fieldRename: FieldRename.snake)` in `lib/core/`, implement repository pattern for Supabase operations, and use `fpdart` for functional error handling

## Further Considerations

1. **User role management** - Implement role-based access (candidate/recruiter) using Supabase RLS policies or metadata in user profiles, or support dual-role users?

2. **AI evaluation criteria** - Define specific grading parameters (skills match, experience relevance, education fit) and scoring system (0-100, letter grades, or tier ranking)?

3. **Real-time features** - Consider using Supabase Realtime for instant application notifications and status updates for better UX?

4. **File handling** - Plan for resume/CV uploads using Supabase Storage with proper file type validation and size limits, integrate with AI for document parsing?

