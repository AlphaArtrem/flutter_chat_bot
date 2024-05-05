part of 'auth_bloc.dart';

///Events for [AuthBloc]
abstract class AuthEvent extends Equatable {
  ///[AuthEvent] default constructor which can't be invoked due to it
  ///being an abstract class
  const AuthEvent();
}

///Event to send OTP email
class AuthEventUserLoggedIn extends AuthEvent {
  ///[AuthEventUserLoggedIn] default constructor
  const AuthEventUserLoggedIn({required this.user});

  ///[user] contains details of logged in user
  final UserAuthModel user;

  @override
  List<Object?> get props => [user];
}

///Event to check if user is logged in
class AuthEventCheckLoginStatus extends AuthEvent {
  ///[AuthEventCheckLoginStatus] default constructor
  const AuthEventCheckLoginStatus(this.onStatusChecked);

  ///Callback to trigger once login status is fetched
  final void Function({required bool isLoggedIn})? onStatusChecked;

  @override
  List<Object?> get props => [];
}

///Event to log user out
class AuthEventLogOut extends AuthEvent {
  ///[AuthEventLogOut] default constructor
  const AuthEventLogOut(this.onLoggedOut);

  ///Callback to trigger once logged out
  final void Function({required bool success})? onLoggedOut;

  @override
  List<Object?> get props => [];
}
