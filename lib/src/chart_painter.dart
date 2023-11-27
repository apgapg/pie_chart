import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

const doublePi = math.pi * 2;

class PieChartPainter extends CustomPainter {
  final List<Paint> _paintList = [];
  late List<double> _subParts;
  double _total = 0;
  double _totalAngle = doublePi;

  final TextStyle? chartValueStyle;
  final Color? chartValueBackgroundColor;
  final bool? showValuesInPercentage;
  final bool showChartValues;
  final bool showChartValuesOutside;
  final int? decimalPlaces;
  final bool? showChartValueLabel;
  final ChartType? chartType;
  final String? centerText;
  final TextStyle? centerTextStyle;
  final String Function(double value)? formatChartValues;
  final double? strokeWidth;
  final Color? emptyColor;
  final List<List<Color>>? gradientList;
  final List<Color>? emptyColorGradient;
  final DegreeOptions degreeOptions;
  final Color baseChartColor;
  final double? totalValue;
  final String? prefix;
  final String? suffix;

  late double _prevAngle;

  double get drawPercentage => degreeOptions.totalDegrees / fullDegree;

  PieChartPainter(
    double angleFactor,
    this.showChartValues,
    this.showChartValuesOutside,
    List<Color> colorList, {
    this.chartValueStyle,
    this.chartValueBackgroundColor,
    required List<double> values,
    List<String>? titles,
    this.showValuesInPercentage,
    this.decimalPlaces,
    this.showChartValueLabel,
    this.chartType,
    this.centerText,
    this.centerTextStyle,
    this.formatChartValues,
    this.strokeWidth,
    this.emptyColor,
    this.gradientList,
    this.emptyColorGradient,
    this.degreeOptions = const DegreeOptions(),
    required this.baseChartColor,
    this.totalValue,
    this.prefix,
    this.suffix,
  }) {
    // set total value
    if (totalValue == null) {
      _total = values.fold(0, (v1, v2) => v1 + v2);
    } else {
      _total = totalValue!;
    }

    if (gradientList?.isEmpty ?? true) {
      for (int i = 0; i < values.length; i++) {
        final paint = Paint()..color = getColor(colorList, i);
        setPaintProps(paint);
        _paintList.add(paint);
      }
    }

    _totalAngle = angleFactor * doublePi * drawPercentage;
    _subParts = values;
    _prevAngle = degreeToRadian(degreeOptions.initialAngle);
  }

  double degreeToRadian(double degree) => degree * math.pi / 180;

  void setPaintProps(Paint p) {
    if (chartType == ChartType.ring) {
      p.style = PaintingStyle.stroke;
      p.strokeWidth = strokeWidth!;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);

    // if it is a full circle, then we set the left to 0 and it works just fine, however,
    // when it is half a circle for example, we want to start from the left, so we set the
    // left to half the width of the canvas to let it start exactly from the left.
    //
    // this is not a precise calculation, should be more generalized later
    // e.g. (-90, 91) should start from the left

    final left =
        degreeOptions.initialAngle >= -90 && degreeOptions.totalDegrees <= 180
            ? -size.width / 2
            : 0.0;

    const top = 0.0;

    final Rect boundingSquare = Rect.fromLTWH(left, top, side, size.height);

    final useCenter = chartType == ChartType.disc ? true : false;

    // draw base pie chart
    final paintBase = Paint()..color = baseChartColor;
    setPaintProps(paintBase);
    canvas.drawArc(
      boundingSquare,
      0,
      doublePi,
      useCenter,
      paintBase,
    );

    // if values total is 0, then draw empty chart
    if (_total == 0) {
      final paint = Paint()..color = emptyColor!;
      setPaintProps(paint);

      canvas.drawArc(
        boundingSquare,
        _prevAngle,
        degreeToRadian(degreeOptions.totalDegrees),
        useCenter,
        paint,
      );
    } else {
      final isGradientPresent = gradientList?.isNotEmpty ?? false;
      final isNonGradientElementPresent =
          (_subParts.length - (gradientList?.length ?? 0)) > 0;

      for (int i = 0; i < _subParts.length; i++) {
        if (isGradientPresent) {
          final endAngle = (((_totalAngle) / _total) * _subParts[i]);
          final paint = Paint();

          final normalizedPrevAngle = (_prevAngle - 0.15) % doublePi;
          final normalizedEndAngle = (endAngle + 0.15) % doublePi;
          final Gradient gradient = SweepGradient(
            transform: GradientRotation(normalizedPrevAngle),
            endAngle: normalizedEndAngle,
            colors: getGradient(gradientList!, i,
                isNonGradientElementPresent: isNonGradientElementPresent,
                emptyColorGradient: emptyColorGradient!),
          );
          paint.shader = gradient.createShader(boundingSquare);
          if (chartType == ChartType.ring) {
            paint.style = PaintingStyle.stroke;
            paint.strokeWidth = strokeWidth!;
            paint.strokeCap = StrokeCap.butt;
          }
          canvas.drawArc(
            boundingSquare,
            _prevAngle,
            endAngle,
            useCenter,
            paint,
          );
        } else {
          canvas.drawArc(
            boundingSquare,
            _prevAngle,
            ((_totalAngle / _total) * _subParts[i]),
            useCenter,
            _paintList[i],
          );
        }

        final radius = showChartValuesOutside ? (side / 2) + 16 : side / 3;
        final radians =
            _prevAngle + (((_totalAngle / _total) * _subParts[i]) / 2);
        final x = (radius) * math.cos(radians);
        final y = (radius) * math.sin(radians);

        if (_subParts.elementAt(i) > 0) {
          final value = formatChartValues != null
              ? formatChartValues!(_subParts.elementAt(i))
              : _subParts.elementAt(i).toStringAsFixed(decimalPlaces!);

          if (showChartValues) {
            final name = showValuesInPercentage == true
                ? formatChartValues != null
                    ? ('${formatChartValues!((_subParts.elementAt(i) / _total) * 100)}%')
                    : ('${((_subParts.elementAt(i) / _total) * 100).toStringAsFixed(decimalPlaces!)}%')
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
    _drawName(canvas, centerText, 0, 0, side, style: centerTextStyle);
  }

  void _drawName(
    Canvas canvas,
    String? name,
    double x,
    double y,
    double side, {
    TextStyle? style,
  }) {
    final span = TextSpan(
      style: style ?? chartValueStyle,
      text: '${prefix ?? ''} $name ${suffix ?? ''}',
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
      final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      final paint = Paint()
        ..color = chartValueBackgroundColor ?? Colors.grey[200]!
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rRect, paint);
    }
    //Finally paint the text above box
    tp.paint(
      canvas,
      Offset(
        (side / 2 + x) - (tp.width / 2),
        (side / 2 + y) - (tp.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      oldDelegate._totalAngle != _totalAngle;
}
