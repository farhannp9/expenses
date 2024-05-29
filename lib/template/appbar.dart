import 'dart:io';

import 'package:flutter/material.dart';

class AppBarTemplate extends StatelessWidget {
  final Widget appBarTitle;
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
    var mainContent = Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor:
            appBarColor ?? Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: appBarTitle,
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
          aspectRatio: 9 / 16,
          child: mainContent,
        ),
      );
    } else {
      return Center(child: mainContent);
    }
  }
}
