import 'package:isar/isar.dart';
part 'inventory.g.dart';

@collection
class Inventory {
  Id id = Isar.autoIncrement;
  String? authorizedBy;
  String? code_value;
  String? description;
  DateTime? expiryDate;
  String? hospitalId;
  String? mobile;
  String? productName;
  String? productType;
  int? quantity;
  String? status;
  String? unitCost;
  bool isSynced;

  Inventory({
    this.authorizedBy,
    this.code_value,
    this.description,
    this.expiryDate,
    this.hospitalId,
    this.mobile,
    this.productName,
    this.productType,
    this.quantity,
    this.status,
    this.unitCost,
    this.isSynced = true,
  });

  factory Inventory.fromJson(json) {
    return Inventory(
      authorizedBy: json['authorizedBy'],
      code_value: json['code_value'],
      description: json['description'],
      expiryDate: DateTime.parse(json['expiryDate']),
      hospitalId: json['hospitalId'],
      mobile: json['mobile'],
      productName: json['productName'],
      productType: json['productType'],
      quantity: json['quantity'],
      status: json['status'],
      unitCost: json['unitCost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'authorizedBy': authorizedBy,
      'code_value': code_value,
      'description': description,
      'expiryDate': expiryDate!.toIso8601String(),
      'hospitalId': hospitalId,
      'mobile': mobile,
      'productName': productName,
      'productType': productType,
      'quantity': quantity,
      'status': status,
      'unitCost': unitCost,
    };
  }
}
