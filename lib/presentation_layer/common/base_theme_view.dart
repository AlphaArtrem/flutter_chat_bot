import 'package:chatgpt/business_layer/theme/theme_cubit.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///A reactive Widget to changes in [ThemeCubit].
class BaseThemeView extends StatelessWidget {
  ///[BaseThemeView] default constructor
  const BaseThemeView({
    required this.builder,
    super.key,
  });

  ///[builder] function to return a [Widget] to render withe current
  final Widget Function(BuildContext context, ThemeState themeState) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (a, b) => a.isLight != b.isLight,
      bloc: themeService,
      builder: builder,
    );
  }
}
