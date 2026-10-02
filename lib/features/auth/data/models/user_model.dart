import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    required bool isEmailVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension UserEntityX on User {
  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}