import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase2_4/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> listDocId = [];
  getDocumentId() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          listDocId.add(element.reference.id);
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      body: ListView.builder(
          itemCount: listDocId.length,
          itemBuilder: (context, index) {
            CollectionReference dataRef =
                FirebaseFirestore.instance.collection('users');
            return FutureBuilder<DocumentSnapshot>(
              future: dataRef.doc(listDocId[index]).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Icon(
                    Icons.info,
                    color: Colors.red,
                    size: 30,
                  ));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  UserModel user =
                      UserModel.fromDucumentSnapShot(snapshot.data!);
                  return snapshot.data == null
                      ? const SizedBox(
                          child: Text('No data...'),
                        )
                      : Card(
                          elevation: 0,
                          child: ListTile(
                            leading: IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(listDocId[index])
                                      .set({
                                    'user_id': user.userId,
                                    'user_name': 'Davan',
                                    'password': user.password
                                  }).then((value) {
                                    listDocId.clear();
                                    getDocumentId();
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
                                      .doc(listDocId[index])
                                      .delete()
                                      .then((value) {
                                    listDocId.clear();
                                    getDocumentId();
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 30,
                                )),
                          ),
                        );
                }
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseFirestore.instance.collection('users').add({
            'user_id': DateTime.now().microsecondsSinceEpoch,
            'user_name': 'Dalin',
            'password': 'wertyui543'
          }).then((value) {
            listDocId.clear();
            getDocumentId();
          });
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
