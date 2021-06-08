import 'package:monegement/models/category_model.dart';

class BlocState {}

class InitState extends BlocState {}

class ShowToast extends BlocState {
  String message;
  ShowToast({this.message});
}

class GetCategoryTransactionsState extends BlocState {
  List categoryTransaction;
  double categoryTotalAmount;
  Category currenCategory;
  GetCategoryTransactionsState(
      {this.categoryTransaction,
      this.categoryTotalAmount,
      this.currenCategory});
}

class GetDateTransactionsState extends BlocState {
  List dateTransactions;
  double dateTotalAmount;
  GetDateTransactionsState({this.dateTotalAmount, this.dateTransactions});
}

class GetCategoryStatsState extends BlocState {
  List stats;
  double yearlyAmount;
  GetCategoryStatsState({this.stats, this.yearlyAmount});
}

class GetYearlyStatsState extends BlocState {
  double totalAmount;
  List yearlyTransactions;
  GetYearlyStatsState({this.totalAmount, this.yearlyTransactions});
}

class GetYearlyBudget extends BlocState {
  double budget;
  GetYearlyBudget({this.budget});
}
