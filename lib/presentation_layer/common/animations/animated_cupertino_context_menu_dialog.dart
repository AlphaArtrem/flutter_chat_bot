import 'dart:ui';

import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedCupertinoContextMenuDialog extends StatefulWidget {
  const AnimatedCupertinoContextMenuDialog({
    required this.child,
    this.options = const [],
    super.key,
  });
  final Widget child;
  final List<Widget> options;

  @override
  State<AnimatedCupertinoContextMenuDialog> createState() =>
      _AnimatedCupertinoContextMenuDialogState();
}

class _AnimatedCupertinoContextMenuDialogState
    extends State<AnimatedCupertinoContextMenuDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 50.h,
                  bottom: 20.h,
                ),
                child: Card(
                  elevation: 0,
                  color: themeService.state.primaryBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: SingleChildScrollView(child: widget.child),
                  ),
                ),
              ),
              if (widget.options.isNotEmpty)
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 15.w,
                    ),
                    width: 300.w,
                    child: CupertinoActionSheet(
                      actions: widget.options,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedCupertinoContextMenuOption extends StatelessWidget {
  const AnimatedCupertinoContextMenuOption({
    required this.text,
    required this.icon,
    this.onTap,
    this.border,
    super.key,
  });

  final String text;
  final IconData icon;
  final Border? border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          border: border ??
              Border(
                bottom: BorderSide(
                  color: themeService.state.primaryBorderColor,
                  width: 0.3.sp,
                ),
              ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: themeService.state.primaryTextColor,
                fontSize: 17.sp,
              ),
            ),
            Icon(
              icon,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}
