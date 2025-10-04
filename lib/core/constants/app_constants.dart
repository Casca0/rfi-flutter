class AppConstants {
  // App Information
  static const String appName = 'Roll for Initiative';
  static const String appVersion = '1.0.0';

  // Discord OAuth2
  static const String discordClientId = String.fromEnvironment(
    'DISCORD_CLIENT_ID',
  );
  static const String discordClientSecret = String.fromEnvironment(
    'DISCORD_CLIENT_SECRET',
  );
  static const String discordRedirectUri = String.fromEnvironment(
    'DISCORD_REDIRECT_URI',
  );
  static const String discordAuthUrl =
      'https://discord.com/api/oauth2/authorize';
  static const String discordTokenUrl = 'https://discord.com/api/oauth2/token';
  static const String discordScope = 'identify email';

  // PocketBase
  static const String pocketbaseUrl = String.fromEnvironment(
    'POCKETBASE_URL',
    defaultValue: 'https://rfi-auth.fly.dev',
  );

  // API Endpoints
  static const String discordApiBaseUrl = 'https://discord.com/api/v10';
  static const String discordUserEndpoint = '/users/@me';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  // Routes
  static const String loginRoute = '/login';
  static const String profileRoute = '/profile';
  static const String homeRoute = '/home';
  static const String campaignsRoute = '/campaigns';
  static const String charactersRoute = '/characters';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);
}
