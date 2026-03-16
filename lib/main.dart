import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainai_flutter/core/config/app_config.dart';
import 'package:sustainai_flutter/core/services/supabase_service.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/auth/providers/auth_provider.dart';
import 'package:sustainai_flutter/features/auth/screens/login_screen.dart';
import 'package:sustainai_flutter/features/auth/screens/signup_screen.dart';
import 'package:sustainai_flutter/features/dashboard/screens/dashboard_screen.dart';
import 'package:sustainai_flutter/features/consumption/screens/consumption_screen.dart';
import 'package:sustainai_flutter/features/settings/screens/settings_screen.dart';
import 'package:sustainai_flutter/features/common/screens/coming_soon_screen.dart';
import 'package:sustainai_flutter/features/financial_integrity/screens/financial_integrity_screen.dart';
import 'package:sustainai_flutter/features/resilience/screens/resilience_screen.dart';
import 'package:sustainai_flutter/features/predictive/screens/predictive_screen.dart';
import 'package:sustainai_flutter/features/monitor/screens/monitor_screen.dart';
import 'package:sustainai_flutter/features/wellbeing/screens/wellbeing_checkin_screen.dart';

void main() asyn {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/consumption': (context) => const ConsumptionScreen(),
          '/financial-integrity': (context) => const FinancialIntegrityScreen(),
          '/wellbeing': (context) => const WellBeingCheckInScreen(),
          '/disaster': (context) => const ResilienceScreen(),
          '/esg-analysis': (context) => const PredictiveScreen(),
          '/sustainability-monitor': (context) => const SustainabilityMonitorScreen(),
        },
      ),

    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.loading) {
          return const LoadingScreen();
        }
        
        if (authProvider.isAuthenticated) {
          return const DashboardScreen();
        }
        
        return const LoginScreen();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary500, AppTheme.primary400],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.eco,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'SUSTAINAI',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Loading your sustainable future...',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppTheme.primary400),
            ),
          ],
        ),
      ),
    );
  }
}
