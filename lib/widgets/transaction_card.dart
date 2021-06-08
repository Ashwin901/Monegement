import 'package:flutter/material.dart';
import 'package:monegement/models/category_model.dart';
import 'package:monegement/models/transaction_model.dart';
import 'package:monegement/screens/transactions/transaction_Screen.dart';

class TransactionCard extends StatefulWidget {
  final TransactionModel transaction;
  final int index;
  final Category currentCategory;
  final bool c;
  TransactionCard({this.transaction, this.index, this.c, this.currentCategory});
  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return NewTransactionScreen(
                  update: true,
                  transaction: widget.transaction,
                  transactionNumber: widget.index,
                  currentCategory: widget.currentCategory,
                  c: widget.c,
                );
              },
            ),
          );
        },
        leading: Icon(
          Icons.account_balance_wallet,
          color: Color(widget.transaction.transactionColor),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: Color(widget.transaction.transactionColor),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Text(
            widget.transaction.transactionCategory,
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(color: Colors.white),
          ),
        ),
        title: Text(
          widget.transaction.transactionDate,
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(fontSize: 13, color: Colors.grey),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "₹ ${widget.transaction.transactionAmount.toString()}",
              style:
                  Theme.of(context).textTheme.headline2.copyWith(fontSize: 18),
            ),
            Text(
              widget.transaction.transactionDescription,
              style:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
