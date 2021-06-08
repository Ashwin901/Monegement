import 'package:flutter/material.dart';

final lightThemeData = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.amber,
  primaryColor: Color(0xff5200BA),
  fontFamily: "Ubuntu",
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.white, unselectedItemColor: Colors.white),
  scaffoldBackgroundColor: Colors.white,
  primaryIconTheme: IconThemeData(color: Colors.white),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  cardColor: Colors.white,
  textTheme: TextTheme(
    headline1: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
    headline2: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
    headline3: TextStyle(color: Colors.black, fontSize: 16),
  ),
  iconTheme: IconThemeData(color: Colors.black),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(
        EdgeInsets.only(top: 10),
      ),
      textStyle: MaterialStateProperty.all(
        TextStyle(color: Colors.blue),
      ),
    ),
  ),
);

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.amber,
  primaryColor: Color(0xff5200BA),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.white, unselectedItemColor: Colors.white),
  scaffoldBackgroundColor: Color(0xff12051F),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.amber,
  ),
  iconTheme: IconThemeData(color: Colors.white),
  primaryIconTheme: IconThemeData(color: Colors.black),
  fontFamily: "Ubuntu",
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  cardColor: Color(0xff180B25),
  textTheme: TextTheme(
    headline1: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
    headline2: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
    headline3: TextStyle(color: Colors.white, fontSize: 16),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(
        EdgeInsets.only(top: 10),
      ),
      textStyle: MaterialStateProperty.all(
        TextStyle(color: Colors.blue),
      ),
    ),
  ),
);
