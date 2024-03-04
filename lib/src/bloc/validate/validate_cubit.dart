import 'package:bloc/bloc.dart';

part 'validate_state.dart';

class ValidateCubit extends Cubit<ValidateState> {
  ValidateCubit() : super(ValidateState.initial());

   isEmptyValidate(String txt){
    emit(state.copyWith(isValid: txt.isEmpty ? false : true));
  }
}
