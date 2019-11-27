import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pie_chart/src/chart_painter.dart';
import 'package:pie_chart/src/legend.dart';

void main() {
  final dataMap = <String, double>{};
  dataMap.putIfAbsent("Flutter", () => 5);
  dataMap.putIfAbsent("React", () => 3);
  dataMap.putIfAbsent("Xamarin", () => 2);
  dataMap.putIfAbsent("Ionic", () => 2);

  testWidgets('Chart is present', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: PieChart(
            dataMap: dataMap,
          ),
        ),
      ),
    ));
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is CustomPaint && widget.painter is PieChartPainter,
      ),
      findsOneWidget,
    );
  });
  group("Legend(s) visibility test", () {
    testWidgets('Legend(s) is visibile', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: PieChart(
              dataMap: dataMap,
            ),
          ),
        ),
      ));
      expect(
        find.byType(Legend),
        findsWidgets,
      );
    });
    testWidgets('Legend(s) number is correct', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: PieChart(
              dataMap: dataMap,
            ),
          ),
        ),
      ));
      expect(
        find.byType(Legend),
        findsNWidgets(dataMap.length),
      );
    });
    testWidgets('Legend(s) is hidden', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: PieChart(
              dataMap: dataMap,
              showLegends: false,
            ),
          ),
        ),
      ));
      expect(
        find.byType(Legend),
        findsNothing,
      );
    });
  });
}
