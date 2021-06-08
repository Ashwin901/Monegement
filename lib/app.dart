import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'screens/landing_screen.dart';

class StartApp extends StatefulWidget {
  @override
  _StartAppState createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('transactions'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              ),
            );
          } else {
            return LandingScreen();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
