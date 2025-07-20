
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';

class SQLiteScreen extends StatefulWidget {
  @override
  _SQLiteScreenState createState() => _SQLiteScreenState();
}

class _SQLiteScreenState extends State<SQLiteScreen> {
  late Database db;

  @override
  void initState() {
    super.initState();
    openDatabase('my_db.db').then((database) {
      db = database;
      db.execute('CREATE TABLE IF NOT EXISTS contacts(id INTEGER PRIMARY KEY, name TEXT, phone TEXT)');
    });
  }

  void insertData(Contact contact) async {
    await db.insert('contacts', contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    setState(() {});
  }

  void fetchData() async {
    var result = await db.query('contacts');
    print(result);
  }

  void updateData(Contact contact) async {
    await db.update('contacts', contact.toMap(), where: 'id = ?', whereArgs: [contact.id]);
    setState(() {});
  }

  void deleteData(int id) async {
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SQLite CRUD Operations")),
      body: Column(
        children: [
          ElevatedButton(onPressed: () => insertData(Contact(name: 'John Doe', phone: '1234567890')), child: Text("Insert Data")),
          ElevatedButton(onPressed: fetchData, child: Text("Fetch Data")),
          ElevatedButton(onPressed: () => updateData(Contact(id: 1, name: 'Jane Doe', phone: '9876543210')), child: Text("Update Data")),
          ElevatedButton(onPressed: () => deleteData(1), child: Text("Delete Data")),
        ],
      ),
    );
  }
}
