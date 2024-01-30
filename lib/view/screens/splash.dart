import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_builder_app/control/route_generator.dart';

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
    Key? key,
    this.duration = const Duration(seconds: 5),
    this.timer,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(widget.duration!, () {
      try {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      } catch (e) {
        // Handle the error, e.g., log it or show an error message
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.background,
          Theme.of(context).colorScheme.surface
        ])),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/icon.png",
                width: 120,
                height: 120,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 250.ms)
                  .rotate(duration: 600.ms, begin: 1),
            )
          ],
        ),
      ),
    );
  }
}
