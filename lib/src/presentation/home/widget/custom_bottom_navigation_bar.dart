import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_dictionary/src/bloc/mark_word/mark_word_cubit.dart';
import 'package:your_dictionary/src/domain/models/word.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:your_dictionary/src/presentation/resources/assets_manager.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      height: 60,
      child: CustomPaint(
        painter: CustomNavbar(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BlocBuilder<MarkWordCubit, MarkWordState>(
              builder: (context, state) {
                return iconButtonBar(
               icon: IconAssets.selectedHome,
                  color: state.typeOfLimit == Limit.all
                      ? Colors.blue.shade300
                      : Colors.black,
                  function: () {
                    context.read<MarkWordCubit>().setAllWordsEvent();
                  },
                );
              },
            ),
            BlocBuilder<MarkWordCubit, MarkWordState>(
              builder: (context, state) {
                return iconButtonBar(
                  icon: IconAssets.selectedBookmark,
                  color: state.typeOfLimit == Limit.marked
                      ? Colors.blue.shade300
                      : Colors.black,
                  function: () {
                    context.read<MarkWordCubit>().setMarkedWordsEvent();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget iconButtonBar(
      {required String icon,
      required Color color,
      required VoidCallback function}) {
    return Column(
      children: [
        IconButton(
          splashRadius: 1,
          onPressed: function,
          icon: SvgPicture.asset(
            icon,
            height: 30,
            color: color,
          ),
        ),
      ],
    );
  }
}

class CustomNavbar extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const targetXPercent = .5;
    const holeWidth = 100.0;
    const holeHalfWidth = .5 * holeWidth;
    const holeHeight = 40.0;

    final targetX = size.width * targetXPercent;

    Path p = Path();

    p.moveTo(0, 0);
    p.lineTo(targetX - holeHalfWidth, 0);
    final point1 = Offset(targetX - holeHalfWidth - 15, 0);
    p.lineTo(point1.dx, point1.dy);
    final point2 = Offset(targetX, holeHeight);
    final controlPoint1 = Offset(point1.dx + 22, 0);
    final controlPoint2 = Offset(point1.dx + 25, 40);
    p.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      point2.dx,
      point2.dy,
    );
    final point3 = Offset(targetX + holeHalfWidth + 15, 0);
    final controlPoint3 = Offset(point3.dx - 25, 40);
    final controlPoint4 = Offset(point3.dx - 22, 0);
    p.cubicTo(
      controlPoint3.dx,
      controlPoint3.dy,
      controlPoint4.dx,
      controlPoint4.dy,
      point3.dx,
      point3.dy,
    );
    p.lineTo(size.width, 0);
    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    p.lineTo(0, 0);
    final navPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      // ..imageFilter =
      //     ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.decal)
      ..color = Color.fromARGB(255, 255, 255, 255);
    canvas.drawPath(p, navPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
// class CustomNavbar extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Path path = Path()
//       ..moveTo(0, size.height)
//       ..lineTo(size.width, size.height)
//       ..lineTo(size.width, size.height - 60)
//       ..arcTo(
//         Rect.fromCircle(
//             center: Offset(size.width - 5, size.height - 60), radius: 5),
//         0,
//         -pi / 2,
//         false,
//       )
//       ..lineTo(size.width / 2, size.height - 65)
//       ..arcTo(
//           Rect.fromCircle(
//               center: Offset(size.width / 2 + 44, size.height - 61), radius: 4),
//           -pi / 2,
//           -pi,
//           false)
//       ..arcTo(
//           Rect.fromCircle(
//               center: Offset(size.width / 2, size.height - 61), radius: 40),
//           0,
//           pi,
//           false)
//       ..arcTo(
//           Rect.fromCircle(
//               center: Offset(size.width / 2 - 44, size.height - 61), radius: 4),
//           0,
//           -pi / 2,
//           false)
//       ..arcTo(
//         Rect.fromCircle(center: Offset(5, size.height - 60), radius: 5),
//         3 * pi / 2,
//         -pi,
//         false,
//       )
//       ..lineTo(0, size.height - 65)
//       ..lineTo(0, size.height)
//       ..close();
//     final navPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeJoin = StrokeJoin.round
//       ..strokeCap = StrokeCap.round
//       ..imageFilter =
//           ImageFilter.blur(sigmaX: 1, sigmaY: 1, tileMode: TileMode.decal)
//       ..color = Color.fromARGB(255, 255, 255, 255);
//     canvas.drawPath(path, navPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
