import 'package:flutter/material.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
class RadioNameButton extends StatelessWidget {
   RadioNameButton({super.key,required this.name,required this.function,required this.val});
final Function(bool?) function;
final String name;
final bool val;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min,
      children: [
        Radio(fillColor: MaterialStatePropertyAll(ColorManager.primary),value: val, groupValue: true, onChanged:function,toggleable: true,),
        Text(name,style: TextStyle(fontSize: 16,color: ColorManager.primary)),
      ],
    );
  }
}