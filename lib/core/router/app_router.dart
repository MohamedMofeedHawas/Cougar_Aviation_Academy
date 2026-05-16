import 'package:cougar_app/blog_and_news.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../accommodations_page.dart';
import '../../features/courses/data/models/course_detail_page.dart';
import '../services/service_locator.dart';
import '../services/prefs_service.dart';

// Import pages
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/courses/presentation/pages/courses_page.dart';
import '../../features/fleet/presentation/pages/fleet_page.dart';
import '../../features/gallery/presentation/pages/gallery_page.dart';
import '../../features/contact/presentation/pages/contact_page.dart';

/// [AppRouter] manages the navigation flow of the application.
/// It includes route guards for authentication and first launch.
class AppRouter {
  AppRouter._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String about = '/about';
  static const String courses = '/courses';
  static const String fleet = '/fleet';
  static const String accommodations = '/accommodations';
  static const String contact = '/contact';
  static const String blogsAndNews = '/blogsAndNews';

  static final router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final prefs = sl<PrefsService>();
      final bool isFirstLaunch = prefs.isFirstLaunch;
      final bool isLoggedIn = prefs.token != null;

      final bool isSplashing = state.matchedLocation == splash;
      final bool isOnboarding = state.matchedLocation == onboarding;
      final bool isLoggingIn = state.matchedLocation == login || state.matchedLocation == register;

      // Handle Splash logic separately if needed, but usually it's the starting point
      if (isSplashing) return null;

      // Handle Onboarding
      if (isFirstLaunch && !isOnboarding) return onboarding;
      if (!isFirstLaunch && isOnboarding) return home;

      // Handle Auth Guards
      if (!isLoggedIn && state.matchedLocation == profile) return login;
      if (isLoggedIn && isLoggingIn) return home;

      return null;
    },
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: accommodations, builder: (context, state) => const AccommodationsPage()),
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: about,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: courses,
        builder: (context, state) => const CoursesPage(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => CourseDetailPage(id: state.pathParameters['id'] ?? '0'),
          ),
        ],
      ),

      GoRoute(
        path: fleet,
        builder: (context, state) => const FleetPage(),
        /*routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => AircraftDetailPage(id: state.pathParameters['id'] ?? '0'),
          ),
        ],*/
      ),

      GoRoute(
        path: contact,
        builder: (context, state) => const ContactPage(),
      ), GoRoute(
        path: blogsAndNews,
        builder: (context, state) => const BlogAndNewsScreen(),
      ),
    ],
  );
}

/// A simple placeholder page for initial router setup.
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
