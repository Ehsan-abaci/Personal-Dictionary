// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'word_bloc.dart';

enum LanguageMode {
  En_Fa(EN_FA_BOX),
  De_En(DE_EN_BOX),
  De_Fa(DE_FA_BOX);

  final String box;

  const LanguageMode(this.box);

  factory LanguageMode.get(String box) {
    switch (box) {
      case EN_FA_BOX:
        return LanguageMode.En_Fa;
      case DE_EN_BOX:
        return LanguageMode.De_En;
      case DE_FA_BOX:
        return LanguageMode.De_Fa;
      default:
        return LanguageMode.En_Fa;
    }
  }
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
