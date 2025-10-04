import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC responsável pelo gerenciamento de estado de autenticação
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitialState()) {
    // Handler para verificar status de autenticação
    on<AuthCheckStatusEvent>(_onCheckStatus);

    // Handler para login
    on<AuthLoginEvent>(_onLogin);

    // Handler para logout
    on<AuthLogoutEvent>(_onLogout);

    // Handler para atualizar usuário
    on<AuthUpdateUserEvent>(_onUpdateUser);
  }

  /// Verifica se o usuário já está logado
  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final user = await authService.getCurrentUser();
      if (user != null) {
        emit(AuthenticatedState(user));
      } else {
        emit(UnauthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState('Erro ao verificar sessão: $e'));
    }
  }

  /// Realiza login com Discord
  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final user = await authService.loginWithDiscord();
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthErrorState('Erro ao realizar login: $e'));
    }
  }

  /// Realiza logout
  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await authService.logout();
      emit(UnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState('Erro ao realizar logout: $e'));
    }
  }

  /// Atualiza dados do usuário
  Future<void> _onUpdateUser(
    AuthUpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthenticatedState) {
      emit(AuthenticatedState(event.user));
    }
  }
}
