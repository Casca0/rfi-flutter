import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'injection_container.dart' as di;
import 'presentation/routes/app_router.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckStatusEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'RPG Companion - Seu Companheiro de Mesa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary, // Primary
            secondary: AppColors.secondary, // Secondary
            tertiary: AppColors.tertiary, // Tertiary
            surface: AppColors.surfaceLight, // Background surface
            onPrimary: AppColors.textLight, // Text on primary
            onSecondary: AppColors.textLight, // Text on secondary
            onSurface: AppColors.textPrimary, // Text on surface
            error: AppColors.fail, // Fail color
            onError: AppColors.textLight, // Text on error
          ),
          textTheme: GoogleFonts.interTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              foregroundColor: AppColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary, // Primary
            secondary: AppColors.secondary, // Secondary
            tertiary: AppColors.tertiary, // Tertiary
            surface: AppColors.surfaceDark, // Dark background
            onPrimary: AppColors.textLight, // Text on primary
            onSecondary: AppColors.textLight, // Text on secondary
            onSurface: AppColors.tertiary, // Text on dark surface
            error: AppColors.fail, // Fail color
            onError: AppColors.textLight, // Text on error
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              foregroundColor: AppColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        routerConfig: _appRouter.router,
      ),
    );
  }
}
