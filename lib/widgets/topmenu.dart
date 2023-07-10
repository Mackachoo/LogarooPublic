import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/widgets/avatar.dart';

class TopMenu extends StatelessWidget {
  final List<Widget>? items;
  final UserData user;
  const TopMenu({super.key, this.items, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      color: Theme.of(context).colorScheme.background,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: (items ?? <Widget>[]) + [Avatar(user: user)],
      ),
    );
  }
}
