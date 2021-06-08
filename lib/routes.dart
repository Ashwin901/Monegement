import 'package:flutter/material.dart';
import 'package:monegement/app.dart';
import 'package:monegement/screens/stats/stats_screen.dart';
import 'package:monegement/screens/categories/add_category_screen.dart';
import 'package:monegement/screens/categories/category_transactions_screen.dart';
import 'package:monegement/screens/categories/categories_screen.dart';
import 'screens/transactions/transaction_Screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => StartApp());
      case '/new':
        return MaterialPageRoute(builder: (_) => NewTransactionScreen());
      case '/category':
        return MaterialPageRoute(builder: (_) => CategoriesScreen());
      case '/categoryTransactions':
        return MaterialPageRoute(builder: (_) => CategoriesExpensesScreen());
      case '/newCategory':
        return MaterialPageRoute(builder: (_) => AddCategoryScreen());
      case '/stats':
        return MaterialPageRoute(builder: (_) => StatsScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text("Invalid route"),
                  ),
                ));
    }
  }
}
