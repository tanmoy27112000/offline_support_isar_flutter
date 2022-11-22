import 'package:flutter/material.dart';
import 'package:medicine_inventory/controller/inventory_controller.dart';
import 'package:medicine_inventory/model/inventory.dart';
import 'package:provider/provider.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({Key? key}) : super(key: key);

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  Inventory inventory = Inventory();
  late InventoryController _inventoryController;
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController listedDateController = TextEditingController();
  late List fields;
  //formkey
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _inventoryController =
        Provider.of<InventoryController>(context, listen: false);
    fields = [
      [
        "Authorized by",
        (val) {
          inventory.authorizedBy = val;
        },
      ],
      [
        "Code value",
        (val) {
          inventory.code_value = val;
        },
      ],
      [
        "Description",
        (val) {
          inventory.description = val;
        },
      ],
      [
        "Hospital Id",
        (val) {
          inventory.hospitalId = val;
        },
      ],
      [
        "mobile",
        (val) {
          inventory.mobile = val;
        },
      ],
      [
        "Product name",
        (val) {
          inventory.productName = val;
        },
      ],
      [
        "Product type",
        (val) {
          inventory.productType = val;
        },
      ],
      [
        "Quantity",
        (val) {
          inventory.quantity = int.parse(val);
        },
      ],
      [
        "Status",
        (val) {
          inventory.status = val;
        },
      ],
      [
        "unit cost",
        (val) {
          inventory.unitCost = val;
        },
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              ...fields
                  .map(
                    (e) => TextfieldWidget(
                      title: e[0],
                      onSaved: e[1],
                    ),
                  )
                  .toList(),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Expiry date",
                ),
                controller: expiryDateController,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 1),
                  ).then((val) {
                    if (val != null) {
                      expiryDateController.text = val.toString();
                    }
                  });
                },
                onSaved: (value) {
                  inventory.expiryDate =
                      DateTime.parse(expiryDateController.text);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "List date",
                ),
                controller: listedDateController,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 1),
                  ).then((val) {
                    if (val != null) {
                      listedDateController.text = val.toString();
                    }
                  });
                },
                onSaved: (value) {
                  // inventory.listedTimeStamp = Timestamp.fromDate(
                  //     DateTime.parse(listedDateController.text));
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  // ignore: avoid_print
                  print(inventory.toJson());
                  _inventoryController.addInventory(inventory);
                  Navigator.pop(context);
                },
                child: const Text('Add Medicine'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextfieldWidget extends StatelessWidget {
  final String title;
  final Function onSaved;
  final TextInputType keyboardType;
  const TextfieldWidget({
    required this.title,
    required this.onSaved,
    this.keyboardType = TextInputType.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: title,
      ),
      onSaved: (value) => onSaved(value),
      keyboardType: keyboardType,
    );
  }
}
