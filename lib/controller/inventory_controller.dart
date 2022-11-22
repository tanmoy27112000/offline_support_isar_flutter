import 'package:flutter/material.dart';
import 'package:medicine_inventory/api/firebase_storage.dart';
import 'package:medicine_inventory/database/isar_helper.dart';
import 'package:medicine_inventory/main.dart';
import 'package:medicine_inventory/model/inventory.dart';

class InventoryController extends ChangeNotifier {
  bool isLoading = false;
  List<Inventory> _inventoryList = [];
  List<Inventory> get inventoryList => _inventoryList;
  List<Inventory> deletedMedicines = [];

  bool isSynced = true;

  final CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();

  //start loading
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  //stop loading
  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

//===================================
//
//    ###    ####    ####
//   ## ##   ##  ##  ##  ##
//  ##   ##  ##  ##  ##  ##
//  #######  ##  ##  ##  ##
//  ##   ##  ####    ####
//
//===================================

  void addInventory(Inventory inventory) async {
    inventory.isSynced = isDeviceConnected.value;
    int id = await IsarHelper.instance.insertOne(inventory);
    inventory.id = id;
    _inventoryList.add(inventory);
    if (isDeviceConnected.value) {
      _cloudFirestoreHelper.addMedicine(inventory.toJson());
    }
    notifyListeners();
  }

//===========================================================
//
//  ##   ##  #####   ####      ###    ######  #####
//  ##   ##  ##  ##  ##  ##   ## ##     ##    ##
//  ##   ##  #####   ##  ##  ##   ##    ##    #####
//  ##   ##  ##      ##  ##  #######    ##    ##
//   #####   ##      ####    ##   ##    ##    #####
//
//===========================================================

  void updateMedicine(int index) async {
    _inventoryList[index].quantity = _inventoryList[index].quantity! + 1;
    _inventoryList[index].isSynced = isDeviceConnected.value;
    int id = await IsarHelper.instance.insertOne(_inventoryList[index]);
    _inventoryList[index].id = id;
    if (isDeviceConnected.value) {
      _cloudFirestoreHelper.updateMedicine(_inventoryList[index]);
    }
    notifyListeners();
  }

  //===========================================
//                                           
//  #####    #####    ###    ####          
//  ##  ##   ##      ## ##   ##  ##        
//  #####    #####  ##   ##  ##  ##        
//  ##  ##   ##     #######  ##  ##        
//  ##   ##  #####  ##   ##  ####          
//                                           
//===========================================


  //get inventory list
  Future<void> getInventoryList({bool showLoading = true}) async {
    showLoading ? startLoading() : null;
    _inventoryList = [];

    await Future.delayed(const Duration(seconds: 1)).then((value) async {
      if (isDeviceConnected.value) {
        _inventoryList = await _cloudFirestoreHelper.getAllMedicine();

        IsarHelper.instance.insertFresh(_inventoryList);
      } else {
        _inventoryList = await IsarHelper.instance.getItems();
      }
    });

    stopLoading();
    notifyListeners();
  }

  //=======================================================
//
//  ####    #####  ##      #####  ######  #####
//  ##  ##  ##     ##      ##       ##    ##
//  ##  ##  #####  ##      #####    ##    #####
//  ##  ##  ##     ##      ##       ##    ##
//  ####    #####  ######  #####    ##    #####
//
//=======================================================

  void removeMedicine(Inventory inventory) async {
    inventory.isSynced = false;
    await IsarHelper.instance.removeItem(inventory);
    _inventoryList
        .removeWhere((element) => element.code_value == inventory.code_value);
    if (isDeviceConnected.value) {
      _cloudFirestoreHelper.removeInventory(inventory);
    } else {
      deletedMedicines.add(inventory);
    }
    notifyListeners();
  }

  //=============================================
//
//   ####  ##    ##  ##     ##   ####
//  ##      ##  ##   ####   ##  ##
//   ###     ####    ##  ## ##  ##
//     ##     ##     ##    ###  ##
//  ####      ##     ##     ##   ####
//
//=============================================

  void checkIsSynced() async {
    List<Inventory> unsyncedMedicines =
        await IsarHelper.instance.getUnsyncedData();
    if (deletedMedicines.isNotEmpty) {
      for (Inventory element in deletedMedicines) {
        _cloudFirestoreHelper.removeInventory(element);
      }
      deletedMedicines.clear();
    }
    if (unsyncedMedicines.isNotEmpty) {
      for (Inventory element in unsyncedMedicines) {
        element.isSynced = true;
        await _cloudFirestoreHelper.updateMedicine(element);
        IsarHelper.instance.updateSync(element);
      }
    }
    getInventoryList(showLoading: false);
  }
}
