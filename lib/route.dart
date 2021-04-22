 
import 'home.dart';
import 'package:flutter/material.dart';
import 'checkLogin.dart';
import 'login.dart';  


//Navigation Widget

final routes = {
  '/': (BuildContext context) => new IsLoggedIn(),
  '/login': (BuildContext context) => new LoginPage(),
  '/home': (BuildContext context) => new Dashboard(), 
};
