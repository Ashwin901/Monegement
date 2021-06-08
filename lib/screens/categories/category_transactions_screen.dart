import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monegement/bloc/bloc_states.dart';
import 'package:monegement/bloc/category_bloc.dart';
import 'package:monegement/constants/constants.dart';
import 'package:monegement/models/category_model.dart';
import 'package:monegement/services/category_services.dart';
import 'package:monegement/widgets/alert_dialog.dart';
import 'package:monegement/widgets/curved_container.dart';
import 'package:monegement/widgets/custom_appbar.dart';
import 'package:monegement/widgets/toast.dart';
import 'package:monegement/widgets/transaction_card.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:monegement/constants/months.dart';

class CategoriesExpensesScreen extends StatefulWidget {
  final int categoryIndex;

  CategoriesExpensesScreen({
    this.categoryIndex,
  });
  @override
  _CategoriesExpensesScreenState createState() =>
      _CategoriesExpensesScreenState();
}

class _CategoriesExpensesScreenState extends State<CategoriesExpensesScreen> {
  TextEditingController _budgetController;
  TextEditingController _monthController;
  List categoryTransactions = [];
  double categoryAmount;
  double percentage;
  Category currentCategory;

  @override
  void initState() {
    _budgetController = TextEditingController();
    _monthController = TextEditingController(
      text: months[DateTime.now().month - 1],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Categories",
        onPop: () {
          getCategoryStats(context, null, null);
          Navigator.pop(context);
        },
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
      body: BlocBuilder<CategoryBloc, BlocState>(
        builder: (context, BlocState state) {
          if (state is GetCategoryTransactionsState) {
            currentCategory = state.currenCategory;
            categoryTransactions = state.categoryTransaction;
            categoryAmount = state.categoryTotalAmount;
            percentage = categoryAmount / currentCategory.budget;
          }
          return WillPopScope(
            child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).primaryColor,
                child: CurvedContainer(
                  childWidget: Column(
                    children: [
                      Text(
                        currentCategory.categoryName,
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
                          percent: percentage > 1 ? 1 : percentage,
                          center: Text(
                            percentage > 1
                                ? "Over budget"
                                : (percentage * 100).toStringAsFixed(0) + "%",
                            style: textStyle1,
                          ),
                          progressColor: Color(currentCategory.categoryColor),
                        ),
                      ),
                      Text(
                        "Spent: ₹ $categoryAmount / ₹ ${currentCategory.budget}",
                        textAlign: TextAlign.center,
                        style: textStyle1.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currentCategory.categoryDescription,
                        textAlign: TextAlign.center,
                        style: textStyle1.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            child: TextField(
                              controller: _monthController,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              textAlign: TextAlign.center,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              pickMonth();
                            },
                            child: Icon(
                              Icons.edit,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        width: 180,
                        child: Divider(
                          height: 50,
                          thickness: 1.5,
                          color: Color(currentCategory.categoryColor),
                        ),
                      ),
                      categoryTransactions.length == 0
                          ? Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              alignment: Alignment.center,
                              child: Text(
                                "No transactions for the selected month under this category",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            )
                          : Column(
                              children: categoryTransactions
                                  .map(
                                    (transaction) => TransactionCard(
                                      transaction: transaction["transaction"],
                                      index: transaction["tNumber"],
                                      currentCategory: currentCategory,
                                      c: true,
                                    ),
                                  )
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            onWillPop: () {
              getCategoryStats(context, null, null);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  void handleBudgetUpdate() {
    if (_budgetController.value.text.isNotEmpty) {
      Category updatedCategory = Category(
        categoryName: currentCategory.categoryName,
        categoryDescription: currentCategory.categoryDescription,
        categoryColor: currentCategory.categoryColor,
        budget: double.parse(_budgetController.value.text),
      );
      updateCategoryBudget(
          context, currentCategory.categoryName, updatedCategory);
    } else {
      showToast("No budget entered");
    }
    _budgetController.text = "";
  }

  void pickMonth() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    int m;

    showMonthPicker(context: context, initialDate: DateTime.now()).then(
      (month) => {
        if (month != null)
          {
            m = int.parse(month.toString().substring(5, 7)),
            _monthController.text = months[m - 1],
            getTransactionsByCategory(
              context,
              currentCategory,
              month.toString().substring(0, 7),
            ),
          }
      },
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _monthController.dispose();
    super.dispose();
  }
}
