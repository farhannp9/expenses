import 'dart:async';

import 'package:expenses/screen/transaction.dart';
import 'package:expenses/service/database.dart';
import 'package:expenses/service/dto/account.dart';
import 'package:expenses/service/dto/totalaccount.dart';
import 'package:expenses/service/dto/transaction.dart';
import 'package:expenses/service/hivedto/accountdto.dart';
import 'package:expenses/service/hivedto/transactiondto.dart';
import 'package:expenses/template/appbar.dart';
import 'package:expenses/template/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat formatter = NumberFormat.decimalPatternDigits(
  locale: 'en_us',
  decimalDigits: 2,
);

class AccountPage extends StatefulWidget {
  final int currentAccountIndex;
  final List<Account> accounts;
  final DatabaseService databaseService;
  final Stream<AccountDto?> changedAccountDto;
  const AccountPage(this.currentAccountIndex, this.accounts,
      this.databaseService, this.changedAccountDto,
      {super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Account account;
  late Color color;
  late StreamSubscription subsc;

  @override
  void initState() {
    super.initState();
    account = widget.accounts[widget.currentAccountIndex];
    color = account.color;
    subsc = widget.changedAccountDto.listen(null);
    subsc.onData((data) async {
      if (account is TotalAccount || data == null) {
        final totalAccount = await _getAll();
        setState(() {
          account = totalAccount;
        });
      } else if (data.name == account.name) {
        setState(() {
          account = data.toAccount();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subsc.cancel();
  }

  Future<TotalAccount> _getAll() async {
    final accounts = await widget.databaseService.getAllAccounts();
    return TotalAccount.create(accounts);
  }

  @override
  Widget build(BuildContext context) {
    return AppBarTemplate(
      appBarColor: account.color,
      drawer: NavigationDrawerTemplate(
          widget.accounts, widget.currentAccountIndex, widget.databaseService),
      appBarTitle: account.name,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return TransactionScreen(
                widget.accounts, widget.currentAccountIndex);
          },
        )),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              // color: Colors.blue,
              child: Column(
                children: [
                  const Center(child: Text("Total")),
                  Center(
                      child: Text(
                    formatter.format(account.getTotal()),
                    style: TextStyle(
                      color: Colors.blue.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        formatter.format(account.getPositive()),
                        style: TextStyle(
                          color: Colors.green.shade300,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(formatter.format(account.getNegative()),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.red.shade300,
                          )),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                  // color: Colors.red,
                  child: _listOfTransactions()),
            )
          ],
        ),
      ),
    );
  }

  Widget _listOfTransactions() {
    return ListView.builder(
      itemCount: (account.transactions.length) * 2,
      itemBuilder: (context, index) {
        if (index % 2 != 0) {
          return Container(
            height: 1,
            color: Colors.white,
          );
        }
        var transaction = account.transactions[index ~/ 2];
        return Dismissible(
          key: Key(transaction.id),
          onDismissed: (direction) =>
              _deleteTransaction(transaction.accountId, transaction.id)
                  .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                action: SnackBarAction(
                    label: "Undo",
                    onPressed: () async {
                      await widget.databaseService.addTransaction(
                          TransactionDto.fromTransaction(transaction));
                    }),
                content: const Text("deleted!")));
          }),
          background: Container(
            color: Colors.red.shade500,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.delete),
                Icon(Icons.delete),
              ],
            ),
          ),
          child: AccountEntry(
              transaction, widget.accounts, widget.currentAccountIndex),
        );
      },
    );
  }

  Future<void> _deleteTransaction(String accountId, String id) async {
    AccountDto acct = (await widget.databaseService.getAccount(accountId))!;
    acct.transactions?.removeWhere((trx) => trx.id == id);

    await widget.databaseService.updateAccount(acct.name, acct);
  }
}

class AccountEntry extends StatelessWidget {
  final Transaction trx;
  final List<Account> accounts;
  final int currentAccountIndex;
  const AccountEntry(this.trx, this.accounts, this.currentAccountIndex,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return TransactionScreen(
            accounts,
            currentAccountIndex,
            toEdit: trx,
          );
        },
      )),
      child: Center(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // color: Colors.green,
            child: trx.amount >= 0
                ? const Icon(Icons.add)
                : const Icon(Icons.remove),
          ),
          Expanded(
            // color: Colors.yellow.shade900,
            child: Text(
              trx.notes,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          // Expanded(
          //     child: Container(
          //         // color: Colors.green,
          //         )),
          Container(
            // color: Colors.blue.shade900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatter.format(trx.amount),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: trx.amount >= 0
                          ? Colors.green.shade300
                          : Colors.red.shade300),
                ),
                Text(DateFormat.yMMMd().format(trx.dateTime)),
              ],
            ),
          )
        ],
      )),
    );
  }
}
