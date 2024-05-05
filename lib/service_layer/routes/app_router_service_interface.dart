import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///Interface for in app router service
abstract class IAppRouterService {
  ///Getter to fetch current context of app
  BuildContext get context => throw UnimplementedError();

  ///[GoRouter] instance to manage app routes
  final GoRouter router = GoRouter(routes: []);
}
