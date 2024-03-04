// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'word_filter_bloc.dart';

 class WordFilterEvent {}
class SetWordFilterEvent extends WordFilterEvent {
  List<Filter> filters;
  SetWordFilterEvent({
    required this.filters,
  });
}
