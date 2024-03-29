import "package:aeye/component/common/app_bar.dart";
import "package:aeye/component/common/bottom_bar.dart";
import "package:aeye/component/common/loading_proto.dart";
import "package:aeye/controller/childController.dart";
import 'package:aeye/controller/localNotificationController.dart';
import "package:aeye/controller/sizeController.dart";
import "package:aeye/page/advice/add_info.dart";
import 'package:aeye/page/advice/main.dart';
import "package:aeye/page/advice/temperament_detail.dart";
import "package:aeye/services/advice.dart";
import "package:aeye/utils/interface/child.dart";
import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:get/get.dart";

AdviceServices adviceServices = AdviceServices();

class MainPre extends StatefulWidget {
  const MainPre({Key? key}) : super(key: key);

  @override
  State<MainPre> createState() => _MainPreState();
}

class _MainPreState extends State<MainPre> {
  ChildController childController = Get.find<ChildController>();
  LocalNotificationController localNotificationController = Get.find();
  FlutterSecureStorage storage = FlutterSecureStorage();

  bool isLoading = false;
  void setIsLoading(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  List<Child>? childList = null;
  void setChildList(List<Child> newList) {
    setState(() {
      childList = newList;
    });
  }

  _asyncMethod() async {
    setIsLoading(true);
    try {
      List<Child> response = await adviceServices.getChildren();
      if (response.isNotEmpty) {
        childController.childList = response.obs;
        setChildList(response);
        Get.back();
        Get.to(AdviceMain());
      }
    } catch (e) {
      print("here");
    } finally {
      setIsLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: Loading(
              isLoading: true,
              height: MediaQuery.of(context).size.height,
            ),
          )
        : Scaffold(
            appBar: Header(curDate: null, curPath: "advice"),
            body: Container(
                height: double.infinity,
                padding: EdgeInsets.only(left: 40, right: 40, top: 50),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("What's your baby's",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Color(0xffFF717F))),
                                SizedBox(height: 10),
                                Text("temperament?",
                                    style: TextStyle(
                                        fontSize: 30, color: Color(0xffFF717F)))
                              ])),
                      SizedBox(height: 80),
                      SizedBox(
                          child: Column(children: [
                        NavigatorButton(
                            scaleWidth(context, 20),
                            scaleWidth(context, 260),
                            "What is temperament?",
                            TemperamentDetail(),
                            Color(0xffE2E2E2)),
                        SizedBox(height: 30),
                        NavigatorButton(
                            scaleWidth(context, 20),
                            scaleWidth(context, 260),
                            "Temperament test",
                            PopUpSelect(),
                            Color(0xffFFF7DF)),
                      ]))
                    ])),
            bottomNavigationBar: BottomNavBar(state: true, curPath: "advice"),
          );
  }
}

SizedBox NavigatorButton(
    double fontSize, double width, String title, Widget nextPage, Color color) {
  return SizedBox(
    width: width,
    height: 70,
    child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40))),
            backgroundColor: color,
            side: BorderSide(
              style: BorderStyle.none,
            )),
        onPressed: () {
          Get.to(() => nextPage);
        },
        child: Text(title,
            style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.w500))),
  );
}

TextButton ButtonToMain() {
  return TextButton(
      onPressed: () {
        Get.to(
          () => TemperamentDetail(),
        );
      },
      child: Text("What is temperament?",
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 20,
              color: Colors.black)));
}
