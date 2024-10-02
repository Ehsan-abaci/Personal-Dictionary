import 'package:flutter/material.dart';

import '../presentation/resources/color_manager.dart';

Widget defItem(String def, TextDirection direction, VoidCallback function) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ColoredBox(
        color: ColorManager.primary,
        child: Directionality(
          textDirection: direction,
          child: Padding(
            padding: EdgeInsets.only(
              right: direction == TextDirection.rtl ? 10 : 0,
              left: direction == TextDirection.ltr ? 10 : 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  def,
                  style: TextStyle(fontSize: 14.0, color: ColorManager.white),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  splashRadius: 10,
                  iconSize: 18,
                  onPressed: function,
                  icon: Icon(
                    Icons.close,
                    color: ColorManager.white,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customTextFormField(BoxConstraints constraints, String hintTxt,
    TextDirection direction, TextEditingController controller, Function func) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
    child: Container(
      height: constraints.maxWidth >= 450
          ? constraints.maxHeight * 0.2
          : constraints.maxHeight * 0.09,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Colors.white),
      child: Row(children: [
        IconButton(
          onPressed: () => func(),
          icon: Icon(
            Icons.add,
            color: ColorManager.primary,
          ),
          splashRadius: 1,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onFieldSubmitted: (_) => func(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textDirection: direction,
              controller: controller,
              decoration: InputDecoration(
                fillColor: ColorManager.white,
                filled: true,
                hintText: hintTxt,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ]),
    ),
  );
}
