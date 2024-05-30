import 'package:expenses/service/dto/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

part 'accountdto.g.dart';

@HiveType(typeId: 1)
class AccountDto {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String currency;
  @HiveField(2)
  final String color;

  AccountDto(this.name, this.currency, this.color);

  static AccountDto fromAccount(Account account) {
    return AccountDto(
        account.name, account.currency, account.color.toHexString());
  }

  Account toAccount() {
    return Account(name, Color(int.parse(color, radix: 16)), [], currency);
  }
}
