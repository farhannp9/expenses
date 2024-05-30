import 'package:expenses/service/dto/account.dart';
import 'package:expenses/service/hivedto/accountdto.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  Future<void> registerAdapter() async {
    Hive.registerAdapter(AccountDtoAdapter());

    final accounts = await getAllAccounts();
    if (accounts.isEmpty) {
      final List<AccountDto> accounts = [
        (Account("Physical", Colors.red.shade900, [])),
        Account("Dana Darurat", Colors.blue.shade900, []),
        Account("Traktir", Colors.green.shade900, []),
        Account("Id Dima", Colors.yellow.shade900, []),
      ].map((element) => AccountDto.fromAccount(element)).toList();
      addAccount(accounts);
    }
  }

  Future<AccountDto?> getAccount(String accountName) async {
    final box = await Hive.openBox<AccountDto>('accounts');
    return box.get(accountName);
  }

  Future<void> addAccount(List<AccountDto> accounts) async {
    Map<String, AccountDto> all =
        Map.fromIterable(accounts, key: (e) => e.name);
    // Map<String, AccountDto> all = Map.fromIterable(
    //     accounts.map((account) => MapEntry(account.name, account)).toList());
    Hive.openBox<AccountDto>('accounts').then((box) => box.putAll(all));
  }

  Future<List<AccountDto>> getAllAccounts() async {
    final box = await Hive.openBox<AccountDto>('accounts');
    return box.values.toList();
  }
}
