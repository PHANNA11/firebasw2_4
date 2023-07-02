import 'package:cloud_firestore/cloud_firestore.dart';
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
                  return Center(
                      child: Icon(
                    Icons.info,
                    color: Colors.red,
                    size: 30,
                  ));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var data = snapshot.data;
                  return data == null
                      ? SizedBox(
                          child: Text('No data...'),
                        )
                      : Card(
                          elevation: 0,
                          child: ListTile(
                            title: Text(data['user_name']),
                          ),
                        );
                }
              },
            );
          }),
    );
  }
}
