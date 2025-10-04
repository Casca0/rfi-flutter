import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/services/oauth2_foreground_service.dart';

class PocketBaseAuthRemoteDataSource {
  final PocketBase pb;

  PocketBaseAuthRemoteDataSource({required this.pb});

  ({LaunchMode mode, bool requiresClose})? _activeLaunchConfig;

  Future<UserModel> loginWithDiscord() async {
    return await OAuth2ForegroundService.withService(() async {
      try {
        final authData = await pb
            .collection('users')
            .authWithOAuth2(
              'discord',
              (url) async => _launchAuthorizationUrl(url),
            );

        debugPrint('✅ Autenticação bem-sucedida!');
        return UserModel.fromPocketBaseRecord(authData.record);
      } catch (e) {
        final errorMessage = e.toString();

        if (errorMessage.contains('auth_oauth2_provider_not_found')) {
          throw const AuthenticationException(
            'Provider Discord não configurado no PocketBase. Verifique a configuração OAuth2 no admin.',
          );
        }

        if (errorMessage.contains('Invalid authorization url')) {
          throw const ValidationException(
            'URL de autorização inválida. Verifique a configuração do Discord no PocketBase.',
          );
        }

        if (errorMessage.contains('network')) {
          throw NetworkException(
            'Erro de rede. Verifique sua conexão e a URL do PocketBase: ${pb.baseURL}',
          );
        }

        throw ServerException('Erro durante o login: $e');
      } finally {
        await _closeInAppViewIfNeeded();
      }
    });
  }

  Future<void> logout() async {
    pb.authStore.clear();
  }

  Future<UserModel?> getCurrentUser() async {
    if (!pb.authStore.isValid || pb.authStore.record == null) {
      return null;
    }
    return UserModel.fromPocketBaseRecord(pb.authStore.record!);
  }

  Future<bool> isAuthenticated() async {
    return pb.authStore.isValid;
  }

  Future<void> _launchAuthorizationUrl(Uri url) async {
    final primaryConfig = _primaryLaunchConfig();
    final fallbackConfig = _fallbackLaunchConfig(primaryConfig);
    final configs = <({LaunchMode mode, bool requiresClose})>[primaryConfig];

    if (fallbackConfig != null) {
      configs.add(fallbackConfig);
    }

    for (final config in configs) {
      try {
        final launched = await launchUrl(url, mode: config.mode);

        if (launched) {
          _activeLaunchConfig = config;
          debugPrint('🌐 OAuth aberto com modo ${config.mode.name}');
          return;
        }
      } catch (error) {
        debugPrint('⚠️ Falha ao abrir OAuth com ${config.mode.name}: $error');
      }
    }

    _activeLaunchConfig = null;
    throw const ServerException('Não foi possível abrir o navegador');
  }

  ({LaunchMode mode, bool requiresClose}) _primaryLaunchConfig() {
    if (kIsWeb) {
      return (mode: LaunchMode.externalApplication, requiresClose: false);
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return (mode: LaunchMode.inAppBrowserView, requiresClose: true);
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return (mode: LaunchMode.externalApplication, requiresClose: false);
      default:
        return (mode: LaunchMode.externalApplication, requiresClose: false);
    }
  }

  ({LaunchMode mode, bool requiresClose})? _fallbackLaunchConfig(
    ({LaunchMode mode, bool requiresClose}) primary,
  ) {
    if (primary.mode == LaunchMode.externalApplication) {
      return null;
    }

    return (mode: LaunchMode.externalApplication, requiresClose: false);
  }

  Future<void> _closeInAppViewIfNeeded() async {
    final config = _activeLaunchConfig;
    _activeLaunchConfig = null;

    if (config == null || !config.requiresClose || !_supportsInAppClose) {
      return;
    }

    try {
      await closeInAppWebView();
      debugPrint('✅ WebView de OAuth2 encerrada');
    } on UnimplementedError catch (error) {
      debugPrint('⚠️ closeInAppWebView não suportado nesta plataforma: $error');
    } catch (error) {
      debugPrint('⚠️ Falha ao fechar webview: $error');
    }
  }

  bool get _supportsInAppClose {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Mantido apenas por compatibilidade futura. Sem sincronização extra.
  /// Caso precise persistir dados adicionais no PocketBase, implemente aqui.
}
