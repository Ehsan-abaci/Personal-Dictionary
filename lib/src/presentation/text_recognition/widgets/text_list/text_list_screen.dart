import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
import 'package:your_dictionary/src/presentation/text_recognition/cubit/recognitioned_texts/recognitioned_texts_cubit.dart';

import '../../../../common/widgets.dart';
import 'text_list_screen_controller.dart';

class TextListScreen {
  TextListScreen._internal();
  static final TextListScreen _inst = TextListScreen._internal();
  factory TextListScreen.inst() => _inst;

  TextListScreenController? controller;

  bool get isShowing => controller != null;

  void show({
    required BuildContext context,
    required Function(String) onCheck,
  }) {
    if (controller?.update() ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        onCheck: onCheck,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  TextListScreenController showOverlay({
    required BuildContext context,
    required Function(String) onCheck,
  }) {
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<RecognitionedTextsCubit>(),
          child: Material(
            color: Colors.black.withAlpha(150),
            child: Center(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: size.height * .5,
                  width: size.width * .8,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: ShapeDecoration(
                  
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.transparent.withOpacity(.2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Recognized texts",
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Expanded(
                        child: BlocBuilder<RecognitionedTextsCubit,
                            RecognitionedTextsState>(
                          builder: (context, state) => ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemCount: state.texts.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, i) => Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: defItem(
                                  state.texts[i],
                                  TextDirection.ltr,
                                  () {
                                    context
                                        .read<RecognitionedTextsCubit>()
                                        .removeTextFromList(i);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return TextListScreenController(
      close: () {
        overlay.remove();
        return true;
      },
      update: () {
        return true;
      },
    );
  }
}
