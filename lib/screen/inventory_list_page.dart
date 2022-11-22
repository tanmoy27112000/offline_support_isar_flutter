import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_inventory/controller/inventory_controller.dart';
import 'package:medicine_inventory/main.dart';
import 'package:medicine_inventory/model/inventory.dart';
import 'package:medicine_inventory/screen/add_item_page.dart';
import 'package:medicine_inventory/widget/item_widget.dart';
import 'package:provider/provider.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({Key? key}) : super(key: key);

  @override
  _InventoryListPageState createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  bool isLoading = false;
  late InventoryController controller;

  @override
  void initState() {
    controller = Provider.of<InventoryController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getInventoryList();
    });
    startTimer(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDeviceConnected,
      builder: (BuildContext context, bool value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Inventory List'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  isDeviceConnected.value = !isDeviceConnected.value;
                  log("Internet status ====== $isDeviceConnected");
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Get.to(
                () => const AddMedicinePage(),
              );
            },
          ),
          body: Consumer<InventoryController>(
            builder: (context, myType, child) {
              return myType.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : myType.inventoryList.isEmpty
                      ? const Center(
                          child: Text('No data found'),
                        )
                      : ListView.builder(
                          itemCount: myType.inventoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Inventory inventory = myType.inventoryList[index];
                            return itemWidget(
                              inventory,
                              () {
                                myType.removeMedicine(inventory);
                              },
                              () {
                                myType.updateMedicine(index);
                              },
                            );
                          },
                        );
            },
          ),
        );
      },
    );
  }

  void startTimer(BuildContext context) {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      log("timer started===========");
      log("timer=====${timer.tick}");
      if (isDeviceConnected.value) {
        controller.checkIsSynced();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Data synced...")));
      }
    });
  }
}
