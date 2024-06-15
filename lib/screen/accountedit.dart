import 'package:expenses/service/database.dart';
import 'package:expenses/service/dto/account.dart';
import 'package:expenses/service/hivedto/accountdto.dart';
import 'package:expenses/template/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AccountEditScreen extends StatefulWidget {
  final Account? toEdit;
  final DatabaseService databaseService;
  final Set<String> currentAccountsName;
  const AccountEditScreen(this.databaseService, this.currentAccountsName,
      {this.toEdit, super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final _labelController = TextEditingController();
  late Future<Set<String>> fCurrentAccounts;
  Color _color = Colors.red;
  @override
  void initState() {
    super.initState();
    if (widget.toEdit != null) {
      _labelController.text = widget.toEdit!.name;
      _color = widget.toEdit!.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarTemplate(
      appBarTitle: "${widget.toEdit != null ? "Edit" : "Add"} Account",
      floatingActionButton: FloatingActionButton(
        onPressed: () => _clickSubmit()(context),
        child: const Icon(Icons.check),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 200,
          // color: Colors.green.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Name", style: TextStyle(fontSize: 20)),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    enabled: widget.toEdit == null ? true : false,
                    controller: _labelController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                    ),
                  ),
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Color", style: TextStyle(fontSize: 20)),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize:
                        const WidgetStatePropertyAll<Size>(Size.fromWidth(200)),
                    backgroundColor: WidgetStatePropertyAll<Color>(_color),
                  ),
                  onPressed: () => _showColorPicker(),
                  child: const Text(""),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _validateForm() {
    var ret = <String>[];
    if (widget.toEdit == null) {
      if (widget.currentAccountsName.contains(_labelController.text)) {
        ret.add("name of the account already existed");
      }
    }
    return ret;
  }

  _showColorPicker() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Pick a color"),
              content: BlockPicker(
                pickerColor: _color, //default color
                onColorChanged: (Color color) {
                  //on the color picked
                  setState(() {
                    _color = color;
                  });
                  Navigator.of(context).pop();
                },
              ));
        });
  }

  Future<void> Function(BuildContext ctx) _clickSubmit() {
    return (ctx) async {
      final msgs = _validateForm();
      if (msgs.isNotEmpty) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Column(
          children: msgs.map((x) => Text(x)).toList(),
        )));
        return;
      }
      return _submitForm().then((_) => Navigator.of(context).pop());
    };
  }

  Future<void> _submitForm() async {
    final toBeSubmitted = Account(
      _labelController.text,
      _color,
      widget.toEdit?.transactions ?? [],
      widget.toEdit?.timestamp,
    );
    if (widget.toEdit == null) {
      widget.databaseService
          .addAccount([AccountDto.fromAccount(toBeSubmitted)]);
    } else {
      widget.databaseService.updateAccount(
          toBeSubmitted.name, AccountDto.fromAccount(toBeSubmitted));
    }
  }
}
