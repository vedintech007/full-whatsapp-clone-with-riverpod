class UserModel {
  UserModel({
    required this.phoneNumber,
    required this.groupId,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
  });
  final String name, uid, profilePic, phoneNumber;
  final bool isOnline;
  final List<String> groupId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'groupId': groupId,
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phoneNumber: map['phoneNumber'] ?? "",
      name: map['name'] ?? "",
      uid: map['uid'] ?? "",
      profilePic: map['profilePic'] ?? "",
      isOnline: map['isOnline'] ?? false,
      groupId: List<String>.from((map['groupId'] as List<dynamic>)),
    );
  }
}
