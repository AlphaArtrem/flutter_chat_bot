part of 'otp_bloc.dart';

///Events for [OTPBloc]
abstract class OTPEvent extends Equatable {
  ///[OTPEvent] default constructor which can't be invoked due to it
  ///being an abstract class
  const OTPEvent();
}

///Event to send OTP email
class OTPEventInitialise extends OTPEvent {
  ///[OTPEventInitialise] default constructor
  const OTPEventInitialise({required this.user});

  ///[user] contains details of logged in user
  ///[user] must be of type [UserAuthModelGoogle]
  ///or must implement or extend it
  final UserAuthModelGoogle user;

  @override
  List<Object?> get props => [user];
}

///Event to verify OTP
class OTPEventVerify extends OTPEvent {
  ///[OTPEventVerify] default constructor
  const OTPEventVerify({required this.callback, required this.otp});

  ///Otp entered by user
  final int otp;

  ///Callback to trigger once email is sent or failed
  final void Function({required bool isSuccess}) callback;

  @override
  List<Object?> get props => [otp];
}
