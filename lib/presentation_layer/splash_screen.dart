import 'package:chatgpt/business_layer/common/auth_bloc.dart';
import 'package:chatgpt/data_layer/models/route_details.dart';
import 'package:chatgpt/data_layer/static/svg_string_assets.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_screen.dart';
import 'package:chatgpt/presentation_layer/pre_auth/auth_screen.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Initial app screen
class SplashScreen extends StatefulWidget {
  ///[SplashScreen] default constructor
  const SplashScreen({super.key});

  ///[SplashScreen] route
  static final RouteDetails route =
      RouteDetails('splashScreen', '/splashScreen');

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigate({required bool isLoggedIn}) {
    navigationService.pushReplacementScreen(
      isLoggedIn ? ChatScreen.route : AuthScreen.route,
    );
  }

  @override
  void initState() {
    super.initState();
    authService.add(AuthEventCheckLoginStatus(_navigate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeService.state.primaryBackgroundColor,
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Hero(
              tag: SvgStringAssets.chatGPTIcon,
              child: SvgPicture.string(
                SvgStringAssets.chatGPTIcon,
                height: 100.h,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '© 2024 ChatGPT App. All rights reserved',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: themeService.state.primaryTextColor,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
