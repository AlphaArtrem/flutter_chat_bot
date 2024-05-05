import 'package:chatgpt/data_layer/models/user_auth/user_auth_model_google.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_screen.dart';
import 'package:chatgpt/repository_layer/auth_repository/auth_repository_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_event.dart';
part 'otp_state.dart';

///[Bloc] for [ChatScreen]
class OTPBloc extends Bloc<OTPEvent, OTPState> {
  ///[OTPBloc] default constructor which takes in [OTPState]
  ///as a required parameter
  OTPBloc(this.authRepository) : super(const OTPStateInitial()) {
    on<OTPEventInitialise>(_initialise);
    on<OTPEventVerify>(_verifyOTP);
  }

  ///Instance for Implementation of [IAuthRepository] to create auth requests
  final IAuthRepository authRepository;

  Future<void> _initialise(
    OTPEventInitialise event,
    Emitter<OTPState> emit,
  ) async {
    emit(const OTPStateInitial());
    try {
      final otp = await authRepository.sendOTPEmail(
        event.user.email,
      );
      emit(OTPStateVerify(user: event.user, sentOTP: otp));
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString().replaceFirst('Exception: ', ''),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _verifyOTP(
    OTPEventVerify event,
    Emitter<OTPState> emit,
  ) async {
    final state = this.state as OTPStateVerify;
    var isSuccess = false;
    emit(state.copyWith(error: '', isLoading: true));
    try {
      if (state.sentOTP == event.otp) {
        await authRepository.setVerificationStatus(
          userID: state.user.userId,
          isVerified: true,
        );
        isSuccess = true;
        emit(
          state.copyWith(
            error: '',
            isInvalid: false,
            isLoading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            error: 'Invalid OTP!',
            isInvalid: true,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString().replaceFirst('Exception: ', ''),
          isLoading: false,
        ),
      );
    }
    event.callback(isSuccess: isSuccess);
  }
}
