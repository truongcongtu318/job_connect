import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/config/env_config.dart';
import 'package:job_connect/core/routes/app_router.dart';
import 'package:job_connect/core/theme/app_theme.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/data_sources/gemini_service.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  await EnvConfig.init();

  // Validate environment variables
  final isValid = EnvConfig.validate();
  if (!isValid) {
    AppLogger.warning(
      'Environment variables not configured. Please create .env file with required credentials.',
    );
  }

  // Initialize services
  try {
    if (isValid) {
      await SupabaseService.init();
      GeminiService.init();
      AppLogger.info('All services initialized successfully');
    } else {
      AppLogger.warning(
        'Skipping service initialization due to missing credentials',
      );
    }
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize services', e, stackTrace);
    // Continue anyway for development
  }

  runApp(const ProviderScope(child: JobConnectApp()));
}

class JobConnectApp extends StatelessWidget {
  const JobConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Job Connect',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
