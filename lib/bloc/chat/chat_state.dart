part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatFailureState extends ChatState {}

class ChatSuccessState extends ChatState {}
