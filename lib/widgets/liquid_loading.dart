import 'dart:async';
import 'package:flutter/material.dart';

class LiquidLoading extends StatefulWidget {
  final double progress; // expects 0 to 1

  const LiquidLoading({Key? key, this.progress = 0.5}) : super(key: key);

  @override
  _LiquidLoadingState createState() => _LiquidLoadingState();
}

class _LiquidLoadingState extends State<LiquidLoading> with TickerProviderStateMixin {
  late AnimationController firstController;
  late Animation<double> firstAnimation;

  late AnimationController secondController;
  late Animation<double> secondAnimation;

  late AnimationController thirdController;
  late Animation<double> thirdAnimation;

  late AnimationController fourthController;
  late Animation<double> fourthAnimation;

  @override
  void initState() {
    super.initState();

    firstController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    firstAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
      CurvedAnimation(parent: firstController, curve: Curves.easeInOut),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    secondAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
      CurvedAnimation(parent: secondController, curve: Curves.easeInOut),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });

    thirdController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    thirdAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
      CurvedAnimation(parent: thirdController, curve: Curves.easeInOut),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });

    fourthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    fourthAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
      CurvedAnimation(parent: fourthController, curve: Curves.easeInOut),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });

    Timer(Duration(seconds: 2), () {
      firstController.forward();
    });

    Timer(Duration(milliseconds: 1600), () {
      secondController.forward();
    });

    Timer(Duration(milliseconds: 800), () {
      thirdController.forward();
    });

    fourthController.forward();
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CustomPaint(
      painter: MyPainter(
        firstAnimation.value,
        secondAnimation.value,
        thirdAnimation.value,
        fourthAnimation.value,
        widget.progress.clamp(0.0, 1.0),
      ),
      child: SizedBox(
        height: size.height * 0.4,
        width: size.width,
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;
  final double progress;

  MyPainter(
      this.firstValue,
      this.secondValue,
      this.thirdValue,
      this.fourthValue,
      this.progress,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final baseWaterLevel = size.height * (1 - progress);

    // wave amplitude (max vertical displacement of wave)
    final waveHeight = size.height * 0.2;

    double normalize(double value) => value - 2;

    final firstY = baseWaterLevel + waveHeight * normalize(firstValue);
    final secondY = baseWaterLevel + waveHeight * normalize(secondValue);
    final thirdY = baseWaterLevel + waveHeight * normalize(thirdValue);
    final fourthY = baseWaterLevel + waveHeight * normalize(fourthValue);

    var paint = Paint()
      ..color = Color(0xff32CD32)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, firstY)
      ..cubicTo(
        size.width * .4,
        secondY,
        size.width * .7,
        thirdY,
        size.width,
        fourthY,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
