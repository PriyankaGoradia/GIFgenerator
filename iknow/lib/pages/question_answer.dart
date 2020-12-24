// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iknow/models/answer.dart';

class QuestionAnswerPage extends StatefulWidget {
  QuestionAnswerPage({Key key}) : super(key: key);

  @override
  QuestionAnswerPageState createState() => QuestionAnswerPageState();
}

class QuestionAnswerPageState extends State<QuestionAnswerPage> {
  ///Text editing Controller for questoin text field
  TextEditingController _questionFieldController = TextEditingController();

  // to store the current answer object; private variable
  Answer _currentAnswer;

  ///s=Scafold key
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ///will handle the process of getting a yes or no answer
  //always wrap network request inside a try catch block
  _handleGetAnswer() async {
    String questionText = _questionFieldController.text?.trim();
    if (questionText == null ||
        questionText.length == 0 ||
        questionText[questionText.length - 1] != '?') {
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('You question should have a ? at the end!'),
        duration: Duration(seconds: 3),
      ));
      // no API call happens in these cases
      return;
    }
    try {
      http.Response response = await http.get('https://yesno.wtf/api');
      // on success 200 is printed as status code for most APIs
      if (response.statusCode == 200 && response.body != null) {
        // converting run time type from string to map; so that we can parse that map into answer module
        Map<String, dynamic> responseBody = json.decode(response.body);
        //answer instance that is to be shown to the user
        Answer answer = Answer.fromMap(responseBody);
        setState(() {
          _currentAnswer = answer;
        });
      }
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
    }
  }

  /// function for reset button
  _handleResetOperation() {
    _questionFieldController.text = '';
    setState(() {
      _currentAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Priii Knows 😏👻👀💁‍♀️'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //50% of the screen width
          Container(
              width: 0.5 * MediaQuery.of(context).size.width,
              child: TextField(
                controller: _questionFieldController,
                decoration: InputDecoration(
                  labelText: 'Ask a Yes/No question',
                  border: OutlineInputBorder(),
                ),
              )),
          SizedBox(height: 30),
          if (_currentAnswer != null)
            Stack(
              children: [
                Container(
                  height: 250,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_currentAnswer.image),
                    ),
                  ),
                ),
                Positioned.fill(
                    bottom: 20,
                    right: 20,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(_currentAnswer.answer.toUpperCase(),
                          style: TextStyle(color: Colors.amber, fontSize: 24)),
                    )),
              ],
            ),
          if (_currentAnswer != null) SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                // just providing a reference to the function
                onPressed: _handleGetAnswer,
                child: Text('Get Answer',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              SizedBox(width: 30),
              RaisedButton(
                onPressed: _handleResetOperation,
                child: Text('Reset',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
