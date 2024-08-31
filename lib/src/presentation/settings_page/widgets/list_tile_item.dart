import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';

Widget listTileItem(BoxConstraints constraints, String title, VoidCallback func,
    Widget trailing) {
  return SizedBox(
    height: constraints.maxWidth > 450
        ? constraints.maxHeight * 0.15
        : constraints.maxHeight * 0.07,
    width: constraints.maxWidth,
    child: InkWell(
      overlayColor: MaterialStatePropertyAll(ColorManager.white),
      onTap: func,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: constraints.maxWidth > 450
                ? constraints.maxWidth * .7
                : constraints.maxWidth * 0.70,
            child: Text(
              title,
              style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
              width: constraints.maxWidth > 450
                  ? constraints.maxWidth * .2
                  : constraints.maxWidth * .2,
              child: trailing),
        ],
      ),
    ),
  );
}

Widget languageModeItem(BoxConstraints constraints, String title,
    VoidCallback func, Widget trailing) {
  return SizedBox(
    height: constraints.maxWidth > 450
        ? constraints.maxHeight * 0.15
        : constraints.maxHeight * 0.09,
    width: constraints.maxWidth,
    child: InkWell(
      overlayColor: MaterialStatePropertyAll(ColorManager.white),
      onTap: func,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: constraints.maxWidth > 450
                ? constraints.maxWidth * .7
                : constraints.maxWidth * 0.60,
            child: Text(
              title,
              style: TextStyle(
                color: ColorManager.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
              width: constraints.maxWidth > 450
                  ? constraints.maxWidth * .2
                  : constraints.maxWidth * .3,
              child: Center(child: trailing)),
        ],
      ),
    ),
  );
}
