import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:monegement/bloc/bloc_events.dart';
import 'package:monegement/bloc/bloc_states.dart';
import 'package:monegement/models/category_model.dart';
import 'package:monegement/models/transaction_model.dart';

class CategoryBloc extends Bloc<BlocEvent, BlocState> {
  CategoryBloc(BlocState initialState) : super(initialState);

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    Box categoryBox = Hive.box('categories');
    Box transactionBox = Hive.box('transactions');

    double getCategoryMonthTotal(String category, String month) {
      double amount = 0;
      TransactionModel t;
      String tMonth;
      for (int i = 0; i < transactionBox.length; i++) {
        t = transactionBox.getAt(i);
        tMonth = t.transactionDate.substring(0, 7);
        if (t.transactionCategory == category && tMonth == month) {
          amount += t.transactionAmount;
        }
      }
      return amount;
    }

    double getYearlyAmount(String year) {
      TransactionModel t;
      double amount = 0;
      for (int i = 0; i < transactionBox.length; i++) {
        t = transactionBox.getAt(i);
        if (t.transactionDate.substring(0, 4) == year) {
          amount += t.transactionAmount;
        }
      }
      return amount;
    }

    if (event is AddDefaultCategories) {
      try {
        for (int i = 0; i < event.categories.length; i++) {
          await categoryBox.put(
              event.categories[i].categoryName, event.categories[i]);
        }
      } catch (e) {
        throw ErrorDescription("Could not add default categories");
      }
    } else if (event is AddCategoryEvent) {
      try {
        if (categoryBox.containsKey(event.category.categoryName)) {
          yield ShowToast(
              message:
                  "A different category has the same name. Please try with a different name");
        } else {
          categoryBox.put(event.category.categoryName, event.category);
        }
      } catch (e) {
        throw ErrorDescription("Some error occured could not add category");
      }
    }
    // Updating the category budget
    else if (event is UpdateCategoryBudgetEvent) {
      try {
        await categoryBox.put(event.categoryName, event.updatedCategory);
      } catch (e) {
        throw ErrorDescription(
            "Some error occured could not update the budget");
      }
    }
    // Get transactions based on category
    else if (event is GetCategoryTransactionsEvent) {
      Category c = event.currentCategory;
      TransactionModel t;
      List categoryTransactions = [];
      String tMonth;

      for (int i = 0; i < transactionBox.length; i++) {
        t = transactionBox.getAt(i) as TransactionModel;
        tMonth = t.transactionDate.substring(0, 7);
        if (t.transactionCategory == c.categoryName && event.month == tMonth) {
          categoryTransactions.add({"tNumber": i, "transaction": t});
        }
      }

      double amount = getCategoryMonthTotal(c.categoryName, event.month);

      yield GetCategoryTransactionsState(
          categoryTransaction: categoryTransactions,
          categoryTotalAmount: amount,
          currenCategory: c);
    }
    // Stats based on category
    else if (event is GetCategoryStatsEvents) {
      List stats = [];
      double amount = 0;
      Category c;
      for (int i = 0; i < categoryBox.length; i++) {
        c = categoryBox.getAt(i);
        amount = getCategoryMonthTotal(c.categoryName, event.month);
        stats.add({
          "category": c,
          "amount": amount,
        });
      }
      double yearlyAmount = getYearlyAmount(event.year);
      yield GetCategoryStatsState(stats: stats, yearlyAmount: yearlyAmount);
    }
  }
}
