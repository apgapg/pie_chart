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
    testWidgets('Legend(s) is visible', (WidgetTester tester) async {
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
              legendOptions: const LegendOptions(showLegends: false),
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

  testWidgets('Chart Data is correct', (WidgetTester tester) async {
    final falseDataMap = <String, dynamic>{};
    falseDataMap.putIfAbsent("Flutter", () => 5);
    falseDataMap.putIfAbsent("React", () => 3);
    falseDataMap.putIfAbsent("Xamarin", () => 2);
    falseDataMap.putIfAbsent("Ionic", () => 2);

    expectLater(
      () async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Center(
              child: PieChart(
                dataMap: falseDataMap as Map<String, double>,
              ),
            ),
          ),
        ));
      },
      throwsA(anything),
    );
  });

  test("Test color return when index is greater than color list", () {
    final List<Color> colorList = [
      const Color(0xFFff7675),
      const Color(0xFF74b9ff),
      const Color(0xFF55efc4),
      const Color(0xFFffeaa7),
    ];
    expect(
      getColor(colorList, 5).runtimeType,
      Color,
    );
  });

  group("Custom legend label test", () {
    testWidgets('Test custom labels are shown', (WidgetTester tester) async {
      final legendLabel = <String,String> {};
      legendLabel.putIfAbsent('Flutter', () => 'Flutter legend');
      legendLabel.putIfAbsent('React', () => 'React legend');
      legendLabel.putIfAbsent('Xamarin', () => 'Xamarin legend');
      legendLabel.putIfAbsent('Ionic', () => 'Ionic legend');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: PieChart(
              dataMap: dataMap,
              legendLabels: legendLabel,
            ),
          ),
        ),
      ));
      expect(
        find.text('Flutter legend'),
        findsOneWidget,
      );
      expect(
        find.text('React legend'),
        findsOneWidget,
      );
      expect(
        find.text('Xamarin legend'),
        findsOneWidget,
      );
      expect(
        find.text('Ionic legend'),
        findsOneWidget,
      );
    });
    testWidgets('Test if label fallback to data map value if not in legendLabels', (WidgetTester tester) async {
      final legendLabel = <String,String> {};
      legendLabel.putIfAbsent('Flutter', () => 'Flutter legend');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: PieChart(
              dataMap: dataMap,
              legendLabels: legendLabel,
            ),
          ),
        ),
      ));
      expect(
        find.text('Flutter legend'),
        findsOneWidget,
      );
      expect(
        find.text('React'),
        findsOneWidget,
      );
      expect(
        find.text('Xamarin'),
        findsOneWidget,
      );
      expect(
        find.text('Ionic'),
        findsOneWidget,
      );
    });
  });
}
