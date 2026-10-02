part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final ProfileUpdateRequest request;

  const ProfileUpdateRequested({required this.request});

  @override
  List<Object?> get props => [request];
}

class ProfileAvatarUploadRequested extends ProfileEvent {
  final String filePath;

  const ProfileAvatarUploadRequested({required this.filePath});

  @override
  List<Object> get props => [filePath];
}

class ProfileDeleteAccountRequested extends ProfileEvent {
  const ProfileDeleteAccountRequested();
}