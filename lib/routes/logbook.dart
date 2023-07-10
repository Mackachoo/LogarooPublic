import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/local.dart';
import 'package:logbook2electricboogaloo/services/auth.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/widgets/buttons.dart';
import 'package:logbook2electricboogaloo/widgets/logbook/grid.dart';
import 'package:logbook2electricboogaloo/widgets/logbook/menu.dart';
import 'package:logbook2electricboogaloo/widgets/scaffold.dart';
import 'package:logbook2electricboogaloo/widgets/logbook/templatesheet.dart';

class Logbook extends StatefulWidget {
  final Activity activity;
  const Logbook({super.key, required this.activity});

  @override
  State<Logbook> createState() => LogbookState();
}

class LogbookState extends State<Logbook> {
  late StreamSubscription uidSubscription;
  late StreamSubscription userSubscription;
  final GlobalKey<ScaffoldState> sheetKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? sheetController;
  UserData? user;
  String? currentSheet;

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
    if (user == null) {
      return const GeneralScaffold(
        body: CircularProgressIndicator(),
      );
    } else {
      return GeneralScaffold(
        sheetkey: sheetKey,
        floatingIcon: Icons.monitor_heart_outlined,
        floatingAction: () {
          storeLocal("previousRoute", "logbook");
          Navigator.of(context).pushNamed("/activities");
        },
        navbar: (widget.activity.source.contains("Default")
                ? <Widget>[manifestButton(context)]
                : <Widget>[]) +
            <Widget>[
              shareButton(context),
              templateButton(context),
            ],
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              LogMenu(user: user!, refreshState: () => setState(() {})),
              const SizedBox(height: 10),
              LogGrid(user: user!, activity: widget.activity)
            ],
          ),
        ),
      );
    }
  }

  MenuButton manifestButton(BuildContext context) => MenuButton(
        label: "Manifest",
        icon: Icons.zoom_out_map_rounded,
        onPressed: () {
          Navigator.of(context)
              .pushNamed("/manifest", arguments: widget.activity);
        },
      );

  MenuButton shareButton(BuildContext context) => MenuButton(
        label: "Share",
        icon: Icons.share,
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            width: 300,
            shape: StadiumBorder(),
            content: Text('Shared logs currently in development',
                textAlign: TextAlign.center),
            behavior: SnackBarBehavior.floating,
          ));
        },
      );

  MenuButton templateButton(BuildContext context) => MenuButton(
      label: "Add",
      icon: Icons.add,
      onPressed: () {
        sheetController?.close();
        if (sheetController == null || currentSheet != "AddLog") {
          currentSheet = "AddLog";
          sheetController = Scaffold.of(sheetKey.currentContext!)
              .showBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  (context) => TemplateSheet(
                        user: user!,
                        activity: widget.activity,
                        sheetController: sheetController,
                      ));
        } else {
          currentSheet = null;
          sheetController = null;
        }
      });
}
