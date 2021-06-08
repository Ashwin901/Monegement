import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextInputType inputType;
  final Widget prefixText;
  final TextEditingController textEditingController;
  final Function onTap;
  final Function validator;
  final String hintText;
  final TextAlign align;

  CustomTextField(
      {this.inputType,
      this.prefixText,
      this.textEditingController,
      this.onTap,
      this.validator,
      this.hintText,
      this.align});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.textEditingController,
        keyboardType:
            widget.inputType != null ? widget.inputType : TextInputType.text,
        validator: widget.validator != null ? widget.validator : null,
        style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 18),
        textAlign: widget.align != null ? widget.align : TextAlign.left,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefix: widget.prefixText != null ? widget.prefixText : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          // fillColor: Colors.grey[200],
          // filled: true,
          hintText: widget.hintText != null ? widget.hintText : " ",
        ),
        onTap: widget.onTap != null ? widget.onTap : () {},
      ),
    );
  }
}

//  focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.black,
//               width: 1,
//             ),
//           ),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.black,
//               width: 1,
//             ),
//           ),
