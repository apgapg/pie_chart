import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartPainter extends CustomPainter {
  List<Paint> _paintList = [];
  late List<double> _subParts;
  List<String>? _subTitles;
  double _total = 0;
  double _totalAngle = math.pi * 2;

  final TextStyle? chartValueStyle;
  final Color? chartValueBackgroundColor;
  final double? initialAngle;
  final bool? showValuesInPercentage;
  final bool showChartValues;
  final bool showChartValuesOutside;
  final int? decimalPlaces;
  final bool? showChartValueLabel;
  final ChartType? chartType;
  final String? centerText;
  final Function? formatChartValues;
  final double? strokeWidth;
  final Color? emptyColor;

  double _prevAngle = 0;

  PieChartPainter(
    double angleFactor,
    this.showChartValues,
    this.showChartValuesOutside,
    List<Color> colorList, {
    this.chartValueStyle,
    this.chartValueBackgroundColor,
    required List<double> values,
    List<String>? titles,
    this.initialAngle,
    this.showValuesInPercentage,
    this.decimalPlaces,
    this.showChartValueLabel,
    this.chartType,
    this.centerText,
    this.formatChartValues,
    this.strokeWidth,
    this.emptyColor,
  }) {
    _total = values.fold(0, (v1, v2) => v1 + v2);
    for (int i = 0; i < values.length; i++) {
      final paint = Paint()..color = getColor(colorList, i);
      if (chartType == ChartType.ring) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = strokeWidth!;
      }
      _paintList.add(paint);
    }
    _totalAngle = angleFactor * math.pi * 2;
    _subParts = values;
    _subTitles = titles;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.width < size.height ? size.width : size.height;
    if (_total == 0) {
      final paint = Paint()..color = emptyColor!;
      if (chartType == ChartType.ring) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = strokeWidth!;
      }
      canvas.drawArc(
        new Rect.fromLTWH(0.0, 0.0, side, size.height),
        _prevAngle,
        360,
        chartType == ChartType.disc ? true : false,
        paint,
      );
    } else {
      _prevAngle = this.initialAngle! * math.pi / 180;
      for (int i = 0; i < _subParts.length; i++) {
        canvas.drawArc(
          new Rect.fromLTWH(0.0, 0.0, side, size.height),
          _prevAngle,
          (((_totalAngle) / _total) * _subParts[i]),
          chartType == ChartType.disc ? true : false,
          _paintList[i],
        );
        final radius = showChartValuesOutside ? (side / 2) + 16 : side / 3;
        final x = (radius) *
            math.cos(
                _prevAngle + ((((_totalAngle) / _total) * _subParts[i]) / 2));
        final y = (radius) *
            math.sin(
                _prevAngle + ((((_totalAngle) / _total) * _subParts[i]) / 2));
        if (_subParts.elementAt(i).toInt() != 0) {
          final value = formatChartValues != null
              ? formatChartValues!(_subParts.elementAt(i))
              : _subParts.elementAt(i).toStringAsFixed(this.decimalPlaces!);

          if (showChartValues) {
            final name = showValuesInPercentage!
                ? (((_subParts.elementAt(i) / _total) * 100)
                        .toStringAsFixed(this.decimalPlaces!) +
                    '%')
                : value;
            _drawName(canvas, name, x, y, side);
          }
        }
        _prevAngle = _prevAngle + (((_totalAngle) / _total) * _subParts[i]);
      }
    }

    if (centerText != null && centerText!.trim().isNotEmpty) {
      _drawCenterText(canvas, side);
    }
  }

  void _drawCenterText(Canvas canvas, double side) {
    _drawName(canvas, centerText, 0, 0, side);
  }

  void _drawName(Canvas canvas, String? name, double x, double y, double side) {
    TextSpan span = TextSpan(
      style: chartValueStyle,
      text: name,
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    if (showChartValueLabel!) {
      //Draw text background box
      final rect = Rect.fromCenter(
        center: Offset((side / 2 + x), (side / 2 + y)),
        width: tp.width + 6,
        height: tp.height + 4,
      );
      final rRect = RRect.fromRectAndRadius(rect, Radius.circular(4));
      final paint = Paint()
        ..color = chartValueBackgroundColor ?? Colors.grey[200]!
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rRect, paint);
    }
    //Finally paint the text above box
    tp.paint(
      canvas,
      new Offset(
        (side / 2 + x) - (tp.width / 2),
        (side / 2 + y) - (tp.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      oldDelegate._totalAngle != _totalAngle;
}
