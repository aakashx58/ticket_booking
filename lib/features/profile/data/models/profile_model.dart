import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/profile.dart';
import '../../../auth/domain/entities/user.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required UserModel user,
    required int totalBookings,
    required int upcomingEvents,
    required int pastEvents,
    required double totalSpent,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}

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

@freezed
class ProfileUpdateRequestModel with _$ProfileUpdateRequestModel {
  const factory ProfileUpdateRequestModel({
    String? name,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? avatarUrl,
  }) = _ProfileUpdateRequestModel;

  factory ProfileUpdateRequestModel.fromJson(Map<String, dynamic> json) => _$ProfileUpdateRequestModelFromJson(json);
}

extension ProfileModelX on ProfileModel {
  Profile toEntity() {
    return Profile(
      user: user.toEntity(),
      totalBookings: totalBookings,
      upcomingEvents: upcomingEvents,
      pastEvents: pastEvents,
      totalSpent: totalSpent,
    );
  }
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

extension ProfileUpdateRequestX on ProfileUpdateRequest {
  ProfileUpdateRequestModel toModel() {
    return ProfileUpdateRequestModel(
      name: name,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      avatarUrl: avatarUrl,
    );
  }
}