import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfileEventLogOut>((event, emit) async {
      emit(ProfileLoadinglState());

      try {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseAuth.instance.signOut();

        FirebaseFirestore.instance.collection("Users").doc(uid).set({
          "token": event.token,
        }, SetOptions(merge: true));
        emit(ProfileSuccessState());
      } catch (e, s) {
        Logger().wtf("$e\n$s");
        emit(ProfileFailureState());
      }
    });
    on<ProfileChangePasswordEvent>((event, emit) async {
      emit(SignInLoadingState());

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        await FirebaseAuth.instance.currentUser!
            .updatePassword(event.newPassword);

        emit(SignInSuccessState());
      } catch (e, s) {
        Logger().wtf("$e\n$s");
        emit(SignInFailureState());
      }
    });
    on<EditProfileEvent>((event, emit) async {
      emit(SignInLoadingState());

      try {
        emit(SignInSuccessState());
      } catch (e, s) {
        Logger().wtf("$e\n$s");
        emit(SignInFailureState());
      }
    });
  }
}
