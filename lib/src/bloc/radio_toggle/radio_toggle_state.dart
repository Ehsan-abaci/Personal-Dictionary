// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'radio_toggle_bloc.dart';

class RadioToggleState {
  bool nounToggle;
  bool adjectiveToggle;
  bool adverbToggle;
  bool verbToggle;
  bool phrasesToggle;

  RadioToggleState({
     this.nounToggle = false,
     this.adjectiveToggle = false,
     this.adverbToggle = false,
     this.verbToggle = false,
     this.phrasesToggle = false,
  });

  factory RadioToggleState.initial(){
    return RadioToggleState();
  }


  RadioToggleState copyWith({
    bool? nounToggle,
    bool? adjectiveToggle,
    bool? adverbToggle,
    bool? verbToggle,
    bool? phrasesToggle,
  }) {
    return RadioToggleState(
      nounToggle: nounToggle ?? this.nounToggle,
      adjectiveToggle: adjectiveToggle ?? this.adjectiveToggle,
      adverbToggle: adverbToggle ?? this.adverbToggle,
      verbToggle: verbToggle ?? this.verbToggle,
      phrasesToggle: phrasesToggle ?? this.phrasesToggle,
    );
  }
 }


