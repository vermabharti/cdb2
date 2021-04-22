import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// WebView Widget

class SingleWeb extends StatefulWidget {
  final String url;
  SingleWeb({Key key, @required this.url}) : super(key: key);

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<SingleWeb> {
  bool _isLoadingPage;

  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: null,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(
            child: new WebView(
              initialUrl: '${widget.url}',
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
    );
  }
}
