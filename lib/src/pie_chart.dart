import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'chart_painter.dart';
import 'legend.dart';
import 'utils.dart';

enum LegendPosition { top, bottom, left, right }

enum ChartType { disc, ring }

class PieChart extends StatefulWidget {
  PieChart({
    @required this.dataMap,
    this.showChartValueLabel = false,
    this.chartValueStyle = defaultChartValueStyle,
    this.chartType = ChartType.disc,
    this.chartValueBackgroundColor = Colors.grey,
    this.chartRadius,
    this.animationDuration,
    this.chartLegendSpacing = 48,
    this.showChartValuesInPercentage = true,
    this.showChartValues = true,
    this.showChartValuesOutside = false,
    this.colorList = defaultColorList,
    this.initialAngle = 0.0,
    this.decimalPlaces = 0,
    this.formatChartValues,
    this.centerText,
    this.strokeWidth = 20.0,
    this.legendOptions = const LegendOptions(),
    Key key,
  }) : super(key: key);

  final Map<String, double> dataMap;

  //Chart values text styling
  final TextStyle chartValueStyle;
  final bool showChartValueLabel;
  final Color chartValueBackgroundColor;
  final ChartType chartType;

  final double chartRadius;
  final Duration animationDuration;
  final double chartLegendSpacing;
  final bool showChartValuesInPercentage;
  final int decimalPlaces;
  final bool showChartValues;
  final bool showChartValuesOutside;
  final List<Color> colorList;
  final double initialAngle;
  final Function formatChartValues;
  final String centerText;
  final double strokeWidth;
  final LegendOptions legendOptions;

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double _animFraction = 0.0;

  List<String> legendTitles;
  List<double> legendValues;

  void initLegends() {
    this.legendTitles = widget.dataMap.keys.toList(growable: false);
  }

  void initValues() {
    this.legendValues = widget.dataMap.values.toList(growable: false);
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
          _animFraction = animation.value;
        });
      });
    controller.forward();
  }

  Widget _getChart() {
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
              _animFraction,
              widget.showChartValues,
              widget.showChartValuesOutside,
              widget.colorList,
              chartValueStyle: widget.chartValueStyle,
              chartValueBackgroundColor: widget.chartValueBackgroundColor,
              values: legendValues,
              titles: legendTitles,
              initialAngle: widget.initialAngle,
              showValuesInPercentage: widget.showChartValuesInPercentage,
              decimalPlaces: widget.decimalPlaces,
              showChartValueLabel: widget.showChartValueLabel,
              chartType: widget.chartType,
              centerText: widget.centerText,
              formatChartValues: widget.formatChartValues,
              strokeWidth: widget.strokeWidth,
            ),
            child: AspectRatio(aspectRatio: 1),
          ),
        ),
      ),
    );
  }

  Widget _getPieChart() {
    switch (widget.legendOptions.legendPosition) {
      case LegendPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _getLegend(
              padding: EdgeInsets.only(
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
              padding: EdgeInsets.only(
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
              padding: EdgeInsets.only(
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
              padding: EdgeInsets.only(
                left: widget.chartLegendSpacing,
              ),
            ),
          ],
        );
      default:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _getChart(),
            _getLegend(
              padding: EdgeInsets.only(
                left: widget.chartLegendSpacing,
              ),
            ),
          ],
        );
    }
  }

  _getLegend({EdgeInsets padding}) {
    if (widget.legendOptions.showLegends) {
      return Padding(
        padding: padding,
        child: Wrap(
          direction: widget.legendOptions.showLegendsInRow
              ? Axis.horizontal
              : Axis.vertical,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: legendTitles
              .map(
                (item) => Legend(
                  title: item,
                  color: getColor(
                    widget.colorList,
                    legendTitles.indexOf(item),
                  ),
                  style: widget.legendOptions.legendTextStyle,
                  legendShape: widget.legendOptions.legendShape,
                ),
              )
              .toList(),
        ),
      );
    } else
      return SizedBox(
        height: 0,
        width: 0,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.0),
      child: _getPieChart(),
    );
  }

  @override
  void didUpdateWidget(PieChart oldWidget) {
    initData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
