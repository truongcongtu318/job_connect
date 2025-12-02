# Job Connect

Ứng dụng kết nối việc làm với tính năng AI Rating dành cho nhà tuyển dụng.

## Tính năng chính

- **Cho ứng viên (Mobile App)**:

  - Tìm kiếm và xem danh sách công việc
  - Ứng tuyển với CV/Resume
  - Theo dõi trạng thái đơn ứng tuyển
  - Quản lý hồ sơ cá nhân

- **Cho nhà tuyển dụng (Web App)**:

  - Đăng tin tuyển dụng
  - Xem danh sách ứng viên
  - **Phân tích hồ sơ ứng viên bằng AI (Gemini)**
  - Quản lý trạng thái ứng tuyển

- **Cho quản trị viên (Web App)**:
  - Quản lý người dùng
  - Thống kê và báo cáo

## Công nghệ

- **Framework**: Flutter (Mobile + Web)
- **State Management**: Riverpod + Freezed + Hooks
- **Navigation**: Go Router
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **AI**: Google Gemini API
- **UI**: Flutter ScreenUtil + Google Fonts

## Kiến trúc

Dự án sử dụng kiến trúc **MVVM (Model-View-ViewModel)**:

```
lib/
├── config/              # Environment configuration
├── core/                # Core utilities, constants, theme, routes
├── data/                # Data layer (models, repositories, data sources)
├── presentation/        # Presentation layer (views, viewmodels, widgets)
└── main.dart            # App entry point
```

## Cài đặt

### Yêu cầu

- Flutter SDK >= 3.7.2
- Dart SDK >= 3.7.2
- Tài khoản Supabase (https://supabase.com)
- Google Gemini API Key (https://ai.google.dev)

### Các bước cài đặt

1. **Clone repository và cài đặt dependencies**:

```bash
flutter pub get
```

2. **Tạo file .env**:

```bash
cp .env.example .env
```

3. **Cấu hình file .env** với thông tin của bạn:

```env
SUPABASE_URL=your_supabase_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here
GEMINI_API_KEY=your_gemini_api_key_here
```

4. **Tạo database trên Supabase**:

- Truy cập Supabase Dashboard
- Tạo project mới
- Vào SQL Editor và chạy file `supabase_schema.sql`

5. **Generate code với build_runner**:

```bash
dart run build_runner build --delete-conflicting-outputs
```

6. **Chạy ứng dụng**:

Mobile (iOS/Android):

```bash
flutter run
```

Web:

```bash
flutter run -d chrome
```

## Phát triển

### Generate Freezed và Riverpod code

Sau khi thay đổi models hoặc providers:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Hoặc watch mode:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Structure thư mục

- `lib/config/`: Cấu hình môi trường
- `lib/core/constants/`: Hằng số, màu sắc, chuỗi
- `lib/core/theme/`: Theme configuration
- `lib/core/routes/`: Go Router configuration
- `lib/core/utils/`: Utilities và extensions
- `lib/data/models/`: Freezed data models
- `lib/data/repositories/`: Repository pattern
- `lib/data/data_sources/`: Supabase và Gemini clients
- `lib/presentation/views/`: UI screens
- `lib/presentation/viewmodels/`: Riverpod ViewModels
- `lib/presentation/widgets/`: Reusable widgets

## Trạng thái dự án

✅ Base project structure
✅ Dependencies configured
✅ Database schema
✅ Data layer (models, repositories)
✅ Core configuration (theme, routes, constants)
✅ Placeholder screens

🚧 To be implemented:

- Authentication UI và logic
- Job listing và detail screens
- Application submission
- AI Rating integration
- Recruiter dashboard
- Admin panel

## License

Private project - All rights reserved
