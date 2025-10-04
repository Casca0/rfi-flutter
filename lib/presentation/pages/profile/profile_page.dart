import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfi_flutter/core/constants/app_constants.dart';
import 'package:rfi_flutter/presentation/bloc/auth/auth_bloc.dart';
import 'package:rfi_flutter/presentation/layout/responsive_layout.dart';
import 'package:rfi_flutter/presentation/pages/profile/views/profile_desktop_view.dart';
import 'package:rfi_flutter/presentation/pages/profile/views/profile_mobile_view.dart';
import 'package:rfi_flutter/presentation/routes/page_config.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.config});

  final PageConfig config;

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
            mobile: ProfileMobileView(user: state.user, config: config),
            desktop: ProfileDesktopView(user: state.user, config: config),
          );
        }

        if (state is AuthErrorState) {
          return Scaffold(
            body: Center(
              child: Text(
                'Erro ao carregar perfil: ${state.message}',
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
                  'Carregando perfil...',
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
