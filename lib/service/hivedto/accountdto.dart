import 'package:expenses/service/dto/account.dart';
import 'package:expenses/service/hivedto/transactiondto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

part 'accountdto.g.dart';

@HiveType(typeId: 1)
class AccountDto implements Comparable<AccountDto> {
  @HiveField(0)
  final String name;
  @HiveField(2)
  final String color;
  @HiveField(3)
  final int timestamp;
  @HiveField(4)
  final List<TransactionDto>? transactions;

  AccountDto(this.name, this.color, this.timestamp, this.transactions);

  static AccountDto fromAccount(Account account) {
    return AccountDto(
        account.name,
        account.color.toHexString(),
        account.timestamp ?? DateTime.now().millisecondsSinceEpoch,
        account.transactions
            .map((x) => TransactionDto.fromTransaction(x))
            .toList());
  }

  Account toAccount() {
    return Account(name, Color(int.parse(color, radix: 16)),
        transactions?.map((x) => x.toTransaction()).toList() ?? [], timestamp);
  }

  @override
  int compareTo(AccountDto other) {
    return timestamp.compareTo(other.timestamp);
  }
}
