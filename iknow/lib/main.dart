import 'package:flutter/material.dart';
import 'package:iknow/pages/question_answer.dart';

void main() {
  runApp(IKnowEverythingApp());
}

class IKnowEverythingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'I Know',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: QuestionAnswerPage(),
    );
  }
}
