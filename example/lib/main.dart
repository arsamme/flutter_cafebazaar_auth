import 'package:cafebazaar_auth/cafebazaar_auth.dart';
import 'package:cafebazaar_auth/cafebazaar_login_button.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  signIn() async {
    CafeBazaarAccount? account = await CafeBazaarAuth.signIn();
    print(account?.accountID??'-');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              width: 180,
              child: CafeBazaarLoginButton(
                onPressed: signIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
