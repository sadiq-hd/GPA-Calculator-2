import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String result;
  final AnimationController controller;
  final Color? backgroundColor;
  final Widget? subtitle;

  const ResultCard({
    Key? key,
    required this.title,
    required this.result,
    required this.controller,
    this.backgroundColor,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
        ),
      ),
      child: FadeTransition(
        opacity: controller,
        child: Card(
          elevation: 4,
          color: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.school_outlined,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4),
                  subtitle!,
                ],
                SizedBox(height: 8),
                Text(
                  result,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}