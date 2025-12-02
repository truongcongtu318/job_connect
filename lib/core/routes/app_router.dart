import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';
import 'package:job_connect/presentation/views/auth/login_screen.dart';
import 'package:job_connect/presentation/views/auth/register_screen.dart';
import 'package:job_connect/presentation/views/auth/role_selection_screen.dart';
import 'package:job_connect/presentation/views/candidate/job_list_screen.dart';
import 'package:job_connect/presentation/views/candidate/job_detail_screen.dart';
import 'package:job_connect/presentation/views/candidate/job_application_screen.dart';
import 'package:job_connect/presentation/views/candidate/application_history_screen.dart';
import 'package:job_connect/presentation/views/candidate/saved_jobs_screen.dart';
import 'package:job_connect/presentation/views/common/notification_screen.dart';
import 'package:job_connect/presentation/views/candidate/profile_screen.dart';
import 'package:job_connect/presentation/views/candidate/edit_profile_screen.dart';
import 'package:job_connect/presentation/views/recruiter/dashboard_screen.dart';
import 'package:job_connect/presentation/views/recruiter/recruiter_login_screen.dart';
import 'package:job_connect/presentation/views/recruiter/job_posting_screen.dart';
import 'package:job_connect/presentation/views/recruiter/applicant_list_screen.dart';
import 'package:job_connect/presentation/views/recruiter/applicant_detail_screen.dart';
import 'package:job_connect/presentation/views/candidate/main_layout.dart';

/// App router configuration using go_router
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = SupabaseService.isAuthenticated;
      final currentUser = SupabaseService.currentUser;
      final userRole = currentUser?.role;

      final isAuthRoute =
          state.matchedLocation.startsWith('/auth') ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/role-selection' ||
          state.matchedLocation == '/recruiter/login';

      // If not authenticated and not on auth route, redirect to appropriate login
      if (!isAuthenticated && !isAuthRoute) {
        // Check if trying to access recruiter routes
        if (state.matchedLocation.startsWith('/recruiter')) {
          return '/recruiter/login';
        }
        return '/login';
      }

      // If authenticated, check role-based access
      if (isAuthenticated && userRole != null) {
        // Prevent recruiters from accessing candidate routes
        if (userRole == 'recruiter' &&
            (state.matchedLocation.startsWith('/jobs') ||
                state.matchedLocation.startsWith('/applications') ||
                state.matchedLocation.startsWith('/profile'))) {
          return '/recruiter/dashboard';
        }

        // Prevent candidates from accessing recruiter routes
        if (userRole == 'candidate' &&
            state.matchedLocation.startsWith('/recruiter')) {
          return '/jobs';
        }
      }

      return null; // No redirect needed
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        name: 'role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      // Candidate routes with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Jobs
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/jobs',
                name: 'jobs',
                builder: (context, state) => const JobListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'job-detail',
                    parentNavigatorKey: rootNavigatorKey, // Hide bottom nav
                    builder: (context, state) {
                      final jobId = state.pathParameters['id']!;
                      return JobDetailScreen(jobId: jobId);
                    },
                    routes: [
                      GoRoute(
                        path: 'apply',
                        name: 'job-application',
                        parentNavigatorKey: rootNavigatorKey, // Hide bottom nav
                        builder: (context, state) {
                          final jobId = state.pathParameters['id']!;
                          return JobApplicationScreen(jobId: jobId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Tab 2: Applications
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/applications',
                name: 'applications',
                builder: (context, state) => const ApplicationHistoryScreen(),
              ),
            ],
          ),

          // Tab 3: Saved Jobs
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved-jobs',
                name: 'saved-jobs',
                builder: (context, state) => const SavedJobsScreen(),
              ),
            ],
          ),

          // Tab 4: Notifications
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                name: 'notifications',
                builder: (context, state) => const NotificationScreen(),
              ),
            ],
          ),

          // Tab 5: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'edit-profile',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Recruiter routes
      GoRoute(
        path: '/recruiter/login',
        name: 'recruiter-login',
        builder: (context, state) => const RecruiterLoginScreen(),
      ),
      GoRoute(
        path: '/recruiter/dashboard',
        name: 'recruiter-dashboard',
        builder: (context, state) => const RecruiterDashboardScreen(),
      ),
      GoRoute(
        path: '/recruiter/jobs/new',
        name: 'job-posting',
        builder: (context, state) => const JobPostingScreen(),
      ),
      GoRoute(
        path: '/recruiter/jobs/:jobId/applicants',
        name: 'applicant-list',
        builder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          return ApplicantListScreen(jobId: jobId);
        },
        routes: [
          GoRoute(
            path: ':applicationId',
            name: 'applicant-detail',
            builder: (context, state) {
              final applicationId = state.pathParameters['applicationId']!;
              return ApplicantDetailScreen(applicationId: applicationId);
            },
          ),
        ],
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('Page not found: ${state.matchedLocation}')),
        ),
  );
}
