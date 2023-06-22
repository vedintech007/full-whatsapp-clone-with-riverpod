class ChatGroup {
  final String senderId;
  final List<String> membersUid;
  final String lastMessage;
  final String groupPic;
  final String groupId;
  final DateTime timeSent;
  final String name;

  ChatGroup({
    required this.senderId,
    required this.membersUid,
    required this.lastMessage,
    required this.groupPic,
    required this.groupId,
    required this.timeSent,
    required this.name,
  });

  factory ChatGroup.fromMap(Map<String, dynamic> json) => ChatGroup(
        senderId: json["senderId"],
        membersUid: List<String>.from(json["membersUid"].map((x) => x)),
        lastMessage: json["lastMessage"],
        groupPic: json["groupPic"],
        groupId: json["groupId"],
        timeSent: DateTime.fromMillisecondsSinceEpoch(json['timeSent'] as int),
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "senderId": senderId,
        "membersUid": List<dynamic>.from(membersUid.map((x) => x)),
        "lastMessage": lastMessage,
        "groupPic": groupPic,
        "groupId": groupId,
        'timeSent': timeSent.millisecondsSinceEpoch,
        "name": name,
      };
}
