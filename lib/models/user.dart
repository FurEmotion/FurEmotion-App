class User {
  final String uid;
  final String email;
  final String nickname;
  final String? photoId;
  final String? jwt;

  User({
    required this.uid,
    required this.email,
    required this.nickname,
    this.photoId,
    this.jwt,
  });

  factory User.fromJson(Map<String, dynamic> json, {String? jwt}) {
    return User(
      uid: json['uid'],
      email: json['email'],
      nickname: json['nickname'],
      photoId: json['photoId'],
      jwt: jwt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'photoId': photoId,
    };
  }

  void printInfo() {
    print('User Info: $uid, $email, $nickname, $photoId');
  }
}
