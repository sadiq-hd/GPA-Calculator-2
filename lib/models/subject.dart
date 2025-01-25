import 'package:flutter/material.dart';

class Subject {
  TextEditingController hoursController = TextEditingController();
  String selectedGrade;
  
  Subject({this.selectedGrade = 'A+'});
  
  void dispose() {
    hoursController.dispose();
  }
  
  Map<String, dynamic> toJson() {
    return {
      'hours': hoursController.text,
      'grade': selectedGrade,
    };
  }
  
  static Subject fromJson(Map<String, dynamic> json) {
    Subject subject = Subject(selectedGrade: json['grade']);
    subject.hoursController.text = json['hours'];
    return subject;
  }
}