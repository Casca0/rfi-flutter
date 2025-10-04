import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:rfi_flutter/presentation/routes/page_config.dart';
import '../pages/login/login_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/campaigns/campaigns_page.dart';
import '../pages/characters/characters_page.dart';
import '../pages/splash_page.dart';
import '../../core/constants/app_constants.dart';
import 'dashboard_transition_scope.dart';

class AppRouter {
  GoRouter get router => _router;

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash Screen - Tela inicial que verifica autenticação
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Login Screen - Tela de autenticação com Discord
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Profile Screen - Tela principal após login
      GoRoute(
        path: AppConstants.profileRoute,
        name: 'profile',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: AppConstants.mediumAnimation,
          reverseTransitionDuration: AppConstants.mediumAnimation,
          child: const ProfilePage(
            config: PageConfig(title: 'Início', icon: Icons.home),
          ),
          transitionsBuilder: _fadeTransitionBuilder,
        ),
      ),

      GoRoute(
        path: AppConstants.campaignsRoute,
        name: 'campaigns',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: AppConstants.mediumAnimation,
          reverseTransitionDuration: AppConstants.mediumAnimation,
          child: const CampaignsPage(),
          transitionsBuilder: _fadeTransitionBuilder,
        ),
      ),

      GoRoute(
        path: AppConstants.charactersRoute,
        name: 'characters',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: AppConstants.mediumAnimation,
          reverseTransitionDuration: AppConstants.mediumAnimation,
          child: const CharactersPage(),
          transitionsBuilder: _fadeTransitionBuilder,
        ),
      ),
    ],

    // Redirect logic para verificar autenticação
    redirect: (context, state) {
      // TODO: Implementar lógica de redirect baseada no estado de autenticação
      // Por enquanto, deixamos null para permitir navegação livre
      return null;
    },

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erro de Navegação',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Página não encontrada: ${state.uri}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Voltar ao Início'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _fadeTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return DashboardTransitionScope(
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    child: child,
  );
}
