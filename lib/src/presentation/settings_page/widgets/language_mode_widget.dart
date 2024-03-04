
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';
import 'package:your_dictionary/src/bloc/word/word_bloc.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';

class LanguageModeWidget extends StatefulWidget {
  const LanguageModeWidget({super.key});

  @override
  State<LanguageModeWidget> createState() => _LanguageModeWidgetState();
}

class _LanguageModeWidgetState extends State<LanguageModeWidget> {
  List<String> txt = [
    "English | Persian",
    "German | English",
    "German | Persian",
  ];
  Map<int, LanguageMode> lanModeMap = {
    0: LanguageMode.En_Fa,
    1: LanguageMode.De_En,
    2: LanguageMode.De_Fa,
  };
  LanguageMode? currentLanMode;

  @override
  void didChangeDependencies() {
    currentLanMode = context.watch<WordBloc>().state.mode;
    super.didChangeDependencies();
  }

  Color? txtColor;

  void onChangedItem(int val) async {
    context
        .read<WordBloc>()
        .add(ChangeLanguageModeEvent(mode: lanModeMap[val]!));
    if ((await Vibration.hasVibrator()) ?? false) {
      if ((await Vibration.hasAmplitudeControl()) ?? false) {
        Vibration.vibrate(duration: 30, amplitude: 128);
      } else {
        Vibration.vibrate(duration: 30);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Stack(
          children: [
            ListWheelScrollView.useDelegate(
              itemExtent: constraints.maxHeight * .32,
              perspective: 0.002,
              onSelectedItemChanged: onChangedItem,
              controller: FixedExtentScrollController(
                initialItem: lanModeMap.keys.firstWhere(
                  (e) => lanModeMap[e] == currentLanMode,
                ),
              ),
              physics: const FixedExtentScrollPhysics(
                  parent: BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast)),
              childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    txtColor = index ==
                            lanModeMap.keys.firstWhere(
                                (e) => lanModeMap[e] == currentLanMode)
                        ? ColorManager.primary
                        : Colors.black26;
                    return Center(
                      child: FittedBox(
                        child: Text(
                          txt[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: txtColor,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 3),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              height: 3,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: ColorManager.white,
                        blurRadius: 7,
                        spreadRadius: 1),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              height: 3,
              child: Container(
                  decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: ColorManager.white, blurRadius: 7, spreadRadius: 1),
              ])),
            ),
            Positioned(
                top: constraints.maxHeight * .51,
                left: 0,
                right: 0,
                child: Divider(
                  color: ColorManager.primary.withOpacity(.6),
                  thickness: 2,
                )),
            Positioned(
                bottom: constraints.maxHeight * .51,
                left: 0,
                right: 0,
                child: Divider(
                  color: ColorManager.primary.withOpacity(.6),
                  thickness: 2,
                )),
          ],
        ),
      ),
    );
  }
}
