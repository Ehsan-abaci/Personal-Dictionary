import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'manage_extending_state.dart';

class ManageExtendingCubit extends Cubit<ManageExtendingState> {
  ManageExtendingCubit() : super(ManageExtendingState.initial());

    // Add a Map to keep track of the 'isExtended' state for each item
  Map<Key, bool> isExtendedMap = {};

  // Modify the 'switching' function to take an 'index' parameter
  switching(Key key){
    // Toggle the 'isExtended' state for the item at 'index'
    isExtendedMap[key] = !(isExtendedMap[key] ?? false);

    // Emit a new state to trigger a rebuild
    emit(ManageExtendingState(isExtendedMap: isExtendedMap));
  }
}
