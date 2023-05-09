import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitialState()) {
    on<SignInEvent>((event, emit) async {
      emit(SignInLoadingState());

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(SignInSuccessState());
      } catch (e, s) {
        Logger().wtf("$e\n$s");
        emit(SignInFailureState());
      }
    });
  }
}
