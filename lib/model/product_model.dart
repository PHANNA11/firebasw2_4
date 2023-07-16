import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  late int id;
  late String name;
  late String image;
  late String description;
  late double price;
  late int qty;
  late double total;
  ProductModel(
      {required this.id,
      required this.name,
      required this.qty,
      required this.price,
      required this.image,
      required this.description,
      required this.total});
  Map<String, dynamic> toMap() {
    return {
      'pro_id': id,
      'pro_name': name,
      'pro_qty': qty,
      'pro_price': price,
      'pro_image': image,
      'pro_description': description,
      'total': qty * price
    };
  }

  ProductModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = snapshot['pro_id'],
        name = snapshot['pro_name'],
        price = snapshot['pro_price'],
        qty = int.parse(snapshot['pro_qty'].toString()),
        image = snapshot['pro_image'],
        description = snapshot['pro_description'],
        total = double.parse(snapshot['total'].toString());
  ProductModel.fromMap(Map<String, dynamic> map)
      : id = map['pro_id'],
        name = map['pro_name'],
        price = map['pro_price'],
        qty = int.parse(map['pro_qty'].toString()),
        image = map['pro_image'],
        description = map['pro_description'],
        total = double.parse(map['total'].toString());
}
