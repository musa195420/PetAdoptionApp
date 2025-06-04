class MessageInfo {
  final String userId;
  final String? email;
  final String? profileImage;
  final String? lastMessage;
  final DateTime? messageTime;

  MessageInfo({
    required this.userId,
    this.email,
    this.profileImage,
    this.lastMessage,
    this.messageTime,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      if (email != null) 'email': email,
      if (profileImage != null) 'profile_image': profileImage,
      if (lastMessage != null) 'last_message': lastMessage,
      if (messageTime != null) 'message_time': messageTime!.toIso8601String(),
    };
  }
}
