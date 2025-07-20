class User {
  final int? id;  // Adding id as nullable since it can be null when creating a new post
  final String title;
  final String body;
  final int userId;

  User({this.id, required this.title, required this.body, required this.userId});

  // Convert a User into a Map object (API POST and PUT)
  Map<String, dynamic> toMap() {
    return {
      'id': id,  // 'id' can be null when creating a new post
      'title': title,
      'body': body,
      'userId': userId,
    };
  }

  // Convert a Map into a User object (API response)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],  // The 'id' will be populated when fetched from the API
      title: map['title'],
      body: map['body'],
      userId: map['userId'],
    );
  }
}
