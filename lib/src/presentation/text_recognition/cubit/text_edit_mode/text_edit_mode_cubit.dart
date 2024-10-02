import 'package:bloc/bloc.dart';

part 'text_edit_mode_state.dart';

class TextEditModeCubit extends Cubit<TextEditModeState> {
  TextEditModeCubit() : super(TextEditModeState(isEditingMode: false));

  bool toggleMode() {
    bool res = state.isEditingMode ? false : true;
    emit(TextEditModeState(isEditingMode: res));
    return res;
  }

  reset() {
    emit(TextEditModeState(isEditingMode: false));
  }
}
