import 'package:chatgpt/business_layer/common/auth_bloc.dart';
import 'package:chatgpt/business_layer/pre_auth/auth/auth_screen_bloc.dart';
import 'package:chatgpt/data_layer/models/route_details.dart';
import 'package:chatgpt/data_layer/static/svg_string_assets.dart';
import 'package:chatgpt/presentation_layer/common/base_streamable_theme_view.dart';
import 'package:chatgpt/presentation_layer/common/splash_screen_logo.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_screen.dart';
import 'package:chatgpt/presentation_layer/pre_auth/otp_verfication_screen.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Home screen of the app
class AuthScreen extends StatelessWidget {
  ///Default constructor for [AuthScreen]
  const AuthScreen({super.key});

  ///[RouteDetails]  for [AuthScreen]
  static final RouteDetails route = RouteDetails('authScreen', '/authScreen');

  @override
  Widget build(BuildContext context) {
    return BaseStreamableThemeView<AuthScreenBloc, AuthScreenState>(
      builder: (context, themeState, blocState) {
        final bloc = context.read<AuthScreenBloc>();
        return Scaffold(
          backgroundColor: themeState.primaryBackgroundColor,
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  SplashScreenLogo(height: 50.h),
                  SizedBox(height: 20.h),
                  _welcomeText(),
                  const Spacer(),
                  _loginButton(bloc),
                  SizedBox(height: 20.h),
                  _loginSignupStatusText(blocState),
                  const Spacer(),
                  _toggleTextButton(bloc),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _welcomeText() {
    return Text(
      'Welcome To ChatGPT',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeService.state.primaryTextColor,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _loginButton(
    AuthScreenBloc bloc,
  ) {
    if (bloc.state.isLoading) {
      return const CircularProgressIndicator();
    } else {
      return MaterialButton(
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: themeService.state.primaryTextColor,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(20.r),
        onPressed: () => bloc.add(
          AuthScreenEventSocialLogin(
            authType: AuthType.google,
            callback: _loginCallback,
          ),
        ),
        child: SvgPicture.string(
          SvgStringAssets.googleLogo,
          height: 50.h,
        ),
      );
    }
  }

  Widget _loginSignupStatusText(AuthScreenState state) {
    return Text(
      !state.isLogin
          ? state.isLoading
              ? 'Creating account ...'
              : 'Sign Up'
          : state.isLoading
              ? 'Logging you in ...'
              : 'Log In',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeService.state.primaryTextColor,
        fontSize: 18.sp,
      ),
    );
  }

  void _loginCallback(AuthScreenState state) {
    if (state is AuthScreenStateLoggedIn) {
      authService.add(AuthEventUserLoggedIn(user: state.user));
      if (!state.user.isEmailVerified) {
        navigationService.pushScreen(
          OTPVerificationScreen.route,
        );
      } else {
        navigationService.pushReplacementScreen(ChatScreen.route);
      }
    } else {
      final loggedOutState = state as AuthScreenStateLoggedOut;
      if (loggedOutState.error.isNotEmpty) {
        navigationService.showSnackBar(state.error);
      }
    }
  }

  Widget _toggleTextButton(
    AuthScreenBloc bloc,
  ) {
    if (bloc.state.isLoading) {
      return const SizedBox.shrink();
    } else {
      return GestureDetector(
        onTap: () => bloc.add(const AuthScreenEventToggleLoginSignUp()),
        child: Text(
          !bloc.state.isLogin
              ? 'Already have an account ? Login'
              : "Don't have an account? SignUp",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.blue,
            fontSize: 18.sp,
          ),
        ),
      );
    }
  }
}
