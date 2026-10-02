import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_service.dart';
import '../core/constants/app_constants.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  getIt.registerLazySingleton<SharedPreferences>(() => SharedPreferences.getInstance());
  
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    ),
  );

  getIt.registerLazySingleton<DioClient>(() => DioClient());
  
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<DioClient>().dio));
  
  await _initModules();
}

Future<void> _initModules() async {
  await init(getIt);
}

Future<void> resetDependencies() async {
  await getIt.reset();
  await configureDependencies();
}