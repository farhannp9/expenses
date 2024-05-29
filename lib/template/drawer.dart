import 'package:expenses/screen/account.dart';
import 'package:expenses/service/dto/account.dart';
import 'package:expenses/template/navigation.dart';
import 'package:flutter/material.dart';

class NavigationDrawerTemplate extends StatelessWidget {
  final List<Account> accounts;
  final int currentIndex;
  const NavigationDrawerTemplate(this.accounts, this.currentIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        // color: Colors.red.shade700,
        child: Column(children: [
          ManageAccountMenu(accounts[DefaultTabController.of(context).index]),
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
  const ManageAccountMenu(this.currentAccount, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("Manage account"),
      children: [
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
              return const AccountEditScreen();
            },
          )),
        ),
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
              return AccountEditScreen(toEdit: currentAccount);
            },
          )),
        ),
      ],
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
