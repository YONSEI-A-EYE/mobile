import 'dart:math';

import "package:aeye/component/common/loading_proto.dart";
import "package:aeye/services/emotion.dart";
import "package:flutter/material.dart";
import "package:syncfusion_flutter_charts/charts.dart";

Map monthToStr = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December"
};

List<String> emotionList = [
  "excited",
  "happy",
  "calm",
  "content",
  "anticipate",
  "tense",
  "angry",
  "sad",
  "relaxed",
  "bored",
  "tired",
  "badSurprised",
  "goodSurprised",
];

List<String> PositiveList = [
  "excited",
  "happy",
  "calm",
  "relaxed",
  "content",
  "goodSurprised",
];

List<String> NegativeList = [
  "tense",
  "angry",
  "sad",
  "bored",
  "tired",
  "badSurprised",
];

List<String> NeutralList = ["anticipate"];

Map<String, List> sentimentMap = {
  "0": PositiveList,
  "1": NeutralList,
  "2": NegativeList
};

class EmotionMonthResult extends StatefulWidget {
  const EmotionMonthResult({Key? key, required this.year, required this.month})
      : super(key: key);

  final int year;
  final int month;

  @override
  State<EmotionMonthResult> createState() => _EmotionMonthResultState();
}

class _EmotionMonthResultState extends State<EmotionMonthResult> {
  EmotionServices emotionServices = EmotionServices();

  Map? data = null;
  void setCurData(Map newData) {
    setState(() {
      data = newData;
    });
  }

  _asyncMethod() async {
    Map response =
        await emotionServices.getMonthlyResult(widget.year, widget.month);
    print(response);
    setCurData(response);
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
    String mon = monthToStr[widget.month];
    if (data == null) {
      return Loading(
          isLoading: true, height: MediaQuery.of(context).size.height);
    }

    Map sentimentalLevel = data!["sentimentLevel"];
    Map emotionHistogram = data!["emotionHistogram"];
    Map monthlyEmotion = data!["monthlyEmotion"];

    num totalEmotion = 0;
    sentimentalLevel.keys.forEach((key) {
      print(sentimentalLevel[key]);
      totalEmotion += sentimentalLevel[key];
    });

    print(totalEmotion);

    bool isShowChart = totalEmotion != 0;
    return Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child: Container(
              width: double.infinity,
              height: 1300,
              padding: EdgeInsets.only(bottom: 100),
              color: Color(0xffFFF2CB),
              child: Column(children: [
                Container(
                    child: Column(children: [
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios_new),
                                color: Colors.black),
                          ],
                        ),
                      ),
                      Text("${mon} ${widget.year}",
                          style: TextStyle(fontSize: 20, color: Colors.grey)),
                      SizedBox(
                        width: 100,
                      )
                    ],
                  ),
                  Text("Monthly Report", style: TextStyle(fontSize: 30)),
                  SizedBox(height: 20)
                ])),
                isShowChart
                    ? ChartWrapper(
                        sentimentalLevel: sentimentalLevel,
                        emotionHistogram: emotionHistogram,
                        monthlyEmotion: monthlyEmotion)
                    : Container(
                        height: 200,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("There is no diary this month",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ))
                            ])),
              ]))),
    );
  }
}

class EmoticonMonthResult extends StatelessWidget {
  const EmoticonMonthResult(
      {Key? key, required this.year, required this.month, required this.data})
      : super(key: key);

  final int year;
  final int month;
  final Map data;

  @override
  Widget build(BuildContext context) {
    String mon = monthToStr[month];

    Map sentimentalLevel = data["sentimentLevel"];
    Map emotionHistogram = data["emotionHistogram"];
    Map monthlyEmotion = data["monthlyEmotion"];

    num totalEmotion = 0;
    sentimentalLevel.keys.forEach((key) {
      print(sentimentalLevel[key]);
      totalEmotion += sentimentalLevel[key];
    });

    print(totalEmotion);

    bool isShowChart = totalEmotion != 0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Container(
                width: double.infinity,
                height: 1300,
                padding: EdgeInsets.only(bottom: 100),
                color: Color(0xffFFF2CB),
                child: Column(children: [
                  Container(
                      child: Column(children: [
                    SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  iconSize: 30,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios_new),
                                  color: Colors.black),
                            ],
                          ),
                        ),
                        Text("${mon} ${year}",
                            style: TextStyle(fontSize: 20, color: Colors.grey)),
                        SizedBox(
                          width: 100,
                        )
                      ],
                    ),
                    Text("Monthly Report", style: TextStyle(fontSize: 30)),
                    SizedBox(height: 20)
                  ])),
                  isShowChart
                      ? ChartWrapper(
                          sentimentalLevel: sentimentalLevel,
                          emotionHistogram: emotionHistogram,
                          monthlyEmotion: monthlyEmotion)
                      : SizedBox(height: 0),
                ]))),
      ),
    );
  }
}

