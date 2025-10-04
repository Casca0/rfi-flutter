import 'package:pocketbase/pocketbase.dart';
import '../data/datasources/auth_remote_data_source_pocketbase.dart';
import '../data/datasources/auth_local_data_source.dart';
import '../data/models/user_model.dart';
import '../domain/entities/user.dart';

/// Serviço simplificado de autenticação que centraliza o fluxo
/// de login/logout e gerenciamento de sessão.
class AuthService {
  final PocketBaseAuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final PocketBase pocketBase;

  AuthService({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.pocketBase,
  });

  /// Realiza login via Discord OAuth2 utilizando PocketBase.
  Future<User> loginWithDiscord() async {
    final userModel = await remoteDataSource.loginWithDiscord();

    // Persiste usuário em cache local
    await localDataSource.cacheUser(userModel);

    // Persiste token atual do PocketBase (se disponível)
    if (pocketBase.authStore.isValid && pocketBase.authStore.token.isNotEmpty) {
      await localDataSource.storeTokens(
        accessToken: pocketBase.authStore.token,
      );
    }

    return userModel.toEntity();
  }

  /// Finaliza a sessão atual do usuário, limpando dados locais e remotos.
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearUserData();
    await localDataSource.clearTokens();
  }

  /// Retorna o usuário atual, se houver sessão válida.
  Future<User?> getCurrentUser() async {
    try {
      final cachedUserModel = await localDataSource.getCachedUser();

      // Tenta recuperar usuário diretamente do authStore do PocketBase
      if (pocketBase.authStore.isValid && pocketBase.authStore.record != null) {
        final recordUser = UserModel.fromPocketBaseRecord(
          pocketBase.authStore.record!,
        ).toEntity();

        if (cachedUserModel != null) {
          final cachedUser = cachedUserModel.toEntity();
          final mergedAvatar =
              (recordUser.avatarUrl != null && recordUser.avatarUrl!.isNotEmpty)
              ? recordUser.avatarUrl
              : cachedUser.avatarUrl;

          return recordUser.copyWith(
            discordId: recordUser.discordId.isNotEmpty
                ? recordUser.discordId
                : cachedUser.discordId,
            username: recordUser.username.isNotEmpty
                ? recordUser.username
                : cachedUser.username,
            email: recordUser.email ?? cachedUser.email,
            avatarUrl: mergedAvatar,
          );
        }

        return recordUser;
      }

      // Fallback para usuário cacheado localmente
      return cachedUserModel?.toEntity();
    } catch (_) {
      return null;
    }
  }

  /// Verifica se existe uma sessão válida no PocketBase.
  bool isAuthenticated() {
    return pocketBase.authStore.isValid;
  }
}
