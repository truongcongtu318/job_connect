# Job Connect

**Job Connect** là nền tảng kết nối việc làm hiện đại, được xây dựng bằng **Flutter** và **Supabase**, tích hợp trí tuệ nhân tạo **Google Gemini** để hỗ trợ nhà tuyển dụng đánh giá hồ sơ ứng viên tự động.

## 🌟 Tính năng nổi bật

### 👨‍💼 Cho Ứng viên (Candidate)

- **Tìm kiếm việc làm**: Tìm kiếm theo từ khóa, địa điểm, mức lương, và loại hình công việc.
- **Ứng tuyển thông minh**: Nộp hồ sơ ứng tuyển (CV/Resume) định dạng PDF trực tiếp từ ứng dụng.
- **Quản lý hồ sơ**: Cập nhật thông tin cá nhân, kinh nghiệm, và kỹ năng.
- **Lịch sử ứng tuyển**: Theo dõi trạng thái các đơn ứng tuyển (Đang chờ, Đã duyệt, Từ chối).
- **Việc làm đã lưu**: Lưu lại các công việc quan tâm để xem sau.

### 🏢 Cho Nhà tuyển dụng (Recruiter)

- **Đăng tin tuyển dụng**: Tạo và quản lý các tin tuyển dụng với đầy đủ thông tin chi tiết.
- **Quản lý ứng viên**: Xem danh sách ứng viên nộp hồ sơ cho từng vị trí.
- **AI Rating (Tích hợp Gemini)**:
  - Tự động trích xuất nội dung từ CV (PDF).
  - Phân tích mức độ phù hợp của ứng viên với mô tả công việc.
  - Chấm điểm (Score), tóm tắt ưu/nhược điểm, và gợi ý từ khóa.
- **Dashboard**: Thống kê tổng quan về số lượng tin đăng, ứng viên, và hoạt động tuyển dụng.
- **Hồ sơ công ty**: Quản lý thông tin thương hiệu nhà tuyển dụng.

## 🛠 Công nghệ sử dụng

- **Mobile Framework**: [Flutter](https://flutter.dev) (SDK >= 3.7.2)
- **Ngôn ngữ**: Dart
- **State Management**: [Riverpod](https://riverpod.dev) (Hooks + Code Generation)
- **Backend & Database**: [Supabase](https://supabase.com) (PostgreSQL, Auth, Storage, Realtime)
- **AI Integration**: [Google Gemini API](https://ai.google.dev) (via `google_generative_ai`)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **PDF Processing**: `syncfusion_flutter_pdf`
- **UI/UX**: `flutter_screenutil`, `google_fonts`, `gap`, `shimmer`

## 🏗 Kiến trúc dự án

Dự án áp dụng kiến trúc **MVVM (Model-View-ViewModel)** kết hợp với **Repository Pattern** để đảm bảo tính tách biệt và dễ bảo trì.

```
lib/
├── config/              # Cấu hình môi trường (Env, Theme)
├── core/                # Các tiện ích cốt lõi (Constants, Utils, Routes)
├── data/                # Lớp dữ liệu
│   ├── data_sources/    # Kết nối API (Supabase, Gemini)
│   ├── models/          # Data Models (Freezed)
│   └── repositories/    # Xử lý logic dữ liệu
├── presentation/        # Lớp giao diện
│   ├── viewmodels/      # Logic UI (Riverpod Providers)
│   ├── views/           # Màn hình UI
│   └── widgets/         # Các widget tái sử dụng
└── main.dart            # Điểm khởi chạy ứng dụng
```

## 🚀 Cài đặt và Chạy dự án

### Yêu cầu tiên quyết

- Flutter SDK đã được cài đặt.
- Tài khoản Supabase.
- API Key từ Google AI Studio (Gemini).

### Các bước thực hiện

1. **Clone dự án**:

   ```bash
   git clone https://github.com/your-username/job_connect.git
   cd job_connect
   ```

2. **Cài đặt dependencies**:

   ```bash
   flutter pub get
   ```

3. **Cấu hình biến môi trường**:

   - Tạo file `.env` tại thư mục gốc (tham khảo `.env.example`).
   - Điền các thông tin cần thiết:
     ```env
     SUPABASE_URL=your_supabase_url
     SUPABASE_ANON_KEY=your_supabase_anon_key
     GEMINI_API_KEY=your_gemini_api_key
     ```

4. **Thiết lập Database (Supabase)**:

   - Tạo project mới trên Supabase.
   - Chạy các script SQL trong thư mục `sql/` (nếu có) hoặc thiết lập các bảng: `profiles`, `jobs`, `applications`, `saved_jobs`, `companies`.
   - Cấu hình Storage bucket: `avatars`, `resumes`.

5. **Chạy Code Generation**:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

6. **Chạy ứng dụng**:
   ```bash
   flutter run
   ```

## 📝 License

Dự án này là sản phẩm nội bộ/cá nhân.

---
