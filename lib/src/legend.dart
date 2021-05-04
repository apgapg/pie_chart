import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  Legend({
    required this.title,
    required this.color,
    required this.style,
    required this.legendShape,
    required this.titleRowWidth,
    this.legendHeight = 8,
    this.legendWidth = 8,
  });

  final String title;
  final Color color;
  final TextStyle style;
  final BoxShape legendShape;
  final double titleRowWidth;
  final double legendHeight;
  final double legendWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          height: legendHeight,
          width: legendWidth,
          decoration: BoxDecoration(
            shape: legendShape,
            color: color,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        SizedBox(
          width: titleRowWidth,
          child: Text(
            title,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
      ],
    );
  }
}
