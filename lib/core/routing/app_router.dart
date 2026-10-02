import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/events/presentation/pages/events_page.dart';
import '../../features/events/presentation/pages/event_detail_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/booking/presentation/pages/my_bookings_page.dart';
import '../../features/booking/presentation/pages/booking_confirmation_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../core/widgets/splash_page.dart';
import '../../core/widgets/main_navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verifyEmail',
        builder: (context, state) => const VerifyEmailPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/events',
            name: 'events',
            builder: (context, state) => const EventsPage(),
          ),
          GoRoute(
            path: '/events/:eventId',
            name: 'eventDetail',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return EventDetailPage(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/bookings',
            name: 'myBookings',
            builder: (context, state) => const MyBookingsPage(),
          ),
          GoRoute(
            path: '/booking/:eventId',
            name: 'booking',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return BookingPage(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/booking/confirmation/:bookingId',
            name: 'bookingConfirmation',
            builder: (context, state) {
              final bookingId = state.pathParameters['bookingId']!;
              return BookingConfirmationPage(bookingId: bookingId);
            },
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/profile/edit',
            name: 'editProfile',
            builder: (context, state) => const EditProfilePage(),
          ),
        ],
      ),
    ],
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    final isAuthenticated = authBloc.state is AuthAuthenticated;
    final isAuthRoute = [
      '/login',
      '/register',
      '/forgot-password',
      '/verify-email',
    ].contains(state.matchedLocation);

    if (!isAuthenticated && !isAuthRoute && state.matchedLocation != '/splash') {
      return '/login';
    }

    if (isAuthenticated && isAuthRoute) {
      return '/events';
    }

    return null;
  }
}