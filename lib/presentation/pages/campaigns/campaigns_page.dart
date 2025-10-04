import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfi_flutter/core/constants/app_constants.dart';
import 'package:rfi_flutter/domain/entities/user.dart';
import 'package:rfi_flutter/presentation/bloc/auth/auth_bloc.dart';
import 'package:rfi_flutter/presentation/layout/responsive_layout.dart';
import 'package:rfi_flutter/presentation/widgets/common/user_sidebar.dart';
import 'package:rfi_flutter/presentation/routes/dashboard_transition_scope.dart';

class CampaignsPage extends StatelessWidget {
  const CampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          context.go(AppConstants.loginRoute);
        }
      },
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return ResponsiveLayout(
            mobile: _CampaignsMobileView(user: state.user),
            desktop: _CampaignsDesktopView(user: state.user),
          );
        }

        if (state is AuthErrorState) {
          return Scaffold(
            body: Center(
              child: Text(
                'Erro ao carregar campanhas: ${state.message}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: AppConstants.defaultPadding),
                Text(
                  'Carregando campanhas...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CampaignsDesktopView extends StatelessWidget {
  const _CampaignsDesktopView({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.campaign, size: 22, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Campanhas'),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.2),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserSidebar(user: user, isDrawer: false),
                const SizedBox(width: AppConstants.largePadding * 2),
                Expanded(
                  child: FadeTransition(
                    opacity: _buildFadeAnimation(context),
                    child: const _CampaignsContent(),
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

class _CampaignsMobileView extends StatelessWidget {
  const _CampaignsMobileView({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.campaign, size: 22, color: colorScheme.onPrimary),
            const SizedBox(width: 8),
            const Text('Campanhas'),
          ],
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      drawer: UserSidebar(
        user: user,
        onClose: () => Navigator.of(context).pop(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorScheme.primary, colorScheme.surface],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _buildFadeAnimation(context),
            child: const SingleChildScrollView(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              child: _CampaignsContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CampaignsContent extends StatelessWidget {
  const _CampaignsContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome_mosaic, color: colorScheme.primary),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Text(
                    'Campanhas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                'Gerencie e organize suas aventuras em um só lugar. '
                'Em breve você poderá criar campanhas, convidar amigos e acompanhar o progresso das mesas.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppConstants.largePadding),
              Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.hourglass_empty, color: colorScheme.primary),
                    const SizedBox(width: AppConstants.defaultPadding),
                    Expanded(
                      child: Text(
                        'Funcionalidade em desenvolvimento. Fique ligado nas próximas atualizações!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Animation<double> _buildFadeAnimation(BuildContext context) {
  final scope = DashboardTransitionScope.maybeOf(context);
  if (scope == null) {
    return const AlwaysStoppedAnimation<double>(1);
  }

  return CurvedAnimation(parent: scope.animation, curve: Curves.easeInOut);
}
