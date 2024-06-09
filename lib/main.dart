import 'dart:async';

import 'package:expenses/screen/accounts.dart';
import 'package:expenses/service/database.dart';
import 'package:expenses/service/dto/totalaccount.dart';
import 'package:expenses/service/dto/transaction.dart';
import 'package:expenses/service/hivedto/accountdto.dart';
import 'package:expenses/template/loading.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

void main() async {
  await Hive.initFlutter();
  getIt.registerSingleton<DatabaseService>(DatabaseService());
  var databaseService = getIt<DatabaseService>();
  await databaseService.registerAdapter();
  final accounts = await databaseService.getAllAccounts();
  runApp(MyApp(databaseService, accounts));
}

class MyApp extends StatefulWidget {
  DatabaseService databaseService;
  List<AccountDto> accounts;
  MyApp(this.databaseService, this.accounts, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<AccountDto>> fAccounts;
  late Stream<AccountDto?> sUpdates;
  StreamController<AccountDto> changeAccountNotification =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    fAccounts = Future.value(widget.accounts);
    sUpdates = widget.databaseService.stream
      ..listen((data) {
        setState(() {
          fAccounts = widget.databaseService.getAllAccounts();
          if (data != null) {
            changeAccountNotification.sink.add(data);
          }
        });
      });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final mainWidget = FutureBuilder(
      future: fAccounts,
      builder:
          (BuildContext context, AsyncSnapshot<List<AccountDto>> snapshot) {
        if (!snapshot.hasData) {
          return const LoadingScreen();
        } else {
          final accounts = (snapshot.data!..sort())
              .map((element) => element.toAccount())
              .toList(growable: true);
          final allTransactions = accounts
              .expand((account) => account.transactions
                  .map((trx) => MapEntry(account.name, trx)))
              .map((entry) => Transaction.addCategory(entry.value, entry.key))
              .toList();
          accounts.insertAll(0,
              [TotalAccount("Total", Colors.grey.shade700, allTransactions)]);
          return DefaultTabController(
            length: accounts.length,
            child: TabBarView(
              children: accounts.indexed
                  .map<Widget>((entry) => AccountPage(entry.$1, accounts,
                      widget.databaseService, changeAccountNotification.stream))
                  .toList(),
            ),
          );
        }
      },
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        // colorScheme: ColorScheme.dark(
        //     primary: Colors.blueGrey.shade600, secondary: Colors.blue.shade800),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: mainWidget,
    );
  }
}
