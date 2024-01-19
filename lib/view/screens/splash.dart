import 'dart:async';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  Widget? child;
  Color? iconBackgroundColor;
  Text? text;
  Timer? timer;
  Gradient? gradient;
  Color? backgroundColor;
  Duration? duration;
  double? circleHeight;

  SplashScreen({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.timer,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(widget.duration!, () {
      Navigator.of(context).pushNamed(
        '/dashboard',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Theme.of(context).canvasColor,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/icon.png"),
                )
              ],
            )));
  }
}
