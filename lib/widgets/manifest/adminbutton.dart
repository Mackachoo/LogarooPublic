import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/centre.dart';
import 'package:logbook2electricboogaloo/services/firestore/development.dart';

class AdminButton extends StatelessWidget {
  final Centre centre;
  final String uid;
  const AdminButton({super.key, required this.centre, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: permissionLevel(uid),
      builder: (context, snapshot) =>
          snapshot.data == 0 // || centre.admins.contains(uid)
              ? IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed("/admin", arguments: centre.cid),
                  icon: const Icon(Icons.manage_accounts_outlined, size: 30))
              : const SizedBox(width: 30),
    );
  }
}
