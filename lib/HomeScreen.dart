import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 2.0,
      duration: Duration(seconds: 5),
      animationBehavior: AnimationBehavior.normal,
    )..forward();

    animationController.addListener(() async {
      if (animationController.status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 600));
      } else if (animationController.value == .5) {
        await Future.delayed(Duration(microseconds: 600));
        animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, snapshot) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Transform.rotate(
                    angle: animationController.value * pi,
                    child: CustomPaint(
                      painter: Flower(
                        color0: Colors.white,
                      ),
                      size: Size(animationController.value*100,animationController.value*100),
                    ),
                  ),
                ]);
          },
        ),
      ),
    );
  }
}

class Flower extends CustomPainter {
  final Color color0;
  final Color color1;
  final Color color2;
  final bool isRadial;
  Flower({this.color0, this.color1, this.color2, this.isRadial});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.height / 2;
    final paint = Paint()
      ..style = color0 != null ? PaintingStyle.stroke : PaintingStyle.fill
      ..color = Colors.white
      ..strokeWidth = 1
      ..shader = color1 != null
          ? isRadial
              ? ui.Gradient.linear(Offset(0, 50), Offset(50, 100),
                  [color1.withOpacity(0.5), color2.withOpacity(0.5)])
              : ui.Gradient.radial(
                  Offset(size.height / 2, size.width / 2),
                  size.width / 2,
                  [color1.withOpacity(0.5), color2.withOpacity(0.5)])
          : null;

    for (int i = 0; i < 6; i++) {
      final xPoint = center + cos(degreeToRadian(60.0 * i)) * center;
      final yPoint = center + sin(degreeToRadian(60.0 * i)) * center;
      canvas.drawCircle(Offset(xPoint,yPoint),size.width/2,paint);
    }
  }

  double degreeToRadian(double degree) {
    return degree * (pi / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
