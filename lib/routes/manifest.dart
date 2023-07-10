import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/auth.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/firestore/centre.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/services/local.dart';
import 'package:logbook2electricboogaloo/widgets/buttons.dart';
import 'package:logbook2electricboogaloo/widgets/manifest/adminbutton.dart';
import 'package:logbook2electricboogaloo/widgets/topmenu.dart';
import 'package:logbook2electricboogaloo/widgets/scaffold.dart';

class Manifest extends StatefulWidget {
  final Activity activity;
  const Manifest({super.key, required this.activity});

  @override
  State<Manifest> createState() => ManifestState();
}

class ManifestState extends State<Manifest> {
  late StreamSubscription uidSubscription;
  late StreamSubscription userSubscription;
  late StreamSubscription centreSubscription;
  UserData? user;
  Centre? centre;

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
        getCentre(checkLocal: true);
      }
    });
  }

  @override
  void dispose() {
    uidSubscription.cancel();
    userSubscription.cancel();
    centreSubscription.cancel();
    super.dispose();
  }

  Future getCentre({bool checkLocal = false}) async {
    late String cid;
    String? storedCentre = await retrieveLocal("previousCentre");
    if (checkLocal && storedCentre is String) {
      cid = storedCentre;
    } else {
      cid = await Navigator.of(context)
          .pushNamed("/centres", arguments: widget.activity) as String;
    }
    centreSubscription = centreStream(cid).listen((c) {
      setState(() {
        centre = c;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || centre == null) {
      return const GeneralScaffold(
        body: CircularProgressIndicator(),
      );
    } else {
      return GeneralScaffold(
        floatingIcon: Icons.monitor_heart_outlined,
        floatingAction: () {
          storeLocal("previousRoute", "manifest");
          Navigator.of(context).pushNamed("/activities");
        },
        navbar: [logbookButton(), centreButton(), placeholderButton()],
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(children: [
            TopMenu(user: user!, items: [
              AdminButton(centre: centre!, uid: user!.uid),
              title(centre!.name)
            ]),
          ]),
        ),
      );
    }
  }

  Widget title(String name) => ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
        child: Text(
          name,
          textScaleFactor: 1.0,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  MenuButton logbookButton() => MenuButton(
        label: "Logbook",
        icon: Icons.web_stories,
        onPressed: () {
          Navigator.of(context)
              .pushNamed("/logbook", arguments: widget.activity);
        },
      );

  MenuButton centreButton() => MenuButton(
        label: widget.activity.centre,
        icon: Icons.flag_circle_outlined,
        onPressed: () async {
          await clearLocal("previousCentre");
          setState(() {});
          getCentre();
        },
      );

  MenuButton placeholderButton() => MenuButton(
        label: "TBD",
        icon: Icons.question_mark_outlined,
        onPressed: () {},
      );
}
