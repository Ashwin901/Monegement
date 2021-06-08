import 'package:flutter/material.dart';
import 'package:monegement/widgets/custom_text_field.dart';
import 'package:monegement/widgets/form_row.dart';

Future alertDialog(
    BuildContext context, String message, Function onPressed) async {
  TextStyle dialogStyle = Theme.of(context).textTheme.headline3;
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Message:",
            style: dialogStyle,
          ),
          content: Text(
            message,
            style: dialogStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style:
                    dialogStyle.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(
                "Yes",
                style:
                    dialogStyle.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      });
}

Future editAlertDialog(BuildContext context, String message, Function onPressed,
    TextEditingController budgetController) async {
  TextStyle dialogStyle = Theme.of(context).textTheme.headline3;

  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            message,
            style: dialogStyle,
          ),
          content: FormRow(
            icon: Icon(Icons.account_balance_wallet_sharp),
            formWidget: CustomTextField(
              textEditingController: budgetController,
              hintText: "Enter the new budget",
              inputType: TextInputType.number,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style:
                    dialogStyle.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(
                "Yes",
                style:
                    dialogStyle.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      });
}
