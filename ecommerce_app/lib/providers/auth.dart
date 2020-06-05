import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';


import '../models/htttp_Exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _uId;
  DateTime expiryDate;

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
      print(json.decode(response.body));

      if (jsonDecode(response.body)['error'] != null) {
        throw HttpException(jsonDecode(response.body)['error']['message']);
      }
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
