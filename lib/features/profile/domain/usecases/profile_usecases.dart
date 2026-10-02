import 'package:dartz/dartz.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';
import '../../core/errors/failures.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, Profile>> call() {
    return repository.getProfile();
  }
}

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, Profile>> call(ProfileUpdateRequest request) {
    return repository.updateProfile(request);
  }
}

class UploadAvatarUseCase {
  final ProfileRepository repository;

  UploadAvatarUseCase(this.repository);

  Future<Either<Failure, String>> call(String filePath) {
    return repository.uploadAvatar(filePath);
  }
}

class DeleteAccountUseCase {
  final ProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.deleteAccount();
  }
}