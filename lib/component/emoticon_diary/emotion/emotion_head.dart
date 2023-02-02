import "package:flutter/material.dart";

class EmotionHead extends StatefulWidget {
  const EmotionHead(
      {Key? key, required this.date, required this.setInputEmotionUp})
      : super(key: key);
  final dynamic date;
  final void Function(bool) setInputEmotionUp;

  @override
  State<EmotionHead> createState() => _EmotionHeadState();
}

class _EmotionHeadState extends State<EmotionHead> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        Opacity(
            opacity: 0,
            child: SizedBox(
              width: 60.0,
              child: IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/ico_close.png')),
            )),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.date,
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 60.0,
          child: IconButton(
              onPressed: () {
                widget.setInputEmotionUp(false);
              },
              icon: Image.asset('assets/images/ico_close.png')),
        )
      ]),
    );
  }
}