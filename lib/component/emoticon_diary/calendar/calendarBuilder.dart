import 'package:aeye/asset/emoticon_url.dart';
import "package:aeye/services/emotion.dart";
import 'package:flutter/material.dart';

import './table-calendar/table_calendar.dart';

EmotionServices emotionServices = EmotionServices();

Map Month = {
  "1": "Jan",
  "2": "Feb",
  "3": "Mar",
  "4": "Apr",
  "5": "May",
  "6": "Jun",
  "7": "Jul",
  "8": "Aug",
  "9": "Sep",
  "10": "Oct",
  "11": "Nov",
  "12": "Dec"
};

List<int> yearList = [for (var i = 2021; i <= 10; i++) i];

SizedBox buildCalendarDay({
  required int? id,
  required String day,
  required bool selected,
  required bool isToday,
  required bool outSide,
  required String imoticon,
  required Color back,
}) {
  Color fontBackground = selected
      ? Color.fromRGBO(255, 0, 0, 0.4)
      : isToday
          ? Color(0xff65B1EF)
          : id == null
              ? Colors.white
              : Color(0xffFFF6DA);
  Color fontColor = isToday ? Colors.white : Colors.black;

  if (outSide) {
    fontColor = Colors.grey;
  }

  return SizedBox(
      child: Container(
          padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 0),
          decoration: BoxDecoration(
              color: back, borderRadius: BorderRadius.circular(10)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(width: 25, imoticon),
                Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: fontBackground),
                    child: Text(style: TextStyle(color: fontColor), day))
              ])));
}

CalendarBuilders calendarBuilders(Map<String, Map> curDates,
    Function(Map<String, Map>) setCurDateAll, Function(bool) setIsLoading) {
  return CalendarBuilders(selectedBuilder: (context, date, _) {
    String day = date.day.toString();
    Map info = curDates[day] ?? {"id": null, "emotion": null, "content": null};

    int? id = info["id"];
    String emoticon = info["emotion"] == null
        ? "assets/images/mean.png"
        : "assets/images/${info["emotion"]}.png";
    Color back = info["id"] == null ? Colors.white : Color(0xffFFF6DA);

    return buildCalendarDay(
        id: id,
        day: day,
        selected: true,
        isToday: false,
        outSide: false,
        imoticon: emoticon,
        back: back);
  }, todayBuilder: (context, date, _) {
    String day = date.day.toString();
    Map info = curDates[day] ?? {"id": null, "emotion": null, "content": null};
    int? id = info["id"];
    String emoticon = info["emotion"] == null
        ? "assets/images/mean.png"
        : "assets/images/${info["emotion"]}.png";
    Color back = info["id"] == null ? Colors.white : Color(0xffFFF6DA);
    return buildCalendarDay(
        id: id,
        day: day,
        selected: false,
        isToday: true,
        outSide: false,
        back: back,
        imoticon: emoticon);
  }, rangeStartBuilder: (context, date, _) {
    String day = date.day.toString();
    Map info = curDates[day] ?? {"id": null, "emotion": null, "content": null};
    int? id = info["id"];
    String emoticon = info["emotion"] == null
        ? "assets/images/mean.png"
        : "assets/images/${info["emotion"]}.png";
    Color back = info["id"] == null ? Colors.white : Color(0xffFFF6DA);
    return buildCalendarDay(
        id: id,
        day: day,
        selected: false,
        isToday: false,
        outSide: false,
        back: back,
        imoticon: emoticon);
  }, rangeEndBuilder: (context, date, _) {
    String day = date.day.toString();
    Map info = curDates[day] ?? {"id": null, "emotion": null, "content": null};
    int? id = info["id"];
    String emoticon = info["emotion"] == null
        ? "assets/images/mean.png"
        : "assets/images/${info["emotion"]}.png";
    Color back = info["id"] == null ? Colors.white : Color(0xffFFF6DA);
    return buildCalendarDay(
        id: id,
        day: day,
        selected: false,
        isToday: false,
        outSide: false,
        back: back,
        imoticon: emoticon);
  }, outsideBuilder: (context, date, _) {
    String day = date.day.toString();
    String emoticon = ImageLink[null];
    Color back = Colors.white;
    return buildCalendarDay(
        id: null,
        day: day,
        selected: false,
        isToday: false,
        outSide: true,
        back: back,
        imoticon: emoticon);
  }, disabledBuilder: (context, date, _) {
    String day = date.day.toString();
    Map info = curDates[day] ?? {"id": null, "emotion": null, "content": null};

    int? id = info["id"];

    String emoticon = info["emotion"] == null
        ? "assets/images/mean.png"
        : "assets/images/${info["emotion"]}.png";
    Color back = info["id"] == null ? Colors.white : Color(0xffFFF6DA);
    return buildCalendarDay(
        id: id,
        day: day,
        selected: false,
        isToday: false,
        outSide: false,
        back: back,
        imoticon: emoticon);
  }, holidayBuilder: (context, date, _) {
    String day = date.day.toString();
    Map info = curDates[day] ?? {"id": null, "emotion": null, "content": null};
    int? id = info["id"];
    String emoticon = info["emotion"] == null
        ? "assets/images/mean.png"
        : "assets/images/${info["emotion"]}.png";
    Color back = info["id"] == null ? Colors.white : Color(0xffFFF6DA);
    return buildCalendarDay(
        id: id,
        day: day,
        selected: false,
        isToday: false,
        outSide: false,
        back: back,
        imoticon: emoticon);
  }, defaultBuilder: (context, date, _) {
    String day = date.day.toString();
    Map info = curDates[day] ?? {"id": null, "emotion": null, "content": null};
    int? id = info["id"];
    Color back = info["id"] == null ? Colors.white : Color(0xffFFF6DA);
    String emoticon = info["emotion"] == null
        ? "assets/images/mean.png"
        : "assets/images/${info["emotion"]}.png";

    return buildCalendarDay(
        id: id,
        day: day,
        back: back,
        selected: false,
        isToday: false,
        outSide: false,
        imoticon: emoticon);
  });
}

class YearButton extends StatefulWidget {
  const YearButton(
      {super.key,
      required this.pageController,
      required this.month,
      required this.setCurDateAll,
      required this.setIsLoading});
  final PageController pageController;
  final int month;
  final void Function(Map) setCurDateAll;
  final void Function(bool) setIsLoading;

  @override
  State<YearButton> createState() => _YearButtonState();
}

class _YearButtonState extends State<YearButton> {
  int dropdownValue = 2023;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 0,
      style: const TextStyle(color: Colors.black),
      onChanged: (int? value) async {
        if (value == null) {
          return;
        }
        int variation = 12 * (value - dropdownValue);
        widget.pageController.animateToPage(variation,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        widget.setIsLoading(true);
        await emotionServices.getEmotionMonth(
            value, widget.month, widget.setCurDateAll);
        widget.setIsLoading(false);
        setState(() {
          dropdownValue = value;
        });
      },
      items: yearList.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
