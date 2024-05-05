import 'package:chatgpt/data_layer/static/svg_string_assets.dart';
import 'package:chatgpt/presentation_layer/common/animations/animated_dots.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    required this.hasValue,
    required this.isFocused,
    required this.textFieldController,
    required this.textFieldFocusNode,
    required this.isLoading,
    super.key,
  });

  ///boolean to know if the text filed has any value
  final bool hasValue;

  ///boolean to know if the text filed in in focus
  final bool isFocused;

  ///boolean to know if data is loading
  final bool isLoading;

  ///[TextEditingController] for the text field
  final TextEditingController textFieldController;

  ///[FocusNode] for the text field
  final FocusNode textFieldFocusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: isLoading,
      focusNode: textFieldFocusNode,
      controller: textFieldController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 7.h,
        ),
        hintText: 'Message',
        suffixIcon: hasValue || isFocused
            ? null
            : isLoading
                ? const AnimatedDotsLoader()
                : SvgPicture.string(
                    SvgStringAssets.soundWaveIcon,
                    colorFilter: ColorFilter.mode(
                      themeService.state.primaryBorderColor,
                      BlendMode.srcIn,
                    ),
                  ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusColor: Colors.transparent,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: themeService.state.primaryBorderColor.withOpacity(0.5),
          ),
        ),
        fillColor: isFocused
            ? Colors.transparent
            : themeService.state.primaryBorderColor.withOpacity(0.25),
        filled: true,
        constraints: hasValue ? null : BoxConstraints(maxHeight: 37.5.h),
      ),
      maxLines: null,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontSize: 15.sp,
      ),
    );
  }
}
