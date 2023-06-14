// class Status {
//   final String uid;
//   final String username;
//   final String phoneNumber;
//   final List<String> photoUrl;
//   final DateTime createdAt;
//   final String profilePic;
//   final String statusId;
//   final List<String?> whoCanSee;

//   Status({
//     required this.uid,
//     required this.username,
//     required this.phoneNumber,
//     required this.photoUrl,
//     required this.createdAt,
//     required this.profilePic,
//     required this.statusId,
//     required this.whoCanSee,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'uid': uid,
//       'username': username,
//       'phoneNumber': phoneNumber,
//       'photoUrl': photoUrl,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'profilePic': profilePic,
//       'statusId': statusId,
//       'whoCanSee': whoCanSee,
//     };
//   }

//   factory Status.fromMap(Map<String, dynamic> map) {
//     return Status(
//       uid: map['uid'] as String,
//       username: map['username'] as String,
//       phoneNumber: map['phoneNumber'] as String,
//       photoUrl: List<String>.from((map['photoUrl'] as List<String>)),
//       createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
//       profilePic: map['profilePic'] as String,
//       statusId: map['statusId'] as String,
//       whoCanSee: List<String>.from((map['whoCanSee'] as List<String>)),
//     );
//   }
// }

class Status {
  final List<String> whoCanSee;
  final String uid;
  final String profilePic;
  final String username;
  final List<String> photoUrl;
  final String statusId;
  final DateTime createdAt;
  final String phoneNumber;

  Status({
    required this.whoCanSee,
    required this.uid,
    required this.profilePic,
    required this.username,
    required this.photoUrl,
    required this.statusId,
    required this.createdAt,
    required this.phoneNumber,
  });

  factory Status.fromMap(Map<String, dynamic> json) => Status(
        whoCanSee: List<String>.from(json["whoCanSee"].map((x) => x)),
        uid: json["uid"],
        profilePic: json["profilePic"],
        username: json["username"],
        photoUrl: List<String>.from(json["photoUrl"].map((x) => x)),
        statusId: json["statusId"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toMap() => {
        "whoCanSee": List<dynamic>.from(whoCanSee.map((x) => x)),
        "uid": uid,
        "profilePic": profilePic,
        "username": username,
        "photoUrl": List<dynamic>.from(photoUrl.map((x) => x)),
        "statusId": statusId,
        "createdAt": createdAt.millisecondsSinceEpoch,
        "phoneNumber": phoneNumber,
      };
}
