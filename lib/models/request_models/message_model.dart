class MessageModel {
  final String? messageId;
  final String? senderId;
  final String? receiverId;
  final String? content;
  final DateTime? timestamp;

  MessageModel({
    this.messageId,
    this.senderId,
    this.receiverId,
    this.content,
    this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (messageId != null) 'message_id': messageId,
      if (senderId != null) 'sender_id': senderId,
      if (receiverId != null) 'receiver_id': receiverId,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
    };
  }
}
