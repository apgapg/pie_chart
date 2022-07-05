# CHANGELOG

## [5.3.2]

- chore: fix dart analysis errors

## [5.3.1]

- chore: upgrade flutter and example app
- fix: gradient color overlap #83

## [5.3.0]

- feat: add `totalValue` parameter

## [5.2.0]

- feat: add `baseChartColor` option

## [5.1.0]

- Update example code with gradient feature
- Add gradient colors support (#73)

## [5.0.1]

- [MacOS] Add macos support in example
- <fix> #66 Pie chart not animating with version 5.0.0+ (#69)  
- Accept center text style as a paramter

## [5.0.0]

* Show custom color when pie chart is empty.
* Set Colors.grey as default value for emptyColor.
* Update README.md with decimalPlaces docs.
* [Null Safety] Migrate project to null safety.

## [4.0.1]

* Fix README.md for broken images link

## [4.0.0] **Breaking**

* Wrap different parameters in chartValuesOptions, legendOptions
* Fix number of issues

## [3.1.1]

* Fix [#22](https://github.com/apgapg/pie_chart/issues/22) showLegends = false causes exception.

## [3.1.0]

* Add ring shape pie chart support

## [3.0.0] **Breaking**

* Migrate to AndroidX
* Add dark mode theme
* Remove color from default legendStyle to support dark mode
* Add enum LegendPosition to align chart legend **Breaking**
* Restructure whole project. Optimize code. Code Cleanup

Thanks [@xsahil03x](https://github.com/xsahil03x) for these changes

## [2.0.0]

* Fix padding, margin **Breaking**
* Fix error when parent is row
* Adapt to screen size **Breaking**
* Override chartRadius when screen is smaller compare to chartRadius **Breaking**
* Update example with macos and web support

## [1.3.0]

* Center text to sector center-line
* Add text labels

## [1.2.0]

* Merge [#12](https://github.com/apgapg/pie_chart/issues/12) Added option for showing decimal places in chart values.
  Thanks [@VB10](https://github.com/VB10) for PR

## [1.1.0]

* Merge [#11](https://github.com/apgapg/pie_chart/issues/11) Added option for changing initial angle of pie chart.
  Thanks [@mschneider](https://github.com/mschneider) for PR

## [1.0.0]

* Added [#8](https://github.com/apgapg/pie_chart/issues/8) Added option for showing chart values outside the pie
  chart [@guyzk](https://github.com/guyzk)
* Added [#7](https://github.com/apgapg/pie_chart/issues/7) Hide 0 values on pie chart.
  Thanks [@guyzk](https://github.com/https://github.com/guyzk)
* Added legend fontFamily support. Thanks [@MahdiPishguy](https://github.com/MahdiPishguy) for PR

## [0.9.0]

* Fixes [#5](https://github.com/apgapg/pie_chart/issues/5) Added custom colorlist optional parameter.
  Thanks [@SJente](https://github.com/SJente)
* Fixes [#3](https://github.com/apgapg/pie_chart/issues/3) Update PieChart when data changes.
  Thanks [@leehuwuj](https://github.com/https://github.com/leehuwuj)
* Fixes [#2](https://github.com/apgapg/pie_chart/issues/2) Added showLegends bool as optional Parameter.
  Thanks [@cuitao1988](https://github.com/https://github.com/cuitao1988)
* Fixes Exception when data length was greater than 5
* Added key to PieChart

## [0.8.0]

* Update README.md
* Format code
* Update min Dart SDK version  
  Thanks [@xsahil03x](https://github.com/xsahil03x) for this PR

## [0.7.0] - Initial Release
