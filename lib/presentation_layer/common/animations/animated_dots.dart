import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Animated dots
class AnimatedDotsLoader extends StatefulWidget {
  ///[AnimatedDotsLoader] constructo
  const AnimatedDotsLoader({
    super.key,
  });

  @override
  State<AnimatedDotsLoader> createState() => _TypeWriterText();
}

class _TypeWriterText extends State<AnimatedDotsLoader>
    with TickerProviderStateMixin {
  late Animation<double> _tween;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    setState(() {
      _animationController = AnimationController(
        duration: const Duration(
          milliseconds: 500,
        ),
        vsync: this,
      );
      _tween = Tween<double>(
        begin: 0.25,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeIn,
        ),
      );
    });
    await _animationController.repeat(reverse: true);
    await _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tween,
      builder: (BuildContext context, Widget? child) {
        final icon = Icon(
          Icons.square_rounded,
          size: 8.r,
        );
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _tween.value,
              child: icon,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: 1 - _tween.value,
              child: icon,
            ),
            SizedBox(width: 10.w),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
