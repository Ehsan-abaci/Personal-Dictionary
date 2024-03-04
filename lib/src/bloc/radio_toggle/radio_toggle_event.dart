// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'radio_toggle_bloc.dart';

class RadioToggleEvent {}

class NounToggleEvent extends RadioToggleEvent {}

class AdjToggleEvent extends RadioToggleEvent {}

class AdverbToggleEvent extends RadioToggleEvent {}

class VerbToggleEvent extends RadioToggleEvent {}

class PhrasesToggleEvent extends RadioToggleEvent {}
class SetToggleEvent extends RadioToggleEvent {
    bool nounToggle;
  bool adjectiveToggle;
  bool adverbToggle;
  bool verbToggle;
  bool phrasesToggle;
  SetToggleEvent({
    required this.nounToggle,
    required this.adjectiveToggle,
    required this.adverbToggle,
    required this.verbToggle,
    required this.phrasesToggle,
  });
}
class ResetToggleEvent extends RadioToggleEvent {}
