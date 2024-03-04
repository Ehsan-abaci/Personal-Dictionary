// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'definition_bloc.dart';

class DefinitionState {
  List<String> secDefs;
  List<String> mainDefs;
  List<String> mainExample;
  DefinitionState({
    required this.secDefs,
    required this.mainDefs,
    required this.mainExample,
  });

  factory DefinitionState.initial() {
    return DefinitionState(
      secDefs: [],
      mainDefs: [],
      mainExample: [],
    );
  }

  DefinitionState copyWith({
    List<String>? secDefs,
    List<String>? mainDefs,
    List<String>? mainExample,
  }) {
    return DefinitionState(
      secDefs: secDefs ?? this.secDefs,
      mainDefs: mainDefs ?? this.mainDefs,
      mainExample: mainExample ?? this.mainExample,
    );
  }
}
