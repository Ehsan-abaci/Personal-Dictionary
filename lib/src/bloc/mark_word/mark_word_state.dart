part of 'mark_word_cubit.dart';
class MarkWordState {
  Limit typeOfLimit;
  MarkWordState({
    required this.typeOfLimit,
  });
factory MarkWordState.initial(){
  return MarkWordState(typeOfLimit: Limit.all);
}
  MarkWordState copyWith({
    Limit? typeOfLimit,
  }) {
    return MarkWordState(
      typeOfLimit: typeOfLimit ?? this.typeOfLimit,
    );
  }
 }