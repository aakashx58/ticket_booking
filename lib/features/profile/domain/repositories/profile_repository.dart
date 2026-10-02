import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import 'profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdateRequest request);
  
  Future<Either<Failure, String>> uploadAvatar(String filePath);
  
  Future<Either<Failure, void>> deleteAccount();
}