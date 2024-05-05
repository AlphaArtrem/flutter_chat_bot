import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Widget to replace [BlocBuilder].
class BaseStreamableView<B extends StateStreamableSource<S>,
    S extends Equatable> extends StatelessWidget {
  ///[BaseStreamableView] default constructor
  const BaseStreamableView({
    required this.builder,
    this.buildWhen,
    this.bloc,
    super.key,
  });

  ///[builder] function to return a [Widget] to render withe current
  ///[BuildContext], the passed [B] bloc or cubit's [S] state
  final Widget Function(
    BuildContext context,
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
    return BlocProvider<B>.value(
      value: bloc ?? serviceLocator<B>(),
      child: BlocBuilder<B, S>(
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}
