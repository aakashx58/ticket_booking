import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../core/network/api_service.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/events/data/datasources/events_remote_data_source.dart';
import '../../features/events/data/repositories/events_repository_impl.dart';
import '../../features/events/domain/repositories/events_repository.dart';
import '../../features/events/domain/usecases/events_usecases.dart';
import '../../features/events/presentation/bloc/events_bloc.dart';

import '../../features/booking/data/datasources/booking_remote_data_source.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/booking_usecases.dart';
import '../../features/booking/presentation/bloc/booking_bloc.dart';

import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/profile_usecases.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  DioClient get dioClient => DioClient();

  @lazySingleton
  ApiService get apiService => ApiService(getIt<DioClient>().dio);

  @lazySingleton
  AuthRemoteDataSource get authRemoteDataSource => AuthRemoteDataSourceImpl(getIt<ApiService>());

  @lazySingleton
  AuthLocalDataSource get authLocalDataSource => AuthLocalDataSourceImpl(
    getIt<SharedPreferences>(),
    getIt<FlutterSecureStorage>(),
  );

  @lazySingleton
  AuthRepository get authRepository => AuthRepositoryImpl(
    getIt<AuthRemoteDataSource>(),
    getIt<AuthLocalDataSource>(),
  );

  @lazySingleton
  LoginUseCase get loginUseCase => LoginUseCase(getIt<AuthRepository>());

  @lazySingleton
  RegisterUseCase get registerUseCase => RegisterUseCase(getIt<AuthRepository>());

  @lazySingleton
  LogoutUseCase get logoutUseCase => LogoutUseCase(getIt<AuthRepository>());

  @lazySingleton
  GetCurrentUserUseCase get getCurrentUserUseCase => GetCurrentUserUseCase(getIt<AuthRepository>());

  @lazySingleton
  ForgotPasswordUseCase get forgotPasswordUseCase => ForgotPasswordUseCase(getIt<AuthRepository>());

  @lazySingleton
  ResetPasswordUseCase get resetPasswordUseCase => ResetPasswordUseCase(getIt<AuthRepository>());

  @lazySingleton
  VerifyEmailUseCase get verifyEmailUseCase => VerifyEmailUseCase(getIt<AuthRepository>());

  @lazySingleton
  UpdateProfileUseCase get updateProfileUseCase => UpdateProfileUseCase(getIt<AuthRepository>());

  @lazySingleton
  ChangePasswordUseCase get changePasswordUseCase => ChangePasswordUseCase(getIt<AuthRepository>());

  @factory
  AuthBloc get authBloc => AuthBloc(
    loginUseCase: getIt<LoginUseCase>(),
    registerUseCase: getIt<RegisterUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
    getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
    resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    verifyEmailUseCase: getIt<VerifyEmailUseCase>(),
    updateProfileUseCase: getIt<UpdateProfileUseCase>(),
    changePasswordUseCase: getIt<ChangePasswordUseCase>(),
  );

  @lazySingleton
  EventsRemoteDataSource get eventsRemoteDataSource => EventsRemoteDataSourceImpl(getIt<ApiService>());

  @lazySingleton
  EventsRepository get eventsRepository => EventsRepositoryImpl(getIt<EventsRemoteDataSource>());

  @lazySingleton
  GetEventsUseCase get getEventsUseCase => GetEventsUseCase(getIt<EventsRepository>());

  @lazySingleton
  GetEventByIdUseCase get getEventByIdUseCase => GetEventByIdUseCase(getIt<EventsRepository>());

  @lazySingleton
  GetFeaturedEventsUseCase get getFeaturedEventsUseCase => GetFeaturedEventsUseCase(getIt<EventsRepository>());

  @lazySingleton
  GetCategoriesUseCase get getCategoriesUseCase => GetCategoriesUseCase(getIt<EventsRepository>());

  @lazySingleton
  SearchEventsUseCase get searchEventsUseCase => SearchEventsUseCase(getIt<EventsRepository>());

  @lazySingleton
  GetEventsByCategoryUseCase get getEventsByCategoryUseCase => GetEventsByCategoryUseCase(getIt<EventsRepository>());

  @factory
  EventsBloc get eventsBloc => EventsBloc(
    getEventsUseCase: getIt<GetEventsUseCase>(),
    getEventByIdUseCase: getIt<GetEventByIdUseCase>(),
    getFeaturedEventsUseCase: getIt<GetFeaturedEventsUseCase>(),
    getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
    searchEventsUseCase: getIt<SearchEventsUseCase>(),
    getEventsByCategoryUseCase: getIt<GetEventsByCategoryUseCase>(),
  );

  @lazySingleton
  BookingRemoteDataSource get bookingRemoteDataSource => BookingRemoteDataSourceImpl(getIt<ApiService>());

  @lazySingleton
  BookingRepository get bookingRepository => BookingRepositoryImpl(getIt<BookingRemoteDataSource>());

  @lazySingleton
  GetMyBookingsUseCase get getMyBookingsUseCase => GetMyBookingsUseCase(getIt<BookingRepository>());

  @lazySingleton
  GetBookingByIdUseCase get getBookingByIdUseCase => GetBookingByIdUseCase(getIt<BookingRepository>());

  @lazySingleton
  CreateBookingUseCase get createBookingUseCase => CreateBookingUseCase(getIt<BookingRepository>());

  @lazySingleton
  CancelBookingUseCase get cancelBookingUseCase => CancelBookingUseCase(getIt<BookingRepository>());

  @lazySingleton
  GetBookingQRCodeUseCase get getBookingQRCodeUseCase => GetBookingQRCodeUseCase(getIt<BookingRepository>());

  @factory
  BookingBloc get bookingBloc => BookingBloc(
    getMyBookingsUseCase: getIt<GetMyBookingsUseCase>(),
    getBookingByIdUseCase: getIt<GetBookingByIdUseCase>(),
    createBookingUseCase: getIt<CreateBookingUseCase>(),
    cancelBookingUseCase: getIt<CancelBookingUseCase>(),
    getBookingQRCodeUseCase: getIt<GetBookingQRCodeUseCase>(),
  );

  @lazySingleton
  ProfileRemoteDataSource get profileRemoteDataSource => ProfileRemoteDataSourceImpl(getIt<ApiService>());

  @lazySingleton
  ProfileRepository get profileRepository => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>());

  @lazySingleton
  GetProfileUseCase get getProfileUseCase => GetProfileUseCase(getIt<ProfileRepository>());

  @lazySingleton
  UpdateProfileUseCase get updateProfileUseCase => UpdateProfileUseCase(getIt<ProfileRepository>());

  @lazySingleton
  UploadAvatarUseCase get uploadAvatarUseCase => UploadAvatarUseCase(getIt<ProfileRepository>());

  @lazySingleton
  DeleteAccountUseCase get deleteAccountUseCase => DeleteAccountUseCase(getIt<ProfileRepository>());

  @factory
  ProfileBloc get profileBloc => ProfileBloc(
    getProfileUseCase: getIt<GetProfileUseCase>(),
    updateProfileUseCase: getIt<UpdateProfileUseCase>(),
    uploadAvatarUseCase: getIt<UploadAvatarUseCase>(),
    deleteAccountUseCase: getIt<DeleteAccountUseCase>(),
  );
}