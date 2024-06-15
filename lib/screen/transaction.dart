import 'package:expenses/service/database.dart';
import 'package:expenses/service/dto/account.dart';
import 'package:expenses/service/dto/totalaccount.dart';
import 'package:expenses/service/dto/transaction.dart';
import 'package:expenses/service/hivedto/accountdto.dart';
import 'package:expenses/template/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final getIt = GetIt.instance;

class TransactionScreen extends StatefulWidget {
  final List<Account> accounts;
  final int currentAccountIndex;
  final Transaction? toEdit;
  const TransactionScreen(this.accounts, this.currentAccountIndex,
      {this.toEdit, super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var _positive = false;
  var _datetime = DateTime.now();
  late Account? _account;
  late int? _currentAccountIndex;
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  late DatabaseService databaseService;

  @override
  void initState() {
    databaseService = getIt<DatabaseService>();
    super.initState();
    _account = widget.accounts[widget.currentAccountIndex];
    _currentAccountIndex = widget.currentAccountIndex;
    if (widget.toEdit != null) {
      final acct = widget.accounts.indexed
          .firstWhere((entry) => entry.$2.name == widget.toEdit!.accountId);
      _account = acct.$2;
      _currentAccountIndex = acct.$1;
      _datetime = widget.toEdit!.dateTime;
      _amountController.text = "${widget.toEdit!.amount.abs()}";
      _notesController.text = widget.toEdit!.notes;
      _positive = widget.toEdit!.amount >= 0 ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarTemplate(
      appBarTitle: "${widget.toEdit != null ? "Edit" : "Add"} Transaction",
      floatingActionButton: FloatingActionButton(
        onPressed: _validateForm()
            ? () => _submitForm().then((_) => Navigator.of(context).pop())
            : null,
        child: const Icon(Icons.check),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 300,
          // color: Colors.green.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Account", style: TextStyle(fontSize: 20)),
                  DropdownMenu<int>(
                      textStyle: const TextStyle(fontSize: 20),
                      onSelected: (value) {
                        if (value != null) {
                          setState(() {
                            _account = widget.accounts[value];
                          });
                        }
                      },
                      width: 200,
                      initialSelection: _account is! TotalAccount
                          ? _currentAccountIndex
                          : null,
                      dropdownMenuEntries: widget.accounts.indexed
                          .where((x) => x.$2 is! TotalAccount)
                          .map((acc) => DropdownMenuEntry(
                              value: acc.$1, label: acc.$2.name))
                          .toList()),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Amount", style: TextStyle(fontSize: 20)),
                Switch(
                  value: _positive,
                  onChanged: (val) => setState(() {
                    _positive = val;
                  }),
                ),
                Icon(_positive ? Icons.add : Icons.remove),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                  ),
                )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Date and Time", style: TextStyle(fontSize: 20)),
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? value = await showDatePicker(
                          context: context,
                          initialDate: _datetime,
                          firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                          lastDate: _datetime.add(const Duration(days: 30)),
                        );

                        if (value != null) {
                          setState(() {
                            _datetime = DateTime(
                                value.year,
                                value.month,
                                value.day,
                                _datetime.hour,
                                _datetime.minute,
                                _datetime.second);
                          });
                        }
                      },
                      child: Text(DateFormat.yMMMd().format(_datetime),
                          style: const TextStyle(fontSize: 15))),
                  ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? val = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_datetime));
                        if (val != null) {
                          setState(() {
                            _datetime = DateTime(
                              _datetime.year,
                              _datetime.month,
                              _datetime.day,
                              val.hour,
                              val.minute,
                              _datetime.second,
                            );
                          });
                        }
                      },
                      child: Text(DateFormat.Hm().format(_datetime))),
                ],
              ),
              Row(children: [
                const Text("Notes", style: TextStyle(fontSize: 20)),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: _notesController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (_account is TotalAccount) {
      return false;
    }
    return true;
  }

  Future<void> _submitForm() async {
    final String? id;
    if (widget.toEdit != null) {
      id = widget.toEdit!.id;
    } else {
      id = const Uuid().v1();
    }
    final toBeSubmitted = Transaction(id,
        accountId: _account!.name,
        amount: double.parse(
                _amountController.text != "" ? _amountController.text : "0.0") *
            (_positive ? 1 : -1),
        notes: _notesController.text,
        dateTime: _datetime);
    //  todo implement persistence

    if (widget.toEdit != null) {
      _account!.transactions.removeWhere((x) => widget.toEdit!.id == x.id);
    }

    _account!.transactions.add(toBeSubmitted);
    databaseService.updateAccount(
        _account!.name, AccountDto.fromAccount(_account!));
  }

  //   final toBeSubmitted = Account(
  //   _labelController.text,
  //   _color,
  //   widget.toEdit?.transactions ?? [],
  //   widget.toEdit?.timestamp,
  // );
  // if (widget.toEdit == null) {
  //   widget.databaseService
  //       .addAccount([AccountDto.fromAccount(toBeSubmitted)]);
  // } else {
  //   widget.databaseService.updateAccount(
  //       toBeSubmitted.name, AccountDto.fromAccount(toBeSubmitted));
  // }
}
