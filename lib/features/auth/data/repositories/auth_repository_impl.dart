import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, AuthTokens>> login(LoginCredentials credentials) async {
    final request = LoginRequest(email: credentials.email, password: credentials.password);
    final result = await _remoteDataSource.login(request);
    
    return result.fold(
      (failure) => Left(failure),
      (authResponse) async {
        await _localDataSource.saveTokens(authResponse);
        await _localDataSource.saveUser(authResponse.user);
        return Right(AuthTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresIn: authResponse.expiresIn,
        ));
      },
    );
  }

  @override
  Future<Either<Failure, AuthTokens>> register(RegisterData data) async {
    final request = RegisterRequest(
      email: data.email,
      password: data.password,
      name: data.name,
      phoneNumber: data.phoneNumber,
    );
    final result = await _remoteDataSource.register(request);
    
    return result.fold(
      (failure) => Left(failure),
      (authResponse) async {
        await _localDataSource.saveTokens(authResponse);
        await _localDataSource.saveUser(authResponse.user);
        return Right(AuthTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresIn: authResponse.expiresIn,
        ));
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final result = await _remoteDataSource.logout();
    await _localDataSource.clearAll();
    return result;
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    final result = await _remoteDataSource.refreshToken();
    
    return result.fold(
      (failure) => Left(failure),
      (authResponse) async {
        await _localDataSource.saveAccessToken(authResponse.accessToken);
        await _localDataSource.saveRefreshToken(authResponse.refreshToken);
        return Right(AuthTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresIn: authResponse.expiresIn,
        ));
      },
    );
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    final isLoggedIn = await _localDataSource.isLoggedIn();
    if (!isLoggedIn) {
      return Left(UnauthorizedFailure(message: 'User not logged in'));
    }
    
    final result = await _remoteDataSource.getCurrentUser();
    
    return result.fold(
      (failure) => Left(failure),
      (userModel) => Right(userModel.toEntity()),
    );
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    final request = ForgotPasswordRequest(email: email);
    return await _remoteDataSource.forgotPassword(request);
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email, String token, String newPassword) async {
    final request = ResetPasswordRequest(email: email, token: token, newPassword: newPassword);
    return await _remoteDataSource.resetPassword(request);
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    final request = VerifyEmailRequest(token: token);
    return await _remoteDataSource.verifyEmail(request);
  }

  @override
  Future<Either<Failure, User>> updateProfile(User user) async {
    final userModel = user.toModel();
    final result = await _remoteDataSource.updateProfile(userModel);
    
    return result.fold(
      (failure) => Left(failure),
      (updatedUserModel) async {
        await _localDataSource.saveUser(updatedUserModel);
        return Right(updatedUserModel.toEntity());
      },
    );
  }

  @override
  Future<Either<Failure, void>> changePassword(String currentPassword, String newPassword) async {
    final request = ChangePasswordRequest(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    return await _remoteDataSource.changePassword(request);
  }
}