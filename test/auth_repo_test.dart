import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'repository/auth_repository_dummy.dart';

void main() async {
  final file = File('${Directory.current.path}/test/json_data/test_data.json');
  final json = jsonDecode(await file.readAsString());
  test('Auth Repo Test', () async {
    final authRepositoryDummy = AuthRepositoryDummy(
      (json as Map<String, dynamic>)['userData'] as Map<String, dynamic>,
    );
    expect(
      await authRepositoryDummy.checkAuthStatus(),
      equals(null),
      reason: 'User must be null if user is not logged in',
    );
    expect(
      (await authRepositoryDummy.checkAuthStatus(isLoggedIn: true))?.userId,
      equals((json['userData'] as Map<String, dynamic>)['userId']),
      reason:
          "User id must match [json['userData']['userId'] if user is logged in",
    );
    expect(
      (await authRepositoryDummy.loginWithGoogle()).email,
      equals((json['userData'] as Map<String, dynamic>)['email']),
      reason: "User email must match [json['userData']['email'] if "
          'user is logged in',
    );
    await authRepositoryDummy.setVerificationStatus(
      userID: (json['userData'] as Map<String, dynamic>)['userId'].toString(),
      isVerified: false,
    );
    expect(
      authRepositoryDummy.json['isEmailVerified'],
      equals(false),
      reason: 'User verification must be false',
    );
    await authRepositoryDummy.setVerificationStatus(
      userID: (json['userData'] as Map<String, dynamic>)['userId'].toString(),
      isVerified: true,
    );
    expect(
      authRepositoryDummy.json['isEmailVerified'],
      equals(true),
      reason: 'User verification must be true',
    );
  });
}
