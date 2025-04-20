class DeleteUser {
 

    final String userId;

  DeleteUser({
 
   required this.userId,
  });

  factory DeleteUser.fromJson(Map<String, dynamic> json) {
    return DeleteUser(
      userId: json['user_id'],
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
    

    };
  }
}