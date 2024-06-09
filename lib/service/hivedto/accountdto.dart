import 'package:expenses/service/dto/account.dart';
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

  AccountDto(this.name, this.color, this.timestamp);

  static AccountDto fromAccount(Account account) {
    return AccountDto(account.name, account.color.toHexString(),
        DateTime.now().millisecondsSinceEpoch);
  }

  Account toAccount() {
    return Account(name, Color(int.parse(color, radix: 16)), []);
  }

  @override
  int compareTo(AccountDto other) {
    return timestamp.compareTo(other.timestamp);
  }
}
