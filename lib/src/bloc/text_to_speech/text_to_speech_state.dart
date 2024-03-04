// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_to_speech_bloc.dart';

enum ErrorStatus {
  error,
  initial,
}

class TextToSpeechState {
  ErrorStatus status;
  String? errorMessage;

  TextToSpeechState({
    required this.status,
    this.errorMessage,
  });

  factory TextToSpeechState.initial() {
    return TextToSpeechState( status: ErrorStatus.initial);
  }

  TextToSpeechState copyWith({

    ErrorStatus? status,
    String? errorMessage,
  }) {
    return TextToSpeechState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
