# Pie Chart

This Flutter package provides a Pie Chart Widget with cool animation.

# 💻 Installation
In the `dependencies:` section of your `pubspec.yaml`, add the following line:

[![Version](https://img.shields.io/pub/v/pie_chart.svg)](https://pub.dartlang.org/packages/pie_chart)

```yaml
dependencies:
  pie_chart: <latest version>
```

# ❔ Usage

### Import this class

```dart
import 'package:pie_chart/pie_chart.dart';
```

#### Usage is simple. Pie Chart is a widget and it just need a Map<String,double> as its data input.

<img src="https://raw.githubusercontent.com/apgapg/pie_chart/master/src/app.gif" align = "right" height = "415" alt="PieChart">

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

# 👍 How to Contribute
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -m 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
