import 'package:cougar_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cougar_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'prefs_service.dart';
import 'hive_service.dart';

/// [sl] is the global instance of [GetIt] for dependency injection.
final GetIt sl = GetIt.instance;

/// [initServiceLocator] initializes all services and repositories.
Future<void> initServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Services
  sl.registerLazySingleton(() => PrefsService(sl()));
  sl.registerLazySingleton(() => HiveService.instance);

  // Initialize Hive
  await sl<HiveService>().init();

  // Features - Auth
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerFactory(() => AuthCubit(sl()));

  // Add other features as they are implemented
}
