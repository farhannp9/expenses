import 'package:expenses/service/dto/account.dart';
import 'package:expenses/service/dto/transaction.dart';
import 'package:expenses/service/hivedto/accountdto.dart';
import 'package:expenses/service/hivedto/transactiondto.dart';
import 'package:flutter/material.dart';

class TotalAccount extends Account {
  static TotalAccount create(List<AccountDto> account) {
    List<Transaction> transactions = account
        .expand<TransactionDto>((x) => x.transactions ?? [])
        .map((x) => x.toTransaction())
        .toList();
    return TotalAccount("Total", Colors.grey.shade700, transactions);
  }

  TotalAccount(super.name, super.color, super.transactions);
}
