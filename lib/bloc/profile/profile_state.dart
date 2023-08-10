part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadinglState extends ProfileState {}

class ProfileSuccessState extends ProfileState {}

class ProfileFailureState extends ProfileState {}

class SignInInitialState extends ProfileState {}

class SignInLoadingState extends ProfileState {}

class SignInFailureState extends ProfileState {}

class SignInSuccessState extends ProfileState {}

class EditinitialState extends ProfileState {}

class EditLoadingState extends ProfileState {}

class EditSuccessState extends ProfileState {}

class EditFailureState extends ProfileState {}
