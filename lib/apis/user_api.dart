import 'package:babystory/models/user.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';

class UserApi {
  final HttpUtils httpUtils = HttpUtils();

  Future<User?> createUser({
    required User user,
  }) async {
    try {
      final res = await httpUtils.post(
        url: '/user/me',
        body: user.toJson(),
      );
      if (res == null || res['token'] == null) {
        debugPrint('Failed to create user');
        return null;
      }
      return User.fromJson(res['user'], jwt: res['token']['access_token']);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<User?> login({
    required String uid,
    required String email,
  }) async {
    try {
      final res = await httpUtils.post(
        url: '/user/me/login',
        body: {
          'uid': uid,
          'email': email,
        },
      );
      if (res == null || res['token'] == null) {
        debugPrint('Failed to login');
        return null;
      }
      return User.fromJson(res['user'], jwt: res['token']['access_token']);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<User?> getUser({
    required String jwt,
  }) async {
    try {
      final res = await httpUtils
          .get(url: '/user/me', headers: {'Authorization': 'Bearer $jwt'});
      if (res == null || res['user'] == null) {
        debugPrint('Failed to get user');
        return null;
      }
      return User.fromJson(res['user']);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
