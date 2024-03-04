import 'package:bloc/bloc.dart';


part 'search_word_state.dart';

class SearchWordCubit extends Cubit<SearchWordState> {
  SearchWordCubit() : super(SearchWordState.initial());

  setSearchTerm ({required String searchTerm}){
      emit(state.copyWith(searchTerm: searchTerm));
  }
}
