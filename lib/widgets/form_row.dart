import 'package:flutter/material.dart';

class FormRow extends StatefulWidget {
  final Icon icon;
  final Widget formWidget;
  FormRow({this.icon, this.formWidget});
  @override
  _FormRowState createState() => _FormRowState();
}

class _FormRowState extends State<FormRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.icon,
        SizedBox(
          width: 5,
        ),
        Expanded(child: widget.formWidget),
      ],
    );
  }
}
