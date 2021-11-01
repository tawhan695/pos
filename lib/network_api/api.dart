
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pos/screen/sale_wholosale.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Network{
  // final String _url = 'https://mtn.tawhan-studio.com/api';
  final String _url = 'http://192.168.30.155/mtn-tawhan/public/api';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
  
    token = jsonDecode(localStorage.getString('token').toString());   
  }

  authData(data, apiUrl) async {
   try {
      var fullUrl = _url + apiUrl;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
   } catch (e) {
     print(e);
   }
  }
  getData(data,apiUrl) async {
   try {
      var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
   } catch (e) {
      print(e);
      return 'error';
   }
  }
  getData2(apiUrl) async {
   try {
      var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.post(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
   } catch (e) {
      print(e);
      return 'error';
   }
  }
  getData3(apiUrl) async {
    try {
         var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
    } catch (e) {
       print(e);
       return 'error';
    }
 
  }
  getDataEmpty(apiUrl) async {
   try {
      var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.delete(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
   } catch (e) {
      print(e);
      return 'error';
   }
  }
  getDataDelete(data,apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.delete(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
    } catch (e) {
       print(e);
       return 'error';
    }
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token',
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