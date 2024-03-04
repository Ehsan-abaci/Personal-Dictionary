// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filtered_words_bloc.dart';

 class FilteredWordsEvent {}
class SetFilteredWords extends FilteredWordsEvent {
  List<Word> words;
  String searchTerm;
  List<Filter> filter;
  Limit limit;
  SetFilteredWords({
    required this.words,
    required this.searchTerm,
    required this.filter,
    required this.limit,
  });
}
