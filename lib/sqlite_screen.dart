import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';

class SQLiteScreen extends StatefulWidget {
  @override
  _SQLiteScreenState createState() => _SQLiteScreenState();
}

class _SQLiteScreenState extends State<SQLiteScreen> {
  late Database db;
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    openDatabase('my_db.db').then((database) {
      db = database;
      db.execute(
        'CREATE TABLE IF NOT EXISTS contacts(id INTEGER PRIMARY KEY, name TEXT, phone TEXT)',
      );
      fetchData();
    });
  }

  void insertData(Contact contact) async {
    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    fetchData();
  }

  void fetchData() async {
    var result = await db.query('contacts');
    setState(() {
      contacts = result.map((data) => Contact.fromMap(data)).toList();
    });
  }

  void updateData(Contact contact) async {
    await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
    fetchData();
  }

  void deleteData(int id) async {
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SQLite CRUD Operations")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () =>
                insertData(Contact(name: 'John Doe', phone: '1234567890')),
            child: Icon(Icons.add),
          ),
          ElevatedButton(onPressed: fetchData, child: Icon(Icons.refresh)),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(contacts[index].name),
                  subtitle: Text(contacts[index].phone),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => updateData(
                          Contact(
                            id: contacts[index].id,
                            name: 'Updated Name1',
                            phone: 'Updated Phone2',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteData(contacts[index].id ?? 0),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
