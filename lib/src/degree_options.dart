const double fullDegree = 360.0;

class DegreeOptions {
  final double totalDegrees;
  final double initialAngle;

  const DegreeOptions({
    this.totalDegrees = 360,
    this.initialAngle = 0,
  })  : assert(totalDegrees >= 0 && totalDegrees <= fullDegree),
        assert(initialAngle >= -fullDegree && initialAngle <= fullDegree);

  DegreeOptions copyWith({
    double? totalDegrees,
    double? initialAngle,
  }) {
    return DegreeOptions(
      totalDegrees: totalDegrees ?? this.totalDegrees,
      initialAngle: initialAngle ?? this.initialAngle,
    );
  }
}
