
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesScreen extends StatefulWidget {
  @override
  _SharedPreferencesScreenState createState() => _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  String _storedData = "";

  void storeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', 'JohnDoe');
    setState(() {
      _storedData = 'Stored username: JohnDoe';
    });
  }

  void retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedData = 'Stored username: ${prefs.getString('username') ?? 'None'}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SharedPreferences Example")),
      body: Column(
        children: [
          ElevatedButton(onPressed: storeData, child: Text("Store Data")),
          ElevatedButton(onPressed: retrieveData, child: Text("Retrieve Data")),
          Text(_storedData),
        ],
      ),
    );
  }
}
