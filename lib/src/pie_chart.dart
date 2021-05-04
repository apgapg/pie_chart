import 'package:flutter/material.dart';

import '../pie_chart.dart';
import 'chart_painter.dart';
import 'chart_values_options.dart';
import 'legend.dart';
import 'utils.dart';

enum LegendPosition { top, bottom, left, right }

enum ChartType { disc, ring }

class PieChart extends StatefulWidget {
  const PieChart({
    required this.dataMap,
    this.chartType = ChartType.disc,
    this.chartRadius,
    this.animationDuration,
    this.chartLegendSpacing = 48,
    this.colorList = defaultColorList,
    this.initialAngleInDegree = 0.0,
    this.formatChartValues,
    this.centerText,
    this.ringStrokeWidth = 20.0,
    this.legendOptions = const LegendOptions(),
    this.chartValuesOptions = const ChartValuesOptions(),
    this.emptyColor = Colors.grey,
    this.border = .05,
    Key? key,
  }) : super(key: key);

  final double border;
  final Map<String, double> dataMap;
  final ChartType chartType;
  final double? chartRadius;
  final Duration? animationDuration;
  final double chartLegendSpacing;
  final List<Color> colorList;
  final double initialAngleInDegree;
  final Function? formatChartValues;
  final String? centerText;
  final double ringStrokeWidth;
  final LegendOptions legendOptions;
  final ChartValuesOptions chartValuesOptions;
  final Color emptyColor;

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  AnimationController? controller;
  double _animFraction = 0;

  List<String>? legendTitles;
  late List<double> legendValues;

  void initLegends() {
    legendTitles = widget.dataMap.keys.toList(growable: false);
  }

  void initValues() {
    legendValues = widget.dataMap.values.toList(growable: false);
  }

  void initData() {
    assert(
      widget.dataMap.isNotEmpty,
      'dataMap passed to pie chart cant be null or empty',
    );
    initLegends();
    initValues();
  }

  @override
  void initState() {
    super.initState();
    initData();
    controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 800),
      vsync: this,
    );
    final Animation curve = CurvedAnimation(
      parent: controller!,
      curve: Curves.decelerate,
    );
    animation =
        Tween<double>(begin: 0, end: 1).animate(curve as Animation<double>)
          ..addListener(() {
            setState(() {
              _animFraction = animation.value;
            });
          });
    controller!.forward();
  }

  Widget _getChart() {
    return Flexible(
      child: LayoutBuilder(
        builder: (_, c) => SizedBox(
          height: widget.chartRadius != null
              ? c.maxWidth < widget.chartRadius!
                  ? c.maxWidth
                  : widget.chartRadius
              : null,
          child: CustomPaint(
            painter: PieChartPainter(
              _animFraction,
              widget.chartValuesOptions.showChartValues,
              widget.chartValuesOptions.showChartValuesOutside,
              widget.colorList,
              chartValueStyle: widget.chartValuesOptions.chartValueStyle,
              chartValueBackgroundColor:
                  widget.chartValuesOptions.chartValueBackgroundColor,
              values: legendValues,
              titles: legendTitles,
              initialAngle: widget.initialAngleInDegree,
              showValuesInPercentage:
                  widget.chartValuesOptions.showChartValuesInPercentage,
              decimalPlaces: widget.chartValuesOptions.decimalPlaces,
              showChartValueLabel:
                  widget.chartValuesOptions.showChartValueBackground,
              chartType: widget.chartType,
              centerText: widget.centerText,
              formatChartValues: widget.formatChartValues,
              strokeWidth: widget.ringStrokeWidth,
              emptyColor: widget.emptyColor,
              border: widget.border,
            ),
            child: const AspectRatio(aspectRatio: 1),
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _getLegend({EdgeInsets? padding}) {
    if (widget.legendOptions.showLegends) {
      return Flexible(
        child: LayoutBuilder(
          builder: (_, c) {
            return Padding(
              padding: padding!,
              child: Wrap(
                direction: widget.legendOptions.showLegendsInRow
                    ? Axis.horizontal
                    : Axis.vertical,
                runSpacing: 8,
                children: legendTitles!
                    .map(
                      (item) => Legend(
                        title: item,
                        legendHeight: widget.legendOptions.height,
                        legendWidth: widget.legendOptions.width,
                        titleRowWidth: c.maxWidth,
                        color: getColor(
                          widget.colorList,
                          legendTitles!.indexOf(item),
                        ),
                        style: widget.legendOptions.legendTextStyle,
                        legendShape: widget.legendOptions.legendShape,
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
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
