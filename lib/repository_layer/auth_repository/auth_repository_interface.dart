import 'package:chatgpt/data_layer/models/user_auth/user_auth_model.dart';
import 'package:chatgpt/data_layer/models/user_auth/user_auth_model_google.dart';

///Abstract class for authentication
abstract class IAuthRepository {
  ///Default constructor of [IAuthRepository]
  IAuthRepository();

  ///Check auth status, returns a [UserAuthModel] if user found or
  ///else returns null
  Future<UserAuthModel?> checkAuthStatus() async {
    throw UnimplementedError();
  }

  ///Authenticate using google sign-in
  Future<UserAuthModelGoogle> loginWithGoogle() async {
    throw UnimplementedError();
  }

  ///Send OTP to email
  Future<int> sendOTPEmail(String recipient) async {
    throw UnimplementedError();
  }

  ///Send user OTP verification status
  Future<void> setVerificationStatus({
    required String userID,
    required bool isVerified,
  }) async {
    throw UnimplementedError();
  }

  ///Logout user
  Future<bool> logout() async {
    throw UnimplementedError();
  }
}
