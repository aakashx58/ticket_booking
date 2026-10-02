import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_service.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ProfileModel>> getProfile();
  
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileUpdateRequestModel request);
  
  Future<Either<Failure, String>> uploadAvatar(String filePath);
  
  Future<Either<Failure, void>> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final response = await _apiService.get('/profile');
      return Right(ProfileModel.fromJson(response.data['data']));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileUpdateRequestModel request) async {
    try {
      final response = await _apiService.put('/profile', data: request.toJson());
      return Right(ProfileModel.fromJson(response.data['data']));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(String filePath) async {
    try {
      // Implementation would use MultipartFile
      return const Right('');
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _apiService.delete('/profile');
      return const Right(null);
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }
}