import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'chart_painter.dart';
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
    this.initialAngleInDegree,
    this.formatChartValues,
    this.centerText,
    this.centerWidget,
    this.centerTextStyle,
    this.ringStrokeWidth = 20.0,
    this.legendOptions = const LegendOptions(),
    this.chartValuesOptions = const ChartValuesOptions(),
    this.emptyColor = Colors.grey,
    this.gradientList,
    this.emptyColorGradient = const [Colors.black26, Colors.black54],
    this.legendLabels = const {},
    Key? key,
    this.degreeOptions = const DegreeOptions(),
    this.baseChartColor = Colors.transparent,
    this.totalValue,
  }) : super(key: key);

  final Map<String, double> dataMap;
  final ChartType chartType;
  final double? chartRadius;
  final Duration? animationDuration;
  final double chartLegendSpacing;
  final List<Color> colorList;
  final List<List<Color>>? gradientList;
  @Deprecated('use degreeOptions instead')
  final double? initialAngleInDegree;
  final String Function(double value)? formatChartValues;
  @Deprecated('use centerWidget instead')
  final String? centerText;
  final Widget? centerWidget;
  final TextStyle? centerTextStyle;
  final double ringStrokeWidth;
  final LegendOptions legendOptions;
  final ChartValuesOptions chartValuesOptions;
  final Color emptyColor;
  final List<Color> emptyColorGradient;
  final DegreeOptions degreeOptions;
  final Map<String, String> legendLabels;
  final Color baseChartColor;
  final double? totalValue;

  @override
  // ignore: library_private_types_in_public_api
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  AnimationController? controller;
  double _animFraction = 0.0;

  List<String>? legendTitles;
  late List<double> legendValues;

  void initLegends() {
    final List<String> legendLabelList =
        widget.dataMap.keys.toList(growable: false);
    legendTitles = legendLabelList
        .map((label) => widget.legendLabels[label] ?? label)
        .toList(growable: false);
  }

  void initValues() {
    legendValues = widget.dataMap.values.toList(growable: false);
  }

  void initData() {
    assert(
      widget.dataMap.isNotEmpty,
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
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
                  showValuesInPercentage:
                      widget.chartValuesOptions.showChartValuesInPercentage,
                  decimalPlaces: widget.chartValuesOptions.decimalPlaces,
                  showChartValueLabel:
                      widget.chartValuesOptions.showChartValueBackground,
                  chartType: widget.chartType,
                  centerText: widget.centerText,
                  centerTextStyle: widget.centerTextStyle,
                  formatChartValues: widget.formatChartValues,
                  strokeWidth: widget.ringStrokeWidth,
                  emptyColor: widget.emptyColor,
                  gradientList: widget.gradientList,
                  emptyColorGradient: widget.emptyColorGradient,
                  degreeOptions: widget.degreeOptions.copyWith(
                    // because we've deprecated initialAngleInDegree,
                    // we want the old value to be used if it's not null
                    // ignore: deprecated_member_use_from_same_package
                    initialAngle: widget.initialAngleInDegree,
                  ),
                  baseChartColor: widget.baseChartColor,
                  totalValue: widget.totalValue,
                  prefix: widget.chartValuesOptions.prefix,
                  suffix: widget.chartValuesOptions.suffix,
                ),
                child: const AspectRatio(aspectRatio: 1),
              ),
              if (widget.centerWidget != null) widget.centerWidget!
            ],
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
            Expanded(
              child: _getLegend(
                padding: EdgeInsets.only(
                  right: widget.chartLegendSpacing,
                ),
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
            Expanded(
              child: _getLegend(
                padding: EdgeInsets.only(
                  left: widget.chartLegendSpacing,
                ),
              ),
            ),
          ],
        );
      default:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _getChart(),
            Expanded(
              child: _getLegend(
                padding: EdgeInsets.only(
                  left: widget.chartLegendSpacing,
                ),
              ),
            ),
          ],
        );
    }
  }

  _getLegend({EdgeInsets? padding}) {
    if (widget.legendOptions.showLegends) {
      final isGradientPresent = widget.gradientList?.isNotEmpty ?? false;
      final isNonGradientElementPresent =
          (widget.dataMap.length - (widget.gradientList?.length ?? 0)) > 0;
      return Padding(
        padding: padding!,
        child: Wrap(
          direction: widget.legendOptions.showLegendsInRow
              ? Axis.horizontal
              : Axis.vertical,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: legendTitles!
              .map(
                (item) => Legend(
                  width: widget.legendOptions.legendWidth,
                  position: widget.legendOptions.legendPosition,
                  title: item,
                  color: isGradientPresent
                      ? getGradient(
                          widget.gradientList!, legendTitles!.indexOf(item),
                          isNonGradientElementPresent:
                              isNonGradientElementPresent,
                          emptyColorGradient: widget.emptyColorGradient)[0]
                      : getColor(
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
    } else {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
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
