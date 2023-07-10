import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/widgets/cards.dart';
import 'package:logbook2electricboogaloo/widgets/avatar.dart';

class AccountSettings extends StatefulWidget {
  final UserData user;
  final GlobalKey<FormState> formkey;
  final bool editable;

  const AccountSettings(
      {super.key,
      required this.user,
      required this.formkey,
      required this.editable});

  @override
  State<AccountSettings> createState() => AccountSettingsState();
}

class AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    List<Widget> entries = [
      Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: Avatar(
              user: widget.user,
              onPressed: widget.editable ? () {} : null,
              radius: 100),
        ),
      ),
      nameField(),
      emailField(),
      pidCard()
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

  Card pidCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Public ID",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.user.pid,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'RobotoMono'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SettingsCard nameField() {
    return SettingsCard(
      update: updateUser,
      editable: widget.editable,
      fields: {
        "Firstname": widget.user.firstname,
        "Lastname": widget.user.lastname
      },
    );
  }

  SettingsCard emailField() {
    return SettingsCard(
      update: updateUser,
      editable: false,
      fields: {"Email": widget.user.email},
    );
  }
}
