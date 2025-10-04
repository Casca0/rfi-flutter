part of 'auth_bloc.dart';

/// Estados do AuthBloc
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitialState extends AuthState {}

/// Estado de carregamento
class AuthLoadingState extends AuthState {}

/// Estado autenticado - usuário logado
class AuthenticatedState extends AuthState {
  final User user;

  const AuthenticatedState(this.user);

  @override
  List<Object> get props => [user];
}

/// Estado não autenticado - usuário não logado
class UnauthenticatedState extends AuthState {}

/// Estado de erro
class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);

  @override
  List<Object> get props => [message];
}
