import 'package:flutter/material.dart';

import '../../asset/init_data.dart';
import '../../component/common/app_bar.dart';
import '../../component/common/loading_proto.dart';
import '../../component/emoticon_diary/calendar/calendar.dart';
import '../../component/emoticon_diary/emotion/emotion.dart' as input_emotion;
import '../../component/emoticon_diary/emotion/emotion_preview.dart';
import '../../services/emotion.dart';

EmotionServices emotionServices = EmotionServices();

class CalendarWrapper extends StatefulWidget {
  const CalendarWrapper({Key? key}) : super(key: key);

  @override
  State<CalendarWrapper> createState() => _CalendarWrapperState();
}

class _CalendarWrapperState extends State<CalendarWrapper> {
  // final LocalNotificationController localNotificationController = Get.find();

  DateTime dateSelected = DateTime.now();
  void setDateSelected(DateTime date) {
    setState(() {
      dateSelected = date;
    });
  }

  bool isLoading = false;
  void setIsLoading(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  bool inputEmotionUp = false;
  void setInputEmotionUp(bool state) {
    setState(() {
      inputEmotionUp = state;
    });
  }

  Map<String, Map> curDates = InitDate;
  void setCurDatesAll(Map<String, Map> Dates) {
    setState(() {
      curDates = Dates;
    });
  }

  void setCurDate(String day, int? id, String? text, String? emotion) {
    setState(() {
      if (id != null) {
        curDates[day]?["id"] = id;
      }
      if (text != null) {
        curDates[day]?["content"] = text;
      }
      if (emotion != null) {
        curDates[day]?["emotion"] = emotion;
      }
    });
  }

  String? curTempEmotion;
  void setCurTempEmotion(String? tempEmotion) {
    setState(() {
      curTempEmotion = tempEmotion;
    });
  }

  bool emotionSelectorUp = false;
  void setEmotionSelectorUp(bool state) {
    setState(() {
      emotionSelectorUp = state;
    });
  }

  TextEditingController controller = TextEditingController();

  Future<void> _asyncMethod() async {
    DateTime Today = DateTime.now().toUtc();
    setIsLoading(true);
    await emotionServices.getEmotionMonth(
        Today.year, Today.month, setCurDatesAll);
    setIsLoading(false);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(curDate: dateSelected, curPath: "emotionDiary"),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 800,
            child: Wrap(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 800,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 800,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Calendar(
                            textEditController: controller,
                            curDates: curDates,
                            setDateSelected: setDateSelected,
                            setInputEmotionUp: setInputEmotionUp,
                            setCurDateAll: setCurDatesAll,
                            setIsLoading: setIsLoading,
                          ),
                          SizedBox(height: 20),
                          EmotionPreview(
                            isLoading: isLoading,
                            curDates: curDates,
                            dateSelected: dateSelected,
                            setInputEmotionUp: setInputEmotionUp,
                            setEmotionSelectorUp: setEmotionSelectorUp,
                          )
                        ],
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      child: isLoading
                          ? SizedBox(height: 0, width: 0)
                          : input_emotion.EmotionWrapper(
                              textController: controller,
                              curDates: curDates,
                              dateSelected: dateSelected,
                              setCurDate: setCurDate,
                              curTempEmotion: curTempEmotion,
                              emotionSelectorUp: emotionSelectorUp,
                              setIsLoading: setIsLoading,
                              setInputEmotionUp: setInputEmotionUp,
                              setCurTempEmotion: setCurTempEmotion,
                              setEmotionSelectorUp: setEmotionSelectorUp,
                            ),
                      width: MediaQuery.of(context).size.width,
                      left: 0,
                      top: inputEmotionUp ? 50 : 800,
                    ),
                    Loading(isLoading: isLoading, height: double.infinity)
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
