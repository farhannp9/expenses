import 'package:expenses/service/dto/account.dart';
import 'package:expenses/template/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AccountEditScreen extends StatefulWidget {
  final Account? toEdit;
  const AccountEditScreen({this.toEdit, super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final _labelController = TextEditingController();
  final _currencyController = TextEditingController();
  var _color = Colors.red.shade900;
  static List<Color> setOfColors = [
    Colors.red.shade900,
    Colors.pink.shade900,
    Colors.purple.shade900,
    Colors.deepPurple.shade900,
    Colors.indigo.shade900,
    Colors.blue.shade900,
    Colors.lightBlue.shade900,
    Colors.cyan.shade900,
    Colors.teal.shade900,
    Colors.green.shade900,
    Colors.lightGreen.shade900,
    Colors.lime.shade900,
    Colors.yellow.shade900,
    Colors.amber.shade900,
    Colors.orange.shade900,
    Colors.deepOrange.shade900,
    Colors.brown.shade900,
    Colors.grey.shade900,
    Colors.blueGrey.shade900,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.toEdit != null) {
      _labelController.text = widget.toEdit!.name;
      _currencyController.text = widget.toEdit!.currency;
      _color = widget.toEdit!.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarTemplate(
      appBarTitle: Text("${widget.toEdit != null ? "Edit" : "Add"} Account"),
      floatingActionButton: FloatingActionButton(
        onPressed: _validateForm()
            ? () => _submitForm().then((_) => Navigator.of(context).pop())
            : null,
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
                const Text("Name"),
                SizedBox(
                  width: 200,
                  child: TextFormField(
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
                const Text("Currency"),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _currencyController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                    ),
                  ),
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Color"),
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

  bool _validateForm() {
    return true;
  }

  _showColorPicker() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Pick a color"),
              content: BlockPicker(
                availableColors: setOfColors,
                pickerColor: _color, //default color
                onColorChanged: (Color color) {
                  //on the color picked
                  setState(() {
                    _color = color.withAlpha(900);
                  });
                  Navigator.of(context).pop();
                },
              ));
        });
  }

  Future<void> _submitForm() async {
    Account(
      _labelController.text,
      _color,
      widget.toEdit?.transactions ?? [],
      _currencyController.text,
    );
    debugPrint('submit');
    //  todo implement persistence
  }
}
