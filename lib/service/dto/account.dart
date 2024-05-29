import 'package:expenses/service/dto/transaction.dart';
import 'package:flutter/material.dart';

class Account {
  final String name;
  final String currency;
  final Color color;
  final List<Transaction> transactions;
  Account(this.name, this.color, this.transactions, [this.currency = "IDR"]);
}
