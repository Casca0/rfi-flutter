import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocketbase/pocketbase.dart';

// Data
import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source_pocketbase.dart';

// Services
import 'services/auth_service.dart';

// Presentation
import 'presentation/bloc/auth/auth_bloc.dart';

// Core
import 'core/constants/app_constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Authentication

  // Bloc
  sl.registerFactory(() => AuthBloc(authService: sl()));

  // Services
  sl.registerLazySingleton(
    () => AuthService(
      remoteDataSource: sl(),
      localDataSource: sl(),
      pocketBase: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PocketBaseAuthRemoteDataSource>(
    () => PocketBaseAuthRemoteDataSource(pb: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! External
  // PocketBase instance
  sl.registerLazySingleton<PocketBase>(
    () => PocketBase(AppConstants.pocketbaseUrl),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
