import 'package:expenses/screen/accountedit.dart';
import 'package:expenses/screen/accountpage.dart';
import 'package:expenses/service/database.dart';
import 'package:expenses/service/dto/account.dart';
import 'package:expenses/service/dto/totalaccount.dart';
import 'package:expenses/template/navigation.dart';
import 'package:flutter/material.dart';

class NavigationDrawerTemplate extends StatelessWidget {
  final List<Account> accounts;
  final int currentIndex;
  final DatabaseService databaseService;
  const NavigationDrawerTemplate(
      this.accounts, this.currentIndex, this.databaseService,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        // color: Colors.red.shade700,
        child: Column(children: [
          ManageAccountMenu(accounts[DefaultTabController.of(context).index],
              databaseService, accounts.map((x) => x.name).toSet()),
          SizedBox(
            height: 2,
            child: Container(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: AccountsInTheDrawer(accounts, currentIndex),
          ),
        ]),
      ),
    );
  }
}

class ManageAccountMenu extends StatelessWidget {
  final Account currentAccount;
  final DatabaseService databaseService;
  final Set<String> accountsName;
  const ManageAccountMenu(
      this.currentAccount, this.databaseService, this.accountsName,
      {super.key});

  @override
  Widget build(BuildContext context) {
    var children = [
      TextButton(
        child: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 10),
            Text("Add Account", style: TextStyle(fontSize: 20)),
          ],
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return AccountEditScreen(databaseService, accountsName);
          },
        )),
      ),
    ];

    if (currentAccount is! TotalAccount) {
      children.addAll([
        TextButton(
          child: const Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 10),
              Text("Edit Account", style: TextStyle(fontSize: 20)),
            ],
          ),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return AccountEditScreen(databaseService, accountsName,
                  toEdit: currentAccount);
            },
          )).then((_) => Navigator.of(context).pop()),
        ),
        TextButton(
          child: const Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 10),
              Text("Delete Account", style: TextStyle(fontSize: 20)),
            ],
          ),
          onPressed: () => databaseService
              .deleteAccount(currentAccount.name)
              .then((_) => DefaultTabController.of(context).animateTo(0)),
        ),
      ]);
    }
    return ExpansionTile(
      title: const Text("Manage account", style: TextStyle(fontSize: 20)),
      children: children,
    );
  }
}

class AccountsInTheDrawer extends StatelessWidget {
  final List<Account> accounts;
  final int currentIndex;
  const AccountsInTheDrawer(this.accounts, this.currentIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: AccountNavigationButton(
              indexTo: index == currentIndex ? null : index,
              child: ListTile(
                leading: Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: accounts[index].color,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(accounts[index].name,
                    style: const TextStyle(fontSize: 23)),
                subtitle: Text(formatter.format(accounts[index].getTotal()),
                    style: const TextStyle(fontSize: 16)),
              ),
            ),
            children: {
              "Income": formatter.format(accounts[index].getPositive()),
              "Expenses": formatter.format(accounts[index].getNegative()),
              "line": "line",
              "Balance": formatter.format(accounts[index].getTotal()),
            }.entries.map((MapEntry<String, String> element) {
              if (element.key == 'line') {
                return SizedBox(
                    height: 2,
                    child: Container(
                      color: Colors.white,
                    ));
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(element.key, style: const TextStyle(fontSize: 20)),
                  Text(element.value, style: const TextStyle(fontSize: 20)),
                ],
              );
            }).toList(),
          );
        });
  }
}
