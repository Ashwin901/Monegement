import 'package:hive/hive.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel {
  @HiveField(0)
  double transactionAmount;

  @HiveField(1)
  String transactionCategory;

  @HiveField(2)
  String transactionDate;

  @HiveField(3)
  String transactionDescription;

  @HiveField(4)
  int transactionColor;

  TransactionModel(
      {this.transactionAmount,
      this.transactionCategory,
      this.transactionDate,
      this.transactionDescription,
      this.transactionColor});
}
