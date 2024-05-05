import 'package:chatgpt/data_layer/models/user_auth/user_auth_model.dart';
import 'package:chatgpt/data_layer/models/user_auth/user_auth_model_google.dart';
import 'package:chatgpt/repository_layer/auth_repository/auth_repository_interface.dart';

class AuthRepositoryDummy implements IAuthRepository {
  AuthRepositoryDummy(this.json);
  final Map<String, dynamic> json;
  @override
  Future<UserAuthModel?> checkAuthStatus({bool isLoggedIn = false}) async {
    if (!isLoggedIn) {
      return null;
    } else {
      return UserAuthModel.fromJson(json);
    }
  }

  @override
  Future<UserAuthModelGoogle> loginWithGoogle() async {
    return UserAuthModelGoogle.fromJson(json);
  }

  @override
  Future<int> sendOTPEmail(String recipient) async {
    return 99999;
  }

  @override
  Future<void> setVerificationStatus({
    required String userID,
    required bool isVerified,
  }) async {
    json['isEmailVerified'] = isVerified;
  }

  @override
  Future<bool> logout() async {
    return true;
  }
}
