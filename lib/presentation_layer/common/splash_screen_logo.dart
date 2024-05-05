import 'package:chatgpt/data_layer/static/svg_string_assets.dart';
import 'package:chatgpt/presentation_layer/pre_auth/auth_screen.dart';
import 'package:chatgpt/presentation_layer/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Logo to be used on [SplashScreen] with [Hero] animation to [AuthScreen]
class SplashScreenLogo extends StatelessWidget {
  ///[SplashScreenLogo] default constructor takes in parameter [height]
  ///to determine image height
  const SplashScreenLogo({this.height, super.key});

  ///parameter [height] to determine image height
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: SvgStringAssets.chatGPTIcon,
      child: SvgPicture.string(
        SvgStringAssets.chatGPTIcon,
        height: height ?? 100.h,
      ),
    );
  }
}
