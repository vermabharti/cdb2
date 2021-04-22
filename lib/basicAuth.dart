import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

//Basic Authentication Method
String mobileusername = 'mobileUser';
String mobilepassword = 'mob123';
String basicAuth =
    'Basic ' + base64Encode(utf8.encode('$mobileusername:$mobilepassword'));
Map<String, String> headers = {
  'content-type': 'text/plain',
  'authorization': basicAuth
};

// SSL certification
bool trustSelfSigned = true;
HttpClient httpClient = new HttpClient()
  ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
IOClient ioClient = new IOClient(httpClient);

//BASE_URL
const BASE_URL = 'https://cdashboard.dcservices.in';

//LOGIN_WEB_SERVICE
const LOGIN_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/DashboardUserAuthentication';

//MAIN_MENU_WEB_SERVICE
const MENU_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/MobileAppMenuService';

//SUB_MENU_WEB_SERVICE
const SUB_MENU_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/MobileAppSubMenuService';

//SUB_MENU_WEBVIEW_WEB_SERVICE
const SUPER_MENU_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/MobileAppLeafMenuService';

// EDL_CHART_WEB_SERVICE
const EDL_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/StatewiseEDLCount';
