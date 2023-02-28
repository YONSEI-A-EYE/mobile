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
  "content",
  "goodSurprised",
  "anticipated"
];

List<String> NegativeList = [
  "tense",
  "angry",
  "sad",
  "relaxed",
  "bored",
  "tired",
  "badSurprised",
];

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

    String bestEmotion = monthlyEmotion["emotion"];
    String monthlyComment = monthlyEmotion["comment"];

    Color monthlyColor = PositiveList.contains(bestEmotion)
        ? Color(0xff4FB600)
        : Color(0xffEC5313);

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xffFFF7DF),
            elevation: 0.0,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  color: Colors.black)
            ]),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 100),
                color: Color(0xffFFF7DF),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Column(children: [
                        Text("${mon} ${year}",
                            style: TextStyle(fontSize: 20, color: Colors.grey)),
                        SizedBox(height: 10),
                        Text("Monthly Report", style: TextStyle(fontSize: 30)),
                        SizedBox(height: 20)
                      ])),
                      Container(
                          width: 360,
                          padding: EdgeInsets.only(
                              left: 0, right: 0, top: 30, bottom: 30),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 40),
                                    Text("Sentiment Level",
                                        style: TextStyle(fontSize: 23)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                      Container(
                                        width: 230,
                                        height: 230,
                                        child: CircularChart(curData: [
                                          _CircularData(
                                              "positive",
                                              sentimentalLevel["positive"],
                                              Color(0xff4FB600)),
                                          _CircularData(
                                              "neutral",
                                              sentimentalLevel["neutral"],
                                              Color(0xffFFB600)),
                                          _CircularData(
                                              "negative",
                                              sentimentalLevel["negative"],
                                              Color(0xffEC5313))
                                        ]),
                                      ),
                                      ChartLegend(curData: [
                                        _CircularData(
                                            "positive",
                                            sentimentalLevel["positive"],
                                            Color(0xff4FB600)),
                                        _CircularData(
                                            "neutral",
                                            sentimentalLevel["neutral"],
                                            Color(0xffFFB600)),
                                        _CircularData(
                                            "negative",
                                            sentimentalLevel["negative"],
                                            Color(0xffEC5313))
                                      ])
                                    ])),
                                EmotionStatic(
                                    emotionHistogram: emotionHistogram,
                                    bestEmotion: bestEmotion),
                                SizedBox(height: 20),
                                Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("In this month,",
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w400)),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text("You felt ",
                                                  style: TextStyle(
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              Text("${bestEmotion}",
                                                  style: TextStyle(
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: monthlyColor)),
                                              Text(" most frequently",
                                                  style: TextStyle(
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          )
                                        ])),
                                SizedBox(height: 30),
                                Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text("${monthlyComment}",
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w400)))
                              ]))
                    ]))));
  }
}

class CircularChart extends StatefulWidget {
  const CircularChart({Key? key, required this.curData}) : super(key: key);

  final List<_CircularData> curData;

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(series: <DoughnutSeries<_CircularData, String>>[
      DoughnutSeries<_CircularData, String>(
        radius: "65%",
        innerRadius: "75%",
        dataSource: widget.curData,
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
                  width: 15,
                  child: Text(data.data.toString(),
                      style: TextStyle(color: data.pointColor)));
            }),
        dataLabelMapper: (_CircularData data, _) => data.data.toString(),
        pointColorMapper: (data, _) => data.pointColor,
        startAngle: -40,
        endAngle: 320,
      )
    ]);
  }
}

class ChartLegend extends StatelessWidget {
  const ChartLegend({Key? key, required this.curData}) : super(key: key);

  final List<_CircularData> curData;

