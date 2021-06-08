import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monegement/bloc/transaction_bloc.dart';
import 'package:monegement/bloc/bloc_events.dart';
import 'package:monegement/bloc/bloc_states.dart';
import 'package:monegement/services/category_services.dart';
import 'package:monegement/widgets/curved_container.dart';
import 'package:monegement/widgets/toast.dart';
import 'package:monegement/widgets/total_budget_card.dart';
import 'package:monegement/widgets/transaction_card.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  double totalBudget;
  bool switchValue;

  TransactionBloc transactionBloc;

  @override
  void initState() {
    totalBudget = Hive.box('budget').get("totalBudget");
    switchValue = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    transactionBloc = BlocProvider.of<TransactionBloc>(context);
    return BlocBuilder<TransactionBloc, BlocState>(
      builder: (_, state) {
        if (state is ShowToast) {
          showToast(state.message);
        } else if (state is GetYearlyBudget) {
          totalBudget = state.budget;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Monegement",
                style: Theme.of(context).appBarTheme.titleTextStyle),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.brightness_high,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    transactionBloc.add(
                      ChangeThemeEvent(),
                    );
                  })
            ],
          ),
          body: ValueListenableBuilder(
              valueListenable: Hive.box('transactions').listenable(),
              builder: (context, Box box, _) {
                List transactionsList = box.values.toList();
                return Container(
                  color: Theme.of(context).primaryColor,
                  child: CurvedContainer(
                    childWidget: SingleChildScrollView(
                      child: Column(
                        children: [
                          totalBudget == null ? TotalBudgetCard() : Container(),
                          box.values.isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Text(
                                    "No transactions made yet.",
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                )
                              : Column(
                                  children: transactionsList
                                      .asMap()
                                      .entries
                                      .map(
                                        (transaction) => TransactionCard(
                                          transaction: transaction.value,
                                          index: transaction.key,
                                        ),
                                      )
                                      .toList(),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: 1,
            onTap: handleOnTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.category,
                  color: Colors.white,
                ),
                label: "Categories",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: "Transaction"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.event_note,
                    color: Colors.white,
                  ),
                  label: "Stats"),
            ],
          ),
        );
      },
    );
  }

  void handleOnTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/category');
        break;
      case 1:
        Navigator.pushNamed(context, '/new');
        break;
      case 2:
        getCategoryStats(context, null, null);
        Navigator.pushNamed(context, '/stats');
        break;
    }
  }
}
