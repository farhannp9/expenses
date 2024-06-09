import 'package:expenses/screen/account.dart';
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
              databaseService),
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
  const ManageAccountMenu(this.currentAccount, this.databaseService,
      {super.key});

  @override
  Widget build(BuildContext context) {
    var children = [
      TextButton(
        child: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 10),
            Text("Add Account"),
          ],
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return AccountEditScreen(databaseService);
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
              Text("Edit Account"),
            ],
          ),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return AccountEditScreen(databaseService, toEdit: currentAccount);
            },
          )).then((_) => Navigator.of(context).pop()),
        ),
        TextButton(
          child: const Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 10),
              Text("Delete Account"),
            ],
          ),
          onPressed: () => databaseService
              .deleteAccount(currentAccount.name)
              .then((_) => DefaultTabController.of(context).animateTo(0)),
        ),
      ]);
    }
    return ExpansionTile(
      title: const Text("Manage account"),
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
                title: Text(accounts[index].name),
                subtitle: const Text("IDR102,000.00"),
              ),
            ),
            children: {
              "Open": "IDR0.00",
              "Income": "IDR1,537,000.00",
              "Expenses": "-IDR1,435,000.00",
              "line": "line",
              "Balance": "IDR102,000",
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
                  Text(element.key),
                  Text(element.value),
                ],
              );
            }).toList(),
          );
        });
  }
}
