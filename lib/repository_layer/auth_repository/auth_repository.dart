import 'dart:math';
import 'package:chatgpt/data_layer/models/user_auth/user_auth_model_google.dart';
import 'package:chatgpt/data_layer/static/api_constants.dart';
import 'package:chatgpt/repository_layer/auth_repository/auth_repository_interface.dart';
import 'package:chatgpt/service_layer/database_service/database_service_interface.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

///Implementation of [IAuthRepository] to authenticate
///user from various sources
class AuthRepository implements IAuthRepository {
  ///Default constructor for [AuthRepository]
  AuthRepository(this.databaseService);

  ///Instance for Implementation of [IDatabaseService] to fetch user data
  final IDatabaseService databaseService;

  ///Instance of [FirebaseAuth] to authenticate user using Firebase
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///Getter for [_firebaseAuth]
  static FirebaseAuth get firebaseAuth => _firebaseAuth;

  @override
  Future<UserAuthModelGoogle> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredentials =
          await _firebaseAuth.signInWithCredential(credential);
      return UserAuthModelGoogle(
        userId: userCredentials.user!.uid,
        isEmailVerified: await databaseService.isEmailVerified(
          userCredentials.user!.uid,
        ),
        email: userCredentials.user!.email!,
        displayName: userCredentials.user!.displayName!,
      );
    } on FirebaseAuthException catch (e) {
      final error = 'Failed with error code: ${e.code}. Try again!';
      apiService.log.d(error);
      throw Exception(error);
    } catch (e) {
      apiService.log.d(e);
      throw Exception('Something went wrong with google sign in. Try again!');
    }
  }

  @override
  Future<int> sendOTPEmail(String recipient) async {
    final exception =
        Exception("Couldn't send email for OTP verification. Try again!");
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final otp = Random(timestamp).nextInt(90000) + 9999;
      apiService.log.d(appConfig.mailerSendBearerToken);
      final headers = {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer ${appConfig.mailerSendBearerToken}',
      };
      final email = '''
      <div style="font-family: Helvetica,Arial,sans-serif;min-width:1000px;overflow:auto;line-height:2">
        <div style="margin:50px auto;width:70%;padding:20px 0">
          <div style="border-bottom:1px solid #eee">
            <a href="" style="font-size:1.4em;color: #00466a;text-decoration:none;font-weight:600">ChatGPT</a>
          </div>
          <p style="font-size:1.1em">Hi,</p>
          <p>Thank you for choosing ChatGPT. Use the following OTP to complete your email verification.</p>
          <h2 style="background: #00466a;margin: 0 auto;width: max-content;padding: 0 10px;color: #fff;border-radius: 4px;">$otp</h2>
          <p style="font-size:0.9em;">Regards,<br />ChatGPT</p>
          <hr style="border:none;border-top:1px solid #eee" />
          <div style="float:right;padding:8px 0;color:#aaa;font-size:0.8em;line-height:1;font-weight:300">
            <p>ChatGPT Inc</p>
            <p>1600 Amphitheatre Parkway</p>
            <p>California</p>
          </div>
        </div>
      </div>
    ''';
      final result = await apiService.postRequest(
        APIConstants.sendMail,
        {
          'from': {'email': 'info@${appConfig.mailerSendVerifiedDomain}'},
          'to': [
            {'email': recipient},
          ],
          'subject': 'OTP for email verification',
          'html': email,
        },
        headers: headers,
        successCodes: [200, 201, 202, 204],
        parseResponseToMap: false,
      );
      if (result.exception == null) {
        return otp;
      } else {
        throw exception;
      }
    } catch (e) {
      apiService.log.d(e);
      throw exception;
    }
  }

  @override
  Future<void> setVerificationStatus({
    required String userID,
    required bool isVerified,
  }) async {
    try {
      await databaseService.setEmailVerificationStatus(
        userID: userID,
        isVerified: isVerified,
      );
    } catch (e) {
      apiService.log.d(e);
      rethrow;
    }
  }

  @override
  Future<UserAuthModelGoogle?> checkAuthStatus() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        return UserAuthModelGoogle(
          userId: _firebaseAuth.currentUser!.uid,
          isEmailVerified: await databaseService.isEmailVerified(
            _firebaseAuth.currentUser!.uid,
          ),
          email: _firebaseAuth.currentUser!.email!,
          displayName: _firebaseAuth.currentUser!.displayName!,
        );
      }
    } catch (e) {
      apiService.log.d(e);
    }
    return null;
  }

  @override
  Future<bool> logout() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.signOut();
      }
      return true;
    } catch (e) {
      apiService.log.d(e);
      return false;
    }
  }
}
