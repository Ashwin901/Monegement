import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monegement/bloc/transaction_bloc.dart';
import 'package:monegement/bloc/bloc_events.dart';
import 'package:monegement/models/transaction_model.dart';
import 'package:monegement/widgets/toast.dart';

TransactionBloc transactionBloc;

void addNewTransaction(BuildContext context, TransactionModel newTransaction) {
  transactionBloc = BlocProvider.of<TransactionBloc>(context);

  try {
    transactionBloc.add(
      AddTransactionEvent(transactionModel: newTransaction),
    );
    showToast("Transaction added");
  } catch (e) {
    showToast("Some error occurred. Could not add transaction");
  }

  Navigator.pop(context);
}

void updateTransaction(
    BuildContext context, TransactionModel updatedTransaction, int index) {
  transactionBloc = BlocProvider.of<TransactionBloc>(context);

  try {
    transactionBloc.add(
      UpdateTransactionEvent(
          transactionNumber: index, transaction: updatedTransaction),
    );
    showToast("Transaction updated");
  } catch (e) {
    showToast("Some error occurred. Could not update transaction");
  }

  Navigator.pop(context);
}

void deleteTransaction(BuildContext context, int index) {
  transactionBloc = BlocProvider.of<TransactionBloc>(context);
  try {
    transactionBloc.add(
      DeleteTransactionEvent(index: index),
    );
    showToast("Transaction deleted");
  } catch (e) {
    showToast("Some error occurred. Could not delete transaction");
  }

  Navigator.pop(context);
  Navigator.pop(context);
}
