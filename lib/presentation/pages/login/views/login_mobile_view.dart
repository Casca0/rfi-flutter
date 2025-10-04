import 'package:flutter/material.dart';
import 'package:rfi_flutter/core/constants/app_constants.dart';
import 'package:rfi_flutter/presentation/bloc/auth/auth_bloc.dart';
import 'package:rfi_flutter/presentation/widgets/auth/discord_login_button.dart';
import 'package:rfi_flutter/presentation/widgets/common/loading_widget.dart';
import 'package:rfi_flutter/presentation/widgets/common/rpg_logo.dart';

class LoginMobileView extends StatelessWidget {
  const LoginMobileView({
    super.key,
    required this.state,
    required this.onLogin,
  });

  final AuthState state;
  final VoidCallback onLogin;

  bool get _isLoading => state is AuthLoadingState;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RPGLogo(
                  size: 120,
                  svgAsset: 'assets/d20.svg',
                  iconColor: Colors.white,
                ),
                const SizedBox(height: AppConstants.largePadding),
                Text(
                  'Bem-vindo ao\n${AppConstants.appName}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                Text(
                  'Sua aventura RPG começa aqui!\nFaça login com sua conta Discord para continuar.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: AppConstants.largePadding * 2),
                if (_isLoading)
                  const Column(
                    children: [
                      LoadingWidget(color: Colors.white),
                      SizedBox(height: AppConstants.defaultPadding),
                      Text(
                        'Conectando com Discord...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  )
                else
                  DiscordLoginButton(onPressed: onLogin),
                const SizedBox(height: AppConstants.largePadding),
                Container(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white70, size: 24),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        'Usamos Discord para autenticação segura.\nSeus dados são protegidos e não compartilhamos informações pessoais.',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