class ChartWrapper extends StatefulWidget {
  const ChartWrapper(
      {Key? key,
      required this.sentimentalLevel,
      required this.emotionHistogram,
      required this.monthlyEmotion})
      : super(key: key);

  final Map sentimentalLevel;
  final Map emotionHistogram;
  final Map monthlyEmotion;

  @override
  State<ChartWrapper> createState() => _ChartWrapperState();
}

class _ChartWrapperState extends State<ChartWrapper>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  )..addListener(() {
      if (mounted) {
        setState(() {});
      }
      ;
    });

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInToLinear,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int curIdx = -1;
  void setCurIdx(int nextIdx) {
    setState(() {
      curIdx = nextIdx;
    });
  }

  @override
  Widget build(BuildContext context) {
    String bestEmotion = widget.monthlyEmotion["emotion"];
    String monthlyComment = widget.monthlyEmotion["comment"];

    Color monthlyColor = PositiveList.contains(bestEmotion)
        ? Color(0xff4FB600)
        : Color(0xffEC5313);

    double value = _animation.value;

    return Container(
        width: 360,
        padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset.zero,
                  blurRadius: 1.0,
                  spreadRadius: -0.9,
                  blurStyle: BlurStyle.normal)
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              SizedBox(width: 40),
              Text("Sentiment Level", style: TextStyle(fontSize: 23)),
            ],
          ),
          Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Container(
                  width: 230,
                  height: 230,
                  child: CircularChart(
                      animationController: _controller,
                      curIdx: curIdx,
                      setCurIdx: setCurIdx,
                      curData: [
                        _CircularData(
                            "positive",
                            widget.sentimentalLevel["positive"],
                            Color(0xff4FB600)),
                        _CircularData(
                            "neutral",
                            widget.sentimentalLevel["neutral"],
                            Color(0xffFFB600)),
                        _CircularData(
                            "negative",
                            widget.sentimentalLevel["negative"],
                            Color(0xffEC5313))
                      ]),
                ),
                ChartLegend(curIdx: curIdx, curData: [
                  _CircularData("positive", widget.sentimentalLevel["positive"],
                      Color(0xff4FB600)),
                  _CircularData("neutral", widget.sentimentalLevel["neutral"],
                      Color(0xffFFB600)),
                  _CircularData("negative", widget.sentimentalLevel["negative"],
                      Color(0xffEC5313))
                ])
              ])),
          // EmotionStatic(
          //     emotionHistogram: widget.emotionHistogram,
          //     bestEmotion: bestEmotion),
          SentimentEmotion(
              value: value,
              curIdx: curIdx,
              emotionHistogram: widget.emotionHistogram),
          SizedBox(height: 20),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("In this month,",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w400)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("You felt ",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w400)),
                        Text("${bestEmotion}",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w400,
                                color: monthlyColor)),
                        Text(" most frequently",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w400)),
                      ],
                    )
                  ])),
          SizedBox(height: 30),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Text("${monthlyComment}",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w400)))
        ]));
  }
}

class CircularChart extends StatefulWidget {
  const CircularChart(
      {Key? key,
      required this.animationController,
      required this.curData,
      required this.curIdx,
      required this.setCurIdx})
      : super(key: key);

  final AnimationController animationController;
  final List<_CircularData> curData;
  final int curIdx;
  final Function(int) setCurIdx;

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(series: <DoughnutSeries<_CircularData, String>>[
      DoughnutSeries<_CircularData, String>(
        radius: "60%",
        innerRadius: "80%",
        dataSource: widget.curData,
        onPointTap: (ChartPointDetails data) {
          int seriesIndex = data.pointIndex!;
          if (widget.curIdx == seriesIndex) {
            widget.setCurIdx(-1);
            return;
          }
          widget.setCurIdx(seriesIndex);
          widget.animationController.reset();
          widget.animationController.forward();
        },
        xValueMapper: (_CircularData data, _) => data.emotion,
        yValueMapper: (_CircularData data, _) => data.data,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            overflowMode: OverflowMode.none,
            labelIntersectAction: LabelIntersectAction.none,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Container(
                  height: 13,
                  width: widget.curIdx == -1 || pointIndex == widget.curIdx
                      ? 10
                      : 500,
                  child: Text(data.data.toString(),
                      style: TextStyle(
                          color:
                              widget.curIdx == -1 || pointIndex == widget.curIdx
                                  ? data.pointColor
                                  : Color(0xff9E9E9E))));
            }),
        dataLabelMapper: (_CircularData data, _) => data.data.toString(),
        pointColorMapper: (data, _) {
          if (widget.curIdx == -1) {
            return data.pointColor;
          } else {
            return data.emotion == widget.curData[widget.curIdx].emotion
                ? data.pointColor
                : Color(0xff9E9E9E);
          }
        },
        startAngle: -40,
        endAngle: 320,
      )
    ]);
  }
}

