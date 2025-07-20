import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model class for Post
class Post {
  final int? id;
  final String title;
  final String body;

  Post({this.id, required this.title, required this.body});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'],
      body: map['body'],
    );
  }
}

class ApiScreen extends StatefulWidget {
  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  List<Post> posts = [];
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerBody = TextEditingController();

  // Create (POST request) - Add new post
  void createPost(String title, String body) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      print('Post created: ${response.body}');
      fetchPosts(); // Reload the list after creating a post
    } else {
      print('Failed to create post. Status code: ${response.statusCode}');
    }
  }

  // Read (GET request) - Fetch posts
  void fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10'));
    if (response.statusCode == 200) {
      setState(() {
        posts = (json.decode(response.body) as List)
            .map((data) => Post.fromMap(data))
            .toList();
      });
    } else {
      print('Failed to load posts. Status code: ${response.statusCode}');
    }
  }

  // Update (PUT request) - Update post details
  void updatePost(int id, String title, String body) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 200) {
      print('Post updated: ${response.body}');
      fetchPosts(); // Reload the list after updating
    } else {
      print('Failed to update post. Status code: ${response.statusCode}');
    }
  }

  // Delete (DELETE request) - Delete post
  void deletePost(int id) async {
    final response = await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

    if (response.statusCode == 200) {
      print('Post deleted');
      fetchPosts(); // Reload the list after deleting
    } else {
      print('Failed to delete post. Status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts(); // Load posts when screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD Operations with JSONPlaceholder")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input fields for title and body
            TextField(
              controller: _controllerTitle,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controllerBody,
              decoration: InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Add Post Button
            ElevatedButton(
              onPressed: () {
                if (_controllerTitle.text.isNotEmpty && _controllerBody.text.isNotEmpty) {
                  createPost(_controllerTitle.text, _controllerBody.text);
                  _controllerTitle.clear();
                  _controllerBody.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please enter all fields."),
                  ));
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.add), Text(' Add Post')],
              ),
            ),
            SizedBox(height: 20),
            // ListView to display posts
            Expanded(
              child: posts.isEmpty
                  ? Center(child: CircularProgressIndicator()) // Show loading if empty
                  : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(posts[index].title),
                      subtitle: Text(posts[index].body),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Button
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _controllerTitle.text = posts[index].title;
                              _controllerBody.text = posts[index].body;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update Post'),
                                    content: Column(
                                      children: [
                                        TextField(
                                          controller: _controllerTitle,
                                          decoration: InputDecoration(labelText: 'Title'),
                                        ),
                                        TextField(
                                          controller: _controllerBody,
                                          decoration: InputDecoration(labelText: 'Body'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          updatePost(posts[index].id!, _controllerTitle.text, _controllerBody.text);
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
                          // Delete Button
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deletePost(posts[index].id!),
                          ),
                        ],
                      ),
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
