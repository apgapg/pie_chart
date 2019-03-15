library pie_chart;

import 'dart:math' as math;

import 'package:flutter/material.dart';

class PieChart extends StatefulWidget {
  final Map<String, double> dataMap;

  final double legendFontSize;
  final Color legendFontColor;
  final FontWeight legendFontWeight;
  final double chartRadius;
  final Duration animationDuration;
  final double chartLegendSpacing;
  final bool showChartValuesInPercentage;
  final bool showChartValues;
  final Color chartValuesColor;

  PieChart({
    @required this.dataMap,
    this.legendFontSize = 14.0,
    this.legendFontColor = Colors.black87,
    this.legendFontWeight = FontWeight.w500,
    this.chartRadius,
    this.animationDuration,
    this.chartLegendSpacing,
    this.showChartValuesInPercentage = true,
    this.showChartValues = true,
    this.chartValuesColor = Colors.black87,
  });

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double _fraction = 0.0;
  List<Color> colorList = [Color(0xFFff7675), Color(0xFF74b9ff), Color(0xFF55efc4), Color(0xFFffeaa7), Color(0xFFa29bfe), Color(0xFFfd79a8), Color(0xFFe17055), Color(0xFF00b894)];

  List<String> legendTitles;
  List<double> legendValues;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    assert(widget.dataMap != null && widget.dataMap.isNotEmpty, "dataMap passed to pie chart cant be null or empty");
    initLegends();
    initValues();

    controller = AnimationController(duration: widget.animationDuration ?? Duration(milliseconds: 800), vsync: this);
    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = Tween<double>(begin: 0, end: 1).animate(curve);
    animation.addListener(() {
      setState(() {
        _fraction = animation.value;
      });
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomPaint(
                  painter: PieChartPainter(_fraction, colorList, values: legendValues, showValuesInPercentage: widget.showChartValuesInPercentage, chartValuesColor: widget.chartValuesColor),
                  child: Container(
                    height: widget.chartRadius ?? MediaQuery.of(context).size.width / 2.5,
                    width: widget.chartRadius ?? MediaQuery.of(context).size.width / 2.5,
                  ),
                ),
                SizedBox(
                  width: widget.chartLegendSpacing ?? 16.0,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: legendTitles
                          .map(
                            (item) => Legend(
                                item,
                                colorList.elementAt(
                                  legendTitles.indexOf(item),
                                ),
                                widget.legendFontSize,
                                widget.legendFontColor,
                                widget.legendFontWeight),
                          )
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void initLegends() {
    this.legendTitles = widget.dataMap.keys.toList(growable: false);
  }

  void initValues() {
    this.legendValues = widget.dataMap.values.toList(growable: false);
  }
}

class PieChartPainter extends CustomPainter {
  Paint paint1;
  Paint paint2;
  Paint paint3;
  Paint paint4;
  Paint paint5;
  List<Paint> paintList = new List();
  List<double> subParts;
  double total = 0;
  double totalAngle = math.pi * 2;
  final bool showValuesInPercentage;
  final Color chartValuesColor;

  PieChartPainter(double angleFactor, List<Color> colorList, {List<double> values, this.showValuesInPercentage, this.chartValuesColor}) {
    paint1 = Paint()..color = colorList[0];
    paint2 = Paint()..color = colorList[1];
    paint3 = Paint()..color = colorList[2];
    paint4 = Paint()..color = colorList[3];
    paint5 = Paint()..color = colorList[4];
    paintList.add(paint1);
    paintList.add(paint2);
    paintList.add(paint3);
    paintList.add(paint4);
    paintList.add(paint5);

    totalAngle = angleFactor * math.pi * 2;
    subParts = values;

    for (double value in values) {
      total = total + value;
    }
  }

  double prevAngle = 0;
  double finalAngle = 0;

  @override
  void paint(Canvas canvas, Size size) {
    prevAngle = 0;
    finalAngle = 0;
    for (int i = 0; i < subParts.length; i++) {
      canvas.drawArc(new Rect.fromLTWH(0.0, 0.0, size.width, size.height), prevAngle, (((totalAngle) / total) * subParts[i]), true, paintList[i]);
      var x = (size.width / 3) * math.cos(prevAngle + ((((totalAngle) / total) * subParts[i]) / 2));
      var y = (size.width / 3) * math.sin(prevAngle + ((((totalAngle) / total) * subParts[i]) / 2));
      var name = showValuesInPercentage ? (((subParts.elementAt(i) / total) * 100).toStringAsFixed(0) + '%') : subParts.elementAt(i).toInt().toString();
      drawName(canvas, name, x, y, size);

      prevAngle = prevAngle + (((totalAngle) / total) * subParts[i]);
    }
  }

  void drawName(Canvas context, String name, double x, double y, Size size) {
    TextSpan span = new TextSpan(style: new TextStyle(color: chartValuesColor, fontSize: 12.0, fontWeight: FontWeight.w700), text: name);
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(context, new Offset(size.width / 2 + x - 6, size.width / 2 + y - 6));
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.totalAngle != totalAngle;
  }
}

class Legend extends StatelessWidget {
  final String text;
  final Color color;
  final Color legendFontColor;
  final double legendFontSize;
  final FontWeight legendFontWeight;

  Legend(this.text, this.color, this.legendFontSize, this.legendFontColor, this.legendFontWeight);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          height: 20.0,
          width: 18.0,
          color: color,
        ),
        SizedBox(
          width: 8.0,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            text,
            style: TextStyle(fontWeight: legendFontWeight, fontSize: legendFontSize, color: legendFontColor),
            softWrap: true,
          ),
        )
      ],
    );
  }
}
