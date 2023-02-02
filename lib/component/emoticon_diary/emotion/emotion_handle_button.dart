import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import "../../../services/emotion.dart";

var EmoticonService = new EmoticonServices();

Map ImageLink = {
  "null": "assets/images/mean.png",
  "angry": "assets/images/angry.png",
  "anticipate": "assets/images/anticipate.png",
  "bored": "assets/images/bored.png",
  "calm": "assets/images/calm.png",
  "content": "assets/images/content.png",
  "excited": "assets/images/excited.png",
  "happy": "assets/images/happy.png",
  "relaxed": "assets/images/relaxed.png",
  "sad": "assets/images/sad.png",
  "surprised(bad reason)": "assets/images/surprised(bad).png",
  "surprised(good reason)": "assets/images/surprised(good).png",
  "tense": "assets/images/tense.png",
  "tired": "assets/images/tired.png"
};

class EmotionHandleButton extends StatefulWidget {
  const EmotionHandleButton(
      {Key? key,
      required this.inputText,
      required this.setEmotion,
      required this.setIsLoading})
      : super(key: key);
  final String inputText;
  final void Function(String) setEmotion;
  final void Function(bool) setIsLoading;
  @override
  State<EmotionHandleButton> createState() => _EmotionHandleButtonState();
}

class _EmotionHandleButtonState extends State<EmotionHandleButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.send),
        onPressed: () {
          widget.setIsLoading(false);
          Future<String> emotion = EmoticonService.getEmotion(widget.inputText);
          emotion.then((val) {
            developer.log(val);
            String imageLink = ImageLink[val];
            widget.setEmotion(imageLink);
            widget.setIsLoading(true);
          });
        });
  }
}