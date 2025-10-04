import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../layout/responsive_layout.dart';
import 'views/login_mobile_view.dart';
import 'views/login_desktop_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            context.go(AppConstants.profileRoute);
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            mobile: LoginMobileView(
              state: state,
              onLogin: () => context.read<AuthBloc>().add(AuthLoginEvent()),
            ),
            desktop: LoginDesktopView(
              state: state,
              onLogin: () => context.read<AuthBloc>().add(AuthLoginEvent()),
            ),
          );
        },
      ),
    );
  }
}
