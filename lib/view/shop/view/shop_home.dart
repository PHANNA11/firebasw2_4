import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase2_4/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:badges/badges.dart' as badges;

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  CollectionReference dataRef =
      FirebaseFirestore.instance.collection('products');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('Shop'),
        actions: const [
          Align(
            alignment: Alignment.centerLeft,
            child: badges.Badge(
              badgeContent: Text('3'),
              child: Icon(
                Icons.shopping_cart,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: dataRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                  child: Icon(
                Icons.info,
                color: Colors.red,
                size: 30,
              ));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 12 / 17,
                  children: List.generate(snapshot.data!.docs.length, (index) {
                    final pro = ProductModel.fromDocumentSnapshot(
                        snapshot.data!.docs[index]);
                    return buildProductCard(pro: pro);
                  }));
            }
          }),
    );
  }

  Widget buildProductCard({ProductModel? pro}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(pro!.image.toString())),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pro.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '\$${pro.price}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: const CircleAvatar(
                      maxRadius: 20,
                      child: Icon(Icons.shopping_cart_checkout),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
