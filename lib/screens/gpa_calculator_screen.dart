import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../utils/gpa_calculator.dart';
import '../widgets/subject_card.dart';
import '../widgets/result_card.dart';

class GPACalculatorScreen extends StatefulWidget {
  @override
  _GPACalculatorScreenState createState() => _GPACalculatorScreenState();
}

class _GPACalculatorScreenState extends State<GPACalculatorScreen>
    with TickerProviderStateMixin {
  List<Subject> subjects = [Subject()];
  String semesterGPA = '';
  String cumulativeGPA = '';
  
  final _previousGPAController = TextEditingController();
  final _previousHoursController = TextEditingController();
  
  late AnimationController _fabController;
  late AnimationController _resultController;
  final Map<int, AnimationController> _subjectControllers = {};

  bool get hasPreviousGPA =>
      _previousGPAController.text.isNotEmpty &&
      double.tryParse(_previousGPAController.text) != null &&
      double.parse(_previousGPAController.text) > 0;

  @override
  void initState() {
    super.initState();
    _setupControllers();
  }

  void _setupControllers() {
    _fabController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _resultController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _initializeSubjectController(0);
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _fabController.dispose();
    _resultController.dispose();
    _subjectControllers.values.forEach((controller) => controller.dispose());
    subjects.forEach((subject) => subject.dispose());
    _previousGPAController.dispose();
    _previousHoursController.dispose();
  }

  void _calculateGPA() {
    try {
      List<Map<String, dynamic>> subjectsData = [];
      
      for (var subject in subjects) {
        if (subject.hoursController.text.isEmpty) {
          throw 'الرجاء إدخال جميع البيانات المطلوبة لكل مادة';
        }
        subjectsData.add({
          'hours': subject.hoursController.text,
          'grade': subject.selectedGrade,
        });
      }

      // حساب المعدل الفصلي
      double semesterGPAValue = GPACalculator.calculateSemesterGPA(subjectsData);
      setState(() {
        semesterGPA = semesterGPAValue.toStringAsFixed(2);
      });

      // حساب المعدل التراكمي إذا كان هناك معدل سابق
      if (hasPreviousGPA) {
        double previousGPA = double.parse(_previousGPAController.text);
        int previousHours = int.parse(_previousHoursController.text);
        
        // حساب مجموع الساعات الحالية
        double currentHours = subjectsData
            .map((s) => double.parse(s['hours']))
            .reduce((a, b) => a + b);
            
        // حساب المعدل التراكمي
        double totalPoints = (previousGPA * previousHours) + 
                           (semesterGPAValue * currentHours);
        double totalHours = previousHours + currentHours;
        
        setState(() {
          cumulativeGPA = (totalPoints / totalHours).toStringAsFixed(2);
        });
      }

      _resultController.forward(from: 0.0);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('خطأ'),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حساب المعدل'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPreviousGPACard(),
                  SizedBox(height: 16),
                  _buildSubjectsCard(),
                  SizedBox(height: 16),
                  if (semesterGPA.isNotEmpty) ...[
                    _buildResultCard(
                      'المعدل الفصلي',
                      semesterGPA,
                    ),
                    if (hasPreviousGPA) ...[
                      SizedBox(height: 16),
                      _buildResultCard(
                        'المعدل التراكمي',
                        cumulativeGPA,
                      ),
                    ],
                  ],
                  SizedBox(height: 80),
                ],
              ),
            ),
            _buildAddSubjectButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousGPACard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المعدل التراكمي السابق (اختياري)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _previousGPAController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'المعدل التراكمي',
                      prefixIcon: Icon(Icons.grade_outlined),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _previousHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'الساعات المجتازة',
                      prefixIcon: Icon(Icons.access_time_outlined),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مواد الفصل الحالي',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            ...subjects.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: SubjectCard(
                  subject: entry.value,
                  index: entry.key,
                  canDelete: subjects.length > 1,
                  onDelete: () => _removeSubject(entry.key),
                ),
              );
            }).toList(),
            SizedBox(height: 16),
            _buildCalculateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return ElevatedButton.icon(
      onPressed: _calculateGPA,
      icon: Icon(Icons.calculate_outlined),
      label: Text(
        'حساب المعدل',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 48),
      ),
    );
  }

  Widget _buildResultCard(String title, String result) {
    return ResultCard(
      title: title,
      result: result,
      controller: _resultController,
    );
  }

  Widget _buildAddSubjectButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: _addSubject,
        child: Icon(Icons.add),
        tooltip: 'إضافة مادة جديدة',
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _addSubject() {
    setState(() {
      subjects.add(Subject());
    });
  }

  void _removeSubject(int index) {
    setState(() {
      subjects[index].dispose();
      subjects.removeAt(index);
    });
  }

  void _initializeSubjectController(int index) {
    _subjectControllers[index] = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..forward();
  }
}