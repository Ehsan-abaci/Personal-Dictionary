import 'package:bloc/bloc.dart';

import '../../domain/models/word.dart';

part 'mark_word_state.dart';

class MarkWordCubit extends Cubit<MarkWordState> {
  MarkWordCubit() : super(MarkWordState.initial());
  setMarkedWordsEvent() {
    emit(state.copyWith(typeOfLimit: Limit.marked));
  }
  setAllWordsEvent() {
    emit(state.copyWith(typeOfLimit: Limit.all));
  }
}
