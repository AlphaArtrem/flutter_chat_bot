part of 'auth_screen_bloc.dart';

///abstract state for [AuthScreenBloc]
abstract class AuthScreenState extends Equatable {
  ///[AuthScreenState] default constructor which can't be invoked due to it
  ///being an abstract class
  const AuthScreenState({
    this.isLogin = true,
    this.isLoading = false,
  });

  ///[isLogin] determines the UI for [AuthScreen]
  final bool isLogin;

  ///[isLoading] determines weather to show a loading state to user
  ///during auth processes
  final bool isLoading;

  ///Copy with constructor for [AuthScreenState]
  AuthScreenState copyWith({
    bool? isLogin,
  }) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [];
}

///Initial State for [AuthScreenBloc]
class AuthScreenStateLoggedOut extends AuthScreenState {
  ///[AuthScreenStateLoggedOut] default constructor
  const AuthScreenStateLoggedOut({
    this.error = '',
    super.isLoading = false,
    super.isLogin = true,
  });

  ///[error] to be shown to user during auth processes
  final String error;

  ///Copy with constructor for [AuthScreenStateLoggedOut]
  @override
  AuthScreenStateLoggedOut copyWith({
    String? error,
    bool? isLoading,
    bool? isLogin,
  }) {
    return AuthScreenStateLoggedOut(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isLogin: isLogin ?? this.isLogin,
    );
  }

  @override
  List<Object?> get props => [
        error,
        isLoading,
        isLogin,
      ];
}

///Authorised state for [AuthScreenBloc]
class AuthScreenStateLoggedIn extends AuthScreenState {
  ///[AuthScreenStateLoggedIn] default constructor
  const AuthScreenStateLoggedIn({
    required this.user,
    required super.isLogin,
    super.isLoading = false,
  });

  ///[user] contains details of logged in user
  final UserAuthModel user;

  @override
  AuthScreenStateLoggedIn copyWith({
    UserAuthModel? user,
    bool? isLogin,
    bool? isLoading,
  }) {
    return AuthScreenStateLoggedIn(
      user: user ?? this.user,
      isLogin: isLogin ?? this.isLogin,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        user,
        isLoading,
        isLogin,
      ];
}
