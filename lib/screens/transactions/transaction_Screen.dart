import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monegement/models/category_model.dart';
import 'package:monegement/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:monegement/services/category_services.dart';
import 'package:monegement/services/transaction_services.dart';
import 'package:monegement/widgets/alert_dialog.dart';
import 'package:monegement/widgets/curved_container.dart';
import 'package:monegement/widgets/custom_text_field.dart';
import 'package:monegement/widgets/custom_dropdown.dart';
import 'package:monegement/widgets/toast.dart';
import 'package:monegement/widgets/form_row.dart';
import 'package:monegement/services/stats_services.dart';

class NewTransactionScreen extends StatefulWidget {
  final bool update;
  final TransactionModel transaction;
  final int transactionNumber;
  final Category currentCategory;
  final bool c;
  NewTransactionScreen(
      {this.transaction,
      this.update,
      this.transactionNumber,
      this.c,
      this.currentCategory});
  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  DateFormat formatter;
  String category;
  int categoryColor;
  String desc;
  TextEditingController _dateTextController;
  TextEditingController _amountController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    _dateTextController = TextEditingController();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    if (widget.update != null && widget.update == true) {
      TransactionModel oldTransaction = widget.transaction;
      _dateTextController.text = oldTransaction.transactionDate;
      _amountController.text = oldTransaction.transactionAmount.toString();
      _descriptionController.text = oldTransaction.transactionDescription;
      category = oldTransaction.transactionCategory;
      categoryColor = oldTransaction.transactionColor;
    }
    formatter = DateFormat('yyyy-MM-dd');
    super.initState();
  }

  Future<Null> getDate(BuildContext context) async {
    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2016),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      _dateTextController.text = formatter.format(pickedDate).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
            widget.update == true ? "Update transaction" : "New transaction",
            style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          widget.update == true
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await alertDialog(
                        context,
                        "Are you sure you want to delete the transaction",
                        handleDelete);
                  },
                )
              : Container(),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('categories').listenable(),
        builder: (context, Box box, _) {
          return SingleChildScrollView(
            child: Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              child: CurvedContainer(
                childWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FormRow(
                      icon: Icon(
                        Icons.attach_money,
                      ),
                      formWidget: CustomTextField(
                        inputType: TextInputType.number,
                        textEditingController: _amountController,
                        hintText: "Enter the amount",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormRow(
                      icon: Icon(
                        Icons.description,
                      ),
                      formWidget: CustomTextField(
                        textEditingController: _descriptionController,
                        hintText: "Enter the description",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormRow(
                      icon: Icon(
                        Icons.date_range,
                      ),
                      formWidget: CustomTextField(
                        textEditingController: _dateTextController,
                        hintText: "Enter the date",
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());

                          getDate(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormRow(
                      icon: Icon(
                        Icons.category,
                      ),
                      formWidget: CustomDropDown(
                        values: box.values,
                        currentValue: category,
                        onChanged: (val) {
                          setState(() {
                            category = val;
                            categoryColor = box.get(val).categoryColor;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: handleSubmit,
                        child: widget.update == true
                            ? Text(
                                "Update Transaction",
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                "Add Transaction",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void handleSubmit() {
    if (_amountController.value.text.isNotEmpty &&
        _dateTextController.value.text.isNotEmpty &&
        category != null) {
      TransactionModel newTransaction = TransactionModel(
        transactionAmount: double.parse(_amountController.value.text),
        transactionCategory: category,
        transactionDate: _dateTextController.value.text,
        transactionDescription: _descriptionController.text.isEmpty
            ? " "
            : _descriptionController.text,
        transactionColor: categoryColor,
      );
      if (widget.update != null && widget.update == true) {
        updateTransaction(context, newTransaction, widget.transactionNumber);
        getDailyStats(context, _dateTextController.text);
        showToast("Transaction updated");
        if (widget.c == true) {
          getTransactionsByCategory(context, widget.currentCategory, null);
        }
      } else {
        addNewTransaction(context, newTransaction);
      }
    } else {
      showToast("Please fill all the details");
    }
  }

  void handleDelete() {
    deleteTransaction(context, widget.transactionNumber);
    getDailyStats(context, _dateTextController.text);
    if (widget.c == true) {
      getTransactionsByCategory(context, widget.currentCategory, null);
    }
  }

  @override
  void dispose() {
    _dateTextController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
