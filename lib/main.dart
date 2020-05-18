import 'package:flutter/material.dart';
import 'dart:core';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Loader Indicator"),
      ),
      body: Center(
          child: CircularProgress(
              size: 65,
              color: Colors.green,
              backgroundColor: Color.fromRGBO(255, 255, 255, 0))),
    );
  }
}

class CircularProgress extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Color color;

  CircularProgress(
      {@required this.size,
      this.backgroundColor = Colors.grey,
      this.color = Colors.blue});

  @override
  _CircularProgress createState() => new _CircularProgress();
}

class _CircularProgress extends State<CircularProgress>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    animation = Tween(begin: 0.0, end: 360.0).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new CustomPaint(
          painter: new CircularCanvas(
              progress: animation.value,
              backgroundColor: widget.backgroundColor,
              color: widget.color),
          size: new Size(widget.size, widget.size),
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: controller.value * 6.3,
              child: child,
            );
          },
          child: Image.asset(
            'assets/images/loader_icon.png',
            height: 40.0,
            width: 40.0,
          ),
        ),
      ],
    );
  }
}

class CircularCanvas extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color color;

  CircularCanvas(
      {this.progress,
      this.backgroundColor = Colors.grey,
      this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint
      ..color = backgroundColor
      ..strokeWidth = size.width / 18
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
        new Offset(size.width / 2, size.height / 2), size.width / 2, paint);
    canvas.drawArc(new Offset(0.0, 0.0) & new Size(size.width, size.width),
        -90.0 * 0.0174533, progress * 0.0174533, false, paint..color = color);
  }

  @override
  bool shouldRepaint(CircularCanvas oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
