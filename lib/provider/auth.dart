import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/httpException.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  Future<void> authReq(String email, String password, String urlString) async {
    final url = Uri.parse(urlString);
    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final resData = jsonDecode(res.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> signUp(String email, String password) async {
    return authReq(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAkjCpvaGVt7AnjslMgBLQra3KM7ssCP4E');
  }

  Future<void> signIn(String email, String password) async {
    return authReq(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAkjCpvaGVt7AnjslMgBLQra3KM7ssCP4E');
  }
}
