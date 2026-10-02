import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_service.dart';
import '../models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, AuthResponse>> login(LoginRequest request);
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthResponse>> refreshToken();
  Future<Either<Failure, UserModel>> getCurrentUser();
  Future<Either<Failure, void>> forgotPassword(ForgotPasswordRequest request);
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request);
  Future<Either<Failure, void>> verifyEmail(VerifyEmailRequest request);
  Future<Either<Failure, UserModel>> updateProfile(UserModel user);
  Future<Either<Failure, void>> changePassword(ChangePasswordRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: request.toJson(),
      );
      return Right(AuthResponse.fromJson(response.data));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        data: request.toJson(),
      );
      return Right(AuthResponse.fromJson(response.data));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _apiService.post('/auth/logout');
      return const Right(null);
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken() async {
    try {
      final response = await _apiService.post('/auth/refresh-token');
      return Right(AuthResponse.fromJson(response.data));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me');
      return Right(UserModel.fromJson(response.data));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(ForgotPasswordRequest request) async {
    try {
      await _apiService.post('/auth/forgot-password', data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request) async {
    try {
      await _apiService.post('/auth/reset-password', data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(VerifyEmailRequest request) async {
    try {
      await _apiService.post('/auth/verify-email', data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile(UserModel user) async {
    try {
      final response = await _apiService.put('/auth/profile', data: user.toJson());
      return Right(UserModel.fromJson(response.data));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(ChangePasswordRequest request) async {
    try {
      await _apiService.post('/auth/change-password', data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }
}