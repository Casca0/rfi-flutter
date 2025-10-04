import 'package:flutter/material.dart';
import 'package:rfi_flutter/core/constants/app_constants.dart';
import 'package:rfi_flutter/domain/entities/user.dart';
import 'package:rfi_flutter/presentation/pages/profile/widgets/profile_details.dart';
import 'package:rfi_flutter/presentation/routes/page_config.dart';
import 'package:rfi_flutter/presentation/routes/dashboard_transition_scope.dart';
import 'package:rfi_flutter/presentation/widgets/common/user_sidebar.dart';

class ProfileMobileView extends StatelessWidget {
  const ProfileMobileView({
    super.key,
    required this.user,
    required this.config,
  });

  final User user;
  final PageConfig config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _buildFadeAnimation(context),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: ProfileDetails(user: user),
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
