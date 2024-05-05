import 'package:equatable/equatable.dart';

///[UserAuthModel] contains details required regarding user from all
///authentication sources condensed into one single class
class UserAuthModel extends Equatable {
  ///Default constructor of [UserAuthModel]
  const UserAuthModel({
    required this.userId,
    required this.isEmailVerified,
  });

  ///Convert JSON to [UserAuthModel]
  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      userId: json['userId'] is String ? json['userId'].toString() : '',
      isEmailVerified:
          json['isEmailVerified'] is bool && json['isEmailVerified'] as bool,
    );
  }

  ///Unique id assigned to each user on signup
  final String userId;

  ///[bool] value to determine if user has verified 2FA using email OTP
  final bool isEmailVerified;

  ///Copy with constructor for [UserAuthModel]
  UserAuthModel copyWith({
    String? userId,
    bool? isEmailVerified,
  }) {
    return UserAuthModel(
      userId: userId ?? this.userId,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  ///Convert [UserAuthModel] to JSON
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['isEmailVerified'] = isEmailVerified;
    return map;
  }

  @override
  List<Object?> get props => [
        userId,
        isEmailVerified,
      ];
}
