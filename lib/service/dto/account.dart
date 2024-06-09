import 'package:expenses/service/dto/transaction.dart';
import 'package:flutter/material.dart';

class Account {
  final String name;
  final Color color;
  final int? timestamp;
  final List<Transaction> transactions;
  Account(this.name, this.color, this.transactions, [this.timestamp]);

  double getTotal() {
    return transactions.fold(0.0, (val, trx) => val + trx.amount);
  }

  double getPositive() {
    return transactions
        .where((element) => element.amount > 0)
        .fold(0.0, (val, trx) => val + trx.amount);
  }

  double getNegative() {
    return transactions
        .where((element) => element.amount < 0)
        .fold(0.0, (val, trx) => val + trx.amount);
  }
}
