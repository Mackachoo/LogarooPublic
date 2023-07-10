import 'package:flutter/material.dart';

class GeneralScaffold extends StatefulWidget {
  final Widget? body;
  final IconData? floatingIcon;
  final VoidCallback? floatingAction;
  final List<Widget>? navbar;
  final GlobalKey? sheetkey;

  const GeneralScaffold(
      {Key? key,
      this.body,
      this.floatingIcon,
      this.floatingAction,
      this.navbar,
      this.sheetkey})
      : super(key: key);

  @override
  State<GeneralScaffold> createState() => _GeneralScaffoldState();
}

class _GeneralScaffoldState extends State<GeneralScaffold> {
  PersistentBottomSheetController? sheetController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: widget.floatingAction,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onTertiary,
          radius: 20,
          child: Icon(widget.floatingIcon),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      bottomNavigationBar: BottomAppBar(
        height: 70,
        elevation: 0.0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.tertiary,
        child: Row(
          children: [
            const SizedBox(width: 70),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.navbar ?? []),
            ),
          ],
        ),
      ),
      body: () {
        return Scaffold(
          key: widget.sheetkey ?? UniqueKey(),
          body: Center(child: widget.body),
        );
      }(),
    );
  }
}
