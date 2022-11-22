import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:medicine_inventory/model/inventory.dart';

class CloudFirestoreHelper {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final CollectionReference inventory =
      FirebaseFirestore.instance.collection('inventory');

  static final CollectionReference medicine =
      FirebaseFirestore.instance.collection('medicine');

  Future getAllMedicine() async {
    List data = [];
    List<Inventory> allMedicine = [];

    await inventory.get().then((QuerySnapshot value) {
      for (var element in value.docs) {
        data.add(element.data());
      }
    });

    for (var document in data) {
      allMedicine.add(Inventory.fromJson(document));
    }

    return allMedicine;
  }

  addMedicine(Map data) async {
    await inventory.add(data).then((value) {
      Get.showSnackbar(GetBar(
        title: "Medicine added",
        message: "successful",
        duration: const Duration(seconds: 1),
      ));
    }).catchError((error) {
      Get.showSnackbar(GetBar(
        title: "Error adding medicine",
        message: error.toString(),
        duration: const Duration(seconds: 1),
      ));
    });
  }

  addMedicineToList(String name) {
    medicine.doc("medicine").get().then(
      (value) {
        List data = value['medicine_list'] ?? [];
        data.add(name);
        medicine.doc("medicine").set({'medicine_list': data}).then(
          (value) {
            Get.showSnackbar(
              GetBar(
                title: "Medicine list updated",
                message: "successful",
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }

  removeInventory(Inventory medicineItem) async {
    await inventory
        .where("code_value", isEqualTo: medicineItem.code_value)
        .get()
        .then((value) async {
      DocumentSnapshot doc = value.docs.first;
      await inventory.doc(doc.id).delete();
    });
  }

  updateMedicine(Inventory medicine) async {
    await inventory
        .where("code_value", isEqualTo: medicine.code_value)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        addMedicine(medicine.toJson());
      } else {
        DocumentSnapshot doc = value.docs.first;
        await inventory.doc(doc.id).update(medicine.toJson());
      }
    });
  }
}
