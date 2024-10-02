part of 'recognitioned_texts_cubit.dart';

class RecognitionedTextsState {
  List<String> texts;
  RecognitionedTextsState({
    required this.texts,
  });

  factory RecognitionedTextsState.initial() {
    return RecognitionedTextsState(
      texts: [],
    );
  }

  RecognitionedTextsState copyWith({
    List<String>? texts,
  }) {
    return RecognitionedTextsState(
      texts: texts ?? this.texts,
    );
  }
}
