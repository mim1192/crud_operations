
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class ApiScreen extends StatefulWidget {
  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  void createPost(User user) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(user.toMap()),
    );
    print('Response: ${response.body}');
  }

  void getPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  void updatePost(User user) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(user.toMap()),
    );
    print('Response: ${response.body}');
  }

  void deletePost() async {
    final response = await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    print('Response: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Free API CRUD Operations")),
      body: Column(
        children: [
          ElevatedButton(onPressed: () => createPost(User(title: 'New Post', body: 'This is the body of the post.', userId: 1)), child: Text("Create Post")),
          ElevatedButton(onPressed: getPosts, child: Text("Get Posts")),
          ElevatedButton(onPressed: () => updatePost(User(title: 'Updated Post', body: 'Updated body content.', userId: 1)), child: Text("Update Post")),
          ElevatedButton(onPressed: deletePost, child: Text("Delete Post")),
        ],
      ),
    );
  }
}
