import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/auth.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/services/local.dart';
import 'package:logbook2electricboogaloo/services/style.dart';
import 'package:logbook2electricboogaloo/widgets/buttons.dart';
import 'package:logbook2electricboogaloo/widgets/topmenu.dart';
import 'package:logbook2electricboogaloo/widgets/scaffold.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  late StreamSubscription uidSubscription;
  late StreamSubscription userSubscription;
  UserData? user;
  Activity? activity;

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

  void setActivity(activity) async {
    if (activity.source == "isDefault") {
      addActivity(activity);
    }
    String? storedRoute = await retrieveLocal("previousRoute");
    await clearLocal("previousCentre");
    if (storedRoute is String) {
      Navigator.of(context).pushNamed("/$storedRoute", arguments: activity);
    } else {
      Navigator.of(context).pushNamed("/logbook", arguments: activity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: user == null
          ? const GeneralScaffold(
              body: CircularProgressIndicator(),
            )
          : GeneralScaffold(
              body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  TopMenu(
                    user: user!,
                    items: const [
                      SizedBox(width: 60),
                      Text("Choose Activity", textScaleFactor: 1.5),
                    ],
                  ),
                  const SizedBox(height: 20),
                  activityChoice(),
                ],
              ),
            )),
    );
  }

  Widget activityChoice() {
    return FutureBuilder<List<Activity>>(
      future: getActivities(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data!
                .map((activity) => AssetButton(
                    label: activity.name,
                    asset: () {
                      return Icon(GlobalStyle().activityIcon[activity.icon]);
                    }(),
                    onPressed: () async => setActivity(activity)))
                .toList(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
