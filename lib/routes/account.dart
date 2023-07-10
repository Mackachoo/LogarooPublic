import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/auth.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/services/style.dart';
import 'package:logbook2electricboogaloo/widgets/account/body.dart';
import 'package:logbook2electricboogaloo/widgets/buttons.dart';
import 'package:logbook2electricboogaloo/widgets/scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late StreamSubscription uidSubscription;
  late StreamSubscription userSubscription;
  UserData? user;
  bool editable = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    uidSubscription = AuthService().uidStream.listen((uid) {
      if (uid == null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/login", ModalRoute.withName(""));
      } else {
        primaryUID = uid;
        userSubscription = userStream.listen((u) {
          setState(() {
            user = u;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    uidSubscription.cancel();
    userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const GeneralScaffold(
        body: CircularProgressIndicator(),
      );
    } else {
      return GeneralScaffold(
        floatingIcon: Icons.close,
        floatingAction: () {
          Navigator.of(context).pop();
        },
        navbar: [
          editButton(context),
          shareButton(context),
          logoutButton(context),
        ],
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: AccountSettings(
              user: user!, formkey: _formkey, editable: editable),
        ),
      );
    }
  }

  AnimatedCrossFade editButton(BuildContext context) {
    // onPressed: () {
    //   if (editable) {
    //     _formkey.currentState!.save();
    //     setState(() {
    //       editable = false;
    //     });
    //   } else {
    //     setState(() {
    //       editable = true;
    //     });
    //   }
    // },
    return AnimatedCrossFade(
      crossFadeState:
          editable ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: GlobalStyle().animationDuration,
      firstChild: MenuButton(
        icon: Icons.edit,
        label: "Edit",
        onPressed: () {
          setState(() {
            editable = true;
          });
        },
      ),
      secondChild: MenuButton(
          icon: Icons.save,
          label: "Save",
          onPressed: () {
            _formkey.currentState!.save();
            setState(() {
              editable = false;
            });
          }),
    );
  }

  MenuButton shareButton(BuildContext context) {
    return MenuButton(
        icon: Icons.share,
        label: "Share",
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            width: 300,
            shape: StadiumBorder(),
            content: Text('Public profiles currently in development',
                textAlign: TextAlign.center),
            behavior: SnackBarBehavior.floating,
          ));
        });
  }

  MenuButton logoutButton(BuildContext context) {
    return MenuButton(
        icon: Icons.logout,
        label: "Logout",
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove("activity");
          await _auth.signOut();
        });
  }
}
