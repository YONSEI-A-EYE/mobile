import "package:aeye/controller/userController.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";

class ViewCode extends StatefulWidget {
  const ViewCode({Key? key}) : super(key: key);

  @override
  State<ViewCode> createState() => _ViewCodeState();
}

class _ViewCodeState extends State<ViewCode> with TickerProviderStateMixin {
  late final AnimationController _Controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..addListener(() {
      if (mounted) {
        setState(() {});
      }
      ;
    });

  late final Animation<double> _Animation = CurvedAnimation(
    parent: _Controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose(){
    _Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    String code = userController.code.toString();
    double opacity = _Animation.value;
    if (opacity == 1) {
      _Controller.reverse();
    }

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          titleSpacing: 0,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(),
              icon:
                  Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
                return;
              },
            );
          }),
          backgroundColor: Color(0xffFFF2CB),
          elevation: 0.1,
          centerTitle: false,
          title: Container(
            child: Row(
              children: [
                Text("",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xffFFF2CB),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pass This Verification Code",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                Text("To Secondary Caregiver",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(height: 30),
                Container(
                    width: 300,
                    height: 70,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      color: Colors.white,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Opacity(
                            opacity: 0,
                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset("assets/images/file_icon.png"),
                            ),
                          ),
                          Text(code,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                          IconButton(
                            splashColor: Colors.grey,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: code));
                              _Controller.forward();
                            },
                            icon: Image.asset("assets/images/file_icon.png"),
                          )
                        ])),
                SizedBox(height: 60),
                Opacity(
                    opacity: opacity,
                    child: Container(child: Text("Code Saved!")))
              ],
            )));
  }
}
