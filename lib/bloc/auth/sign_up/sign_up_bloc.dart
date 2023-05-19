import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpEvent>((event, emit) async {
      emit(SignUpLoadingState());

      try {
        final UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: event.email, password: event.password);
        if (user.user != null) {
          await FirebaseFirestore.instance.collection("Users").add(
            {
              "name": event.name,
              "uid": user.user!.uid,
            },
          );
        }
        emit(SignUpSuccessState());
      } on FirebaseAuthException catch (e, s) {
        Logger().wtf("$e\n$s");
        if (e.message == "422") {
          emit(
            SignUpFailureState(
              message: e.message!,
            ),
          );
        } else {
          emit(SignUpFailureState());
        }
      }
    });
  }
}
