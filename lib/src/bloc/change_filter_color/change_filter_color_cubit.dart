import 'dart:ui';

import 'package:bloc/bloc.dart';

import '../../presentation/resources/color_manager.dart';

part 'change_filter_color_state.dart';

class ChangeFilterColorCubit extends Cubit<ChangeFilterColorState> {
  ChangeFilterColorCubit() : super(ChangeFilterColorState.initial());

  void setFilterColor({
    required int filterIndex,
    required Color color,
  }) {
    emit(state.copyWith(
        colorMap: state.colorMap
          ..update(
              filterIndex,
              (value) => value == ColorManager.white
                  ? color
                  : ColorManager.white)));
  }
}
