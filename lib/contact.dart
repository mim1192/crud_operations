
class Contact {
  int? id;
  String name;
  String phone;

  Contact({this.id, required this.name, required this.phone});

  // Convert a Contact into a Map object (SQLite insert)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  // Convert a Map into a Contact object (SQLite query)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
    );
  }
}
