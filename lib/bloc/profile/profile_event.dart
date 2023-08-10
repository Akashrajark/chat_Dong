part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileEventLogOut extends ProfileEvent {
  final String? token;

  ProfileEventLogOut(this.token);
}

class ProfileChangePasswordEvent extends ProfileEvent {
  final String email, password, newPassword;

  ProfileChangePasswordEvent(
      {required this.email, required this.password, required this.newPassword});
}

class EditProfileEvent extends ProfileEvent {
  final String name, bio;

  EditProfileEvent({
    required this.name,
    required this.bio,
  });
}
