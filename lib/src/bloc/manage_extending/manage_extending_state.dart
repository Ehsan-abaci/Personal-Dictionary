// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_extending_cubit.dart';

class ManageExtendingState {
  Map<Key, bool> isExtendedMap;

  ManageExtendingState({
    required this.isExtendedMap,

  });

  ManageExtendingState copyWith({required Map<Key, bool>? isExtendedMap}){
    return ManageExtendingState(isExtendedMap: isExtendedMap ?? this.isExtendedMap);
  }

  factory ManageExtendingState.initial(){
    return ManageExtendingState(isExtendedMap: {});
  }
 }


