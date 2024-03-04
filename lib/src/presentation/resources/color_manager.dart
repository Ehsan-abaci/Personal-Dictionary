import 'dart:ui';
class ColorManager{
  static Color primary = HexColor.fromHexColor('#151345');
  static Color white = HexColor.fromHexColor('#ffffff');
  static Color yellow = HexColor.fromHexColor('#f0ce0e');
  static Color grey = HexColor.fromHexColor('#E8e8ea');
  static Color filterColor = const Color.fromARGB(255, 199, 196, 196);
}


extension HexColor on Color{
  static Color fromHexColor(String hexColor){
    hexColor = hexColor.replaceAll('#', '');
    if(hexColor.length ==6){
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor,radix: 16));
  }
}