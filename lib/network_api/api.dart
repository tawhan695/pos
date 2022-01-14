import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pos/screen/sale_wholosale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  // final String _url = 'https://mtn.tawhan-studio.com/api';
  final String _url = 'https://tawhan.xyz/api';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    token = jsonDecode(localStorage.getString('token').toString());
  }
 
  logOut() async {
    await getData2('/logout');
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    var token2 = jsonDecode(pref.getString('token').toString());
    print(token2);
   
    if (token2 !=null) {
      return false;
    } else {
      return true;
    }

  }

  authData(data, apiUrl) async { // post
    try {
      var fullUrl = _url + apiUrl;
      return await http.post(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaders());
    } on TimeoutException catch (_) {
      print('error');
      print(_);
      return 'error';
    } on SocketException catch (_) {
      print('error');
      print(_);
      return 'error';
    }
  }

  getData(data, apiUrl) async { // post
    try {
      var fullUrl = _url + apiUrl;
      await _getToken();
      return await http.post(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaders());
    } on TimeoutException catch (_) {
      print('error');
      print(_);
      return 'error';
    } on SocketException catch (_) {
      print('error');
      print(_);
      return 'error';
    }
  }

  getData2(apiUrl) async { //post
    try {
      var fullUrl = _url + apiUrl;
      await _getToken();
      return await http.post(Uri.parse(fullUrl), headers: _setHeaders());
    } on TimeoutException catch (_) {
      print('error');
      print(_);
      return 'error';
    } on SocketException catch (_) {
      print('error');
      print(_);
      return 'error';
    }
  }

  getData3(apiUrl) async { //get
    try {
      var fullUrl = _url + apiUrl;
      await _getToken();
      return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
    } on TimeoutException catch (_) {
      print('error');
      print(_);
      return 'error';
    } on SocketException catch (_) {
      print('error');
      print(_);
      return 'error';
    }
  }

  getDataEmpty(apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
      await _getToken();
      return await http.delete(Uri.parse(fullUrl), headers: _setHeaders());
    } on TimeoutException catch (_) {
      print('error');
      print(_);
      return 'error';
    } on SocketException catch (_) {
      print('error');
      print(_);
      return 'error';
    }
  }

  getDataDelete(data, apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
      await _getToken();
      return await http.delete(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaders());
    } on TimeoutException catch (_) {
      print('error');
      print(_);
      return 'error';
    } on SocketException catch (_) {
      print('error');
      print(_);
      return 'error';
    }
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Retry-After': '3600',
      };
}



// class APIService {
//   Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
//     final String url = "https://reqres.in/api/login";

//     var url2 = url;
//     final response = await http.post(url2, body: requestModel.toJson());
//     if (response.statusCode == 200 || response.statusCode == 400) {
//       return LoginResponseModel.fromJson(
//         json.decode(response.body),
//       );
//     } else {
//       throw Exception('Failed to load data!');
//     }
//   }
// }