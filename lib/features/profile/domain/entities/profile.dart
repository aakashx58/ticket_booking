import 'package:equatable/equatable.dart';
import '../../auth/domain/entities/user.dart';

class Profile extends Equatable {
  final User user;
  final int totalBookings;
  final int upcomingEvents;
  final int pastEvents;
  final double totalSpent;

  const Profile({
    required this.user,
    required this.totalBookings,
    required this.upcomingEvents,
    required this.pastEvents,
    required this.totalSpent,
  });

  @override
  List<Object?> get props => [user, totalBookings, upcomingEvents, pastEvents, totalSpent];
}

class ProfileUpdateRequest extends Equatable {
  final String? name;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? avatarUrl;

  const ProfileUpdateRequest({
    this.name,
    this.phoneNumber,
    this.dateOfBirth,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, phoneNumber, dateOfBirth, avatarUrl];
}