import 'package:expenses/service/dto/transaction.dart';
import 'package:flutter/material.dart';

class Account {
  final String name;
  final Color color;
  final int? timestamp;
  final List<Transaction> transactions;
  Account(this.name, this.color, this.transactions, [this.timestamp]);
}
