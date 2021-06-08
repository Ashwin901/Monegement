import 'package:flutter/material.dart';
import 'package:monegement/services/stats_services.dart';
import 'package:monegement/widgets/toast.dart';
import 'custom_text_field.dart';
import 'form_row.dart';

class TotalBudgetCard extends StatefulWidget {
  @override
  _TotalBudgetCardState createState() => _TotalBudgetCardState();
}

class _TotalBudgetCardState extends State<TotalBudgetCard> {
  TextEditingController _totalBudgetController;

  @override
  void initState() {
    _totalBudgetController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Looks like you have not entered the yearly budget",
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            FormRow(
              icon: Icon(Icons.attach_money),
              formWidget: CustomTextField(
                textEditingController: _totalBudgetController,
                inputType: TextInputType.number,
                hintText: "Enter the budget",
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              onPressed: handleBudgetSubmit,
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleBudgetSubmit() {
    if (_totalBudgetController.value.text.isNotEmpty) {
      addTotalBudget(
        context,
        double.parse(_totalBudgetController.value.text),
      );
    } else {
      showToast("Please enter the budget");
    }
  }
}
