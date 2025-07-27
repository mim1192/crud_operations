import 'package:crud_operations/shared_preferences_screen.dart';
import 'package:crud_operations/sqlite_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'api_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/sqlite': (context) => SQLiteScreen(),
        '/sharedpreferences': (context) => SharedPreferencesScreen(),
        '/api': (context) => ApiScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔐 FCM Token: $token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter CRUD App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await Firebase.initializeApp();

                getToken(); // First call
                Navigator.pushNamed(context, '/sqlite'); // Then navigate
              },
              child: Text("SQLite CRUD Operations"),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/sharedpreferences'),
              child: Text("SharedPreferences Example"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/api'),
              child: Text("Free API CRUD Operations"),
            ),
          ],
        ),
      ),
    );
  }
}
