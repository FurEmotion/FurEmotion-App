import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart'; // For basename
import 'package:http_parser/http_parser.dart'; // For MediaType

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpUtils {
  late String baseroot;

  HttpUtils() {
    baseroot = dotenv.env['API_BASE_ROOT'] ?? '';
  }

  Future<dynamic> get({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? querys,
  }) async {
    headers ??= {};
    querys ??= {};
    try {
      var uri = Uri.parse('$baseroot$url').replace(queryParameters: querys);
      print("Request: $uri");
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...headers,
      });
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      debugPrintStack();
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> post({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    headers ??= {};
    body ??= {};
    try {
      var uri = Uri.parse('$baseroot$url');
      print("Request URL: $baseroot$url");
      print("Request Body: $body");
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // HttpHeaders.acceptCharsetHeader: 'utf-8',
            ...headers,
          },
          body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> put({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    headers ??= {};
    body ??= {};
    try {
      var uri = Uri.parse('$baseroot$url');
      final response = await http.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // HttpHeaders.acceptCharsetHeader: 'utf-8',
            ...headers,
          },
          body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> delete({
    required String url,
    Map<String, String>? headers,
  }) async {
    headers ??= {};
    try {
      var uri = Uri.parse('$baseroot$url');
      print("Request URL: $baseroot$url");
      final response = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...headers,
      });
      if (response.statusCode == 200 || response.statusCode == 204) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> postMultipart({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? fields,
    required String? filePath,
  }) async {
    fields ??= {};
    try {
      var uri = Uri.parse('$baseroot$url');

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Accept': 'application/json',
          ...?headers,
        })
        ..fields.addAll(fields);

      if (filePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', filePath),
        );
      }

      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        return jsonDecode(responseData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> postMultiImages({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? fields,
    required List<File> images,
  }) async {
    headers ??= {};
    fields ??= {};

    try {
      var uri = Uri.parse('$baseroot$url');

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Accept': 'application/json',
          ...headers,
        })
        ..fields.addAll(fields);

      for (int i = 0; i < images.length; i++) {
        var stream = http.ByteStream(images[i].openRead());
        var length = await images[i].length();
        request.files.add(
          http.MultipartFile('fileList', stream, length,
              filename: basename(images[i].path),
              contentType: MediaType('image', images[i].path.split('.').last)),
        );
      }

      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        return jsonDecode(responseData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
