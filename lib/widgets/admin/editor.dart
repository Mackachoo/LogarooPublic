import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/roles.dart';

class RolesEditor extends StatefulWidget {
  final Role role;
  const RolesEditor({super.key, required this.role});

  @override
  State<RolesEditor> createState() => _RolesEditorState();
}

class _RolesEditorState extends State<RolesEditor> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: []);
  }

  Widget selectPermission(String permission) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(permission),
        Checkbox(
          value: widget.role.checkPermission(permission),
          onChanged: (value) =>
              setState(() => widget.role.flipPermission(permission)),
        )
      ],
    );
  }
}
