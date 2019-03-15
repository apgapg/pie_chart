# Pie Chart [![pub package](https://www.ayushpgupta.site/pub_logo.svg)](https://pub.dartlang.org/packages/pie_chart)

This Flutter package provides a Pie Chart Widget with cool animation.

<p align="center">
  <img src="https://raw.githubusercontent.com/apgapg/pie_chart/master/src/app.gif" alt="Demo App" style="margin:auto" width="372" height="686">
</p>

# Usage

Usage is simple. Pie Chart is a widget and it just need a Map<String,double> as its data input.

```dart
Map<String, double> dataMap = new Map();
dataMap.putIfAbsent("Flutter", () => 5);
dataMap.putIfAbsent("React", () => 3);
dataMap.putIfAbsent("Xamarin", () => 2);
dataMap.putIfAbsent("Ionic", () => 2);

PieChart(
      dataMap: dataMap,
      legendFontColor: Colors.blueGrey[900],
      legendFontSize: 14.0,
      legendFontWeight: FontWeight.w500,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32.0,
      chartRadius: MediaQuery
          .of(context)
          .size
          .width / 2.7,
      showChartValuesInPercentage: true,
      showChartValues: true,
      chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
      )
```
