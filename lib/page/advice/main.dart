import "package:aeye/component/common/app_bar.dart";
import "package:aeye/component/common/bottom_bar.dart";
import "package:aeye/component/common/loading_proto.dart";
import "package:aeye/controller/childController.dart";
import "package:aeye/controller/sizeController.dart";
import 'package:aeye/page/advice/add_info.dart';
import "package:aeye/page/advice/temperament_explain.dart";
import "package:aeye/page/advice/tipDetail.dart";
import "package:aeye/utils/interface/child.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class AdviceMain extends StatefulWidget {
  const AdviceMain({Key? key}) : super(key: key);

  @override
  State<AdviceMain> createState() => _AdviceMainState();
}

class _AdviceMainState extends State<AdviceMain> {
  ChildController childController = Get.find();

  int curViewInd = 0;
  void setViewToRight() {
    setState(() {
      curViewInd += 1;
    });
  }

  void setViewToLeft() {
    setState(() {
      curViewInd -= 1;
    });
  }

  List<Child>? curChildList = null;
  void setChildList(List<Child> newList) {
    setState(() {
      curChildList = newList;
    });
  }

  _asyncMethod() async {
    List<Child> response = await adviceServices.getChildren();
    setChildList(response);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (curChildList == null) {
      return Loading(
          isLoading: true, height: MediaQuery.of(context).size.height);
    }

    List<String> curTips = [
      "During conflict",
      "Changing environment",
      "Crying baby"
    ];

    Child curView = curChildList![curViewInd];
    String curTemp = curView.temperament;

    return Scaffold(
      appBar: Header(null, "advice"),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Column(children: [
            Container(
                child: Column(children: [
              ViewTemperament(
                  childList: curChildList!,
                  curViewInd: curViewInd,
                  curView: curView,
                  setViewToLeft: setViewToLeft,
                  setViewToRight: setViewToRight)
            ])),
            SizedBox(height: 30),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Text("Parenting tips",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 20),
                  Column(
                      children: curTips.map((tip) {
                    return TipsNavigator(
                        tip,
                        TipDetail(
                            temperament: curTemp,
                            title: tip,
                            name: curView.name),
                        context);
                  }).toList())
                ])),
          ])),
      bottomNavigationBar: BottomNavBar(state: true, curPath: "advice"),
    );
  }
}

class ViewTemperament extends StatefulWidget {
  const ViewTemperament(
      {Key? key,
      required this.childList,
      required this.curViewInd,
      required this.curView,
      required this.setViewToLeft,
      required this.setViewToRight})
      : super(key: key);

  final List<Child> childList;
  final int curViewInd;
  final Child curView;
  final void Function() setViewToLeft;
  final void Function() setViewToRight;

  @override
  State<ViewTemperament> createState() => _ViewTemperamentState();
}

class _ViewTemperamentState extends State<ViewTemperament> {
  @override
  Widget build(BuildContext context) {
    double distance = MediaQuery.of(context).size.width - 60;
    double height = scaleHeight(context, 200);
    return Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color(0xffFFF7DF),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 18.0,
                spreadRadius: 0.0,
                offset: Offset(0, 6))
          ],
        ),
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            width: double.infinity,
            height: height,
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: -1 * distance * widget.curViewInd,
            child: SizedBox(
                child: Row(
                    children: widget.childList.map((child) {
              return Slide(child, distance, height);
            }).toList())),
          ),
          Positioned(
              top: height / 2 - 15,
              left: 5,
              child: IconButton(
                  splashRadius: 0.1,
                  padding: EdgeInsets.zero, // 패딩 설정
                  constraints: BoxConstraints(),
                  onPressed: () {
                    if (widget.curViewInd == 0) {
                      return;
                    }
                    widget.setViewToLeft();
                  },
                  icon: widget.curViewInd == 0
                      ? SizedBox(width: 0)
                      : Icon(size: 30, Icons.keyboard_arrow_left))),
          Positioned(
              top: height / 2 - 15,
              right: 5,
              child: IconButton(
                  splashRadius: 0.1,
                  padding: EdgeInsets.zero, // 패딩 설정
                  constraints: BoxConstraints(),
                  onPressed: () {
                    if (widget.curViewInd + 1 == widget.childList.length) {
                      return;
                    }
                    widget.setViewToRight();
                  },
                  icon: widget.curViewInd + 1 == widget.childList.length
                      ? SizedBox(width: 0)
                      : Icon(size: 30, Icons.keyboard_arrow_right)))
        ]));
  }
}

Container Slide(Child child, double width, double height) {
  String imageLink = "";
  switch (child.temperament) {
    case ("Easy"):
      imageLink = "assets/images/dog.png";
      break;
    case ("Difficult"):
      imageLink = "assets/images/cat.png";
      break;
    case ("Slow to warm up"):
      imageLink = "assets/images/turtle.png";
      break;
    default:
      break;
  }

  return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(left: 50, right: 30, top: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          PopUpMenuButtonWrapper()
          // TextButton(
          //     onPressed: () {
          //       Get.to(() => ReviseInfo(id: child.id));
          //     },
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: [
          //         Text("Change child's", style: TextStyle(color: Colors.grey)),
          //         Text("temperament", style: TextStyle(color: Colors.grey))
          //       ],
          //     ))
        ])),
        Text(child.name,
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.w800)),
        SizedBox(height: 20),
        TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              Get.to(() => TemperamentExplain(temperament: child.temperament));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(child: Image.asset(width: 60, imageLink)),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(child.temperament,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffFF717F))),
                        SizedBox(height: 15),
                        Text("temperament",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffFF717F)))
                      ]),
                ),
              ],
            ))
      ]));
}

Container TipsNavigator(String title, Widget navigate, BuildContext context) {
  String imageLink = "";
  switch (title) {
    case ("Changing environment"):
      imageLink = "assets/images/school.png";
      break;
    case ("During conflict"):
      imageLink = "assets/images/fisted.png";
      break;
    case ("Crying baby"):
      imageLink = "assets/images/babyCrying.png";
      break;
    default:
      break;
  }

  return Container(
    padding: EdgeInsets.only(bottom: 20),
    child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 5),
                blurRadius: 20,
                spreadRadius: -19)
          ],
        ),
        child: TextButton(
            style: TextButton.styleFrom(
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.topLeft),
            onPressed: () {
              Get.to(() => navigate);
            },
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(imageLink),
                  SizedBox(width: 10),
                  Text(title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ))),
  );
}

enum SampleItem { itemOne, itemTwo, itemThree }

class PopUpMenuButtonWrapper extends StatefulWidget {
  const PopUpMenuButtonWrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<PopUpMenuButtonWrapper> createState() => _PopUpMenuButtonWrapperState();
}

class _PopUpMenuButtonWrapperState extends State<PopUpMenuButtonWrapper> {
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 30,
      child: PopupMenuButton<SampleItem>(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        initialValue: selectedMenu,
        // Callback that sets the selected popup menu item.
        onSelected: (SampleItem item) async {
          if (item == SampleItem.itemOne) {
          } else {}
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: SampleItem.itemOne,
            child: Text("edit"),
          ),
          PopupMenuItem(
            value: SampleItem.itemTwo,
            child: Text("daily report"),
          ),
        ],
      ),
    );
  }
}
