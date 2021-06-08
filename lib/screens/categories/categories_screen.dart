import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monegement/bloc/transaction_bloc.dart';
import 'package:monegement/bloc/bloc_states.dart';
import 'package:monegement/models/category_model.dart';
import 'package:monegement/screens/categories/category_transactions_screen.dart';
import 'package:monegement/services/category_services.dart';
import 'package:monegement/widgets/curved_container.dart';
import 'package:monegement/widgets/custom_appbar.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Categories",
      ),
      body: BlocBuilder<TransactionBloc, BlocState>(
        builder: (context, BlocState state) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: CurvedContainer(
              childWidget: ValueListenableBuilder(
                valueListenable: Hive.box('categories').listenable(),
                builder: (context, Box box, _) {
                  return Column(
                    children: [
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(
                            box.length,
                            (index) => GestureDetector(
                              onTap: () {
                                Category currentCategory = box.getAt(index);
                                getTransactionsByCategory(
                                    context, currentCategory, null);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CategoriesExpensesScreen(
                                        categoryIndex: index,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 0.1),
                                      blurRadius: 2.0,
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category,
                                      size: 50,
                                      color:
                                          Color(box.getAt(index).categoryColor),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      box.getAt(index).categoryName,
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context, '/newCategory');
                        },
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
