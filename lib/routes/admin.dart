import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/auth.dart';
import 'package:logbook2electricboogaloo/services/firestore/centre.dart';
import 'package:logbook2electricboogaloo/widgets/admin/body.dart';
import 'package:logbook2electricboogaloo/widgets/buttons.dart';
import 'package:logbook2electricboogaloo/widgets/dialogs.dart';
import 'package:logbook2electricboogaloo/widgets/scaffold.dart';

class Admin extends StatefulWidget {
  final String cid;
  const Admin({super.key, required this.cid});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  late StreamSubscription uidSubscription;
  late StreamSubscription centreSubscription;
  Centre? centre;
  bool editable = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    uidSubscription = AuthService().uidStream.listen((uid) {
      if (uid == null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/login", ModalRoute.withName(""));
      } else {
        centreSubscription = centreStream(widget.cid).listen((c) {
          setState(() {
            centre = c;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    uidSubscription.cancel();
    centreSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (centre == null) {
      return const GeneralScaffold(
        body: CircularProgressIndicator(),
      );
    } else {
      return GeneralScaffold(
        floatingIcon: Icons.close,
        floatingAction: () {
          Navigator.of(context).pop();
        },
        navbar: [editButton(context), visibilityButton(context)],
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: CentreSettings(
              centre: centre!, formkey: _formkey, editable: editable),
        ),
      );
    }
  }

  MenuButton editButton(BuildContext context) {
    return editable
        ? MenuButton(
            icon: Icons.save,
            label: "Save",
            onPressed: () {
              _formkey.currentState!.save();
              setState(() {
                editable = false;
              });
            })
        : MenuButton(
            icon: Icons.edit,
            label: "Edit",
            onPressed: () {
              setState(() {
                editable = true;
              });
            },
          );
  }

  MenuButton visibilityButton(BuildContext context) {
    return centre!.visible
        ? MenuButton(
            icon: Icons.visibility_off_outlined,
            label: "Hide",
            onPressed: () {
              updateCentre("Visible", false, cid: centre!.cid);
              textPopups(context,
                  "${centre!.name} is no longer visible to the public.");
            })
        : MenuButton(
            icon: Icons.visibility_outlined,
            label: "Show",
            onPressed: () {
              updateCentre("Visible", true, cid: centre!.cid);
              textPopups(
                  context, "${centre!.name} is now visible to the public.");
            },
          );
  }
}
