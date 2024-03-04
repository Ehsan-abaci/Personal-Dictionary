// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'word_filter_bloc.dart';

class WordFilterState {
  final List<Filter> filters;
  WordFilterState({
    required this.filters,
  });

factory WordFilterState.initial(){
  return WordFilterState(filters: []);
}
  WordFilterState copyWith({
    List<Filter>? filters,
  }) {
    return WordFilterState(
      filters: filters ?? this.filters,
    );
  }
 }

