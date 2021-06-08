import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:monegement/models/transaction_model.dart';
import 'bloc_events.dart';
import 'bloc_states.dart';
import 'package:hive/hive.dart';

class TransactionBloc extends Bloc<BlocEvent, BlocState> {
  TransactionBloc(BlocState initialState) : super(initialState);

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    Box transactionBox = Hive.box('transactions');
    Box budgetBox = Hive.box('budget');

    if (event is AddTransactionEvent) {
      try {
        await transactionBox.add(event.transactionModel);
      } catch (e) {
        throw ErrorDescription("Could not add the transaction");
      }
    } else if (event is DeleteTransactionEvent) {
      try {
        await transactionBox.deleteAt(event.index);
      } catch (e) {
        throw ErrorDescription("Could not delete the transaction");
      }
    } else if (event is UpdateTransactionEvent) {
      try {
        await transactionBox.putAt(event.transactionNumber, event.transaction);
      } catch (e) {
        throw ErrorDescription("Could not update the transaction");
      }
    } else if (event is GetDateTransactionsEvent) {
      String transactionDate = event.date;
      TransactionModel t;
      List dateTransactions = [];
      double amount = 0;
      for (int i = 0; i < transactionBox.length; i++) {
        t = transactionBox.getAt(i) as TransactionModel;
        if (t.transactionDate == transactionDate) {
          dateTransactions.add({"tNumber": i, "transaction": t});
          amount += t.transactionAmount;
        }
      }

      yield GetDateTransactionsState(
          dateTotalAmount: amount, dateTransactions: dateTransactions);
    } else if (event is AddTotalBudgetEvent) {
      double budget = event.budget;
      try {
        await budgetBox.put("totalBudget", budget);
        yield GetYearlyBudget(budget: budget);
      } catch (e) {
        throw ErrorDescription("Could not add the yearly budget");
      }
    } else if (event is GetYearlyStatsEvent) {
      String year = event.year;
      TransactionModel t;
      double amount = 0;
      List yearlyTransactions = [];
      for (int i = 0; i < transactionBox.length; i++) {
        t = transactionBox.getAt(i);
        if (t.transactionDate.substring(0, 4) == year) {
          amount += t.transactionAmount;
          yearlyTransactions.add(
            {"tNumber": i, "transaction": t},
          );
        }
      }
      yield GetYearlyStatsState(
          totalAmount: amount, yearlyTransactions: yearlyTransactions);
    } else if (event is ChangeThemeEvent) {
      var mode = Hive.box('darkMode').get("mode");
      mode = mode == null ? false : mode;
      try {
        await Hive.box('darkMode').put("mode", !mode);
      } catch (e) {
        throw ErrorDescription("Could not change theme");
      }
    }
  }
}
