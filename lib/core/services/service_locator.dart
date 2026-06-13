import 'package:aleef/core/services/session_service.dart';
import 'package:aleef/features/doctor/home/data/services/active_appointments_api_service.dart';
import 'package:aleef/features/doctor/home/data/services/appointment_management_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'secure_storage_service.dart';
import 'socket_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<SessionService>(() => SessionService());

  getIt.registerLazySingleton<SocketService>(() => SocketService());
  getIt.registerLazySingleton<ActiveAppointmentsApiService>(
    () => ActiveAppointmentsApiService(),
  );
  getIt.registerLazySingleton<AppointmentManagementService>(() => AppointmentManagementService(getIt()));

}

