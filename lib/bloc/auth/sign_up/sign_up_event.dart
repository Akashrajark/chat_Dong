part of 'sign_up_bloc.dart';

class SignUpEvent {
  final String name, email, password;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}
