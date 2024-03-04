part of 'validate_cubit.dart';


 class ValidateState {
   bool isValid;
   ValidateState({ required this.isValid});

   factory ValidateState.initial(){
    return ValidateState(isValid: true);
   }
ValidateState copyWith({
    bool? isValid,
  }) {
    return ValidateState(
      isValid: isValid ?? this.isValid,
    );
  }
 }
