
class User {
  final String title;
  final String body;
  final int userId;

  User({required this.title, required this.body, required this.userId});

  // Convert a User into a Map object (API POST)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
    };
  }

  // Convert a Map into a User object (API response)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      title: map['title'],
      body: map['body'],
      userId: map['userId'],
    );
  }
}
