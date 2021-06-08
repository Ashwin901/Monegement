import 'package:monegement/models/category_model.dart';
import 'package:monegement/models/transaction_model.dart';

class BlocEvent {}

class AddTransactionEvent extends BlocEvent {
  TransactionModel transactionModel;
  AddTransactionEvent({this.transactionModel});
}

class UpdateTransactionEvent extends BlocEvent {
  int transactionNumber;
  TransactionModel transaction;
  UpdateTransactionEvent({this.transactionNumber, this.transaction});
}

class DeleteTransactionEvent extends BlocEvent {
  int index;
  DeleteTransactionEvent({this.index});
}

// Get transactions based on a particular date
class GetDateTransactionsEvent extends BlocEvent {
  String date;
  GetDateTransactionsEvent({this.date});
}

// Category based events

class AddCategoryEvent extends BlocEvent {
  Category category;
  AddCategoryEvent({this.category});
}

// Get transactions based on category
class GetCategoryTransactionsEvent extends BlocEvent {
  Category currentCategory;
  String month;
  GetCategoryTransactionsEvent({this.currentCategory, this.month});
}

// Update budget for each category
class UpdateCategoryBudgetEvent extends BlocEvent {
  Category updatedCategory;
  String categoryName;
  UpdateCategoryBudgetEvent({this.updatedCategory, this.categoryName});
}

// Get stats based on based category
class GetCategoryStatsEvents extends BlocEvent {
  String month;
  String year;
  GetCategoryStatsEvents({this.month, this.year});
}

// add default categories
class AddDefaultCategories extends BlocEvent {
  List<Category> categories;
  AddDefaultCategories({this.categories});
}

// Add yearly budget
class AddTotalBudgetEvent extends BlocEvent {
  double budget;
  AddTotalBudgetEvent({this.budget});
}

class GetYearlyStatsEvent extends BlocEvent {
  String year;
  GetYearlyStatsEvent({this.year});
}

class ChangeThemeEvent extends BlocEvent {}
