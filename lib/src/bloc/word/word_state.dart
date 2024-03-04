// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'word_bloc.dart';
enum LanguageMode{
  En_Fa,
  De_En,
  De_Fa,
}
class WordState {
 final List<Word> wordList;
 final LanguageMode mode;
  WordState({
    required this.wordList,
    required this.mode,
  });
 

  factory WordState.initial(LanguageMode mode) {
    return WordState(
     wordList: [],
     mode: mode,
    );
  }

  WordState copyWith({
    List<Word>? wordList,
    LanguageMode? mode, 
  }) {
    return WordState(
      wordList: wordList ?? this.wordList,
      mode: mode ?? this.mode,
    );
  }
}