  @override
  Widget build(BuildContext context) {
    int total = curData.fold(0, (vTotal, element) {
      return vTotal + element.data;
    });

    return Container(
        padding: EdgeInsets.only(right: 20),
        child: Column(
            children: curData.map<SizedBox>((element) {
          int curRate = (element.data / total * 100).floor();
          return LegendContent(element.emotion, curRate, element.pointColor);
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

class EmotionStatic extends StatefulWidget {
  const EmotionStatic(
      {Key? key, required this.emotionHistogram, required this.bestEmotion})
      : super(
          key: key,
        );

  final Map emotionHistogram;
  final String bestEmotion;

  @override
  State<EmotionStatic> createState() => _EmotionStaticState();
}

class _EmotionStaticState extends State<EmotionStatic> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StaticRow(0, 2, widget.emotionHistogram, widget.bestEmotion),
              SizedBox(height: 10),
              StaticRow(3, 6, widget.emotionHistogram, widget.bestEmotion),
              SizedBox(height: 10),
              StaticRow(7, 10, widget.emotionHistogram, widget.bestEmotion),
              SizedBox(height: 10),
              StaticRow(11, 12, widget.emotionHistogram, widget.bestEmotion)
            ]));
  }
}

SizedBox StaticRow(
    int startInd, int endInd, Map emotionHistogram, String bestEmotion) {
  return SizedBox(
    width: double.infinity,
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: emotionList.sublist(startInd, endInd + 1).map((emotion) {
          bool state = false;
          if (emotion == bestEmotion) {
            state = true;
          }
          return EmotionEach(
              emotion: emotion,
              frequency: emotionHistogram[emotion],
              state: state);
        }).toList()),
  );
}

class EmotionEach extends StatefulWidget {
  const EmotionEach(
      {Key? key,
      required this.emotion,
      required this.frequency,
      required this.state})
      : super(key: key);

  final String emotion;
  final int? frequency;
  final bool state;

  @override
  State<EmotionEach> createState() => _EmotionEachState();
}

class _EmotionEachState extends State<EmotionEach> {
  @override
  Widget build(BuildContext context) {
    String emotionLink = "assets/images/${widget.emotion}-1.png";
    Color fontColor = widget.state ? Colors.black : Colors.grey;

    return Container(
        width: widget.emotion == "badSurprised" ||
                widget.emotion == "goodSurprised"
            ? 120
            : 80,
        height: 60,
        child: Column(children: [
          Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    offset: Offset.zero,
                    blurRadius: 0.8,
                    spreadRadius: 0.0)
              ]),
              child: Text(widget.emotion, style: TextStyle(color: fontColor))),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(emotionLink, width: 30, height: 30),
            SizedBox(width: 20),
            Text(widget.frequency.toString())
          ])
        ]));
  }
}

class _CircularData {
  _CircularData(this.emotion, this.data, this.pointColor);

  final String emotion;
  final int data;
  final Color pointColor;
}

class Histogram extends StatefulWidget {
  const Histogram({Key? key, required this.emotionHistogram}) : super(key: key);

  final Map<String, int> emotionHistogram;

  @override
  State<Histogram> createState() => _HistogramState();
}

class _HistogramState extends State<Histogram> {
  String curClicked = "excited";
  void setCurClicked(String curEmotion) {
    setState(() {
      curClicked = curEmotion;
    });
  }

  @override
  Widget build(BuildContext context) {
    int curIndex = emotionList.indexOf(curClicked);

    return Column(children: [
      SizedBox(
          width: double.infinity,
          child: Transform.translate(
              offset: Offset(curIndex * 20, 0), child: Text(curClicked))),
      SizedBox(child: Row(children: []))
    ]);
  }
}

class HistoStick extends StatefulWidget {
  const HistoStick({Key? key, required this.emotion}) : super(key: key);

  final String emotion;

  @override
  State<HistoStick> createState() => _HistoStickState();
}

class _HistoStickState extends State<HistoStick> {
  @override
  Widget build(BuildContext context) {
    List<String> positiveList = [
      "excited",
      "happy",
      "content",
      "calm",
      "good_surprised",
      "relaxed"
    ];

    Color stickColor = positiveList.contains(widget.emotion)
        ? Color(0xff4FB600)
        : Color(0xffEC5313);

    return SizedBox();
  }
}