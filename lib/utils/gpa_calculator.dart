class GPACalculator {
  static const Map<String, double> gradePoints = {
    'A+': 4.0,
    'A': 3.75,
    'B+': 3.5,
    'B': 3.0,
    'C+': 2.5,
    'C': 2.0,
    'D+': 1.5,
    'D': 1.0,
    'F': 0.0,
  };

  static double calculateSemesterGPA(List<Map<String, dynamic>> subjects) {
    double totalPoints = 0;
    double totalHours = 0;

    for (var subject in subjects) {
      double hours = double.parse(subject['hours']);
      double points = gradePoints[subject['grade']]!;
      
      totalPoints += hours * points;
      totalHours += hours;
    }

    return totalPoints / totalHours;
  }

  static double calculateCumulativeGPA({
    required double previousGPA,
    required int previousHours,
    required double currentGPA,
    required double currentHours,
  }) {
    double totalPoints = (previousGPA * previousHours) + (currentGPA * currentHours);
    double totalHours = previousHours + currentHours;
    return totalPoints / totalHours;
  }
}