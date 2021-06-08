import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monegement/bloc/bloc_events.dart';
import 'package:monegement/bloc/transaction_bloc.dart';
import 'package:monegement/widgets/toast.dart';

TransactionBloc transactionBloc;

void addTotalBudget(BuildContext context, double amount) {
  transactionBloc = BlocProvider.of<TransactionBloc>(context);
  try {
    transactionBloc.add(
      AddTotalBudgetEvent(budget: amount),
    );
    showToast("Yearly budget updated");
  } catch (e) {
    showToast("Some error occurred. Could not update yearly budget");
  }
}

void getYearlyStats(BuildContext context, String year) {
  String selectedYear = year == null ? DateTime.now().year.toString() : year;

  transactionBloc = BlocProvider.of<TransactionBloc>(context);
  transactionBloc.add(
    GetYearlyStatsEvent(year: selectedYear),
  );
}

void getDailyStats(BuildContext context, String date) {
  transactionBloc = BlocProvider.of<TransactionBloc>(context);
  transactionBloc.add(
    GetDateTransactionsEvent(date: date),
  );
}
