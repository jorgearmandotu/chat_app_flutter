import 'dart:convert';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../global/environment.dart';

class AuthService with ChangeNotifier {

  Usuario? usuario;
  bool _autenticando = false;
  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando( bool value ){
    _autenticando = value;
    notifyListeners();
  }

  // Getters del token estaticos
  static  Future<String> getToken() async {
    const storage =   FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if(token != null){
    return token;
    }
    else{
      return '';
    }
  }

  static Future<void> deleteToken() async {
    const  storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  
  Future<bool> login( String email, String password ) async {

    autenticando = true;

    final data = {
      'email': email,
      'password': password,
    };

    final resp = await http.post(Uri.parse('${ Environment.apiUrl }/login'),
    body: jsonEncode(data),
    headers: {
      'Content-Type': 'application/json'
    });
    autenticando = false;
    if( resp.statusCode == 200){
      final loginResponse = loginResponseFromJson( resp.body);
      usuario = loginResponse.usuario;

      await  _guardarToken( loginResponse.token );
      return true;
    }else{
      return false;
    }
  }

  Future register( String nombre, String email, String Password ) async {

    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': Password,
    };

    final resp = await http.post(Uri.parse('${ Environment.apiUrl }/login/new'),
    body: jsonEncode(data),
    headers: {
      'Content-Type': 'application/json' 
    });

    autenticando = false;

    if( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      await _guardarToken( loginResponse.token );
      return true;
    }else{
      final respBody = jsonDecode( resp.body );
      return respBody['msg'];
    }
  }

  Future<bool?> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final resp = await http.get(Uri.parse('${ Environment.apiUrl }/login/renew'),
    headers: {
      'Contenr-Type' : 'application/json',
      'x-token': (token != null) ? token : '',
     }
    );

    
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    }else{
      logout();
      return false;
    }

  }

  Future _guardarToken( String token ) async{
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}