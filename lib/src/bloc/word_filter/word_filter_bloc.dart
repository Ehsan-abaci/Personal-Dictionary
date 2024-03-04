import 'package:bloc/bloc.dart';
import 'package:your_dictionary/src/domain/models/word.dart';

part 'word_filter_event.dart';
part 'word_filter_state.dart';

class WordFilterBloc extends Bloc<WordFilterEvent, WordFilterState> {
  WordFilterBloc() : super(WordFilterState.initial()) {
    on<SetWordFilterEvent>((event, emit) {
      emit(state.copyWith(filters: event.filters));
    });
  }
}
