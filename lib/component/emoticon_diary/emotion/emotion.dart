import 'package:flutter/material.dart';

import '../../common/loading.dart';
import 'emotion_chart.dart';
import 'emotion_handle_button.dart';
import 'emotion_head.dart';
import 'emotion_input.dart';
import 'emotion_selector.dart';

const String url = "http://localhost:3000";

class EmotionWrapper extends StatefulWidget {
  const EmotionWrapper(
      {Key? key,
      required this.setInputEmotionUp,
      required this.dateSelected,
      required this.dateSelectedDeformed})
      : super(key: key);
  final void Function(bool) setInputEmotionUp;
  final String dateSelected;
  final DateTime dateSelectedDeformed;
  @override
  State<EmotionWrapper> createState() => _EmotionWrapperState();
}

class _EmotionWrapperState extends State<EmotionWrapper> {
  @override
  Widget build(BuildContext context) {
    bool emotionSelectorUp = false;
    void setEmotionSelectorUp(bool state) {
      setState(() {
        emotionSelectorUp = state;
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), //키보드 이외의 영역 터치시 사라짐
      child: SingleChildScrollView(
        child: Container(
          height: 800,
          decoration: BoxDecoration(
            //style 느낌
            color: Colors.white,
          ),
          child: Stack(children: [
            EmotionContainer(
                date: widget.dateSelected,
                setInputEmotionUp: widget.setInputEmotionUp,
                dateSelectedDeformed: widget.dateSelectedDeformed),
            EmoticonSelector(emotionSelectorUp: emotionSelectorUp)
          ]),
        ),
      ),
    );
  }
}

class EmotionContainer extends StatefulWidget {
  final String date;

  const EmotionContainer(
      {Key? key,
      required this.date,
      required this.setInputEmotionUp,
      required this.dateSelectedDeformed})
      : super(key: key);
  final void Function(bool) setInputEmotionUp;
  final DateTime dateSelectedDeformed;

  @override
  State<EmotionContainer> createState() => _EmotionContainerState();
}

class _EmotionContainerState extends State<EmotionContainer> {
  @override
  String inputText = '';
  void setInputText(String text) {
    setState(() {
      inputText = text;
    });
  }

  String emotion = "assets/images/mean.png";
  void setEmotion(String newEmotion) {
    setState(() {
      emotion = newEmotion;
    });
  }

  bool isLoading = true;
  void setIsLoading(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Color.fromRGBO(240, 240, 240, 1),
        ),
        child: Stack(
          children: [
            Column(children: <Widget>[
              SizedBox(height: 30),
              EmotionHead(
                  date: widget.date,
                  setInputEmotionUp: widget.setInputEmotionUp),
              SizedBox(height: 30),
              EmotionChart(emotion: emotion),
              SizedBox(
                child: Column(children: <Widget>[
                  EmotionInput(inputText: inputText, setInputText: setInputText)
                ]),
              ),
              SizedBox(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  EmotionHandleButton(
                    inputText: inputText,
                    setEmotion: setEmotion,
                    setIsLoading: setIsLoading,
                    dateSelectedDeformed: widget.dateSelectedDeformed,
                  )
                ]),
              )
            ]),
            Loading(isLoading: isLoading, height: 800),
          ],
        ),
      ),
    );
  }
}
