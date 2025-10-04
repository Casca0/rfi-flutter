import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Serviço para manter conexão ativa durante OAuth2 no Android 15+
class OAuth2ForegroundService {
  static const MethodChannel _channel = MethodChannel('oauth2_service');

  /// Inicia o foreground service para manter conexão ativa
  static Future<void> startService() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('startService');
        debugPrint('🚀 Foreground service iniciado para OAuth2');
      } catch (e) {
        debugPrint('❌ Erro ao iniciar foreground service: $e');
        // Não lance erro aqui, apenas log - o OAuth2 pode funcionar sem o service
      }
    }
  }

  /// Para o foreground service
  static Future<void> stopService() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('stopService');
        debugPrint('🛑 Foreground service parado');
      } catch (e) {
        debugPrint('❌ Erro ao parar foreground service: $e');
        // Não lance erro aqui, apenas log
      }
    }
  }

  /// Verifica se estamos no Android e se o service está disponível
  static bool get isSupported => Platform.isAndroid;

  /// Executa uma função com foreground service ativo
  static Future<T> withService<T>(Future<T> Function() action) async {
    if (isSupported) {
      await startService();
    }

    try {
      return await action();
    } finally {
      if (isSupported) {
        await stopService();
      }
    }
  }
}
