import "package:aeye/controller/routeController.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RouteController routeController = Get.find();
    return Scaffold(
      body: SizedBox(
          child: Column(children: [
        Container(),
        SizedBox(),
        SizedBox(
            child: Row(children: [
          OutlinedButton(onPressed: () {}, child: SizedBox()),
          OutlinedButton(onPressed: () {}, child: SizedBox())
        ]))
      ])),
    );
  }
}
