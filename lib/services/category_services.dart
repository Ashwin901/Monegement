import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:monegement/bloc/transaction_bloc.dart';
import 'package:monegement/bloc/bloc_events.dart';
import 'package:monegement/bloc/category_bloc.dart';
import 'package:monegement/models/category_model.dart';
import 'package:monegement/constants/default_categories.dart';
import 'package:monegement/widgets/toast.dart';

TransactionBloc transactionBloc;
CategoryBloc categoryBloc;

void addNewCategory(BuildContext context, Category newCategory) {
  categoryBloc = BlocProvider.of<CategoryBloc>(context);
  try {
    categoryBloc.add(
      AddCategoryEvent(category: newCategory),
    );
    showToast("New category added");
  } catch (e) {
    showToast("Some error occured. Could not add new category");
  }

  Navigator.pop(context);
}

void getTransactionsByCategory(
    BuildContext context, Category currentCategory, String month) {
  String selectedMonth =
      month == null ? DateTime.now().toString().substring(0, 7) : month;
  categoryBloc = BlocProvider.of<CategoryBloc>(context);
  try {
    categoryBloc.add(
      GetCategoryTransactionsEvent(
          currentCategory: currentCategory, month: selectedMonth),
    );
  } catch (e) {
    showToast(e.toString());
  }
}

void updateCategoryBudget(
    BuildContext context, String categoryName, Category updatedCategory) {
  categoryBloc = BlocProvider.of<CategoryBloc>(context);
  try {
    categoryBloc.add(
      UpdateCategoryBudgetEvent(
          categoryName: categoryName, updatedCategory: updatedCategory),
    );
    showToast("Category budget updated");
    getTransactionsByCategory(context, updatedCategory, null);
  } catch (e) {
    showToast(e.toString());
  }

  Navigator.pop(context);
}

void getCategoryStats(BuildContext context, String month, String year) {
  categoryBloc = BlocProvider.of<CategoryBloc>(context);
  String selectedMonth =
      month == null ? DateTime.now().toString().substring(0, 7) : month;
  String selectedYear = year == null ? DateTime.now().year.toString() : year;
  categoryBloc.add(
    GetCategoryStatsEvents(month: selectedMonth, year: selectedYear),
  );
}

Future<void> addDefaultCategories() async {
  Box box = Hive.box('categories');
  if (box.length == 0) {
    for (int i = 0; i < defaultCategories.length; i++) {
      await box.put(defaultCategories[i].categoryName, defaultCategories[i]);
    }
  }
}
