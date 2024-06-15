import 'dart:io';

import 'package:flutter/material.dart';

class AppBarTemplate extends StatelessWidget {
  final String appBarTitle;
  final Widget child;
  final Color? appBarColor;
  final Widget? floatingActionButton;
  final Widget? drawer;
  const AppBarTemplate(
      {required this.child,
      required this.appBarTitle,
      this.floatingActionButton,
      this.appBarColor,
      this.drawer,
      super.key});

  @override
  Widget build(BuildContext context) {
    final myColor = appBarColor ?? Theme.of(context).colorScheme.inversePrimary;
    final textColor =
        myColor.computeLuminance() > 0.4 ? Colors.black : Colors.white;
    var mainContent = Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: textColor),
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: myColor,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          appBarTitle,
          style: TextStyle(color: textColor, fontSize: 27),
        ),
      ),
      drawer: drawer == null
          ? null
          : Drawer(
              child: drawer,
            ),
      body: child,
      floatingActionButton: floatingActionButton,
    );
    if (Platform.isWindows) {
      return Center(
        child: AspectRatio(
          aspectRatio: 10 / 16,
          child: mainContent,
        ),
      );
    } else {
      return Center(child: mainContent);
    }
  }
}
