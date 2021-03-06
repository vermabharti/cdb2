import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsLoggedIn extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<IsLoggedIn> {
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  //ISLoggedIn Method

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = (prefs.getString('username') ?? "");
    if (_username == "") {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/home'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
