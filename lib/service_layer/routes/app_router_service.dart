import 'package:chatgpt/presentation_layer/post_auth/home/chat_screen.dart';
import 'package:chatgpt/presentation_layer/pre_auth/auth_screen.dart';
import 'package:chatgpt/presentation_layer/pre_auth/otp_verfication_screen.dart';
import 'package:chatgpt/presentation_layer/splash_screen.dart';
import 'package:chatgpt/service_layer/routes/app_router_service_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///[IAppRouterService] implementation to manage app routes
class AppRoutersService implements IAppRouterService {
  @override
  BuildContext get context =>
      router.routeInformationParser.configuration.navigatorKey.currentContext!;

  @override
  final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: SplashScreen.route.path,
    routes: [
      GoRoute(
        path: SplashScreen.route.path,
        name: SplashScreen.route.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SplashScreen(),
          );
        },
      ),
      GoRoute(
        path: AuthScreen.route.path,
        name: AuthScreen.route.name,
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const AuthScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          );
        },
      ),
      GoRoute(
        path: OTPVerificationScreen.route.path,
        name: OTPVerificationScreen.route.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: OTPVerificationScreen(),
          );
        },
      ),
      GoRoute(
        path: ChatScreen.route.path,
        name: ChatScreen.route.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ChatScreen(),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(
        child: Center(
          child: Text(
            'Page not found',
          ),
        ),
      );
    },
  );
}
