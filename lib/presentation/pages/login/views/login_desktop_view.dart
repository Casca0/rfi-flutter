import 'package:flutter/material.dart';
import 'package:rfi_flutter/core/constants/app_constants.dart';
import 'package:rfi_flutter/presentation/bloc/auth/auth_bloc.dart';
import 'package:rfi_flutter/presentation/widgets/auth/discord_login_button.dart';
import 'package:rfi_flutter/presentation/widgets/common/loading_widget.dart';
import 'package:rfi_flutter/presentation/widgets/common/rpg_logo.dart';

class LoginDesktopView extends StatelessWidget {
  const LoginDesktopView({
    super.key,
    required this.state,
    required this.onLogin,
  });

  final AuthState state;
  final VoidCallback onLogin;

  bool get _isLoading => state is AuthLoadingState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Row(
            children: [
              Expanded(child: _buildHeroPanel(context)),
              const SizedBox(width: AppConstants.largePadding * 2),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: _buildLoginCard(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.largePadding),
        Text(
          'Organize campanhas, personagens e jogue com seus amigos em um só lugar.',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white70, height: 1.4),
        ),
        const SizedBox(height: AppConstants.largePadding),
        Wrap(
          spacing: AppConstants.largePadding,
          runSpacing: AppConstants.defaultPadding,
          children: const [
            _FeatureHighlight(icon: Icons.people, label: 'Party Management'),
            _FeatureHighlight(
              icon: Icons.map,
              label: 'Campanhas compartilhadas',
            ),
            _FeatureHighlight(
              icon: Icons.casino,
              label: 'Rolagens de dados rápidas',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const RPGLogo(
              size: 120,
              svgAsset: 'assets/d20.svg',
              iconColor: Colors.white,
            ),
            const SizedBox(height: AppConstants.largePadding),
            Text(
              'Entre na sua campanha',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'Use sua conta Discord para autenticar com segurança e começar a aventura.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: AppConstants.largePadding * 1.5),
            if (_isLoading)
              const Column(
                children: [
                  LoadingWidget(),
                  SizedBox(height: AppConstants.defaultPadding),
                  Text('Conectando com Discord...'),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: DiscordLoginButton(onPressed: onLogin),
              ),
            const SizedBox(height: AppConstants.largePadding),
            Text(
              'Não compartilhamos suas informações pessoais e você pode revogar o acesso a qualquer momento pelas configurações do Discord.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureHighlight extends StatelessWidget {
  const _FeatureHighlight({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 18),
      label: Text(label),
      labelStyle: const TextStyle(color: Colors.white),
      backgroundColor: Colors.white.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
    );
  }
}
