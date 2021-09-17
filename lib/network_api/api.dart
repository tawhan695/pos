import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network{
  final String _url = 'https://mtn.tawhan-studio.com/api';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
  
    token = jsonDecode(localStorage.getString('token').toString());
    print('token is $token');
  }
  
  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }
  getData(data,apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }
  getData2(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.post(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
  }
  getData3(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token',
    // 'Authorization' : 'Bearer 2|9ILdVoh0G1mtarawr14wRWk4VHrggPhzfT91f8IN'
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