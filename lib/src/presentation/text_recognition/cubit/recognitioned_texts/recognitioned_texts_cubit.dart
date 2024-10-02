import 'package:bloc/bloc.dart';
import 'package:your_dictionary/src/bloc/word/word_bloc.dart';

import '../../../../domain/models/word.dart';

part 'recognitioned_texts_state.dart';

class RecognitionedTextsCubit extends Cubit<RecognitionedTextsState> {
  final WordBloc wordBloc;
  RecognitionedTextsCubit(
    this.wordBloc,
  ) : super(RecognitionedTextsState.initial());

  addWordToList(String text) {
    emit(state.copyWith(texts: [...state.texts, text]));
  }

  removeTextFromList(int index) {
    emit(state.copyWith(texts: state.texts..removeAt(index)));
  }

  submitWords() {
    final texts = state.texts;
    final List<Word> words = [];
    for (final t in texts) {
      words.add(Word(title: t));
    }
    wordBloc.add(AddMultiWordsEvent(wordsData: words));
  }
}
