import 'package:babystory/models/user.dart';
import 'package:babystory/providers/user_provider.dart';
import 'package:babystory/services/auth.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final HttpUtils httpUtils = HttpUtils();
  final AuthServices _authServices = AuthServices();
  late User user;

  User getUserFromProvider() {
    final user = context.read<UserProvider>().user;
    if (user == null) {
      throw Exception('Parent is null');
    }
    return user;
  }

  @override
  void initState() {
    super.initState();
    user = getUserFromProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _authServices.signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(174, 204, 55, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                child: const Text(
                  '로그아웃',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
