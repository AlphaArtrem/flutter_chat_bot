part of 'auth_bloc.dart';

///abstract state for [AuthBloc]
abstract class AuthState extends Equatable {
  ///[AuthState] default constructor which can't be invoked due to it
  ///being an abstract class
  const AuthState();

  ///Copy with constructor for [AuthState]
  AuthState copyWith() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [];
}

///Initial unauthorised state for [AuthBloc].
///Check if user is authorised or not during this state
class AuthStateLoading extends AuthState {
  ///[AuthStateLoading] default constructor
  const AuthStateLoading({
    this.error = '',
    this.isLoading = true,
  });

  ///[error] to be shown to user during auth processes
  final String error;

  ///[isLoading] determines weather to show a loading state to user
  ///during auth processes
  final bool isLoading;

  @override
  AuthStateLoading copyWith({String? error, bool? isLoading}) {
    return AuthStateLoading(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        error,
        isLoading,
      ];
}

///Unauthorised state for [AuthBloc]
class AuthStateLoggedOut extends AuthState {
  ///[AuthStateLoggedOut] default constructor
  const AuthStateLoggedOut();
}

///Authorised state for [AuthBloc]
class AuthStateLoggedIn extends AuthState {
  ///[AuthStateLoggedIn] default constructor
  const AuthStateLoggedIn({
    required this.user,
  });

  ///[user] contains details of logged in user
  final UserAuthModel user;

  @override
  AuthStateLoggedIn copyWith({
    String? error,
    bool? isLoading,
    UserAuthModel? user,
    int? otp,
  }) {
    return AuthStateLoggedIn(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        user,
      ];
}
