import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase2_4/model/user_model.dart';
import 'package:firebase2_4/view/shop/view/shop_home.dart';
import 'package:firebase2_4/view/storage/test_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference dataRef = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
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
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    UserModel user = UserModel.fromDucumentSnapShot(
                        snapshot.data!.docs[index]);

                    return snapshot.data == null
                        ? const SizedBox(
                            child: Text('No data...'),
                          )
                        : Card(
                            elevation: 0,
                            child: ListTile(
                              onTap: () {
                                Get.to(() => ShopHome(
                                      userDocId: snapshot.data!.docs[index].id,
                                    ));
                              },
                              leading: IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!.docs[index].id)
                                        .set({
                                      'user_id': user.userId,
                                      'user_name': 'Davan',
                                      'password': user.password
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  )),
                              title: Text(user.userName),
                              trailing: IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!.docs[index].id)
                                        .delete();
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                    size: 30,
                                  )),
                            ),
                          );
                  });
            }
          }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () async {
              Get.to(() => StorageImage());
            },
            child: const Icon(Icons.image),
          ),
          FloatingActionButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').add({
                'user_id': DateTime.now().microsecondsSinceEpoch,
                'user_name': 'Dalin',
                'password': 'wertyui543'
              });
            },
            child: const Icon(Icons.done),
          ),
        ],
      ),
    );
  }
}
