import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_inventory/model/inventory.dart';

Container itemWidget(Inventory e, VoidCallback onDelete,VoidCallback onUpdate) {
  return Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      boxShadow: kElevationToShadow[3],
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        10,
      ),
    ),
    child: ListTile(
      title: Text(e.productName!),
      subtitle: Text(
        "Expiry: ${DateFormat('yyyy-MM-dd').format(e.expiryDate!)}",
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Qty: " + e.quantity.toString(),
          ),
          IconButton(
            onPressed: onUpdate,
            icon: const Icon(
              Icons.add,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    ),
  );
}
