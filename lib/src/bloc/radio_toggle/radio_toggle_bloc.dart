import 'package:bloc/bloc.dart';
part 'radio_toggle_event.dart';
part 'radio_toggle_state.dart';

class RadioToggleBloc extends Bloc<RadioToggleEvent, RadioToggleState> {
  RadioToggleBloc() : super(RadioToggleState.initial()) {
    on<NounToggleEvent>((event, emit) { 
      emit(
          state.copyWith(nounToggle: state.nounToggle == false ? true : false));
    });
     on<AdjToggleEvent>((event, emit) {
      emit(
          state.copyWith(adjectiveToggle: state.adjectiveToggle == false ? true : false));
    });
     on<AdverbToggleEvent>((event, emit) {
      emit(
          state.copyWith(adverbToggle: state.adverbToggle == false ? true : false));
    });
     on<VerbToggleEvent>((event, emit) {
      emit(
          state.copyWith(verbToggle: state.verbToggle == false ? true : false));
    });
     on<PhrasesToggleEvent>((event, emit) {
      emit(
          state.copyWith(phrasesToggle: state.phrasesToggle == false ? true : false));
    });
    on<ResetToggleEvent>((event, emit) => emit(state.copyWith(
      adjectiveToggle: false,
      adverbToggle: false,
      nounToggle: false,
      phrasesToggle: false,
      verbToggle: false,
    )));
    on<SetToggleEvent>((event, emit) {
      emit(state.copyWith(
        adjectiveToggle: event.adjectiveToggle,
        adverbToggle: event.adverbToggle,
        nounToggle: event.nounToggle,
        phrasesToggle: event.phrasesToggle,
        verbToggle: event.verbToggle,
      ));
    });
  }
}
