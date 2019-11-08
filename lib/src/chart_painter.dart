import 'package:flutter/material.dart';
import 'dart:math' as math;

class PieChartPainter extends CustomPainter {
  PieChartPainter(
    double angleFactor,
    this.showChartValuesOutside,
    List<Color> colorList, {
    this.chartValueStyle,
    this.chartValueBackgroundColor,
    List<double> values,
    this.initialAngle,
    this.showValuesInPercentage,
    this.decimalPlaces,
    this.showChartValueLabel,
  }) {
    for (int i = 0; i < values.length; i++) {
      _paintList.add(Paint()..color = _getColor(colorList, i));
    }
    _totalAngle = angleFactor * math.pi * 2;
    _subParts = values;
    _total = values.fold(0, (v1, v2) => v1 + v2);
  }

  List<Paint> _paintList = [];
  List<double> _subParts;
  double _total = 0;
  double _totalAngle = math.pi * 2;

  final TextStyle chartValueStyle;
  final Color chartValueBackgroundColor;
  final double initialAngle;
  final bool showValuesInPercentage;
  final bool showChartValuesOutside;
  final int decimalPlaces;
  final bool showChartValueLabel;

  double _prevAngle = 0;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.width < size.height ? size.width : size.height;
    _prevAngle = this.initialAngle;
    for (int i = 0; i < _subParts.length; i++) {
      canvas.drawArc(
        new Rect.fromLTWH(0.0, 0.0, side, size.height),
        _prevAngle,
        (((_totalAngle) / _total) * _subParts[i]),
        true,
        _paintList[i],
      );
      final factor = showChartValuesOutside ? 1.65 : 3;
      final x = (side / factor) *
          math.cos(
              _prevAngle + ((((_totalAngle) / _total) * _subParts[i]) / 2));
      final y = (side / factor) *
          math.sin(
              _prevAngle + ((((_totalAngle) / _total) * _subParts[i]) / 2));
      if (_subParts.elementAt(i).toInt() != 0) {
        final name = showValuesInPercentage
            ? (((_subParts.elementAt(i) / _total) * 100)
                    .toStringAsFixed(this.decimalPlaces) +
                '%')
            : _subParts.elementAt(i).toStringAsFixed(this.decimalPlaces);

        _drawName(canvas, name, x, y, side);
      }
      _prevAngle = _prevAngle + (((_totalAngle) / _total) * _subParts[i]);
    }
  }

  Color _getColor(List<Color> colorList, int index) {
    if (index > (colorList.length - 1)) {
      var newIndex = index % (colorList.length - 1);
      return colorList.elementAt(newIndex);
    } else
      return colorList.elementAt(index);
  }

  void _drawName(Canvas canvas, String name, double x, double y, double side) {
    TextSpan span = TextSpan(style: chartValueStyle, text: name);
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    if (showChartValueLabel) {
      //Draw text background box
      final rect = Rect.fromCenter(
        center: Offset((side / 2 + x), (side / 2 + y)),
        width: tp.width + 4,
        height: tp.height + 2,
      );
      final rRect = RRect.fromRectAndRadius(rect, Radius.circular(4));
      final paint = Paint()
        ..color = chartValueBackgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rRect, paint);
    }
    //Finally paint the text above box
    tp.paint(
        canvas,
        new Offset(
            (side / 2 + x) - (tp.width / 2), (side / 2 + y) - (tp.height / 2)));
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      oldDelegate._totalAngle != _totalAngle;
}
