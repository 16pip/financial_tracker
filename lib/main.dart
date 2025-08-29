import 'package:flutter/material.dart';
import 'package:financial_tracker/financial_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FinancialTrackerApp());
  }
}
