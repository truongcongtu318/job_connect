/// String constants used throughout the app
class AppStrings {
  AppStrings._();

  // Common
  static const String ok = 'OK';
  static const String cancel = 'Hủy';
  static const String save = 'Lưu';
  static const String delete = 'Xóa';
  static const String edit = 'Sửa';
  static const String search = 'Tìm kiếm';
  static const String filter = 'Lọc';
  static const String apply = 'Ứng tuyển';
  static const String loading = 'Đang tải...';
  static const String error = 'Lỗi';
  static const String success = 'Thành công';

  // Auth
  static const String login = 'Đăng nhập';
  static const String register = 'Đăng ký';
  static const String logout = 'Đăng xuất';
  static const String email = 'Email';
  static const String password = 'Mật khẩu';
  static const String confirmPassword = 'Xác nhận mật khẩu';
  static const String fullName = 'Họ và tên';
  static const String phone = 'Số điện thoại';
  static const String forgotPassword = 'Quên mật khẩu?';
  static const String dontHaveAccount = 'Chưa có tài khoản?';
  static const String alreadyHaveAccount = 'Đã có tài khoản?';

  // Role selection
  static const String selectRole = 'Chọn vai trò';
  static const String candidate = 'Người tìm việc';
  static const String recruiter = 'Nhà tuyển dụng';
  static const String candidateDesc = 'Tìm kiếm và ứng tuyển công việc';
  static const String recruiterDesc = 'Đăng tin và tuyển dụng ứng viên';

  // Jobs
  static const String jobs = 'Công việc';
  static const String jobTitle = 'Tiêu đề công việc';
  static const String jobDescription = 'Mô tả công việc';
  static const String jobRequirements = 'Yêu cầu công việc';
  static const String location = 'Địa điểm';
  static const String salary = 'Mức lương';
  static const String jobType = 'Loại công việc';
  static const String createJob = 'Tạo tin tuyển dụng';
  static const String editJob = 'Sửa tin tuyển dụng';
  static const String myJobs = 'Tin của tôi';

  // Applications
  static const String applications = 'Đơn ứng tuyển';
  static const String myApplications = 'Đơn của tôi';
  static const String applicants = 'Ứng viên';
  static const String resume = 'Hồ sơ / CV';
  static const String coverLetter = 'Thư xin việc';
  static const String uploadResume = 'Tải lên hồ sơ';
  static const String viewResume = 'Xem hồ sơ';
  static const String applicationStatus = 'Trạng thái';

  // AI Rating
  static const String aiRating = 'Đánh giá AI';
  static const String analyzeWithAI = 'Phân tích bằng AI';
  static const String aiInsights = 'Nhận xét AI';
  static const String overallScore = 'Điểm tổng thể';
  static const String skillMatch = 'Phù hợp kỹ năng';
  static const String experienceScore = 'Kinh nghiệm';
  static const String educationScore = 'Học vấn';
  static const String aiAnalyzing = 'AI đang phân tích...';
  static const String batchAnalyze = 'Phân tích hàng loạt';

  // Profile
  static const String profile = 'Hồ sơ';
  static const String editProfile = 'Sửa hồ sơ';
  static const String companyName = 'Tên công ty';

  // Error messages
  static const String errorOccurred = 'Đã xảy ra lỗi';
  static const String errorNetwork = 'Lỗi kết nối mạng';
  static const String errorInvalidCredentials =
      'Email hoặc mật khẩu không đúng';
  static const String errorEmailExists = 'Email đã được sử dụng';
  static const String errorFieldRequired = 'Trường này không được để trống';
  static const String errorInvalidEmail = 'Email không hợp lệ';
  static const String errorPasswordTooShort =
      'Mật khẩu phải có ít nhất 6 ký tự';
  static const String errorPasswordNotMatch = 'Mật khẩu xác nhận không khớp';

  // Success messages
  static const String successLogin = 'Đăng nhập thành công';
  static const String successRegister = 'Đăng ký thành công';
  static const String successJobCreated = 'Tạo tin tuyển dụng thành công';
  static const String successApplicationSubmitted = 'Ứng tuyển thành công';
  static const String successProfileUpdated = 'Cập nhật hồ sơ thành công';
}
