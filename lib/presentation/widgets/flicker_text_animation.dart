import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Yasser/values/values.dart';

class FlickerTextAnimation extends StatefulWidget {
  FlickerTextAnimation({
    Key? key,
    required this.controller,
    this.textColor,
    this.fadeInColor,
    required this.text,
    this.textStyle,
    this.start,
    this.end,
    this.wrapAlignment = WrapAlignment.start,
    this.fontSize = Sizes.TEXT_SIZE_18,
  })  : color = ColorTween(
    begin: textColor,
    end: fadeInColor,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        start ?? 0.0,
        end ?? 1.0,
        curve: Curves.easeIn,
      ),
    ),
  ),
        title = IntTween(
          begin: (Random().nextDouble() * pow(10, text.length)).toInt(),
          end: (Random().nextDouble() * pow(10, text.length)).toInt(),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              start ?? 0.0,
              end ?? 1.0,
              curve: Curves.easeIn,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<Color?> color;
  final Animation<int> title;
  final Color? textColor;
  final Color? fadeInColor;
  final String text;
  final double fontSize;
  final TextStyle? textStyle;

  final double? start;
  final double? end;
  final WrapAlignment wrapAlignment;

  @override
  _FlickerTextAnimationState createState() => _FlickerTextAnimationState();
}

class _FlickerTextAnimationState extends State<FlickerTextAnimation> {
  bool isAnimating = false;
  late VoidCallback _statusListener;

  @override
  void initState() {
    super.initState();

    // إنشاء الـ listener مرة واحدة
    _statusListener = () {
      _handleAnimationStatus(widget.controller.status);
    };

    // إضافة الـ listener
    widget.controller.addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    // التأكد من أن الـ widget لا يزال mounted
    if (!mounted) return;

    bool newAnimatingState = isAnimating;

    if (status == AnimationStatus.forward) {
      newAnimatingState = true;
    } else if (status == AnimationStatus.completed) {
      newAnimatingState = false;
    }

    // تحديث الحالة فقط إذا تغيرت
    if (newAnimatingState != isAnimating) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (mounted) { // تأكد مرة أخرى قبل setState
          setState(() {
            isAnimating = newAnimatingState;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    // إزالة الـ listener قبل dispose
    widget.controller.removeStatusListener(_handleAnimationStatus);
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    ThemeData theme = Theme.of(context);
    return Container(
      child: Wrap(
        alignment: widget.wrapAlignment,
        spacing: 0,
        runSpacing: 0,
        children: [
          Text(
            isAnimating ? widget.title.value.toString() : widget.text,
            style: widget.textStyle ??
                theme.textTheme.titleLarge!.copyWith(
                  color: widget.color.value,
                  fontSize: widget.fontSize,
                ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: widget.controller,
    );
  }
}