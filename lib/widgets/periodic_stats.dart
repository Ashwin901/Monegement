import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:monegement/bloc/bloc_states.dart';
import 'package:monegement/bloc/category_bloc.dart';
import 'package:monegement/models/category_model.dart';
import 'package:monegement/screens/categories/category_transactions_screen.dart';
import 'package:monegement/screens/stats/yearly_stats_screen.dart';
import 'package:monegement/services/category_services.dart';
import 'package:monegement/widgets/header_text.dart';
import 'package:monegement/widgets/total_budget_card.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:monegement/constants/months.dart';
import 'package:monegement/services/stats_services.dart';

class PeriodicStats extends StatefulWidget {
  @override
  _PeriodicStatsState createState() => _PeriodicStatsState();
}

class _PeriodicStatsState extends State<PeriodicStats> {
  List stats = [];
  int currentMonth = DateTime.now().month;
  double yearlyAmount = 0;
  double totalBudget;

  @override
  void initState() {
    currentMonth = DateTime.now().month;
    totalBudget = Hive.box('budget').get("totalBudget");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, BlocState>(
      builder: (context, BlocState state) {
        if (state is GetCategoryStatsState) {
          stats = state.stats;
          yearlyAmount = state.yearlyAmount;
        } else if (state is GetYearlyBudget) {
          totalBudget = state.budget;
        }
        return stats.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 10, left: 12),
                        child: Row(
                          children: [
                            Text(
                              "${months[currentMonth - 1]} Stats",
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(fontSize: 25),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            TextButton(
                              onPressed: pickMonth,
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.only(top: 10),
                                ),
                              ),
                              child: Text(
                                "Edit month",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Card(
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Column(
                            children: stats
                                .asMap()
                                .entries
                                .map(
                                  (stat) => CategoryStatWidget(
                                    index: stat.key,
                                    currentCategory: stat.value["category"],
                                    amount: stat.value["amount"],
                                    year: false,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 10, left: 12),
                        child: Row(
                          children: [
                            Text(
                              "Yearly Stats",
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(fontSize: 25),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                      totalBudget == null
                          ? TotalBudgetCard()
                          : Card(
                              elevation: 3.0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: Column(
                                  children: [
                                    CategoryStatWidget(
                                      year: true,
                                      amount: yearlyAmount,
                                      currentCategory: Category(
                                          budget: Hive.box('budget')
                                              .get("totalBudget"),
                                          categoryName: "Total",
                                          categoryColor: Theme.of(context)
                                              .primaryColor
                                              .value),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  void pickMonth() async {
    int m;
    showMonthPicker(context: context, initialDate: DateTime.now())
        .then((month) => {
              if (month != null)
                {
                  m = int.parse(month.toString().substring(5, 7)),
                  if (currentMonth != m)
                    {
                      setState(() {
                        currentMonth = m;
                      }),
                      getCategoryStats(
                          context, month.toString().substring(0, 7), null)
                    }
                }
            });
  }
}

class CategoryStatWidget extends StatefulWidget {
  final double amount;
  final Category currentCategory;
  final int index;
  final bool year;

  CategoryStatWidget(
      {this.amount, this.currentCategory, this.index, this.year});
  @override
  _CategoryStatWidgetState createState() => _CategoryStatWidgetState();
}

class _CategoryStatWidgetState extends State<CategoryStatWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (widget.year == true) {
          getYearlyStats(context, null);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return YearlyStatsScreen(
                  amount: widget.amount,
                  budget: widget.currentCategory.budget,
                );
              },
            ),
          );
        } else {
          getTransactionsByCategory(
            context,
            widget.currentCategory,
            null,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CategoriesExpensesScreen(
                categoryIndex: widget.index,
              );
            }),
          );
        }
      },
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderText(
                text: widget.currentCategory.categoryName,
              ),
              Container(
                child: Text(
                  "${widget.amount} / ${widget.currentCategory.budget}",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ],
          ),
          LinearPercentIndicator(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            lineHeight: 7.0,
            percent: (widget.amount / widget.currentCategory.budget) > 1
                ? 1
                : widget.amount / widget.currentCategory.budget,
            progressColor: Color(widget.currentCategory.categoryColor),
            animation: true,
            animationDuration: 1000,
            linearStrokeCap: LinearStrokeCap.butt,
            trailing: Icon(
              Icons.chevron_right,
              size: 25,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}
