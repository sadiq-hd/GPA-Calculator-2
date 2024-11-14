import 'package:flutter/material.dart';

class Subject {
  TextEditingController hoursController = TextEditingController();
  String selectedGrade = 'A+';
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo,
        colorScheme: ColorScheme.light(
          primary: Colors.indigo,
          secondary: Colors.teal,
          surface: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Subject> subjects = [Subject()];
  double totalPoints = 0;
  double totalHours = 0;
  String resultMessage = '';
  final List<String> grades = ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'];

  // Animation controllers
  late AnimationController _fabController;
  late AnimationController _resultController;
  final Map<int, AnimationController> _subjectControllers = {};

  @override
  void initState() {
    super.initState();
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

  void _initializeSubjectController(int index) {
    _subjectControllers[index] = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _resultController.dispose();
    _subjectControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حساب المعدل الفصلي',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme
                  .of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          buildSubjectsInputs(),
                          SizedBox(height: 20),
                          buildCalculateButton(),
                        ],
                      ),
                    ),
                  ),
                  if (resultMessage.isNotEmpty) ...[
                    SizedBox(height: 20),
                    buildResultCard(),
                  ],
                  SizedBox(height: 80),
                ],
              ),
            ),
            buildAnimatedFAB(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildAnimatedFAB() {
    return Positioned(
      bottom: 16, // تحديد موقع الزر من الأسفل
      right: 16, // تحديد موقع الزر من اليمين
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: _fabController,
            curve: Curves.easeInOut,
          ),
        ),
        child: FloatingActionButton(
          onPressed: addSubject,
          child: Icon(Icons.add),
          tooltip: 'إضافة مادة جديدة',
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 4,
        ),
      ),
    );
  }



  Widget buildCalculateButton() {
    return ElevatedButton.icon(
      onPressed: () {
        calculateSemesterGPA();
        _resultController.forward(from: 0.0);
      },
      icon: Icon(Icons.calculate_outlined, size: 28),
      label: Text('حساب المعدل',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        minimumSize: Size(double.infinity, 56),
        elevation: 3,
      ),
    );
  }

  Widget buildResultCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _resultController,
          curve: Curves.easeOutBack,
        ),
      ),
      child: FadeTransition(
        opacity: _resultController,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Theme
              .of(context)
              .colorScheme
              .primary,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  Icons.school_outlined,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 8),
                Text(
                  'المعدل الفصلي',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  resultMessage,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubjectsInputs() {
    return Column(
      children: subjects
          .asMap()
          .entries
          .map((entry) {
        int index = entry.key;
        return SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: _subjectControllers[index]!,
            curve: Curves.easeInOut,
          ),
          child: FadeTransition(
            opacity: _subjectControllers[index]!,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: buildSubjectInput(index),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildSubjectInput(int index) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: buildSubjectInputContent(index),
    );
  }

  Widget buildSubjectInputContent(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'المادة ${index + 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                ),
              ),
            ),
            if (subjects.length > 1)
              IconButton(
                icon: Icon(Icons.delete_outlined),
                onPressed: () => removeSubject(index),
                color: Colors.red[400],
                tooltip: 'حذف المادة',
              ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: subjects[index].hoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'الساعات المعتمدة',
                  prefixIcon: Icon(Icons.access_time_outlined),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: buildGradeDropdown(index),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGradeDropdown(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: subjects[index].selectedGrade,
          isExpanded: true,
          items: grades.map((String grade) {
            return DropdownMenuItem<String>(
              value: grade,
              child: Row(
                children: [
                  Icon(Icons.grade_outlined, color: getGradeColor(grade)),
                  SizedBox(width: 8),
                  Text(grade, style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              subjects[index].selectedGrade = newValue!;
            });
          },
        ),
      ),
    );
  }

  Color getGradeColor(String grade) {
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

  Widget buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Text(
        '© 2024 GPA Calculator. All rights reserved Sadiq Developer.',
        style: TextStyle(fontSize: 12, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  void addSubject() {
    setState(() {
      int newIndex = subjects.length;
      subjects.add(Subject());
      _initializeSubjectController(newIndex);
      _fabController.forward(from: 0.0);
    });
  }

  void removeSubject(int index) {
    setState(() {
      subjects.removeAt(index);
      _subjectControllers[index]?.dispose();
      _subjectControllers.remove(index);
      for (int i = index; i < subjects.length; i++) {
        _subjectControllers[i] = _subjectControllers[i + 1]!;
      }
      _subjectControllers.remove(subjects.length);
    });
  }

  void calculateSemesterGPA() {
    try {
      totalPoints = 0;
      totalHours = 0;

      for (var subject in subjects) {
        if (subject.hoursController.text.isEmpty) {
          throw 'الرجاء إدخال جميع البيانات المطلوبة لكل مادة';
        }
        totalPoints += calculateSubjectPoints(
          subject.hoursController.text,
          subject.selectedGrade,
        );
        totalHours += double.parse(subject.hoursController.text);
      }

      double gpa = totalPoints / totalHours;
      setState(() {
        resultMessage = gpa.toStringAsFixed(2);
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('خطأ'),
              content: Text(e.toString()),
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
  }

  double calculateSubjectPoints(String hours, String grade) {
    double creditHours = double.parse(hours);
    double subjectPoints = 0;

    switch (grade) {
      case 'A+':
        subjectPoints = 4.0;
        break;
      case 'A':
        subjectPoints = 3.75;
        break;
      case 'B+':
        subjectPoints = 3.5;
        break;
      case 'B':
        subjectPoints = 3.0;
        break;
      case 'C+':
        subjectPoints = 2.5;
        break;
      case 'C':
        subjectPoints = 2.0;
        break;
      case 'D+':
        subjectPoints = 1.5;
        break;
      case 'D':
        subjectPoints = 1.0;
        break;
      case 'F':
        subjectPoints = 0.0;
        break;
      default:
        throw 'درجة غير صالحة';
    }

    return creditHours * subjectPoints;
  }
}