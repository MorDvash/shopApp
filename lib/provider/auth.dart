import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/httpException.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTime;

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token as String;
    }
    return '';
  }

  String get userId {
    return _userId as String;
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
      final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode({
      //   'token': _token,
      //   'userId': _userId,
      //   'expiryDate': _expiryDate!.toIso8601String()
      // });
      final token = json.encode(_token);
      final userId = json.encode(_userId);
      // final expiryDate = json.encode(_expiryDate);
      prefs.setString('token', token);
      prefs.setString('userId', userId);
      // prefs.setString('expiryDate', expiryDate);
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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return false;
    }
    print('got here');
    final extractedToken = json.decode(prefs.getString('token') as String);
    final extractedUserId = json.decode(prefs.getString('userId') as String);
    // final extractedExpiryDate = json.decode(prefs.getString('expiryDate') as String);
    print('got here111');
    // final expiryDate =
    //     DateTime.parse(extractedExpiryDate as String);

    // if (expiryDate.isBefore(DateTime.now())) {
    //   return false;
    // }
    _token = extractedToken as String;
    _userId = extractedUserId as String;
    // _expiryDate = expiryDate;
    // notifyListeners();
    // autoLogOut();
    return true;
  }

  void autoLogOut() {
    if (_authTime != null) {
      _authTime?.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpiry as int), logOut);
  }
}
