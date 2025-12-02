/// App-wide constants
class AppConstants {
  AppConstants._();

  // App information
  static const String appName = 'Job Connect';
  static const String appVersion = '1.0.0';

  // API endpoints
  static const int apiTimeout = 30000; // 30 seconds

  // Pagination
  static const int itemsPerPage = 20;

  // File upload limits
  static const int maxResumeFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedResumeExtensions = ['pdf', 'doc', 'docx'];

  // AI Rating thresholds
  static const double aiScoreMin = 0.0;
  static const double aiScoreMax = 10.0;
  static const double aiGoodScoreThreshold = 7.0;
  static const double aiAverageScoreThreshold = 5.0;

  // Application status
  static const String statusPending = 'pending';
  static const String statusReviewing = 'reviewing';
  static const String statusShortlisted = 'shortlisted';
  static const String statusRejected = 'rejected';
  static const String statusAccepted = 'accepted';

  // Job status
  static const String jobStatusActive = 'active';
  static const String jobStatusClosed = 'closed';
  static const String jobStatusDraft = 'draft';

  // User roles
  static const String roleCandidate = 'candidate';
  static const String roleRecruiter = 'recruiter';
  static const String roleAdmin = 'admin';

  // Date formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Storage bucket names (Supabase)
  static const String resumesBucket = 'resumes';
  static const String avatarsBucket = 'avatars';
}
