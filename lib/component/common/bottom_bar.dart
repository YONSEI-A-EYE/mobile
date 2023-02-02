import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      shape: CircularNotchedRectangle(),
      // ← carves notch for FAB in BottomAppBar
      color: Colors.white,
      notchMargin: 15,
      child: SizedBox(
        width: double.infinity,
        height: 81,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(50, 50, 50, 0.1),
                Color.fromRGBO(50, 50, 50, 0.3)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 1,
                ),
                BottomAppBar(
                  clipBehavior: Clip.antiAlias,
                  shape: const CircularNotchedRectangle(),
                  color: Colors.white,
                  elevation: 0,
                  notchMargin: 15,
                  child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {},
                                    icon: Image.asset(
                                      width: 45,
                                      "assets/images/babyFace@2.png",
                                    )),
                                Text("Baby Monitor")
                              ],
                            ),
                            SizedBox(width: 80),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {},
                                    icon: Image.asset(
                                        width: 50, "assets/images/diary.png")),
                                Text("Diary")
                              ],
                            )
                          ])),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}