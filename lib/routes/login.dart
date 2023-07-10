import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/auth.dart';
import 'package:logbook2electricboogaloo/widgets/scaffold.dart';
import 'package:logbook2electricboogaloo/widgets/login/emailpassword.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late StreamSubscription uidSubscription;

  @override
  void initState() {
    super.initState();

    //Checks user is logged in and gets user data
    uidSubscription = AuthService().uidStream.listen((uid) {
      if (uid != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/activities", ModalRoute.withName(""));
      }
    });
  }

  @override
  void dispose() {
    uidSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const GeneralScaffold(body: EmailPasswordLogin()),
    );
  }
}
