import 'package:expenses/screen/accounts.dart';
import 'package:expenses/service/dto/account.dart';
import 'package:expenses/template/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Account> accounts = [
    Account("Physical", Colors.red.shade900, []),
    Account("Dana Darurat", Colors.blue.shade900, []),
    Account("Traktir", Colors.green.shade900, []),
    Account("Id Dima", Colors.yellow.shade900, []),
  ];
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final drawer = NavigationDrawerTemplate(accounts);
    DefaultTabController controllerTab = DefaultTabController(
      length: accounts.length,
      child: TabBarView(
        children: accounts.indexed
            .map<Widget>((entry) => AccountPage(entry.$1, accounts,
                drawer: NavigationDrawerTemplate(accounts, entry.$1)))
            .toList(),
      ),
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
      home: controllerTab,
    );
  }
}
