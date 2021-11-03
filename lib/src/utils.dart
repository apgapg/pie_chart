import 'package:flutter/material.dart';

const defaultChartValueStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const defaultLegendStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

const List<Color> defaultColorList = [
  Color(0xFFff7675),
  Color(0xFF74b9ff),
  Color(0xFF55efc4),
  Color(0xFFffeaa7),
  Color(0xFFa29bfe),
  Color(0xFFfd79a8),
  Color(0xFFe17055),
  Color(0xFF00b894),
];

Color getColor(List<Color> colorList, int index) {
  if (index > (colorList.length - 1)) {
    final newIndex = index % (colorList.length - 1);
    return colorList.elementAt(newIndex);
  }
  return colorList.elementAt(index);
}

List<Color> getGradient(List<List<Color>> gradientList, int index,
    {required bool isNonGradientElementPresent,
    required List<Color> emptyColorGradient}) {
  index = isNonGradientElementPresent ? index - 1 : index;
  if (index == -1) {
    return emptyColorGradient;
  } else if (index > (gradientList.length - 1)) {
    final newIndex = index % gradientList.length;
    return gradientList.elementAt(newIndex);
  }
  return gradientList.elementAt(index);
}
