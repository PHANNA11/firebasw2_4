import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase2_4/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ShoppingScreen extends StatefulWidget {
  ShoppingScreen({super.key, this.userDocId});
  String? userDocId;

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  CollectionReference dataRef =
      FirebaseFirestore.instance.collection('products');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: dataRef.snapshots(),
          builder: (context, snapshot) {
            CollectionReference dataRefShopping = FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userDocId)
                .collection('shoppings');

            return snapshot.data == null
                ? const SizedBox()
                : StreamBuilder<QuerySnapshot>(
                    stream: dataRefShopping.snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.hasError) {
                        return const Center(
                            child: Icon(
                          Icons.info,
                          color: Colors.red,
                          size: 30,
                        ));
                      } else if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return snapshots.data!.docs.isEmpty
                            ? const SizedBox()
                            : ListView.builder(
                                itemCount: snapshots
                                    .data!.docs[0]['shopping_cart'].length,
                                itemBuilder: (context, index) {
                                  var pro = ProductModel.fromMap(snapshots
                                      .data!.docs[0]['shopping_cart'][index]);

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 140,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: double.infinity,
                                              width: 140,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          pro.image))),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  pro.name,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '\$ ${pro.price.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.red),
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: const CircleAvatar(
                                                        maxRadius: 15,
                                                        child:
                                                            Icon(Icons.remove),
                                                      ),
                                                    ),
                                                    Chip(
                                                      label: Text(
                                                          pro.qty.toString()),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {},
                                                      child: const CircleAvatar(
                                                        maxRadius: 15,
                                                        child: Icon(Icons.add),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '\$${(pro.qty * pro.price).toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                      }
                    });
          }),
    );
  }
}
