import 'dart:io';

import 'package:chatgpt/data_layer/models/route_details.dart';
import 'package:chatgpt/service_layer/navigation/navigation_service_interface.dart';
import 'package:chatgpt/service_layer/routes/app_router_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///[INavigationService] implementation for in app navigation
class NavigationService implements INavigationService {
  ///Default constructor for [NavigationService].
  ///Takes [AppRoutersService] as a parameter
  const NavigationService(this.appRoutersService);

  @override
  final AppRoutersService appRoutersService;

  @override
  Future<dynamic> pushScreen(
    RouteDetails route, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? extra,
    bool makeHapticFeedback = true,
  }) {
    if (makeHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    ScaffoldMessenger.of(appRoutersService.context).hideCurrentSnackBar();
    return appRoutersService.router.pushNamed(
      route.name,
      queryParameters: queryParameters ?? <String, dynamic>{},
      pathParameters: pathParameters ?? <String, String>{},
      extra: extra ?? <String, dynamic>{},
    );
  }

  @override
  void pushReplacementScreen(
    RouteDetails route, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? extra,
    bool makeHapticFeedback = true,
  }) {
    if (makeHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    ScaffoldMessenger.of(appRoutersService.context).hideCurrentSnackBar();
    appRoutersService.router.pushReplacementNamed(
      route.name,
      queryParameters: queryParameters ?? <String, dynamic>{},
      pathParameters: pathParameters ?? <String, String>{},
      extra: extra ?? <String, dynamic>{},
    );
  }

  @override
  void popAndPushReplacement(
    RouteDetails route, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? extra,
    bool makeHapticFeedback = true,
  }) {
    appRoutersService.router.pop();
    pushReplacementScreen(
      route,
      queryParameters: queryParameters,
      pathParameters: pathParameters,
      extra: extra,
      makeHapticFeedback: makeHapticFeedback,
    );
  }

  @override
  void goToRoute(
    RouteDetails route, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? extra,
    bool makeHapticFeedback = true,
  }) {
    if (makeHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    ScaffoldMessenger.of(appRoutersService.context).hideCurrentSnackBar();
    appRoutersService.router.goNamed(
      route.name,
      queryParameters: queryParameters ?? <String, dynamic>{},
      pathParameters: pathParameters ?? <String, String>{},
      extra: extra ?? <String, dynamic>{},
    );
  }

  @override
  Future<dynamic> pushDialog(Widget dialog, {bool isDismissible = false}) {
    return Platform.isAndroid
        ? showDialog(
            context: appRoutersService.context,
            barrierDismissible: isDismissible,
            builder: (BuildContext context) {
              return dialog;
            },
          )
        : showCupertinoDialog(
            context: appRoutersService.context,
            barrierDismissible: isDismissible,
            builder: (BuildContext context) {
              return dialog;
            },
          );
  }

  @override
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? snackBarAction,
  }) {
    ScaffoldMessenger.of(appRoutersService.context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: duration,
          content: Text(message),
          action: snackBarAction,
        ),
      );
  }

  @override
  void pop({dynamic sendDataBack, bool useHaptic = true}) {
    appRoutersService.router.pop(sendDataBack);
    ScaffoldMessenger.of(appRoutersService.context).hideCurrentSnackBar();
    if (useHaptic) {
      HapticFeedback.selectionClick();
    }
  }

  @override
  void popAndPushScreen(
    RouteDetails route, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? params,
    Map<String, dynamic>? extra,
    bool makeHapticFeedback = false,
  }) {
    pop();
    pushScreen(
      route,
      queryParameters: queryParams,
      pathParameters: params,
      extra: extra,
      makeHapticFeedback: makeHapticFeedback,
    );
  }
}
