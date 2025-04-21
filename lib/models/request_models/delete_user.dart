class SingleUser {
 

    final String userId;

  SingleUser({
 
   required this.userId,
  });

  factory SingleUser.fromJson(Map<String, dynamic> json) {
    return SingleUser(
      userId: json['user_id'],
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
    

    };
  }
}