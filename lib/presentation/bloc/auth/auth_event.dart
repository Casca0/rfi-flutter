part of 'auth_bloc.dart';

/// Eventos do AuthBloc
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Evento para verificar status de autenticação
class AuthCheckStatusEvent extends AuthEvent {}

/// Evento para realizar login
class AuthLoginEvent extends AuthEvent {}

/// Evento para realizar logout
class AuthLogoutEvent extends AuthEvent {}

/// Evento para atualizar dados do usuário
class AuthUpdateUserEvent extends AuthEvent {
  final User user;

  const AuthUpdateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}
