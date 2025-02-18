import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class ApiClient {
  final String _baseUrl =  
  'http://192.168.100.103:8080/api/v0';
  // 'http://172.20.10.6:8080/api/v0';
  //  'http://172.20.10.2:8080/api/v0'; // Wifi Móvil
  // 'http://192.168.0.31:8080/api/v0'; // Red

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.get(url, headers: await _authHeader());
      debugPrint("${response.headers}");
      debugPrint("${response.reasonPhrase}");
      _handleResponse(response);

      return response;
    } catch (e) {
      throw Exception('Error en GET: $e');
    }
  }

  Future<http.Response> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: _defaultHeaders(),
        body: jsonEncode(body),
      );
      debugPrint("POST request to $url with body: $body");
      debugPrint(
          "Response status: ${response.statusCode}, body: ${response.body}");
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en POST: $e');
    }
  }

  Future<http.Response> postAuth(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: await _authHeader(),
        body: jsonEncode(body),
      );
      debugPrint("POST request to $url with body: $body");
      debugPrint(
          "Response status: ${response.statusCode}, body: ${response.body}");
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en POST: $e');
    }
  }

  Future<http.Response> put(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.put(
        url,
        headers: await _authHeader(),
        body: jsonEncode(body),
      );
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en PUT: $e');
    }
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.delete(url, headers: await _authHeader());
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en DELETE: $e');
    }
  }

  Future<http.Response> patch(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.patch(
        url,
        headers: _defaultHeaders(),
        body: jsonEncode(body),
      );
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en PATCH: $e');
    }
  }

  Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode > 299) {
      throw Exception(
        'Error HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }

  Future<Map<String, String>> _authHeader() async {
    final userPreferences = UserPreferences();
    String type = await userPreferences.typeToken;
    String token = await userPreferences.token;

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$type $token',
    };
  }
}
