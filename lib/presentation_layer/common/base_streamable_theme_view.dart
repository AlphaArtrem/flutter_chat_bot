import 'package:chatgpt/business_layer/theme/theme_cubit.dart';
import 'package:chatgpt/presentation_layer/common/base_streamable_view.dart';
import 'package:chatgpt/presentation_layer/common/base_theme_view.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Widget to replace [BaseStreamableView] and [BaseThemeView].
/// It is reactive to changes in
///[ThemeCubit] too.
class BaseStreamableThemeView<B extends StateStreamableSource<S>,
    S extends Equatable> extends StatelessWidget {
  ///[BaseStreamableThemeView] default constructor
  const BaseStreamableThemeView({
    required this.builder,
    this.buildWhen,
    this.bloc,
    super.key,
  });

  ///[builder] function to return a [Widget] to render withe current
  ///[BuildContext],  [ThemeState] and the passed [B] bloc or cubit's [S] state
  final Widget Function(
    BuildContext context,
    ThemeState themeState,
    S state,
  ) builder;

  ///Function which takes the previous `state` and
  /// the current `state` and is responsible for returning a [bool] which
  /// determines whether to rebuild [BlocBuilder] with the current `state`.
  final bool Function(S previous, S current)? buildWhen;

  ///[bloc] takes in existing bloc or one not registered with [serviceLocator]
  final B? bloc;

  @override
  Widget build(BuildContext context) {
    return BaseThemeView(
      builder: (BuildContext context, ThemeState themeState) {
        return BaseStreamableView<B, S>(
          bloc: bloc,
          buildWhen: buildWhen,
          builder: (context, state) => builder(context, themeState, state),
        );
      },
    );
  }
}
