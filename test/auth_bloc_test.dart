import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:chatgpt/business_layer/common/auth_bloc.dart';
import 'package:chatgpt/business_layer/pre_auth/auth/auth_screen_bloc.dart';
import 'package:chatgpt/business_layer/pre_auth/otp/otp_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'repository/auth_repository_dummy.dart';

void main() async {
  final file = File('${Directory.current.path}/test/json_data/test_data.json');
  final json = jsonDecode(await file.readAsString());
  final authRepositoryDummy = AuthRepositoryDummy(
    (json as Map<String, dynamic>)['userData'] as Map<String, dynamic>,
  );
  final user = await authRepositoryDummy.loginWithGoogle();
  group('Auth Flow Test', () {
    late AuthBloc authBloc;
    late AuthScreenBloc authScreenBloc;
    late OTPBloc otpBloc;

    setUp(() {
      authBloc = AuthBloc(authRepositoryDummy);
      authScreenBloc = AuthScreenBloc(authRepositoryDummy);
      otpBloc = OTPBloc(authRepositoryDummy);
    });

    test('Initial Auth Fow States Test', () {
      expect(
        authBloc.state,
        equals(const AuthStateLoading()),
        reason: 'Initial AuthBloc state should be AuthStateLoading',
      );

      expect(
        authScreenBloc.state,
        equals(const AuthScreenStateLoggedOut()),
        reason: 'Initial AuthScreenBloc state should be '
            'AuthScreenStateLoggedOut',
      );

      expect(
        authScreenBloc.state.isLogin,
        equals(true),
        reason: 'Initial AuthScreenBloc should be in login mode',
      );

      expect(
        otpBloc.state,
        equals(const OTPStateInitial()),
        reason: 'Initial OTPBloc state should be OTPStateInitial',
      );
    });

    blocTest<AuthScreenBloc, AuthScreenState>(
      'AuthScreenBloc should be in signup mode on method toggle',
      build: () => authScreenBloc,
      act: (bloc) => bloc.add(const AuthScreenEventToggleLoginSignUp()),
      expect: () => [const AuthScreenStateLoggedOut(isLogin: false)],
    );

    blocTest<AuthScreenBloc, AuthScreenState>(
      'AuthScreenBloc should be logged in on AuthScreenEventSocialLogin',
      build: () => authScreenBloc,
      act: (bloc) => bloc.add(
        AuthScreenEventSocialLogin(
          authType: AuthType.google,
          callback: (AuthScreenState state) {},
        ),
      ),
      expect: () => [
        const AuthScreenStateLoggedOut(isLoading: true),
        AuthScreenStateLoggedIn(user: user, isLogin: true),
      ],
    );

    blocTest<OTPBloc, OTPState>(
      'OTPBloc should generate OTP and emit OTPStateVerify state',
      build: () => otpBloc,
      act: (bloc) => bloc.add(OTPEventInitialise(user: user)),
      expect: () => [
        const OTPStateInitial(),
        OTPStateVerify(user: user, sentOTP: 99999),
      ],
    );

    blocTest<OTPBloc, OTPState>(
      'OTPBloc should verify valid OTP',
      build: () => otpBloc..add(OTPEventInitialise(user: user)),
      act: (bloc) => bloc.add(
        OTPEventVerify(
          otp: 99999,
          callback: ({required bool isSuccess}) {},
        ),
      ),
      expect: () => [
        const OTPStateInitial(),
        OTPStateVerify(user: user, sentOTP: 99999),
        OTPStateVerify(user: user, sentOTP: 99999, isLoading: true),
        OTPStateVerify(user: user, sentOTP: 99999),
      ],
    );

    blocTest<OTPBloc, OTPState>(
      'OTPBloc should throw error on invalid OTP',
      build: () => otpBloc..add(OTPEventInitialise(user: user)),
      act: (bloc) => bloc.add(
        OTPEventVerify(
          otp: 9999,
          callback: ({required bool isSuccess}) {},
        ),
      ),
      expect: () => [
        const OTPStateInitial(),
        OTPStateVerify(user: user, sentOTP: 99999),
        OTPStateVerify(user: user, sentOTP: 99999, isLoading: true),
        OTPStateVerify(
          user: user,
          sentOTP: 99999,
          error: 'Invalid OTP!',
          isInvalid: true,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'AuthBloc should login on AuthEventUserLoggedIn',
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthEventUserLoggedIn(user: user)),
      expect: () => [AuthStateLoggedIn(user: user)],
    );
  });
}
