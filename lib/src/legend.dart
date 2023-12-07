import 'package:flutter/material.dart';

import '../pie_chart.dart';

class Legend extends StatelessWidget {
  const Legend({
    required this.title,
    required this.color,
    required this.style,
    required this.legendShape,
    required this.position,
    this.width,
    Key? key,
  }) : super(key: key);

  final String title;
  final Color color;
  final TextStyle style;
  final BoxShape legendShape;
  final LegendPosition position;
  final double? width;

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return SizedBox(
      width:
          (position == LegendPosition.right || position == LegendPosition.left)
              ? sw * 0.5
              : sw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            height: 20.0,
            width: 18.0,
            decoration: BoxDecoration(
              shape: legendShape,
              color: color,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              title,
              style: style,
              softWrap: true,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
        ],
      ),
    );
  }
}
