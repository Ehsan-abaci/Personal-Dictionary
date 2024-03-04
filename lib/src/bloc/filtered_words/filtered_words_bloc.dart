import 'package:bloc/bloc.dart';
import '../../domain/models/word.dart';

part 'filtered_words_event.dart';
part 'filtered_words_state.dart';

class FilteredWordsBloc extends Bloc<FilteredWordsEvent, FilteredWordsState> {
  FilteredWordsBloc() : super(FilteredWordsState.initial()) {
    on<SetFilteredWords>((event, emit) {
      print(event.words);
      List<Word> filteredWords = event.words;
      if(event.limit == Limit.marked){
         filteredWords = filteredWords.where((word) => word.isMarked).toList();
      }
      for(Filter filter in event.filter){
        switch(filter){
          case Filter.verb:
          filteredWords = filteredWords.where((word) => word.verb).toList();
          break;
          case Filter.adjective:
          filteredWords = filteredWords.where((word) => word.adj).toList();
           break;
           case Filter.adverb :
          filteredWords = filteredWords.where((word) => word.adverb).toList();
          break;
          case Filter.noun :
          filteredWords = filteredWords.where((word) => word.noun).toList();
          break;
           case Filter.phrases :
          filteredWords = filteredWords.where((word) => word.phrases).toList();
          break;
        }
      }
      if(event.searchTerm.isNotEmpty){
        filteredWords = filteredWords.where((word) => word.title.toLowerCase().contains(event.searchTerm.toLowerCase())).toList();
      }
      emit(state.copyWith(wordList: filteredWords));
    });
  }
}
