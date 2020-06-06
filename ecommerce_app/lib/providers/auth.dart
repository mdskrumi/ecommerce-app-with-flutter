import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/htttp_Exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _uId;
  DateTime _expiryDate;

  bool isAuth(){
    return token != null;
  }

  String get userId => _uId;

  String get token {
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String pass, String urlSegment) async {
    email = email.replaceAll(" ", '');
    print(email + " \n" + pass);

    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBQz0JKGkWZs6WHa4xchWJUdZwmBL4FprY";

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': pass,
          'returnSecureToken': true,
        }),
      );
      if (jsonDecode(response.body)['error'] != null) {
        throw HttpException(jsonDecode(response.body)['error']['message']);
      }
      final responseData = json.decode(response.body);
      _token = responseData['idToken'];
      _uId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      print("User: " + _uId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String pass) async {
    return _authenticate(email, pass, 'signUp');
  }

  Future<void> logIn(String email, String pass) async {
    return _authenticate(email, pass, 'signInWithPassword');
  }
}
