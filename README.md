# Pie Chart ![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/apgapg/pie_chart) [![GitHub stars](https://img.shields.io/github/stars/apgapg/pie_chart.svg?style=social)](https://github.com/apgapg/pie_chart) [![Twitter Follow](https://img.shields.io/twitter/url/https/@ayushpgupta.svg?style=social)](https://twitter.com/ayushpgupta) ![GitHub last commit](https://img.shields.io/github/last-commit/apgapg/pie_chart.svg) [![Website shields.io](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](https://apgapg.github.io/)[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)](https://github.com/apgapg/pie_chart) 

This Flutter package provides a Pie Chart Widget with cool animation.

Live Demo: [https://apgapg.github.io/pie_chart/](https://apgapg.github.io/pie_chart/)

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

<img src="https://raw.githubusercontent.com/apgapg/pie_chart/master/src/app.gif"  height = "400" alt="PieChart">

```dart
Map<String, double> dataMap = new Map();
dataMap.putIfAbsent("Flutter", () => 5);
dataMap.putIfAbsent("React", () => 3);
dataMap.putIfAbsent("Xamarin", () => 2);
dataMap.putIfAbsent("Ionic", () => 2);
```

### - Simple Implementation
```dart
PieChart(dataMap: dataMap) 
```

### - Full Implementation
```dart
PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32.0,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        showChartValuesInPercentage: true,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: colorList,
        showLegends: true,
        legendPosition: LegendPosition.right,
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
        ),
        chartType: ChartType.disc,
    )
```

### Change legend position with 'legendPosition'

<img src="https://raw.githubusercontent.com/apgapg/pie_chart/master/src/s4.png"  height = "400" alt="PieChart"> <img src="https://raw.githubusercontent.com/apgapg/pie_chart/master/src/s5.png"  height = "400" alt="PieChart"> <img src="https://raw.githubusercontent.com/apgapg/pie_chart/master/src/s6.png"  height = "400" alt="PieChart"> <img src="https://raw.githubusercontent.com/apgapg/pie_chart/master/src/s7.png"  height = "400" alt="PieChart">

### Change Chart shape to ring

```dart
chartType: ChartType.ring,
```
<img src="https://raw.githubusercontent.com/apgapg/pie_chart/master/src/s9.png"  height = "400" alt="PieChart">  

```dart
chartType: ChartType.ring,
showChartValuesOutside: true,
```

<img src="https://raw.githubusercontent.com/apgapg/pie_chart/master/src/s8.png"  height = "400" alt="PieChart">

## Issues

<!-- issueTable -->

| Title                                                                                                                                   |         Status          |                                                        Assignee                                                        | Body                                                                                                                                                                                                                                                                                                                                                                   |
| :-------------------------------------------------------------------------------------------------------------------------------------- | :---------------------: | :--------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="https://github.com/apgapg/pie_chart/pull/34">[ImgBot] Optimize images</a>                                                      |       :no_entry:        |                                                                                                                        | ## Beep boop. Your images are optimized!<br /><br />Your image file size has been reduced by **29%** 🎉<br />...                                                                                                                                                                                                                                                       |
| <a href="https://github.com/apgapg/pie_chart/issues/33">Percentage from 0-10% / lesser percentage is not displaying</a>                 | :eight_spoked_asterisk: |                                                                                                                        | Hi <br /><br />Its a very good library, but I am stuck where I will have a percentage of value is less than  10 %<br />...                                                                                                                                                                                                                                             |
| <a href="https://github.com/apgapg/pie_chart/issues/32">issue with overlapping see screen shot </a>                                     | :eight_spoked_asterisk: |                                                                                                                        | ![Screenshot_20200323-202028__01](https://user-images.githubusercontent.com/47334522/77390977-32a39e00-6da0-11ea-8667-a72e11743f11.jpg)<br />                                                                                                                                                                                                                          |
| <a href="https://github.com/apgapg/pie_chart/issues/31">Pie chart show only half</a>                                                    | :eight_spoked_asterisk: |                                                                                                                        | Pie chart  only show half if dataMap consists of only one value.<br /><br />```<br />...                                                                                                                                                                                                                                                                               |
| <a href="https://github.com/apgapg/pie_chart/issues/30">Error: The method 'getColor' isn't defined for the class 'PieChartPainter'.</a> |       :no_entry:        |                                                                                                                        | I get this error <br /><br />```<br />...                                                                                                                                                                                                                                                                                                                              |
| <a href="https://github.com/apgapg/pie_chart/issues/29">Change label position </a>                                                      |       :no_entry:        |                                                                                                                        | The label now is displayed vertically.  It is possible to displayed  horizontally? <br /><br />I want change the legend position to top, and displayed the label horizontally.<br />...                                                                                                                                                                                |
| <a href="https://github.com/apgapg/pie_chart/issues/28">How to place labels completely outside of the ring? </a>                        | :eight_spoked_asterisk: |                                                                                                                        | Hi Bro, Is there a way we can place labels completely outside the ring like the below?<br /><br />![download (1)](https://user-images.githubusercontent.com/24856031/74508402-fec59500-4f24-11ea-99b4-d5a98829958d.png)<br />...                                                                                                                                       |
| <a href="https://github.com/apgapg/pie_chart/pull/27">adding Format data functionality</a>                                              |       :no_entry:        |                                                                                                                        | this functionality allows to format the data how you want, I used this to show a pie chart with comparing the times I spent doing things in each category with my timer, so when showing the data, instead of show the absolute number representing the time in minutes, or percentage, I could transform the data that was 90 to 01:30, or 60 to 01:00, and so on.... |
| <a href="https://github.com/apgapg/pie_chart/pull/26">Add center text option</a>                                                        |       :no_entry:        |                                                                                                                        | This PR adds center text support #24 <br /><br />![Ring](https://i.stack.imgur.com/2VTBQ.png)<br />...                                                                                                                                                                                                                                                                 |
| <a href="https://github.com/apgapg/pie_chart/issues/25">Gradient</a>                                                                    | :eight_spoked_asterisk: |                                                                                                                        | Is there anyways to add a gradient to the colors?                                                                                                                                                                                                                                                                                                                      |
| <a href="https://github.com/apgapg/pie_chart/issues/24">How to add text in the center of the ring?</a>                                  |       :no_entry:        |                                                                                                                        | Is it possible?                                                                                                                                                                                                                                                                                                                                                        |
| <a href="https://github.com/apgapg/pie_chart/issues/23">A few issues since upgrading from 2.0.0</a>                                     | :eight_spoked_asterisk: |                                                                                                                        | Hi!<br /><br />A few issues since upgrading from 2.0.0<br />...                                                                                                                                                                                                                                                                                                        |
| <a href="https://github.com/apgapg/pie_chart/issues/22">showLegends = false causes exception</a>                                        |       :no_entry:        |                                                                                                                        | Hi, is it possible to hide legends? I am displaying pie chart inside a row widget and I tried showLegends = false but i am getting '**Row's children must not contain any null value, but a null value was found at index 1**' exception. Any idea?                                                                                                                    |
| <a href="https://github.com/apgapg/pie_chart/issues/21">Add click support</a>                                                           | :eight_spoked_asterisk: |                                                                                                                        | Would be great if you could click on a piece of the pie or on a label and receive a notification of which of the values the click corresponds to.                                                                                                                                                                                                                      |
| <a href="https://github.com/apgapg/pie_chart/pull/20">Add ring shape pie chart support</a>                                              |       :no_entry:        |                                                                                                                        | Fixes #19 This PR adds support for 'chartType' parameter with values 'ChartType.ring' or 'ChartType.disc'.<br />This will give two different chart shapes as name suggests.<br />Update example and README                                                                                                                                                             |
| <a href="https://github.com/apgapg/pie_chart/issues/19">Feature: Pie chart as ring </a>                                                 |       :no_entry:        | <a href="https://github.com/apgapg"><img src="https://avatars0.githubusercontent.com/u/13887407?v=4" width="20" /></a> |                                                                                                                                                                                                                                                                                                                                                                        |
| <a href="https://github.com/apgapg/pie_chart/issues/18">[Feature Request] Column View</a>                                               |       :no_entry:        | <a href="https://github.com/apgapg"><img src="https://avatars0.githubusercontent.com/u/13887407?v=4" width="20" /></a> | Hi, absolutely loving this plugin for my workout app. Got the visual breakdown of what they train in like 5 minutes.<br /><br />A nice feature might be a column view, where the pie chart is on top and the legend is below. This would allow each to be larger so I could use bigger fonts inside the pie chat.                                                      |
| <a href="https://github.com/apgapg/pie_chart/pull/17">Feature legend position</a>                                                       |       :no_entry:        |                                                                                                                        | #2 This PR adds a new property legendPosition in the widget, which enables positioning legend around the pie chart.<br /><br />`legendPosition: LegendPosition.right`<br />...                                                                                                                                                                                         |
| <a href="https://github.com/apgapg/pie_chart/pull/16">Feature legend position</a>                                                       |       :no_entry:        |                                                                                                                        | #2  This PR adds a new property `legendPosition` in the widget, which enables positioning legend around the pie chart.<br /><br />`legendPosition: LegendPosition.right`<br />...                                                                                                                                                                                      |
| <a href="https://github.com/apgapg/pie_chart/pull/15">Code restructure</a>                                                              |       :no_entry:        |                                                                                                                        |                                                                                                                                                                                                                                                                                                                                                                        |
| <a href="https://github.com/apgapg/pie_chart/issues/14">Can navigate to other pages when tap on labels?</a>                             |       :no_entry:        |                                                                                                                        |                                                                                                                                                                                                                                                                                                                                                                        |
| <a href="https://github.com/apgapg/pie_chart/issues/13">Enable selecting piechart slice starting angle</a>                              |       :no_entry:        |                                                                                                                        | First thank you for your work. This is the easiest to use flutter chart plugin on pub!<br /><br />Currently the piechart starts animating from the right side of the circle (from 3 o'clock).<br />...                                                                                                                                                                 |
| <a href="https://github.com/apgapg/pie_chart/pull/12">chart filter option</a>                                                           |       :no_entry:        |                                                                                                                        | Hello<br />I need a pie chart decimal values so add [filterChartValues]. If how much you want to set values.<br /><br />...                                                                                                                                                                                                                                            |
| <a href="https://github.com/apgapg/pie_chart/pull/11">allow to configure initialAngle</a>                                               |       :no_entry:        |                                                                                                                        | * allow to configure initialAngle<br />* set initialAngle to always start at 12 o'clock                                                                                                                                                                                                                                                                                |
| <a href="https://github.com/apgapg/pie_chart/issues/10">toDouble was Called on null</a>                                                 |       :no_entry:        |                                                                                                                        | `I/flutter (30917): ══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════<br />I/flutter (30917): The following NoSuchMethodError was thrown building PieChart(dirty, state:<br />I/flutter (30917): _PieChartState#f7d87(ticker active)):<br />...                                                                     |
| <a href="https://github.com/apgapg/pie_chart/pull/9">Update README.md</a>                                                               |       :no_entry:        |                                                                                                                        | proposal to update the dataMap.<br />because it was confusing and and induced errors.                                                                                                                                                                                                                                                                                  |
| <a href="https://github.com/apgapg/pie_chart/issues/8">Enhancement: Add option for outside labels</a>                                   |       :no_entry:        |                                                                                                                        | As of now if there are a lot of segments in the chart the label values (in the pie) are cut by one another.<br />It would be great if there was an option to have outside labels something like:<br />https://google.github.io/charts/flutter/example/pie_charts/outside_label                                                                                         |
| <a href="https://github.com/apgapg/pie_chart/issues/7">Request: Omit zero values from chart</a>                                         |       :no_entry:        |                                                                                                                        | First of all great lib! good work!<br />I would like to request an option to omit zero values from the chart (not from the legend) as right now if some of the values are o it shows 0% between the other groups and it looks weird...                                                                                                                                 |
| <a href="https://github.com/apgapg/pie_chart/pull/6">adding font family</a>                                                             |       :no_entry:        |                                                                                                                        | i added font family option on this library to have more feature customizing that                                                                                                                                                                                                                                                                                       |
| <a href="https://github.com/apgapg/pie_chart/issues/5">Pie Chart Colors</a>                                                             |       :no_entry:        |                                                                                                                        | Goodmorning Apgapg,<br /><br />I was wondering if you had any progress on this issue?<br />...                                                                                                                                                                                                                                                                         |

<!-- issueTable -->

# ⭐ My Flutter Packages
- [json_table](https://pub.dartlang.org/packages/json_table)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/json_table.svg?style=social)](https://github.com/apgapg/json_table)  Create Flutter Json Table from json map directly.
- [avatar_glow](https://pub.dartlang.org/packages/avatar_glow)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/avatar_glow.svg?style=social)](https://github.com/apgapg/avatar_glow)  Flutter Avatar Glow Widget with glowing animation.
- [search_widget](https://pub.dartlang.org/packages/search_widget)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/search_widget.svg?style=social)](https://github.com/apgapg/search_widget)  Flutter Search Widget for selecting an option from list.
- [animating_location_pin](https://pub.dev/packages/animating_location_pin)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/animating_location_pin.svg?style=social)](https://github.com/apgapg/animating_location_pin)  Flutter Animating Location Pin Widget providing Animating Location Pin Widget which can be used while fetching device location.
                                                                                                                                                                                                                             
# ⭐ My Flutter Apps
- [flutter_profile](https://github.com/apgapg/flutter_profile)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/flutter_profile.svg?style=social)](https://github.com/apgapg/flutter_profile)  Showcase My Portfolio: Ayush P Gupta on Playstore.
- [flutter_sankalan](https://github.com/apgapg/flutter_sankalan)  [![GitHub stars](https://img.shields.io/github/stars/apgapg/flutter_sankalan.svg?style=social)](https://github.com/apgapg/flutter_sankalan)  Flutter App which allows reading/uploading short stories.

# 👍 Contribution
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -m 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
