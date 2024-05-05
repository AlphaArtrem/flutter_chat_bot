part of 'otp_bloc.dart';

///abstract state for [OTPBloc]
abstract class OTPState extends Equatable {
  ///[OTPState] default constructor which can't be invoked due to it
  ///being an abstract class
  const OTPState({
    this.error = '',
    this.isLoading = false,
  });

  ///[error] to be shown to user during auth processes
  final String error;

  ///[isLoading] determines weather to show a loading state to user
  ///during auth processes
  final bool isLoading;

  ///Copy with constructor for [OTPState]
  OTPState copyWith({
    String? error,
    bool? isLoading,
  }) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [
        error,
        isLoading,
      ];
}

///Initial OTP State
class OTPStateInitial extends OTPState {
  ///[OTPStateInitial] default constructor
  const OTPStateInitial({
    super.error,
    super.isLoading = true,
  });

  @override
  OTPStateInitial copyWith({
    String? error,
    bool? isLoading,
  }) {
    return OTPStateInitial(
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

///Authorised state for [OTPBloc]
class OTPStateVerify extends OTPState {
  ///[OTPStateVerify] default constructor
  const OTPStateVerify({
    required this.user,
    this.sentOTP = 0,
    this.isInvalid = false,
    super.error,
    super.isLoading,
  });

  ///OTP for email verification
  final int sentOTP;

  ///boolean value to determine if otp is invalid
  final bool isInvalid;

  ///[user] contains details of logged in user
  ///[user] must be of type [UserAuthModelGoogle]
  ///or must implement or extend it
  final UserAuthModelGoogle user;

  @override
  OTPStateVerify copyWith({
    String? error,
    bool? isLoading,
    UserAuthModelGoogle? user,
    int? otp,
    bool? isInvalid,
  }) {
    return OTPStateVerify(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      sentOTP: otp ?? sentOTP,
      isInvalid: isInvalid ?? this.isInvalid,
    );
  }

  @override
  List<Object?> get props => [
        error,
        isLoading,
        user,
        sentOTP,
        isInvalid,
      ];
}
