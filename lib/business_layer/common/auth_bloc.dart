import 'package:chatgpt/data_layer/models/user_auth/user_auth_model.dart';
import 'package:chatgpt/data_layer/models/user_auth/user_auth_model_google.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_screen.dart';
import 'package:chatgpt/repository_layer/auth_repository/auth_repository_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_enums.dart';

///[Bloc] for [ChatScreen]
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  ///[AuthBloc] default constructor which takes in [AuthState]
  ///as a required parameter
  AuthBloc(this.authRepository) : super(const AuthStateLoading()) {
    on<AuthEventCheckLoginStatus>(_checkLoginStatus);
    on<AuthEventUserLoggedIn>(
      (event, emit) => emit(AuthStateLoggedIn(user: event.user)),
    );
  }

  ///Instance for Implementation of [IAuthRepository] to create auth requests
  final IAuthRepository authRepository;

  Future<void> _checkLoginStatus(
    AuthEventCheckLoginStatus event,
    Emitter<AuthState> emit,
  ) async {
    final user = await authRepository.checkAuthStatus();
    if (user != null) {
      if (user.isEmailVerified) {
        add(AuthEventUserLoggedIn(user: user));
      }
    }
    event.onStatusChecked?.call(
      isLoggedIn:
          user != null && user is UserAuthModelGoogle && user.isEmailVerified,
    );
  }
}
