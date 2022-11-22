import 'package:isar/isar.dart';
import 'package:medicine_inventory/model/inventory.dart';

class IsarHelper {
  IsarHelper._privateConstructor();
  static final IsarHelper _instance = IsarHelper._privateConstructor();
  static IsarHelper get instance => _instance;

  late Isar isarInstance;

  init() async {
    isarInstance = await Isar.open([InventorySchema]);
  }

  insertFresh(List<Inventory> inventoryList) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.clear();
      for (Inventory element in inventoryList) {
        await isarInstance.inventorys.put(element);
      }
    });
  }

  insertOne(Inventory inventoryItem) async {
    late int id;
    await isarInstance.writeTxn(() async {
      id = await isarInstance.inventorys.put(inventoryItem);
    });
    return id;
  }

  getItems() async {
    IsarCollection<Inventory> medicineCollection =
        isarInstance.collection<Inventory>();
    List<Inventory?> medicines = await medicineCollection.where().findAll();
    return medicines;
  }

  removeItem(Inventory inventory) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.inventorys.delete(inventory.id);
    });
  }

  void updateSync(Inventory inventory) async {
    inventory.isSynced = true;
    await isarInstance.writeTxn(() async {
      await isarInstance.inventorys.put(inventory);
    });
  }

  getUnsyncedData() async {
    IsarCollection<Inventory> medicineCollection =
        isarInstance.collection<Inventory>();
    List<Inventory?> medicines =
        await medicineCollection.filter().isSyncedEqualTo(false).findAll();
    return medicines;
  }
}
