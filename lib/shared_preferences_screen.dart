import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesScreen extends StatefulWidget {
  @override
  _SharedPreferencesScreenState createState() => _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  List<String> _usernames = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsernames();
  }

  // Load usernames from SharedPreferences
  void _loadUsernames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernames = prefs.getStringList('usernames') ?? [];
    });
  }

  // Save a new username to SharedPreferences
  void _addUsername() async {
    if (_controller.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _usernames.add(_controller.text);
      await prefs.setStringList('usernames', _usernames);
      setState(() {
        _controller.clear();
      });
    }
  }

  // Update an existing username in the list
  void _updateUsername(int index) async {
    if (_controller.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _usernames[index] = _controller.text;
      await prefs.setStringList('usernames', _usernames);
      setState(() {
        _controller.clear();
      });
    }
  }

  // Delete a username from the list
  void _deleteUsername(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _usernames.removeAt(index);
    await prefs.setStringList('usernames', _usernames);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SharedPreferences CRUD Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter Username'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addUsername,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.add), Text(' Add Username')],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _usernames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_usernames[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _controller.text = _usernames[index];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Update Username'),
                                  content: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(labelText: 'New Username'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _updateUsername(index);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Update'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteUsername(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
