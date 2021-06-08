import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  final values;
  final currentValue;
  final Function onChanged;
  CustomDropDown({this.values, this.currentValue, this.onChanged});
  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            hint: Text("Select the category"),
            style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 18),
            isDense: true,
            isExpanded: true,
            value: widget.currentValue,
            items: widget.values
                .map<DropdownMenuItem<String>>(
                  (val) => DropdownMenuItem<String>(
                    child: Text(val.categoryName),
                    value: val.categoryName,
                  ),
                )
                .toList(),
            onChanged: widget.onChanged),
      ),
    );
  }
}
