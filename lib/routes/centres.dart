import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/auth.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/services/local.dart';
import 'package:logbook2electricboogaloo/widgets/buttons.dart';
import 'package:logbook2electricboogaloo/widgets/centres/createcentre.dart';
import 'package:logbook2electricboogaloo/widgets/centres/centreschoice.dart';
import 'package:logbook2electricboogaloo/widgets/topmenu.dart';
import 'package:logbook2electricboogaloo/widgets/scaffold.dart';

// This page gives the user a list of centres to choose from

class Centres extends StatefulWidget {
  final Activity activity;
  const Centres({super.key, required this.activity});

  @override
  State<Centres> createState() => _CentresState();
}

class _CentresState extends State<Centres> {
  late StreamSubscription uidSubscription;
  late StreamSubscription userSubscription;
  UserData? user;

  @override
  void initState() {
    super.initState();

    //Checks user is logged in and gets user data
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
    return user == null
        ? const GeneralScaffold(
            body: CircularProgressIndicator(),
          )
        : GeneralScaffold(
            floatingIcon: Icons.monitor_heart_outlined,
            floatingAction: () {
              storeLocal("previousRoute", "manifest");
              Navigator.of(context).pushNamed("/activities");
            },
            navbar: [logbookButton()],
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  TopMenu(
                    user: user!,
                    items: [
                      CreateCentreButton(
                          uid: user!.uid, activity: widget.activity),
                      Text("Choose ${widget.activity.centre}",
                          textScaleFactor: 1.5),
                    ],
                  ),
                  CentreChoice(user: user!, activity: widget.activity)
                ],
              ),
            ),
          );
  }

  MenuButton logbookButton() => MenuButton(
        label: "Logbook",
        icon: Icons.web_stories,
        onPressed: () {
          Navigator.of(context)
              .pushNamed("/logbook", arguments: widget.activity);
        },
      );
}
