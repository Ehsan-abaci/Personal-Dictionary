// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_to_speech_bloc.dart';

 class TextToSpeechEvent {}
class PlayAudioEvent extends TextToSpeechEvent {
  String text;
  LanguageMode mode;
  PlayAudioEvent({
    required this.text,
    required this.mode,
  });
}
