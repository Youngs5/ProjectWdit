import 'dart:math';
import 'package:wdit/design_course/action_button.dart';
import 'package:wdit/design_course/create_Appointment_screen.dart';
import 'package:wdit/design_course/design_course_app_theme.dart';
import 'package:flutter/material.dart';

const Duration _duration = Duration(milliseconds: 300);

class ExpandableFAB extends StatefulWidget {
  final double? distance;
  final List<Widget>? children;
  const ExpandableFAB(
      {Key? key, @required this.distance, @required this.children})
      : super(key: key);

  @override
  State<ExpandableFAB> createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        value: _open ? 1.0 : 0.0, duration: _duration, vsync: this);
    _expandAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          _ExpandableActionButton(
              distance: widget.distance,
              degree: 90,
              progress: _expandAnimation,
              child: ActionButton(
                icon: Icon(Icons.house),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Appointment(),
                  //   ),
                  // );
                },
              )),
          _buildTabToOpenFAB(),
          _buildTabToCloseFAB(),
        ],
      ),
    );
  }

  AnimatedContainer _buildTabToOpenFAB() {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      duration: _duration,
      transform: Matrix4.rotationZ(_open ? 0 : pi / 4),
      child: AnimatedOpacity(
        duration: _duration,
        opacity: 0.0,
        child: FloatingActionButton(
          onPressed: toggle,
          child: Icon(Icons.house),
        ),
      ),
    );
  }

  AnimatedContainer _buildTabToCloseFAB() {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      duration: _duration,
      transform: Matrix4.rotationZ(_open ? 0 : pi / 4),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: toggle,
        child: Icon(
          Icons.close,
          color: DesignCourseAppTheme.nearlyBlue.withOpacity(0.5),
        ),
      ),
    );
  }

  void toggle() {
    _open = !_open;
    setState(() {
      if (_open)
        _controller.forward();
      else
        _controller.reverse();
    });
  }
}

class _ExpandableActionButton extends StatelessWidget {
  final double? distance;
  final double? degree;
  final Animation<double>? progress;
  final Widget? child;

  const _ExpandableActionButton(
      {Key? key,
      @required this.distance,
      @required this.degree,
      @required this.progress,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress!,
      builder: (BuildContext context, Widget? child) {
        final Offset offset = Offset.fromDirection(
            degree! * (pi / 100), progress!.value * distance!);
        return Positioned(
            right: offset.dx + 4, bottom: offset.dy + 4, child: child!);
      },
      child: child,
    );
  }
}
