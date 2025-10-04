import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/rpg_logo.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';

/// Tela de splash que verifica o estado de autenticação inicial
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Verifica se o usuário já está logado
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    // Delay para mostrar a splash screen
    Future.delayed(AppConstants.mediumAnimation, () {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckStatusEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedState) {
              // Usuário logado - vai para perfil
              context.go(AppConstants.profileRoute);
            } else if (state is UnauthenticatedState) {
              // Usuário não logado - vai para login
              context.go(AppConstants.loginRoute);
            }
          },
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo do RPG
                RPGLogo(size: 120),

                SizedBox(height: AppConstants.largePadding),

                // Nome do App
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: AppConstants.smallPadding),

                // Subtítulo
                Text(
                  'Companheiro para RPG de Mesa',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),

                SizedBox(height: AppConstants.largePadding * 2),

                // Loading indicator
                LoadingWidget(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
