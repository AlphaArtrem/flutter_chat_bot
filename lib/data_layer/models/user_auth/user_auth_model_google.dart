import 'package:chatgpt/data_layer/models/user_auth/user_auth_model.dart';

///[UserAuthModel] contains details required regarding user
///when authenticated using google sign in
class UserAuthModelGoogle extends UserAuthModel {
  ///Default constructor of [UserAuthModelGoogle]
  const UserAuthModelGoogle({
    required super.userId,
    required super.isEmailVerified,
    required this.email,
    required this.displayName,
  });

  @override
  factory UserAuthModelGoogle.fromJson(
    Map<String, dynamic> json,
  ) {
    final user = UserAuthModel.fromJson(json);
    return UserAuthModelGoogle(
      userId: user.userId,
      isEmailVerified: user.isEmailVerified,
      email: json['email'] is String ? json['email'].toString() : '',
      displayName:
          json['displayName'] is String ? json['displayName'].toString() : '',
    );
  }

  ///Google sign in email
  final String email;

  ///User display name
  final String displayName;

  @override
  UserAuthModelGoogle copyWith({
    String? userId,
    bool? isEmailVerified,
    String? email,
    String? displayName,
  }) {
    return UserAuthModelGoogle(
      userId: userId ?? this.userId,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['email'] = email;
    map['displayName'] = displayName;
    return map;
  }

  @override
  List<Object?> get props => [
        userId,
        isEmailVerified,
        email,
        displayName,
      ];
}
