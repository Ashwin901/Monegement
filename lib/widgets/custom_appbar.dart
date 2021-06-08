import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onPop;
  final List<Widget> actions;

  CustomAppBar({this.title, this.onPop, this.actions});
  @override
  Size get preferredSize => const Size.fromHeight(60);

  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        title,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      leading: IconButton(
        icon: Icon(
          Icons.close,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {
          onPop == null ? Navigator.pop(context) : onPop();
        },
      ),
      actions: actions == null ? [] : actions,
    );
  }
}
