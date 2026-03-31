import 'package:aleef/core/services/session_service.dart';
import 'package:get_it/get_it.dart';
import 'secure_storage_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<SessionService>(() => SessionService());
}