class ChartLegend extends StatelessWidget {
  const ChartLegend({Key? key, required this.curData, required this.curIdx})
      : super(key: key);

  final List<_CircularData> curData;
  final int curIdx;

  @override
  Widget build(BuildContext context) {
    int total = curData.fold(0, (vTotal, element) {
      return vTotal + element.data;
    });
    if (total == 0) {
      return SizedBox(width: 0);
    }

    return Container(
        padding: EdgeInsets.only(right: 20),
        child: Column(
            children: curData.map<SizedBox>((element) {
          int curRate = (element.data / total * 100).floor();
          Color curColor =
              curIdx == -1 || element.emotion == curData[curIdx].emotion
                  ? element.pointColor
                  : Color(0xff9E9E9E);
          return LegendContent(element.emotion, curRate, curColor);
        }).toList()));
  }
}

SizedBox LegendContent(String title, int rate, Color color) {
  return SizedBox(
      width: 105,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Icon(Icons.circle, size: 5, color: color),
          SizedBox(width: 5),
          Text("${title}", style: TextStyle(color: color))
        ]),
        Text("${rate}%", style: TextStyle(color: color))
      ]));
}

class SentimentEmotion extends StatefulWidget {
  const SentimentEmotion(
      {Key? key,
      required this.value,
      required this.curIdx,
      required this.emotionHistogram})
      : super(key: key);

  final double value;
  final int curIdx;
  final Map emotionHistogram;

  @override
  State<SentimentEmotion> createState() => _SentimentEmotionState();
}

class _SentimentEmotionState extends State<SentimentEmotion> {
  @override
  Widget build(BuildContext context) {
    Map<String, Color> colorMap = {
      "0": Color(0xff4FB600),
      "1": Color(0xffFFB600),
      "2": Color(0xffEC5313)
    };

    if (widget.curIdx == -1) {
      return Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text("Click chart and view more details", style: TextStyle())
          ]));
    }

    List curList = sentimentMap[widget.curIdx.toString()]!;
    Color curColor = colorMap[widget.curIdx.toString()]!;

    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
            children: curList.map((emotion) {
          return EmotionRow(
              value: widget.value,
              emotion: emotion,
              color: curColor,
              num: widget.emotionHistogram[emotion]);
        }).toList()));
  }
}

class EmotionRow extends StatefulWidget {
  const EmotionRow(
      {Key? key,
      required this.emotion,
      required this.color,
      required this.num,
      required this.value})
      : super(key: key);

  final String emotion;
  final Color color;
  final int num;
  final double value;

  @override
  State<EmotionRow> createState() => _EmotionRowState();
}

class _EmotionRowState extends State<EmotionRow> {
  @override
  Widget build(BuildContext context) {
    String curEmotion = "assets/images/${widget.emotion}-1.png";
    double curValue = widget.value;
    double maxWidth = 400 * (widget.num / 31);
    double imageHeight = min(curValue * 100, 30);
    double width = curValue < 0.3 ? 0 : maxWidth * (curValue - 0.3);

    return Container(
        padding: EdgeInsets.only(
          bottom: 10,
          top: 10,
        ),
        child: Row(children: [
          Container(
              width: 30,
              height: 30,
              child: Stack(children: [
                Transform.translate(
                    offset: Offset(0, imageHeight - 30),
                    child: Opacity(
                      opacity: min(curValue * 10 / 3, 1),
                      child: Image.asset(
                        width: 30,
                        height: 30,
                        curEmotion,
                      ),
                    )),
                Transform.translate(
                    offset: Offset(0, imageHeight - 30),
                    child: Opacity(
                      opacity: max(0, 1 - (curValue * 10 / 3)),
                      child: Image.asset(
                        width: 30,
                        height: 30,
                        "assets/images/mean.png",
                      ),
                    )),
              ])),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.emotion,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    color: widget.color,
                    width: width,
                    height: 20,
                  ),
                  SizedBox(width: widget.num == 0 ? 0 : 10),
                  Text(widget.num.toString(),
                      style: TextStyle(color: widget.color, fontSize: 18))
                ],
              )
            ],
          )
        ]));
  }
}

class _CircularData {
  _CircularData(this.emotion, this.data, this.pointColor);

  final String emotion;
  final int data;
  final Color pointColor;
}
