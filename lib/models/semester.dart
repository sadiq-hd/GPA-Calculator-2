class Semester {
  String name;
  double gpa;
  int creditHours;
  
  Semester({
    required this.name,
    required this.gpa,
    required this.creditHours,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gpa': gpa,
      'creditHours': creditHours,
    };
  }
  
  static Semester fromJson(Map<String, dynamic> json) {
    return Semester(
      name: json['name'],
      gpa: json['gpa'],
      creditHours: json['creditHours'],
    );
  }
}