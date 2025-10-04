import 'package:flutter/material.dart';
import 'package:rfi_flutter/core/constants/app_constants.dart';
import 'package:rfi_flutter/domain/entities/user.dart';
import 'package:rfi_flutter/presentation/pages/profile/widgets/profile_details.dart';
import 'package:rfi_flutter/presentation/routes/page_config.dart';
import 'package:rfi_flutter/presentation/routes/dashboard_transition_scope.dart';
import 'package:rfi_flutter/presentation/widgets/common/user_sidebar.dart';

class ProfileDesktopView extends StatelessWidget {
  const ProfileDesktopView({
    super.key,
    required this.user,
    required this.config,
  });

  final User user;
  final PageConfig config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (config.icon != null) ...[
              Icon(
                config.icon,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
            ],
            Text(config.title),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              Theme.of(context).colorScheme.surface,
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: AppConstants.defaultPadding,
                        ),
                        child: ProfileDetails(user: user),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Animation<double> _buildFadeAnimation(BuildContext context) {
    final scope = DashboardTransitionScope.maybeOf(context);
    if (scope == null) {
      return const AlwaysStoppedAnimation<double>(1);
    }

    return CurvedAnimation(parent: scope.animation, curve: Curves.easeInOut);
  }
}
