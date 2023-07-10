import 'package:flutter/material.dart';

import 'package:logbook2electricboogaloo/services/firestore/user.dart';

class Avatar extends StatelessWidget {
  final UserData user;
  final VoidCallback? onPressed;
  final double radius;
  const Avatar(
      {super.key, required this.user, this.onPressed, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    // StorageService(user.uid).downloadAvatar();
    return IconButton(
      onPressed: onPressed != null
          ? () => onPressed!()
          : () => Navigator.of(context).pushNamed("/account"),
      icon: CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).colorScheme.primary,
          // foregroundImage: AssetImage('assets/${user.uid}/avatar.jpg'),
          child: Icon(
            Icons.person,
            size: radius,
            color: Theme.of(context).colorScheme.onPrimary,
          )),
    );
  }
}
