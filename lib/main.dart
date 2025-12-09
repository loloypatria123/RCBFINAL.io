import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/email_verification_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/password_reset_verification_page.dart';
import 'pages/user_dashboard_old.dart';
import 'pages/firestore_debug_page.dart';
import 'pages/admin_recovery_page.dart';
import 'pages/admin_main_layout.dart';
import 'pages/admin_mobile_dashboard.dart';
import 'pages/user_settings_page.dart';
import 'providers/auth_provider.dart';
import 'providers/ui_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize Supabase
  // TODO: Replace with your Supabase URL and anon key
  // Get these from your Supabase project settings: https://app.supabase.com/project/_/settings/api
  await Supabase.initialize(
    url: 'https://githmtuzvplarlsdfvoc.supabase.co', // Replace with your Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdpdGhtdHV6dnBsYXJsc2Rmdm9jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ5ODc3MjIsImV4cCI6MjA4MDU2MzcyMn0.Q7rsnnS8H9L5FvyimIEgosFuV3BJahdASnewkhdXC1s', // Replace with your Supabase anon key
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Helper method to detect platform and return appropriate admin dashboard
  static Widget _getAdminDashboard() {
    // Check if running on web
    if (kIsWeb) {
      return const AdminMainLayout();
    }
    // For mobile platforms (Android, iOS)
    return const AdminMobileDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UIProvider()),
      ],
      child: Consumer<UIProvider>(
        builder: (context, uiProvider, _) {
          return MaterialApp(
            title: 'RCB',
            theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: uiProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SignInPage(),
            debugShowCheckedModeBanner: false,
            routes: {
              '/sign-in': (context) => const SignInPage(),
              '/sign-up': (context) => const SignUpPage(),
              '/email-verification': (context) {
                final email =
                    ModalRoute.of(context)?.settings.arguments as String?;
                return EmailVerificationPage(email: email ?? '');
              },
              '/forgot-password': (context) => const ForgotPasswordPage(),
              '/password-reset-verification': (context) {
                final email =
                    ModalRoute.of(context)?.settings.arguments as String?;
                return PasswordResetVerificationPage(email: email ?? '');
              },
              '/admin-dashboard': (context) => _getAdminDashboard(),
              '/admin-panel': (context) => _getAdminDashboard(),
              '/user-dashboard': (context) => const UserDashboard(),
              '/firestore-debug': (context) => const FirestoreDebugPage(),
              '/admin-recovery': (context) {
                final args =
                    ModalRoute.of(context)?.settings.arguments
                        as Map<String, dynamic>?;
                return AdminRecoveryPage(
                  uid: args?['uid'] ?? '',
                  email: args?['email'] ?? '',
                );
              },
              '/UserSettingsPage': (context) => const UserSettingsPage(),
            },
          );
        },
      ),
    );
  }
}
