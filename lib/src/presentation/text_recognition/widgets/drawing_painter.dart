import 'package:flutter/material.dart';

class DrawingLine {
  final List<Offset> offset;
  final Color color;
  final double penSize;

  DrawingLine(this.offset, this.color, this.penSize);
}

class DrawingPainter extends CustomPainter {
  final List<DrawingLine> _lines;

  DrawingPainter(this._lines);

  @override
  void paint(Canvas canvas, Size size) {
    if (_lines.isEmpty) return;

    for (final line in _lines) {
      Paint paint = Paint()
        ..color = line.color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square
        ..strokeJoin = StrokeJoin.bevel
        ..strokeWidth = line.penSize;

      for (int j = 0; j < line.offset.length - 1; j++) {
        canvas.drawLine(line.offset[j], line.offset[j + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
