import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

/// Interface para data source local de autenticação
abstract class AuthLocalDataSource {
  /// Obtém dados do usuário armazenados localmente
  Future<UserModel?> getCachedUser();

  /// Armazena dados do usuário localmente
  Future<void> cacheUser(UserModel user);

  /// Remove dados do usuário armazenados localmente
  Future<void> clearUserData();

  /// Armazena tokens de acesso de forma segura
  Future<void> storeTokens({required String accessToken, String? refreshToken});

  /// Obtém tokens de acesso armazenados
  Future<Map<String, String?>> getTokens();

  /// Remove tokens armazenados
  Future<void> clearTokens();

  /// Verifica se o usuário está logado
  Future<bool> isLoggedIn();
}

/// Implementação do data source local de autenticação
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.userDataKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Erro ao obter dados do usuário em cache: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(AppConstants.userDataKey, userJson);
    } catch (e) {
      throw CacheException('Erro ao armazenar dados do usuário: $e');
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await sharedPreferences.remove(AppConstants.userDataKey);
    } catch (e) {
      throw CacheException('Erro ao limpar dados do usuário: $e');
    }
  }

  @override
  Future<void> storeTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    try {
      await sharedPreferences.setString(
        AppConstants.accessTokenKey,
        accessToken,
      );

      if (refreshToken != null) {
        await sharedPreferences.setString(
          AppConstants.refreshTokenKey,
          refreshToken,
        );
      }
    } catch (e) {
      throw CacheException('Erro ao armazenar tokens: $e');
    }
  }

  @override
  Future<Map<String, String?>> getTokens() async {
    try {
      final accessToken = sharedPreferences.getString(
        AppConstants.accessTokenKey,
      );

      final refreshToken = sharedPreferences.getString(
        AppConstants.refreshTokenKey,
      );

      return {'access_token': accessToken, 'refresh_token': refreshToken};
    } catch (e) {
      throw CacheException('Erro ao obter tokens: $e');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await sharedPreferences.remove(AppConstants.accessTokenKey);
      await sharedPreferences.remove(AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Erro ao limpar tokens: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final accessToken = sharedPreferences.getString(
        AppConstants.accessTokenKey,
      );

      final user = await getCachedUser();

      return accessToken != null && user != null;
    } catch (e) {
      return false;
    }
  }
}
