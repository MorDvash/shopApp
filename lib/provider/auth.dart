import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/httpException.dart';

class Auth with ChangeNotifier {
  late String _token;
  DateTime? _expiryDate;
  late String _userId;
  Timer? _authTime;

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return '';
  }

  String get userId {
    return _userId;
  }

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
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            resData['expiresIn'],
          ),
        ),
      );
      autoLogOut();
      notifyListeners();
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

  void logOut() {
    _token = '';
    _userId = '';
    _expiryDate = null;
    if (_authTime != null) {
      _authTime?.cancel();
      _authTime = null;
    }
    notifyListeners();
  }

  void autoLogOut() {
    if (_authTime != null) {
      _authTime?.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpiry as int), logOut);
  }
}
