import 'package:flutter/material.dart';

class CurvedContainer extends StatefulWidget {
  final Widget childWidget;
  CurvedContainer({this.childWidget});
  @override
  _CurvedContainerState createState() => _CurvedContainerState();
}

class _CurvedContainerState extends State<CurvedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 35),
        padding: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 2.5),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: widget.childWidget);
  }
}
