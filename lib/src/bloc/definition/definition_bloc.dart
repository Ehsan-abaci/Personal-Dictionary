import 'package:bloc/bloc.dart';

part 'definition_event.dart';
part 'definition_state.dart';

class DefinitionBloc extends Bloc<DefinitionEvent, DefinitionState> {
  DefinitionBloc() : super(DefinitionState.initial()) {
    on<AddToSecDefsEvent>((event, emit) {
     emit(state.copyWith(secDefs: state.secDefs..add(event.faDef)));
    });
      on<AddToMainDefsEvent>((event, emit) {
     emit(state.copyWith(mainDefs: state.mainDefs..add(event.enDef)));
    });
     on<AddToMainExEvent>((event, emit) {
     emit(state.copyWith(mainExample: state.mainExample..add(event.mainExample)));
    });
    on<RemoveFromSecDefEvent>((event, emit) {
     List<String> newFaDef = state.secDefs..removeAt(event.index);
      emit(state.copyWith(secDefs: newFaDef));
    });
      on<RemoveFromMainDefEvent>((event, emit) {
      emit(state.copyWith(mainDefs: state.mainDefs..removeAt(event.index)));
    });
     on<RemoveFromMainExEvent>((event, emit) {
      emit(state.copyWith(mainExample: state.mainExample..removeAt(event.index)));
    });
    on<ResetDefinitionEvent>((event, emit) {
      emit(state.copyWith(mainDefs: [],secDefs: [],mainExample: []));
    });
    on<AddDefsEvent>((event, emit) {
      emit(state.copyWith(mainDefs: event.enDefs,secDefs: event.faDefs,mainExample: event.mainExample));
    });
  }
}
