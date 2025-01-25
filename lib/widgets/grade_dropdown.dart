import 'package:flutter/material.dart';

class GradeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const GradeDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  static const List<String> grades = ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'];

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Colors.green;
      case 'B+':
      case 'B':
        return Colors.blue;
      case 'C+':
      case 'C':
        return Colors.orange;
      case 'D+':
      case 'D':
        return Colors.deepOrange;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: grades.map((String grade) {
            return DropdownMenuItem<String>(
              value: grade,
              child: Row(
                children: [
                  Icon(Icons.grade_outlined, color: _getGradeColor(grade)),
                  SizedBox(width: 8),
                  Text(grade, style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}