class MessageInfo {
  String userId;
  String? email;
  String? profileImage;
  String? lastMessage;
  DateTime? messageTime;
  bool? isVerified;

  MessageInfo({
    required this.userId,
    this.email,
    this.profileImage,
    this.lastMessage,
    this.messageTime,
    this.isVerified = false,
  });

  factory MessageInfo.fromJson(Map<String, dynamic> json) {
    return MessageInfo(
        userId: json['user_id'],
        email: json['email'],
        profileImage: json['profile_image'],
        lastMessage: json['last_message'],
        messageTime: json['message_time'] != null
            ? DateTime.parse(json['message_time'])
            : null,
        isVerified: json['verified']);
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      if (email != null) 'email': email,
      if (profileImage != null) 'profile_image': profileImage,
      if (lastMessage != null) 'last_message': lastMessage,
      if (messageTime != null) 'message_time': messageTime!.toIso8601String(),
      if (isVerified != null) 'verified': isVerified,
    };
  }
}
