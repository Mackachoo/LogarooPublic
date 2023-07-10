import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/centre.dart';
import 'package:logbook2electricboogaloo/widgets/admin/roles.dart';
import 'package:logbook2electricboogaloo/widgets/admin/users.dart';
import 'package:logbook2electricboogaloo/widgets/cards.dart';

class CentreSettings extends StatefulWidget {
  final Centre centre;
  final GlobalKey<FormState> formkey;
  final bool editable;

  const CentreSettings(
      {super.key,
      required this.centre,
      required this.formkey,
      required this.editable});

  @override
  State<CentreSettings> createState() => CentreSettingsState();
}

class CentreSettingsState extends State<CentreSettings> {
  @override
  Widget build(BuildContext context) {
    List<Widget> entries = [
      nameField(),
      CentreRoles(centre: widget.centre),
      CentreUsers(centre: widget.centre),
    ];

    return Form(
      key: widget.formkey,
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        itemCount: entries.length,
        itemBuilder: (context, index) => entries[index],
        separatorBuilder: (context, index) => const SizedBox(height: 20.0),
      ),
    );
  }

  SettingsCard nameField() {
    return SettingsCard(
      update: (k, v) => updateCentre(k, v, cid: widget.centre.cid),
      editable: widget.editable,
      fields: {
        "Name": widget.centre.name,
      },
    );
  }
}
