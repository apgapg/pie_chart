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
  final bool showChartValuesOutside;
  final Color chartValuesColor;
  final List<Color> colorList;
  final bool showLegends;
  final double initialAngle;
  final String fontFamily;
  static const List<Color> defaultColorList = [
    Color(0xFFff7675),
    Color(0xFF74b9ff),
    Color(0xFF55efc4),
    Color(0xFFffeaa7),
    Color(0xFFa29bfe),
    Color(0xFFfd79a8),
    Color(0xFFe17055),
    Color(0xFF00b894),
  ];

  PieChart(
      {@required this.dataMap,
      this.legendFontSize = 14.0,
      this.legendFontColor = Colors.black87,
      this.legendFontWeight = FontWeight.w500,
      this.chartRadius,
      this.animationDuration,
      this.chartLegendSpacing,
      this.showChartValuesInPercentage = true,
      this.showChartValues = true,
      this.showChartValuesOutside = false,
      this.chartValuesColor = Colors.black87,
      this.colorList = defaultColorList,
      this.showLegends = true,
      this.initialAngle = 0.0,
      this.fontFamily,
      Key key})
      : super(key: key);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double _fraction = 0.0;

  List<String> legendTitles;
  List<double> legendValues;

  @override
  void initState() {
    super.initState();
    initData();

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

  void initData() {
    assert(widget.dataMap != null && widget.dataMap.isNotEmpty, "dataMap passed to pie chart cant be null or empty");
    initLegends();
    initValues();
  }

  @override
  void didUpdateWidget(PieChart oldWidget) {
    //This condition isnt working oldWidget.data is giving same data as
    //new widget.
    // print(oldWidget.dataMap);
    // print(widget.dataMap);
    //if (oldWidget.dataMap != widget.dataMap) initData();
    initData();
    super.didUpdateWidget(oldWidget);
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
                  painter: PieChartPainter(
                    _fraction,
                    widget.showChartValuesOutside,
                    widget.colorList,
                    values: legendValues,
                    initialAngle: widget.initialAngle,
                    showValuesInPercentage: widget.showChartValuesInPercentage,
                    chartValuesColor: widget.chartValuesColor,
                  ),
                  child: Container(
                    height: widget.chartRadius ?? MediaQuery.of(context).size.width / 2.5,
                    width: widget.chartRadius ?? MediaQuery.of(context).size.width / 2.5,
                  ),
                ),
                widget.showLegends
                    ? SizedBox(
                        width: widget.chartLegendSpacing ?? 16.0,
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
                widget.showLegends
                    ? Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: legendTitles
                                .map(
                                  (item) => Legend(
                                        item,
                                        getColor(widget.colorList, legendTitles.indexOf(item)),
                                        widget.legendFontSize,
                                        widget.legendFontColor,
                                        widget.legendFontWeight,
                                        widget.fontFamily,
                                      ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
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

  Color getColor(List<Color> colorList, int index) {
    if (index > (colorList.length - 1)) {
      var newIndex = index % (colorList.length - 1);
      return colorList.elementAt(newIndex);
    } else
      return colorList.elementAt(index);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class PieChartPainter extends CustomPainter {
  List<Paint> paintList = new List();
  List<double> subParts;
  double total = 0;
  double totalAngle = math.pi * 2;
  final double initialAngle;
  final bool showValuesInPercentage;
  final bool showChartValuesOutside;
  final Color chartValuesColor;

  PieChartPainter(
    double angleFactor,
    this.showChartValuesOutside,
    List<Color> colorList, {
    List<double> values,
    this.initialAngle,
    this.showValuesInPercentage,
    this.chartValuesColor,
  }) {
    for (int i = 0; i < values.length; i++) {
      paintList.add(Paint()..color = getColor(colorList, i));
    }

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
    prevAngle = this.initialAngle;
    finalAngle = 0;
    for (int i = 0; i < subParts.length; i++) {
      canvas.drawArc(new Rect.fromLTWH(0.0, 0.0, size.width, size.height), prevAngle, (((totalAngle) / total) * subParts[i]), true, paintList[i]);
      var factor = showChartValuesOutside ? 1.65 : 3;
      var x = (size.width / factor) * math.cos(prevAngle + ((((totalAngle) / total) * subParts[i]) / 2));
      var y = (size.width / factor) * math.sin(prevAngle + ((((totalAngle) / total) * subParts[i]) / 2));
      if (subParts.elementAt(i).toInt() != 0) {
        var name = showValuesInPercentage ? (((subParts.elementAt(i) / total) * 100).toStringAsFixed(0) + '%') : subParts.elementAt(i).toInt().toString();
        drawName(canvas, name, x - 4, y, size);
      }
      prevAngle = prevAngle + (((totalAngle) / total) * subParts[i]);
    }
  }

  Color getColor(List<Color> colorList, int index) {
    if (index > (colorList.length - 1)) {
      var newIndex = index % (colorList.length - 1);
      return colorList.elementAt(newIndex);
    } else
      return colorList.elementAt(index);
  }

  void drawName(Canvas context, String name, double x, double y, Size size) {
    TextSpan span = new TextSpan(style: new TextStyle(color: chartValuesColor, fontSize: 12.0, fontWeight: FontWeight.w700), text: name);
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.rtl);
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
  final String legendFontFamily;

  Legend(this.text, this.color, this.legendFontSize, this.legendFontColor, this.legendFontWeight, this.legendFontFamily);

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
            style: TextStyle(fontWeight: legendFontWeight, fontSize: legendFontSize, color: legendFontColor, fontFamily: legendFontFamily),
            softWrap: true,
          ),
        )
      ],
    );
  }
}
