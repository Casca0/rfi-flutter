import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Servidor HTTP local para receber callback OAuth2 do Discord
class OAuth2CallbackServer {
  HttpServer? _server;
  late Completer<String> _codeCompleter;

  /// Inicia o servidor local e retorna o código de autorização
  Future<String> waitForAuthorizationCode() async {
    _codeCompleter = Completer<String>();

    try {
      // Inicia servidor na porta 8080
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
      debugPrint('OAuth2 callback server running on http://localhost:8080');

      // Escuta por requests
      await for (HttpRequest request in _server!) {
        await _handleRequest(request);
        if (_codeCompleter.isCompleted) {
          break;
        }
      }

      return await _codeCompleter.future;
    } catch (e) {
      _codeCompleter.completeError('Erro ao iniciar servidor: $e');
      return await _codeCompleter.future;
    }
  }

  /// Manipula requests HTTP recebidos
  Future<void> _handleRequest(HttpRequest request) async {
    final uri = request.uri;

    if (uri.path == '/auth/callback') {
      // Extrai código de autorização
      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];
      // final state = uri.queryParameters['state']; // Para validação CSRF futura

      if (error != null) {
        await _sendErrorResponse(request, 'Erro na autorização: $error');
        _codeCompleter.completeError('Discord authorization error: $error');
        return;
      }

      if (code == null) {
        await _sendErrorResponse(
          request,
          'Código de autorização não encontrado',
        );
        _codeCompleter.completeError('Authorization code not found');
        return;
      }

      // Sucesso - envia resposta e completa com código
      await _sendSuccessResponse(request);
      _codeCompleter.complete(code);
    } else {
      // Rota não encontrada
      await _send404Response(request);
    }
  }

  /// Envia resposta de sucesso
  Future<void> _sendSuccessResponse(HttpRequest request) async {
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.html
      ..write('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>RPG Companion - Autenticação</title>
          <style>
            body {
              font-family: 'Segoe UI', Arial, sans-serif;
              background: linear-gradient(135deg, #31465E, #233243);
              color: white;
              margin: 0;
              padding: 40px;
              display: flex;
              align-items: center;
              justify-content: center;
              min-height: 100vh;
            }
            .container {
              text-align: center;
              background: rgba(255,255,255,0.1);
              padding: 40px;
              border-radius: 16px;
              backdrop-filter: blur(10px);
            }
            .success-icon {
              font-size: 64px;
              margin-bottom: 20px;
            }
            h1 { color: #94C25B; margin-bottom: 10px; }
            p { margin-bottom: 20px; opacity: 0.9; }
            .close-btn {
              background: #94C25B;
              color: white;
              border: none;
              padding: 12px 24px;
              border-radius: 8px;
              cursor: pointer;
              font-size: 16px;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="success-icon">✅</div>
            <h1>Autenticação Bem-sucedida!</h1>
            <p>Você foi autenticado com sucesso no Discord.</p>
            <p>Agora você pode fechar esta janela e voltar ao RPG Companion.</p>
            <button class="close-btn" onclick="window.close()">Fechar Janela</button>
          </div>
          <script>
            // Tenta fechar automaticamente após 3 segundos
            setTimeout(() => {
              window.close();
            }, 3000);
          </script>
        </body>
        </html>
      ''');
    await request.response.close();
  }

  /// Envia resposta de erro
  Future<void> _sendErrorResponse(HttpRequest request, String message) async {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..headers.contentType = ContentType.html
      ..write('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>RPG Companion - Erro</title>
          <style>
            body {
              font-family: 'Segoe UI', Arial, sans-serif;
              background: linear-gradient(135deg, #31465E, #233243);
              color: white;
              margin: 0;
              padding: 40px;
              display: flex;
              align-items: center;
              justify-content: center;
              min-height: 100vh;
            }
            .container {
              text-align: center;
              background: rgba(255,255,255,0.1);
              padding: 40px;
              border-radius: 16px;
              backdrop-filter: blur(10px);
            }
            .error-icon {
              font-size: 64px;
              margin-bottom: 20px;
            }
            h1 { color: #A3293F; margin-bottom: 10px; }
            p { margin-bottom: 20px; opacity: 0.9; }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="error-icon">❌</div>
            <h1>Erro na Autenticação</h1>
            <p>$message</p>
            <p>Tente novamente ou entre em contato com o suporte.</p>
          </div>
        </body>
        </html>
      ''');
    await request.response.close();
  }

  /// Envia resposta 404
  Future<void> _send404Response(HttpRequest request) async {
    request.response
      ..statusCode = HttpStatus.notFound
      ..headers.contentType = ContentType.html
      ..write('<h1>404 - Página não encontrada</h1>');
    await request.response.close();
  }

  /// Para o servidor
  Future<void> stop() async {
    await _server?.close();
    _server = null;
  }
}
