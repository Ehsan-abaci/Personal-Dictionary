// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filtered_words_bloc.dart';

class FilteredWordsState {
   final List<Word> wordList;
  FilteredWordsState({
    required this.wordList,
  });

  factory FilteredWordsState.initial(){
   return FilteredWordsState(
    wordList: [],
   );
  }

  FilteredWordsState copyWith({
    List<Word>? wordList,
  }) {
    return FilteredWordsState(
      wordList: wordList ?? this.wordList,
    );
  }
 }


