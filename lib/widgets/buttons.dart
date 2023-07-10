import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_action/slide_action.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  const MenuButton(
      {super.key, required this.icon, required this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onPressed,
      child: SizedBox(
        width: 70,
        child: Column(children: [
          Icon(icon, color: Theme.of(context).colorScheme.onTertiary),
          Text(
            label ?? "",
            style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
          ),
        ]),
      ),
    );
  }
}

class AssetButton extends StatelessWidget {
  final String label;
  final Widget asset;
  final VoidCallback? onPressed;
  const AssetButton(
      {super.key,
      required this.label,
      required this.asset,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(label, overflow: TextOverflow.fade),
              ),
              icon: asset,
              onPressed: onPressed),
        ),
      ),
    );
  }
}

class SlideButton extends StatelessWidget {
  final String? label;
  final VoidCallback action;
  const SlideButton({super.key, required this.action, this.label});

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      trackBuilder: (context, state) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: Center(
            child: Text(
              state.isPerformingAction ? "Loading..." : label ?? "",
              textScaleFactor: 1.2,
            ),
          ),
        );
      },
      thumbBuilder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            // Show loading indicator if async operation is being performed
            child: state.isPerformingAction
                ? const CircularProgressIndicator()
                : Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
          ),
        );
      },
      action: action,
    );
  }
}
