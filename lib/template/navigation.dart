import 'package:flutter/material.dart';

class AccountNavigationButton extends StatelessWidget {
  final Widget child;
  final int? indexTo;
  const AccountNavigationButton({required this.child, this.indexTo, super.key});

  @override
  Widget build(BuildContext context) {
    if (indexTo == null) {
      return Container(
        color: Colors.grey.shade800,
        child: child,
      );
    } else {
      return InkWell(
        child: child,
        onTap: () => DefaultTabController.of(context).animateTo(indexTo!),
      );
    }
  }
}
