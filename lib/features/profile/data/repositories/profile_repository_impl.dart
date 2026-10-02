import 'package:dartz/dartz.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    final result = await _remoteDataSource.getProfile();
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdateRequest request) async {
    final requestModel = request.toModel();
    final result = await _remoteDataSource.updateProfile(requestModel);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(String filePath) async {
    return await _remoteDataSource.uploadAvatar(filePath);
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return await _remoteDataSource.deleteAccount();
  }
}