import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monegement/bloc/transaction_bloc.dart';
import 'package:monegement/bloc/bloc_states.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monegement/bloc/category_bloc.dart';
import 'package:monegement/models/category_model.dart';
import 'package:monegement/services/category_services.dart';
import 'package:monegement/constants/theme_options.dart';
import 'models/transaction_model.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox('categories');
  await Hive.openBox('budget');
  await Hive.openBox('darkMode');
  await addDefaultCategories();
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<TransactionBloc>(
        create: (context) => TransactionBloc(
          InitState(),
        ),
      ),
      BlocProvider<CategoryBloc>(
        create: (context) => CategoryBloc(
          InitState(),
        ),
      )
    ], child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TransactionBloc transactionBloc;

  @override
  Widget build(BuildContext context) {
    transactionBloc = BlocProvider.of<TransactionBloc>(context);
    return ValueListenableBuilder(
      valueListenable: Hive.box('darkMode').listenable(),
      builder: (content, Box box, _) {
        var mode = Hive.box('darkMode').get('mode') != null
            ? Hive.box('darkMode').get('mode')
            : false;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Monegement',
          theme: mode == false ? lightThemeData : darkThemeData,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/',
        );
      },
    );
  }

  @override
  void dispose() {
    transactionBloc.close();
    super.dispose();
  }
}
