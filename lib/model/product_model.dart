import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  late int id;
  late String name;
  late String image;
  late String description;
  late double price;
  late int qty;
  ProductModel(
      {required this.id,
      required this.name,
      required this.qty,
      required this.price,
      required this.image,
      required this.description});
  Map<String, dynamic> toMap() {
    return {
      'pro_id': id,
      'pro_name': name,
      'pro_qty': qty,
      'pro_price': price,
      'pro_image': image,
      'pro_description': description
    };
  }

  ProductModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = snapshot['pro_id'],
        name = snapshot['pro_name'],
        price = snapshot['pro_price'],
        qty = int.parse(snapshot['pro_qty'].toString()),
        image = snapshot['pro_image'],
        description = snapshot['pro_description'];
}
