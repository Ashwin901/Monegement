import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  HeaderText({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 16),
        textAlign: TextAlign.left,
      ),
    );
  }
}
