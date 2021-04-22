import 'dart:async';
import 'dart:convert';

import 'package:cdb/web.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'basicAuth.dart';

class MainMenu extends StatefulWidget {
  final String title;
  final String id;
  MainMenu({Key key, @required this.id, @required this.title})
      : super(key: key);
  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<MainMenu> { 


// Dynamic Main Menu Method
  Future<List<dynamic>> _fetchSubMenu() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final formData = jsonEncode({
        "primaryKeys": ["${widget.id}"]
      });
      Response response =
          await ioClient.post(SUB_MENU_URL, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> listid = list["dataValue"];
        List menuid = listid.map((f) {
          return f[0];
        }).toList();
        print('menuid $menuid');
        List submenuid = listid.map((f) {
          return f[1];
        }).toList();
        print('menuid $submenuid');
        return listid;
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


//  Dynamic SubMenu Fetch Method
  Future<List<dynamic>> _fetchSuperMenu() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final formData = jsonEncode({
        "primaryKeys": ["363003000000", "10"]
      });
      // print(key);
      Response response =
          await ioClient.post(SUPER_MENU_URL, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> listid = list["dataValue"];
        return listid;
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

  bool isLoading = true; 
 bool _isLoadingPage;

  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Dashboard'),
      ),
      body: 
      Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(
            // WebView Screen
            child: new WebView(
              initialUrl:
            'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mw==&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1',
              // initialUrl: '$defaulturl',
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
          _isLoadingPage
              ? Center(child: CircularProgressIndicator())
              : Container(
                  color: Color(0xffffffff),
                ),
        ],
      ),
      // WebView(
      //   initialUrl:
      //       'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mw==&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1',
      //   // initialUrl: '$defaulturl',
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
      // drawer: Drawer(
      //     child: Column(children: [
      //   Container(
      //     width: MediaQuery.of(context).size.width * 0.85,
      //     height: 120,
      //     child: DrawerHeader(
      //       decoration: BoxDecoration(color: Color(0xffc6446e)),
      //       child: Text("${widget.title}",
      //           style: TextStyle(
      //               color: Colors.white,
      //               fontFamily: 'Open Sans',
      //               fontWeight: FontWeight.w600,
      //               fontSize: 18)),
      //     ),
      //   ),
      //   Expanded(
      //       flex: 1,
      //       child: new FutureBuilder(
      //           future: _fetchSubMenu(),
      //           builder: (BuildContext context, AsyncSnapshot snapshot) {
      //             if (!snapshot.hasData || snapshot.data == null) {
      //               return new Center(
      //                 child: new Column(
      //                   children: <Widget>[
      //                     new Padding(padding: new EdgeInsets.all(50.0)),
      //                     new Center(child: CircularProgressIndicator())
      //                   ],
      //                 ),
      //               );
      //             } else if (snapshot.data.length == 0) {
      //               return Text("No Data found",
      //                   textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontFamily: 'Open Sans',
      //                       fontWeight: FontWeight.w600,
      //                       fontSize: 26));
      //             } else {
      //               List<dynamic> posts = snapshot.data;
      //               return Container(
      //                   child: ListView(
      //                       children: posts.map((e) {
      //                 // var selected;
      //                 return ExpansionTile(
      //                   // key: Key(e[0].toString()),
      //                   // initiallyExpanded: e == selected,
      //                   title: Text(e[2]),
      //                   // onExpansionChanged: selectedComtactData,
      //                   // onExpansionChanged: ((newState) {
      //                   //   if (newState)
      //                   //     setState(() {
      //                   //       selected = e;
      //                   //       print('object $e');
      //                   //     });
      //                   //   else
      //                   //     setState(() {
      //                   //       selected = 0;
      //                   //     });
      //                   // }),
      //                   children: [
      //                     new FutureBuilder(
      //                         future: _fetchSuperMenu(),
      //                         builder: (BuildContext context,
      //                             AsyncSnapshot<List<dynamic>> snapshot) {
      //                           if (!snapshot.hasData ||
      //                               snapshot.data == null) {
      //                             return new Center(
      //                               child: new Column(
      //                                 children: <Widget>[
      //                                   new Padding(
      //                                       padding: new EdgeInsets.all(50.0)),
      //                                   new Container(
      //                                       width: 100,
      //                                       height: 100,
      //                                       child: Image(
      //                                           image: new AssetImage(
      //                                               "assets/images/progress3.gif"))),
      //                                 ],
      //                               ),
      //                             );
      //                           } else if (snapshot.data.length == 0) {
      //                             print(snapshot.data.length);
      //                             return Text("No Data found",
      //                                 textAlign: TextAlign.center,
      //                                 style: TextStyle(
      //                                     color: Colors.black,
      //                                     fontFamily: 'Open Sans',
      //                                     fontWeight: FontWeight.w600,
      //                                     fontSize: 26));
      //                           } else {
      //                             List<dynamic> posts1 = snapshot.data;
      //                             return SizedBox(
      //                               height: 500,
      //                               child: ListView(
      //                                 children: posts1.map((item) {
      //                                   return GestureDetector(
      //                                       onTap: () {
      //                                         Navigator.push(
      //                                           context,
      //                                           MaterialPageRoute(
      //                                               builder: (context) =>
      //                                                   SingleWeb()),
      //                                         );
      //                                       },
      //                                       child: Container(
      //                                           alignment: Alignment.topLeft,
      //                                           padding: EdgeInsets.all(10),
      //                                           child: Text(
      //                                             item[0],
      //                                             textAlign: TextAlign.right,
      //                                             style: TextStyle(
      //                                               fontSize: 15,
      //                                               color: Color(0xff2c003e),
      //                                               fontFamily: 'Open Sans',
      //                                             ),
      //                                           )));
      //                                 }).toList(),
      //                               ),
      //                             );
      //                           }
      //                         })
      //                   ],
      //                 );
      //               }).toList()));
      //             }
      //           })),
      // ])),
      // 
      // SideBar Drawer
        drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child:
        ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height:100,
              child: DrawerHeader(
              child: Text('Dashboard'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            )),


      // Expandable ListViews 
          ExpansionTile(
            title: Text("Central Dashboard"),
            children: <Widget>[
              GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjE=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },
              child:Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child:
                                                  Text(
                                                    'EDL Report',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),
                                                  GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjI=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },
                                             child:     Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Rate Contract',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),

                                                  GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjM=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },child:Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Demand & Procurement State',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),

                                                 GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjQ=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Common Essential Drugs',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),
                                                                                 GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjU=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Drugs Expiry Details',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),
                                                                                 GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDM=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Stock Details',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),
                                                                                          GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjc=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'State wise RC Expiry Details',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),
                                                                                          GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjg=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Drugs Excess/Shortage',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),
                                                                                          GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjk=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Stock Out Detail V 2.0 old',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),
                                                                                          GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDI=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'User Detail',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  ))),
                                                                                GestureDetector(
                onTap: (){
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWeb(url :'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDE=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1')),
                );
                },child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Facility Details',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff2c003e),
                                                      fontFamily: 'Open Sans',
                                                    ),
                                                  )))
                                                  ],
          )
        ,
            ListTile(
              title: Text('Maternal Healt Dashboard'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('CMSS Dashboard'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
             ListTile(
              title: Text('Family Planning Dashboard'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Monthly State Rank'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
