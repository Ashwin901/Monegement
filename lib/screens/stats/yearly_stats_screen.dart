import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monegement/bloc/transaction_bloc.dart';
import 'package:monegement/bloc/bloc_states.dart';
import 'package:monegement/constants/constants.dart';
import 'package:monegement/services/stats_services.dart';
import 'package:monegement/widgets/alert_dialog.dart';
import 'package:monegement/widgets/curved_container.dart';
import 'package:monegement/widgets/custom_appbar.dart';
import 'package:monegement/widgets/toast.dart';
import 'package:monegement/widgets/transaction_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class YearlyStatsScreen extends StatefulWidget {
  final double amount, budget;
  YearlyStatsScreen({this.budget, this.amount});
  @override
  _YearlyStatsScreenState createState() => _YearlyStatsScreenState();
}

class _YearlyStatsScreenState extends State<YearlyStatsScreen> {
  List yearlyTransactions = [];
  TextEditingController _budgetController;
  double amount, budget;

  @override
  void initState() {
    amount = widget.amount;
    budget = widget.budget;
    _budgetController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Stats",
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {
              await editAlertDialog(context, "Update budget",
                  handleBudgetUpdate, _budgetController);
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, BlocState>(
        builder: (context, BlocState state) {
          if (state is GetYearlyStatsState) {
            yearlyTransactions = state.yearlyTransactions;
            amount = state.totalAmount;
          }
          return SingleChildScrollView(
            child: Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              child: CurvedContainer(
                childWidget: Column(
                  children: [
                    Text(
                      "Yearly Stats",
                      textAlign: TextAlign.center,
                      style: textStyle1.copyWith(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      child: CircularPercentIndicator(
                        animation: true,
                        animationDuration: 1000,
                        radius: 90.0,
                        lineWidth: 4.0,
                        percent: amount / budget,
                        center: Text(
                          widget.amount / widget.budget > 1
                              ? "Over budget"
                              : ((amount / budget) * 100).toStringAsFixed(0) +
                                  "%",
                          style: textStyle1,
                        ),
                        progressColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      "Spent: ₹ $amount / ₹$budget",
                      textAlign: TextAlign.center,
                      style: textStyle1.copyWith(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 180,
                      child: Divider(
                        height: 50,
                        thickness: 1.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    yearlyTransactions.length == 0
                        ? Center(
                            child: Text(
                                "No transactions for the current year yet."),
                          )
                        : Column(
                            children: yearlyTransactions
                                .asMap()
                                .entries
                                .map(
                                  (transaction) => TransactionCard(
                                    transaction:
                                        transaction.value["transaction"],
                                    index: transaction.value["tNumber"],
                                  ),
                                )
                                .toList(),
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

  void handleBudgetUpdate() {
    if (_budgetController.value.text.isNotEmpty) {
      addTotalBudget(
        context,
        double.parse(_budgetController.value.text),
      );
      setState(() {
        budget = double.parse(_budgetController.value.text);
      });
      Navigator.pop(context);
    } else {
      showToast("No budget entered");
    }
    _budgetController.text = "";
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }
}
