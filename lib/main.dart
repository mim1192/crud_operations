
import 'package:flutter/material.dart';
import 'screens/sqlite_screen.dart';
import 'screens/shared_preferences_screen.dart';
import 'screens/api_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter CRUD App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/sqlite'),
              child: Text("SQLite CRUD Operations"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/sharedpreferences'),
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
