import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase2_4/model/product_model.dart';

class UserModel {
  late int userId;
  late String userName;
  late String password;
  //late List<ProductModel>? listProduct;
  UserModel({
    required this.userId,
    required this.userName,
    required this.password,
    //required this.listProduct,
  });
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'password': password,
      // 'shoppings': {'shopping_cart': listProduct}
    };
  }

  UserModel.fromDucumentSnapShot(DocumentSnapshot ref)
      : userId = ref['user_id'],
        userName = ref['user_name'],
        password = ref['password'];
  // listProduct = ref['shoppings']['shopping_cart'] == null
  //     ? []
  //     : List<ProductModel>.from(ref['shopping_cart']
  //         ?.map((x) => ProductModel.fromDocumentSnapshot(x)));
  // List<ProductModel> getShopping({required String ?userDocId}){
  //   String? shopDoc;

  //     CollectionReference dataRefShopping = FirebaseFirestore
  //                       .instance
  //                       .collection('users')
  //                       .doc(userDocId)
  //                       .collection('shoppings');
  //                   dataRefShopping.get().then(
  //                     (value) {
  //                       log('DocShopping:${value.docs.first.id}');
  //                     shopDoc=value.docs.first.id;

  //                     },
  //                   );
  //   return List<ProductModel>.from(dataRefShopping.doc(shopDoc).get()?.((x)=>ProductModel.fromDocumentSnapshot(x)).toList();
  // }
}
