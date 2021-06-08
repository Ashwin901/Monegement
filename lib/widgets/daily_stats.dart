import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:monegement/bloc/transaction_bloc.dart';
import 'package:monegement/bloc/bloc_states.dart';
import 'package:monegement/services/stats_services.dart';
import 'package:monegement/widgets/custom_text_field.dart';
import 'package:monegement/widgets/form_row.dart';
import 'package:monegement/widgets/transaction_card.dart';

class DailyStats extends StatefulWidget {
  @override
  _DailyStatsState createState() => _DailyStatsState();
}

class _DailyStatsState extends State<DailyStats> {
  TextEditingController _dateController;
  DateFormat formatter;
  List dailyTransactions = [];

  @override
  void initState() {
    _dateController = TextEditingController();
    formatter = DateFormat('yyyy-MM-dd');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, BlocState>(
      builder: (context, BlocState state) {
        if (state is GetDateTransactionsState) {
          dailyTransactions = state.dateTransactions;
        }
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      width: 180,
                      child: FormRow(
                        icon: Icon(Icons.calendar_today),
                        formWidget: CustomTextField(
                          textEditingController: _dateController,
                          hintText: "Pick a date",
                          align: TextAlign.center,
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            getDate(context);
                          },
                        ),
                      ),
                    ),
                    dailyTransactions.length == 0
                        ? Container(
                            height: MediaQuery.of(context).size.height / 1.5,
                            alignment: Alignment.center,
                            child: Text(
                              "No transactions on this date",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: dailyTransactions
                                  .map(
                                    (transaction) => TransactionCard(
                                      transaction: transaction["transaction"],
                                      index: transaction["tNumber"],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Null> getDate(BuildContext context) async {
    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2016),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      _dateController.text = formatter.format(pickedDate).toString();
      getDailyStats(context, _dateController.text);
    }
  }
}
