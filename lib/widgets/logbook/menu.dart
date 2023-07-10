import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/widgets/logbook/parameters.dart'
    as parameters;
import 'package:logbook2electricboogaloo/widgets/topmenu.dart';
import 'package:logbook2electricboogaloo/widgets/dialogs.dart';

class LogMenu extends StatelessWidget {
  final UserData user;
  final VoidCallback refreshState;
  const LogMenu({super.key, required this.user, required this.refreshState});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TopMenu(
        user: user,
        items: [
          search(context),
          filter(context, constraints.maxWidth > 400),
          group(context, constraints.maxWidth > 400),
          deleted(context),
          sort(context),
        ],
      ),
    );
  }

  Widget search(BuildContext context) {
    return IconButton(
        onPressed: () {
          // parameters.search = parameters.search == null ? "" : null;
          // refreshState();
          developmentPopup(context);
        },
        icon: Icon(Icons.search,
            color: parameters.search != null
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground));
  }

  TextButton filter(BuildContext context, bool showLabel) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: parameters.filter.isEmpty
              ? Theme.of(context).colorScheme.onBackground
              : Theme.of(context).colorScheme.primary),
      icon: const Icon(Icons.filter_list),
      label: Text(showLabel ? "Filter" : ""),
      onPressed: () {
        developmentPopup(context);
      },
    );
  }

  TextButton group(BuildContext context, bool showLabel) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: parameters.group.isEmpty
              ? Theme.of(context).colorScheme.onBackground
              : Theme.of(context).colorScheme.primary),
      icon: const Icon(Icons.folder_copy_outlined),
      label: Text(showLabel ? "Group" : ""),
      onPressed: () {
        developmentPopup(context);
      },
    );
  }

  IconButton deleted(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.delete_sweep,
            color: parameters.deleted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground),
        iconSize: 30,
        onPressed: () {
          parameters.deleted = !parameters.deleted;
          refreshState();
        });
  }

  IconButton sort(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.swap_vert),
      iconSize: 30,
      onPressed: () {
        developmentPopup(context);
      },
    );
  }
}
