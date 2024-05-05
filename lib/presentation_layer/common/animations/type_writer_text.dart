import 'dart:math';

import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/material.dart';

///Animate text wit type writer animation
class TypeWriterText extends StatefulWidget {
  ///[TypeWriterText] constructor which takes in text to animate.
  const TypeWriterText({
    required this.text,
    this.cursor,
    this.style,
    this.onAnimate,
    super.key,
  });

  ///Text to animate
  final String text;

  ///[TextStyle] for rendered [text]
  final TextStyle? style;

  ///Trailing cursor fo typing animation
  final Widget? cursor;

  ///Listener for animation controller
  final VoidCallback? onAnimate;

  @override
  State<TypeWriterText> createState() => _TypeWriterText();
}

class _TypeWriterText extends State<TypeWriterText>
    with TickerProviderStateMixin {
  late Animation<int> _characterCount;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _start(end: min(widget.text.length, 1000));
  }

  Future<void> _start({
    required int end,
    int start = 0,
    Duration? duration,
  }) async {
    setState(() {
      _animationController = AnimationController(
        duration: duration ??
            Duration(
              milliseconds: end,
            ),
        vsync: this,
      );
      _characterCount = StepTween(
        begin: start,
        end: end,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeIn,
        ),
      );
    });
    if (widget.onAnimate != null) {
      _animationController.addListener(_onAnimate);
    }
    await _animationController.forward();
  }

  void _onAnimate() {
    widget.onAnimate?.call();
    if (_animationController.isCompleted) {
      _animationController.removeListener(_onAnimate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterCount,
      builder: (BuildContext context, Widget? child) {
        final text = widget.text.substring(0, _characterCount.value);
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: text,
                style: widget.style,
              ),
              if (_characterCount.isCompleted &&
                  _characterCount.value < widget.text.length)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    onTap: () {
                      _start(
                        start: _characterCount.value,
                        end: widget.text.length,
                        duration: Duration(
                          milliseconds: min(
                            (widget.text.length - _characterCount.value) * 10,
                            25000,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      ' Read more...',
                      style: (widget.style ?? const TextStyle()).copyWith(
                        color: themeService.state.primaryLinkColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              if (widget.cursor != null && !_characterCount.isCompleted)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: _characterCount.value % 3 == 0 ? 0 : 1,
                    child: widget.cursor,
                  ),
                ),
            ],
          ),
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
