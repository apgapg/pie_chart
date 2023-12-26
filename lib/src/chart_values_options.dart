import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pie_chart/src/utils.dart';

class ChartValuesOptions {
  final bool showChartValueBackground;
  final int decimalPlaces;
  final bool showChartValuesInPercentage;
  final bool showChartValues;
  final bool showChartValuesOutside;
  final Color? chartValueBackgroundColor;
  final TextStyle chartValueStyle;
  final String? prefix;
  final String? suffix;

  const ChartValuesOptions({
    this.showChartValueBackground = true,
    this.decimalPlaces = 1,
    this.chartValueBackgroundColor,
    this.showChartValuesInPercentage = false,
    this.chartValueStyle = defaultChartValueStyle,
    this.showChartValues = true,
    this.showChartValuesOutside = false,
    this.prefix,
    this.suffix,
  });
}
