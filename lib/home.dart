import 'dart:convert';
import 'dart:core';
import 'package:cdb/jitsi.dart';
import 'package:cdb/menu.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'basicAuth.dart';

class _MyColor {
  const _MyColor(this.color, this.name);

  final Color color;
  final String name;
}

class Dashboard extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<Dashboard> {
  String _id;
  String _name;


// Get Menu Dashboard 
  Future<List<dynamic>> _getMainMenu() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _id = (prefs.getString('username') ?? "");
      print(_id);
      _name = (prefs.getString('uname') ?? "");
      final formData = jsonEncode({
        "primaryKeys": ['$_id']
      });
      Response response =
          await ioClient.post(MENU_URL, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> userid = list["dataValue"];
        return userid;
      } else {
        throw Exception('Failed to load Menu');
      }
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xffffffff),
              title: Text("Please Check your Internet Connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff000000))),
            );
          });
    }
  }
// Get Icon 
  IconData getIconForName(String iconName) {
    switch (iconName) {
      case 'chartBar':
        {
          return FontAwesomeIcons.chartBar;
        }
        break;
      case 'chartArea':
        {
          return FontAwesomeIcons.chartArea;
        }
        break;
      case 'chartPie':
        {
          return FontAwesomeIcons.chartPie;
        }
        break;
      case 'chartLine':
        {
          return FontAwesomeIcons.chartLine;
        }
        break;
      default:
        {
          return FontAwesomeIcons.chartArea;
        }
    }
  }

  var colors = [
    LinearGradient(colors: [Colors.amber, Colors.amber.withOpacity(.7)]),
    LinearGradient(colors: [Colors.cyan, Colors.cyan.withOpacity(.7)]),
    LinearGradient(colors: [Colors.green, Colors.green.withOpacity(.7)]),
    LinearGradient(
        colors: [Colors.redAccent, Colors.redAccent.withOpacity(.7)]),
    LinearGradient(
        colors: [Colors.deepPurple, Colors.deepPurple.withOpacity(.7)]),
    LinearGradient(colors: [Colors.grey, Colors.grey.withOpacity(.7)])
  ];

  @override
  void initState() {
    super.initState();

    setState(() {
      loadUsername();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMainMenu();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString('uname') ?? "");
      print('rolename == $_name');
    });
  }

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          "Welcome $_name",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.video_call), onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyJitsiMeet()),
          );
          }),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("username");
              prefs.remove("password");
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Text(
                "Central dashboard Reports",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              new FutureBuilder(
                  future: _getMainMenu(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return new Center(
                        child: new Column(
                          children: <Widget>[
                            new Padding(padding: new EdgeInsets.all(50.0)),
                            new Center(
                              child: CircularProgressIndicator(),
                            )
                          ],
                        ),
                      );
                    } else if (snapshot.data.length == 0) {
                      return Text("No Data found",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                              fontSize: 26));
                    } else {
                      List<dynamic> posts = snapshot.data;
                      int i =  colors.length  ; 
                      return SizedBox(
                          height: 800,
                          child: ListView(
                              shrinkWrap: true,
                              reverse: false,
                              controller: _scrollController,
                              children: posts.map((value) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainMenu(id: value[0], title: value[1])),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: colors[1],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(children: [
                                              Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: FaIcon(
                                                      getIconForName(value[3]),
                                                      color:
                                                          Color(0xffffffff))),
                                              Text(
                                                value[1],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ]),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "click for more details ->",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              }).toList()));
                    }
                  })

              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.all(5),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       gradient: LinearGradient(
              //           colors: [Colors.cyan, Colors.cyan.withOpacity(.7)])),
              //   child: Padding(
              //     padding: EdgeInsets.all(20.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Row(children: [
              //           Icon(Icons.pie_chart, color: Colors.white, size: 30),
              //           Text(
              //             " Report Set",
              //             style: TextStyle(color: Colors.white, fontSize: 18),
              //           ),
              //         ]),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           "click for more details ->",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 15,
              //               fontWeight: FontWeight.w100),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.all(5),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       gradient: LinearGradient(
              //           colors: [Colors.green, Colors.green.withOpacity(.7)])),
              //   child: Padding(
              //     padding: EdgeInsets.all(20.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Row(children: [
              //           Icon(Icons.pie_chart, color: Colors.white, size: 30),
              //           Text(
              //             " Admin Dashboard (UAT Dsahboard)",
              //             style: TextStyle(color: Colors.white, fontSize: 18),
              //           ),
              //         ]),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           "click for more details ->",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 15,
              //               fontWeight: FontWeight.w100),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.all(5),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       gradient: LinearGradient(colors: [
              //         Colors.redAccent,
              //         Colors.redAccent.withOpacity(.7)
              //       ])),
              //   child: Padding(
              //     padding: EdgeInsets.all(20.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Row(children: [
              //           Icon(Icons.pie_chart, color: Colors.white, size: 30),
              //           Text(
              //             " Stockout V 2.0",
              //             style: TextStyle(color: Colors.white, fontSize: 18),
              //           ),
              //         ]),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           "click for more details ->",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 15,
              //               fontWeight: FontWeight.w100),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.all(5),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       gradient: LinearGradient(colors: [
              //         Colors.deepPurple,
              //         Colors.deepPurple.withOpacity(.7)
              //       ])),
              //   child: Padding(
              //     padding: EdgeInsets.all(20.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Row(children: [
              //           Icon(Icons.pie_chart, color: Colors.white, size: 30),
              //           Text(
              //             " Admin New",
              //             style: TextStyle(color: Colors.white, fontSize: 18),
              //           ),
              //         ]),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           "click for more details ->",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 15,
              //               fontWeight: FontWeight.w100),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.all(5),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       gradient: LinearGradient(
              //           colors: [Colors.grey, Colors.grey.withOpacity(.7)])),
              //   child: Padding(
              //     padding: EdgeInsets.all(20.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Row(children: [
              //           Icon(Icons.pie_chart, color: Colors.white, size: 30),
              //           Text(
              //             " Job Dashboard",
              //             style: TextStyle(color: Colors.white, fontSize: 18),
              //           ),
              //         ]),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           "click for more details ->",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 15,
              //               fontWeight: FontWeight.w100),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      )),
    );
  }
}
