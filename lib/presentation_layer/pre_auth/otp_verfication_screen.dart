import 'package:chatgpt/business_layer/common/auth_bloc.dart';
import 'package:chatgpt/business_layer/pre_auth/otp/otp_bloc.dart';
import 'package:chatgpt/data_layer/models/route_details.dart';
import 'package:chatgpt/data_layer/models/user_auth/user_auth_model_google.dart';
import 'package:chatgpt/presentation_layer/common/base_streamable_view.dart';
import 'package:chatgpt/presentation_layer/common/base_theme_view.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_screen.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Screen for user to enter OTP and verify account
class OTPVerificationScreen extends StatelessWidget {
  ///Default constructor for [OTPVerificationScreen]
  const OTPVerificationScreen({super.key});

  ///[RouteDetails]  for [OTPVerificationScreen]
  static final RouteDetails route =
      RouteDetails('otpVerificationScreen', '/otpVerificationScreen');

  @override
  Widget build(BuildContext context) {
    return BaseThemeView(
      builder: (context, themeState) {
        final hasUserWithEmail = authService.state is AuthStateLoggedIn &&
            (authService.state as AuthStateLoggedIn).user
                is UserAuthModelGoogle;
        return Scaffold(
          backgroundColor: themeState.primaryBackgroundColor,
          appBar: _appBar(),
          body: Center(
            child: hasUserWithEmail
                ? _otpStreamableWidget()
                : Center(
                    child: Text(
                      'User must be logged in to send OTP',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: themeService.state.errorColor,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  AppBar _appBar() {
    final themeState = themeService.state;
    return AppBar(
      backgroundColor: themeState.primaryBackgroundColor,
      title: Text(
        'Email Verification',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: themeState.primaryTextColor,
          fontSize: 18.sp,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _otpStreamableWidget() {
    final user =
        (authService.state as AuthStateLoggedIn).user as UserAuthModelGoogle;
    return BaseStreamableView<OTPBloc, OTPState>(
      bloc: serviceLocator.get<OTPBloc>()..add(OTPEventInitialise(user: user)),
      builder: (context, blocState) {
        return blocState is OTPStateInitial
            ? _loaderAndStatus(blocState, 'Sending email with OTP....')
            : _verifyState(blocState as OTPStateVerify);
      },
    );
  }

  Widget _loaderAndStatus(OTPState state, String loadingText) {
    final themeState = themeService.state;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state.isLoading) ...[
          const CircularProgressIndicator(),
          SizedBox(height: 20.h),
        ],
        Text(
          state.isLoading ? loadingText : state.error,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: state.error.isNotEmpty
                ? themeState.errorColor
                : themeState.primaryTextColor,
            fontSize: 16.sp,
          ),
        ),
        if (state is OTPStateInitial && state.error.isNotEmpty) ...[
          _resendOTPTextButton(),
        ],
      ],
    );
  }

  Widget _resendOTPTextButton() {
    final themeState = themeService.state;
    final user =
        (authService.state as AuthStateLoggedIn).user as UserAuthModelGoogle;
    return TextButton(
      onPressed: () =>
          serviceLocator.get<OTPBloc>().add(OTPEventInitialise(user: user)),
      child: Text(
        'Resend OTP',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: themeState.primaryLinkColor,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _verifyState(OTPStateVerify state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _instructions(state),
        SizedBox(height: 20.h),
        _otpField(state),
        SizedBox(height: 20.h),
        if (state.isLoading)
          _loaderAndStatus(state, 'Verifying OTP....')
        else
          _resendOTPTextButton(),
      ],
    );
  }

  Widget _instructions(
    OTPStateVerify state,
  ) {
    final themeState = themeService.state;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Enter the 5 digit code sent to your email\n',
          ),
          TextSpan(
            text: state.user.email,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: themeState.primaryLinkColor,
            ),
          ),
        ],
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: themeState.primaryTextColor,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _otpField(
    OTPStateVerify state,
  ) {
    final themeState = themeService.state;
    return Flexible(
      child: OtpTextField(
        numberOfFields: 5,
        fieldHeight: 60.h,
        fieldWidth: 50.w,
        borderColor: themeState.activeOTPBoxColor,
        enabledBorderColor: state.isInvalid
            ? themeState.errorColor
            : themeState.primaryBorderColor,
        focusedBorderColor: themeState.activeOTPBoxColor,
        showFieldAsBox: true,
        textStyle: TextStyle(
          fontWeight: FontWeight.w900,
          color: themeState.primaryTextColor,
          fontSize: 20.sp,
        ),
        readOnly: state.isLoading,
        onSubmit: (pin) {
          serviceLocator.get<OTPBloc>().add(
                OTPEventVerify(
                  callback: ({required bool isSuccess}) =>
                      _otpSubmittedCallback(
                    state,
                    isSuccess,
                  ),
                  otp: int.tryParse(pin) ?? 0,
                ),
              );
        },
      ),
    );
  }

  void _otpSubmittedCallback(OTPStateVerify state, bool isSuccess) {
    if (isSuccess) {
      final authState = authService.state as AuthStateLoggedIn;
      final user = authState.user as UserAuthModelGoogle;
      authService.add(
        AuthEventUserLoggedIn(user: user.copyWith(isEmailVerified: isSuccess)),
      );
      navigationService.goToRoute(ChatScreen.route);
    } else {
      navigationService.showSnackBar(
        state.error.isNotEmpty
            ? state.error
            : 'Could not verify OTP. Try again!',
      );
    }
  }
}
