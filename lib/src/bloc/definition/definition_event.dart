// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'definition_bloc.dart';

 class DefinitionEvent {}
class AddDefsEvent extends DefinitionEvent {
  List<String> faDefs;
  List<String> enDefs;
  List<String> mainExample;
  AddDefsEvent({
    required this.faDefs,
    required this.enDefs,
    required this.mainExample,
  });
 }
class AddToSecDefsEvent extends DefinitionEvent {
  String faDef;
  AddToSecDefsEvent({
    required this.faDef,
  });
}
class AddToMainDefsEvent extends DefinitionEvent {
  String enDef;
  AddToMainDefsEvent({
    required this.enDef,
  });
}
class AddToMainExEvent extends DefinitionEvent {
  String mainExample;
  AddToMainExEvent({
    required this.mainExample,
  });
}
  class ResetDefinitionEvent extends DefinitionEvent{}

class RemoveFromSecDefEvent extends DefinitionEvent {
    int index;
  RemoveFromSecDefEvent({
    required this.index,
  });
  }
class RemoveFromMainDefEvent extends DefinitionEvent {
  int index;
  RemoveFromMainDefEvent({
    required this.index,
  });
}
class RemoveFromMainExEvent extends DefinitionEvent {
  int index;
  RemoveFromMainExEvent({
    required this.index,
  });
}
