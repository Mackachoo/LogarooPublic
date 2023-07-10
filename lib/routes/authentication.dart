import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/auth.dart';
import 'package:logbook2electricboogaloo/widgets/scaffold.dart';

class AuthenticationRoute extends StatefulWidget {
  const AuthenticationRoute({Key? key}) : super(key: key);

  @override
  State<AuthenticationRoute> createState() => _AuthenticationRouteState();
}

class _AuthenticationRouteState extends State<AuthenticationRoute> {
  late StreamSubscription uidSubscription;

  @override
  void initState() {
    super.initState();
    uidSubscription = AuthService().uidStream.listen((uid) {
      if (uid == null) {
        Navigator.of(context).pushNamed('/login');
      } else {
        Navigator.of(context).pushNamed('/activities');
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
    return const GeneralScaffold(
      body: kDebugMode
          ? Text("Debug Mode: Loading...")
          : CircularProgressIndicator(),
    );
  }
}
