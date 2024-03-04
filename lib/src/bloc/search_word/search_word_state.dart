part of 'search_word_cubit.dart';

class SearchWordState {
  String searchTerm;
  SearchWordState({
    required this.searchTerm,
  });
factory SearchWordState.initial(){
  return SearchWordState(searchTerm: "");
}
  SearchWordState copyWith({
    String? searchTerm,
  }) {
    return SearchWordState(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
 }