import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rfi_flutter/presentation/bloc/auth/auth_bloc.dart';
import 'package:rfi_flutter/domain/entities/user.dart';
import 'package:rfi_flutter/core/constants/app_constants.dart';
import 'package:rfi_flutter/core/utils/responsive_utils.dart';

class UserSidebar extends StatelessWidget {
  const UserSidebar({
    super.key,
    required this.user,
    this.onClose,
    this.isDrawer = true,
  });

  final User user;
  final VoidCallback? onClose;
  final bool isDrawer;

  @override
  Widget build(BuildContext context) {
    final content = _UserSidebarContent(
      user: user,
      onClose: onClose,
      isDrawer: isDrawer,
    );

    if (isDrawer) {
      return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: SafeArea(child: content),
      );
    }

    final sidebarWidth = context.isDesktop ? 320.0 : 280.0;

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SafeArea(child: content),
    );
  }
}

class _UserSidebarContent extends StatelessWidget {
  const _UserSidebarContent({
    required this.user,
    this.onClose,
    required this.isDrawer,
  });

  final User user;
  final VoidCallback? onClose;
  final bool isDrawer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildUserHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.defaultPadding,
            ),
            child: _buildNavigationSection(context),
          ),
        ),
        _buildLogoutSection(context),
      ],
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 56,
        left: AppConstants.defaultPadding,
        right: AppConstants.defaultPadding,
        bottom: AppConstants.defaultPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isDrawer ? 0 : AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: Column(
        children: [
          _buildUserAvatar(),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            user.username,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (user.email != null) ...[
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              user.email!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 48,
        backgroundColor: Colors.grey[300],
        child: user.avatarUrl != null
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user.avatarUrl!,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 96,
                    height: 96,
                    color: Colors.grey[300],
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : Icon(Icons.person, size: 48, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildNavigationSection(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final items = <_NavigationItem>[
      const _NavigationItem(
        label: 'Início',
        icon: Icons.home,
        route: AppConstants.profileRoute,
      ),
      const _NavigationItem(
        label: 'Campanhas',
        icon: Icons.campaign,
        route: AppConstants.campaignsRoute,
      ),
      const _NavigationItem(
        label: 'Personagens',
        icon: Icons.groups_3,
        route: AppConstants.charactersRoute,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppConstants.smallPadding),
        for (var i = 0; i < items.length; i++) ...[
          _buildNavigationButton(context, location, items[i]),
          if (i < items.length - 1)
            const SizedBox(height: AppConstants.smallPadding),
        ],
      ],
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String currentLocation,
    _NavigationItem item,
  ) {
    final isActive = _isRouteActive(currentLocation, item.route);

    return _SidebarNavigationButton(
      item: item,
      isActive: isActive,
      onTap: () => _onNavigationTap(context, item.route, isActive),
    );
  }

  bool _isRouteActive(String location, String route) {
    final locationPath = Uri.parse(location).path;
    final routePath = Uri.parse(route).path;

    if (routePath == '/') {
      return locationPath == '/';
    }

    return locationPath == routePath || locationPath.startsWith('$routePath/');
  }

  void _onNavigationTap(BuildContext context, String route, bool isActive) {
    if (!isActive) {
      context.go(route);
    }

    if (onClose != null) {
      onClose!();
    }
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnauthenticatedState) {
            if (onClose != null) onClose!();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logout realizado'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao fazer o logout: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;

          return ElevatedButton.icon(
            onPressed: isLoading
                ? null
                : () => _showLogoutConfirmation(context),
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
            label: Text(isLoading ? 'Saindo...' : 'Sair'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Logout'),
          content: const Text('Tem certeza que deseja sair?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                dialogContext.read<AuthBloc>().add(AuthLogoutEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

class _SidebarNavigationButton extends StatelessWidget {
  const _SidebarNavigationButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavigationItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = isActive
        ? colorScheme.primary
        : colorScheme.surface;
    final foregroundColor = isActive
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final iconColor = isActive ? colorScheme.onPrimary : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: AnimatedContainer(
          duration: AppConstants.shortAnimation,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.defaultPadding * 0.85,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.24),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Icon(item.icon, color: iconColor),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Text(
                  item.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (isActive)
                Icon(Icons.arrow_forward_ios, size: 16, color: foregroundColor),
            ],
          ),
        ),
      ),
    );
  }
}
