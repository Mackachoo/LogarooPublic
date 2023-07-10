import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/centre.dart';
import 'package:logbook2electricboogaloo/services/firestore/sharing.dart';
import 'package:logbook2electricboogaloo/widgets/dropdown.dart';

class CentreUsers extends StatelessWidget {
  final Centre centre;
  const CentreUsers({super.key, required this.centre});

  @override
  Widget build(BuildContext context) {
    return SimpleDropdown(
        header: "Users",
        body: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: ListView.separated(
              itemCount: userList.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemBuilder: (context, index) => userList[index],
            ),
          ),
        ));
  }

  List<Widget> get userList {
    List<String> users = centre.users.keys.toList();
    users.sort((a, b) => (a).compareTo(b));
    return users.map((e) => sharedUser(e)).toList();
  }
}
