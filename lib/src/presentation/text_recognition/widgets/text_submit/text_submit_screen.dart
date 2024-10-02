import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_dictionary/src/presentation/text_recognition/widgets/text_submit/text_submit_screen_controller.dart';

import '../../../resources/color_manager.dart';
import '../../cubit/text_edit_mode/text_edit_mode_cubit.dart';

class TextSubmitScreen {
  TextSubmitScreen._internal();
  static final TextSubmitScreen _inst = TextSubmitScreen._internal();
  factory TextSubmitScreen.inst() => _inst;

  TextSubmitScreenController? controller;

  bool get isShowing => controller != null;

  void show({
    required BuildContext context,
    required String text,
    required Function(String) onCheck,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        txt: text,
        onCheck: onCheck,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  TextSubmitScreenController showOverlay({
    required BuildContext context,
    required String txt,
    required Function(String) onCheck,
  }) {
    final text = StreamController<String>();
    text.add(txt);
    final textEditingController = TextEditingController(text: txt);
    final textFocusNode = FocusNode();

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: size.height * .4,
                width: size.width * .8,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: BlocBuilder<TextEditModeCubit, TextEditModeState>(
                        builder: (context, state) {
                          return SizedBox(
                            height: size.height * .15,
                            child: TextField(
                              focusNode: textFocusNode,
                              controller: textEditingController,
                              maxLines: null, // Set this
                              expands: true, // and this
                              keyboardType: TextInputType.multiline,
                              readOnly: !state.isEditingMode,
                              textAlign: ui.TextAlign.center,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: 24,
                                  fontWeight: ui.FontWeight.w600),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child:
                            BlocBuilder<TextEditModeCubit, TextEditModeState>(
                          builder: (context, state) {
                            return ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: BorderSide(color: ColorManager.white),
                                foregroundColor: ColorManager.white,
                                shadowColor: Colors.transparent,
                              ),
                              label:
                                  Text(state.isEditingMode ? 'submit' : 'edit'),
                              onPressed: () {
                                final res = context
                                    .read<TextEditModeCubit>()
                                    .toggleMode();
                                if (res) {
                                  textFocusNode.requestFocus();
                                } else {
                                  textFocusNode.unfocus();
                                }
                              },
                              icon: Icon(
                                state.isEditingMode
                                    ? CupertinoIcons.clear
                                    : CupertinoIcons.pencil_outline,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: hide,
                          icon: const Icon(
                            CupertinoIcons.clear_circled,
                            size: 35,
                          ),
                          color: ColorManager.white,
                        ),
                        const SizedBox(width: 30),
                        IconButton(
                          onPressed: () {
                            onCheck(textEditingController.text);
                            hide();
                          },
                          icon: const Icon(
                            CupertinoIcons.check_mark_circled,
                            size: 35,
                          ),
                          color: ColorManager.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return TextSubmitScreenController(
      close: () {
        context.read<TextEditModeCubit>().reset();
        text.close();
        overlay.remove();
        return true;
      },
      update: (texts) {
        text.add(texts);
        return true;
      },
    );
  }
}
