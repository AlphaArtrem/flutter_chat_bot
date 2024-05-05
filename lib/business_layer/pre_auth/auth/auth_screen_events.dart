part of 'auth_screen_bloc.dart';

///Events for [AuthScreenBloc]
abstract class AuthScreenEvent extends Equatable {
  ///[AuthScreenEvent] default constructor which can't be invoked due to it
  ///being an abstract class
  const AuthScreenEvent();
}

///Event to switch between login and signup states
class AuthScreenEventToggleLoginSignUp extends AuthScreenEvent {
  ///[AuthScreenEventToggleLoginSignUp] default constructor
  const AuthScreenEventToggleLoginSignUp();

  @override
  List<Object?> get props => [];
}

///Event to trigger social login
class AuthScreenEventSocialLogin extends AuthScreenEvent {
  ///[AuthScreenEventSocialLogin] default constructor which takes in [authType]
  ///as a parameter
  const AuthScreenEventSocialLogin({
    required this.authType,
    required this.callback,
  });

  ///[authType] determines the social authentication method to
  ///trigger from [AuthScreen]
  final AuthType authType;

  ///Callback to trigger on state change
  final void Function(AuthScreenState state) callback;

  @override
  List<Object?> get props => [authType];
}
