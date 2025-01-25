import 'package:flutter/material.dart';
import '../models/subject.dart';
import 'grade_dropdown.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final int index;
  final bool canDelete;
  final VoidCallback? onDelete;

  const SubjectCard({
    Key? key,
    required this.subject,
    required this.index,
    this.canDelete = true,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 16),
          _buildInputs(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'المادة ${index + 1}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        if (canDelete && onDelete != null)
          IconButton(
            icon: Icon(Icons.delete_outlined),
            onPressed: onDelete,
            color: Colors.red[400],
            tooltip: 'حذف المادة',
          ),
      ],
    );
  }

  Widget _buildInputs(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: subject.hoursController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'الساعات المعتمدة',
              prefixIcon: Icon(Icons.access_time_outlined),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: GradeDropdown(
            value: subject.selectedGrade,
            onChanged: (newValue) {
              subject.selectedGrade = newValue!;
            },
          ),
        ),
      ],
    );
  }
}