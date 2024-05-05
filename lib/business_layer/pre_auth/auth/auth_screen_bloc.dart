import 'package:chatgpt/business_layer/common/auth_bloc.dart';
import 'package:chatgpt/data_layer/models/user_auth/user_auth_model.dart';
import 'package:chatgpt/presentation_layer/pre_auth/auth_screen.dart';
import 'package:chatgpt/repository_layer/auth_repository/auth_repository_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'auth_screen_events.dart';
part 'auth_screen_state.dart';

///[Bloc] for [AuthScreen]
class AuthScreenBloc extends Bloc<AuthScreenEvent, AuthScreenState> {
  ///[AuthScreenBloc] default constructor which takes in [AuthScreenState]
  ///as a required parameter
  AuthScreenBloc(this.authRepository)
      : super(const AuthScreenStateLoggedOut()) {
    on<AuthScreenEventToggleLoginSignUp>(_toggleLogin);
    on<AuthScreenEventSocialLogin>(_login);
  }

  ///Instance for Implementation of [IAuthRepository] to create auth requests
  final IAuthRepository authRepository;

  void _toggleLogin(
    AuthScreenEventToggleLoginSignUp event,
    Emitter<AuthScreenState> emit,
  ) {
    emit(state.copyWith(isLogin: !state.isLogin));
  }

  Future<void> _login(
    AuthScreenEventSocialLogin event,
    Emitter<AuthScreenState> emit,
  ) async {
    final loggedOutState = AuthScreenStateLoggedOut(
      isLogin: state.isLogin,
      isLoading: true,
    );
    try {
      emit(loggedOutState);
      final user = await authRepository.loginWithGoogle();
      emit(
        AuthScreenStateLoggedIn(user: user, isLogin: loggedOutState.isLogin),
      );
    } catch (e) {
      Logger().d(e);
      emit(
        loggedOutState.copyWith(
          error: e.toString().replaceFirst('Exception: ', ''),
          isLoading: false,
        ),
      );
    }
    event.callback(state);
  }
}
