import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import 'user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login(LoginCredentials credentials);
  Future<Either<Failure, AuthTokens>> register(RegisterData data);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthTokens>> refreshToken();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(String email, String token, String newPassword);
  Future<Either<Failure, void>> verifyEmail(String token);
  Future<Either<Failure, User>> updateProfile(User user);
  Future<Either<Failure, void>> changePassword(String currentPassword, String newPassword);
}