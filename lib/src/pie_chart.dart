import 'package:flutter/material.dart';

import 'chart_painter.dart';
import 'legend.dart';
import 'utils.dart';

enum LegendPosition { top, bottom, left, right }

class PieChart extends StatefulWidget {
  PieChart({
    @required this.dataMap,
    this.showChartValueLabel = false,
    this.chartValueStyle = defaultChartValueStyle,
    this.legendPosition = LegendPosition.right,
    this.chartValueBackgroundColor = Colors.grey,
    this.legendStyle = defaultLegendStyle,
    this.chartRadius,
    this.animationDuration,
    this.chartLegendSpacing = 48,
    this.showChartValuesInPercentage = true,
    this.showChartValues = true,
    this.showChartValuesOutside = false,
    this.colorList = defaultColorList,
    this.showLegends = true,
    this.initialAngle = 0.0,
    this.decimalPlaces = 0,
    Key key,
  }) : super(key: key);

  final Map<String, double> dataMap;

  //Chart values text styling
  final TextStyle chartValueStyle;
  final bool showChartValueLabel;
  final Color chartValueBackgroundColor;

  //Legend styling
  final TextStyle legendStyle;

  final LegendPosition legendPosition;

  final double chartRadius;
  final Duration animationDuration;
  final double chartLegendSpacing;
  final bool showChartValuesInPercentage;
  final int decimalPlaces;
  final bool showChartValues;
  final bool showChartValuesOutside;
  final List<Color> colorList;
  final bool showLegends;
  final double initialAngle;

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double _fraction = 0.0;

  List<String> legendTitles;
  List<double> legendValues;

  void initLegends() {
    this.legendTitles = widget.dataMap.keys.toList(growable: false);
  }

  void initValues() {
    this.legendValues = widget.dataMap.values.toList(growable: false);
  }

  Color getColor(List<Color> colorList, int index) {
    if (index > (colorList.length - 1)) {
      final newIndex = index % (colorList.length - 1);
      return colorList.elementAt(newIndex);
    }
    return colorList.elementAt(index);
  }

  void initData() {
    assert(
      widget.dataMap != null && widget.dataMap.isNotEmpty,
      "dataMap passed to pie chart cant be null or empty",
    );
    initLegends();
    initValues();
  }

  @override
  void initState() {
    super.initState();
    initData();
    controller = AnimationController(
      duration: widget.animationDuration ?? Duration(milliseconds: 800),
      vsync: this,
    );
    final Animation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addListener(() {
        setState(() {
          _fraction = animation.value;
        });
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(PieChart oldWidget) {
    //This condition isn't working oldWidget.data is giving same data as
    //new widget.
    // print(oldWidget.dataMap);
    // print(widget.dataMap);
    //if (oldWidget.dataMap != widget.dataMap) initData();
    initData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  _getChart() {
    return Flexible(
      child: LayoutBuilder(
        builder: (_, c) => Container(
          height: widget.chartRadius != null
              ? c.maxWidth < widget.chartRadius
                  ? c.maxWidth
                  : widget.chartRadius
              : null,
          child: CustomPaint(
            painter: PieChartPainter(
              _fraction,
              widget.showChartValuesOutside,
              widget.colorList,
              chartValueStyle: widget.chartValueStyle,
              chartValueBackgroundColor: widget.chartValueBackgroundColor,
              values: legendValues,
              initialAngle: widget.initialAngle,
              showValuesInPercentage: widget.showChartValuesInPercentage,
              decimalPlaces: widget.decimalPlaces,
              showChartValueLabel: widget.showChartValueLabel,
            ),
            child: AspectRatio(aspectRatio: 1),
          ),
        ),
      ),
    );
  }

  _getLegend(EdgeInsets legendSpacing) {
    if (widget.showLegends) {
      return Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: legendSpacing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: legendTitles
                .map((item) => Legend(
                      title: item,
                      color: getColor(
                        widget.colorList,
                        legendTitles.indexOf(item),
                      ),
                      style: widget.legendStyle,
                    ))
                .toList(),
          ),
        ),
      );
    }
  }

  _getPieChart() {
    switch (widget.legendPosition) {
      case LegendPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _getLegend(
              EdgeInsets.only(
                bottom: widget.chartLegendSpacing,
              ),
            ),
            _getChart(),
          ],
        );
      case LegendPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _getChart(),
            _getLegend(
              EdgeInsets.only(
                top: widget.chartLegendSpacing,
              ),
            ),
          ],
        );
      case LegendPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _getLegend(
              EdgeInsets.only(
                right: widget.chartLegendSpacing,
              ),
            ),
            _getChart(),
          ],
        );
      case LegendPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _getChart(),
            _getLegend(
              EdgeInsets.only(
                left: widget.chartLegendSpacing,
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.0),
      child: _getPieChart(),
    );
  }
}
